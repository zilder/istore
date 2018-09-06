#!/usr/bin/bash

declare -A istore=(
    [name]=IStore
    [keysize]=4
    [valsize]=4
    [sql_key_type]=int4
    [key_in_f]=int4in
    [key_out_f]=int4out
    [val_out_f]=int4out)

declare -A bigistore=(
    [name]=BigIStore
    [keysize]=4
    [valsize]=8
    [sql_key_type]=int4
    [key_in_f]=int4in
    [key_out_f]=int4out
    [val_out_f]=int8out)

declare -A dateistore=(
    [name]=DateIStore
    [keysize]=4
    [valsize]=8
    [sql_key_type]=date
    [key_in_f]=date_in
    [key_out_f]=date_out
    [val_out_f]=int4out)

declare -a types=( istore bigistore dateistore )


generate_c() {
    typename=$1
    keybytes=$2
    valbytes=$3
    keyin=$5
    keyout=$6
    valin="int${valbytes}in"
    valout="int${valbytes}out"
    keybits=$(($keybytes * 8))
    valbits=$(($valbytes * 8))
    lowertypename=`echo $typename | tr '[:upper:]' '[:lower:]'`
    uppertypename=`echo $typename | tr '[:lower:]' '[:upper:]'`

    if [ $keybytes -le 4 ]; then
        align="'i'"
        io_macros="
            #define BUF_READ_KEY(buf) pq_getmsgint(buf, $keybytes)\n
            #define BUF_STORE_KEY(buf, key) pq_sendint(buf, key, $keybytes)\n"
    else
        align="'d'"
        io_macros="
            #define BUF_READ_KEY(buf) pq_getmsgint64(buf)\n
            #define BUF_STORE_KEY(buf, key) pq_sendint64(buf, key)\n"
    fi

    if [ $valbytes -le 4 ]; then
        io_macros+="
            #define BUF_READ_VALUE(buf) pq_getmsgint(buf, $valbytes)\n
            #define BUF_STORE_VALUE(buf, val) pq_sendint(buf, val, $valbytes)\n"
    else
        io_macros+="
            #define BUF_READ_VALUE(buf) pq_getmsgint64(buf)\n
            #define BUF_STORE_VALUE(buf, val) pq_sendint64(buf, val)\n"
    fi

    # typedefs
    defines="
        typedef $typename Store;\n
        typedef ${typename}Pair StorePair;\n
        typedef ${typename}Pairs StorePairs;\n
        typedef int${keybits} Key;\n
        typedef int${valbits} StoreValue;\n
        \n
    "

    # defines
    defines+="
        #define KEYSIZE ${keybytes}\n
        #define VALUESIZE ${valbytes}\n
        #define KEYOID INT${keybytes}OID\n
        #define VALUEOID INT${valbytes}OID\n
        #define VALUE_ALIGN $align\n
        #define KeyGetDatum Int${keybits}GetDatum\n
        #define ValueGetDatum Int${valbits}GetDatum\n
        #define key_cmp is_int${keybits}_arr_comp\n
        \n
    "

    # macros
    defines+="
        #define STORE_FUNCTION(FUNC) \\\\\n
        PG_FUNCTION_INFO_V1(${lowertypename}_ ## FUNC); \\\\\n
        Datum ${lowertypename}_ ## FUNC(PG_FUNCTION_ARGS) \n
        \n
        #define FINALIZE_STORE FINALIZE_${uppertypename}\n
        #define PG_GETARG_STORE PG_GETARG_${uppertypename}\n
        #define PG_GETARG_STORE_COPY PG_GETARG_${uppertypename}_COPY\n
        #define PG_GETARG_KEY PG_GETARG_INT${keybits}\n
        #define PG_GETARG_VALUE PG_GETARG_INT${valbits}\n
        #define store_tree_to_pairs ${lowertypename}_tree_to_pairs\n
        #define store_pairs_init ${lowertypename}_pairs_init\n
        #define store_pairs_insert ${lowertypename}_pairs_insert\n
        #define plus_func int${valbytes}pl\n
        #define minus_func int${valbytes}mi\n
        #define div_func int${valbytes}div\n
        #define mul_func int${valbytes}mul\n
        \n
        #define key_input_func $keyin\n
        #define key_output_func $keyout\n
        #define val_input_func $valin\n
        #define val_output_func $valout\n
    "

    defines+=$io_macros

    defines=`echo $defines | tr '\n' "\\n"`
    sed -e "s/\${defines}/$defines/" src/istore_type.c.template > src/${lowertypename}_type.c
}

generate_sql() {
    typename=$1
    keybytes=$2
    valbytes=$3
    pg_keytype=$4
    lowertypename=`echo $typename | tr '[:upper:]' '[:lower:]'`

    sed -e "s/%type%/${lowertypename}/g" \
        -e "s/%valtype%/int${valbytes}/g" \
        -e "s/%keytype%/${pg_keytype}/g" \
        sql/istore.sql.template > sql/${lowertypename}.sql
}

generate_c_from_template() {
    template=$1
    output=$2 && shift 2
    typenames=( "$@" )
    code=""

    # extract template
    t=`awk '/{%/{p=1;next}/%}/{p=0}p' $template`

    for arrname in "${typenames[@]}"
    do
        declare -nl arrptr="$arrname"
        store_type="${arrptr[name]}"
        keysize="${arrptr[keysize]}"
        valsize="${arrptr[valsize]}"
        keybits=$((${keysize} * 8))
        valbits=$((${valsize} * 8))
        store_type_lower=`echo "$store_type" | tr '[:upper:]' '[:lower:]'`

        # replace template params with apropriate values
        code+=`echo "$t" | sed -e "s/\\${store_type}/${store_type}/g" \
                               -e "s/\\${store_type_lower}/${store_type_lower}/g" \
                               -e "s/\\${store_pairs_type}/${store_type}Pairs/g" \
                               -e "s/\\${store_pair_type}/${store_type}Pair/g" \
                               -e "s/\\${keytype}/int${keybits}/g" \
                               -e "s/\\${valtype}/int${valbits}/g"`
    done

    # replace template between {% and %} with generated code
    echo "$code" > /tmp/filled_template.tmp
    cat $template | sed -e "/{%/r /tmp/filled_template.tmp" \
                        -e "/{%/,/%}/d" > $output
}

generate_pairs() {
    generate_c_from_template 'src/pairs.c.template' 'src/pairs.c' $@
}

generate_header() {
    generate_c_from_template 'src/istore.h.template' 'src/istore.h' $@
}

generate() {
    generate_c $@
    generate_sql $@
}

generate IStore     4 4 int4 int4in  int4out
generate BigIStore  4 8 int4 int4in  int4out
generate DateIStore 8 8 date date_in date_out

generate_pairs "${types[@]}" 
generate_header "${types[@]}"
