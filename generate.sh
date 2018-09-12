#!/usr/bin/bash

#
# Source code generator
#
# Basicly it takes template files, extracts part between {% and %} and
# replaces template parameters (e.g. ${store}) with actual values. To add new
# type just create a new associative array as follows and add it to the `types`
# array:
#
#    declare -A datestore=(
#        [name]=DateStore       # name of new SQL type 
#        [keysize]=4            # size of key in bytes (max 8 bytes)
#        [valsize]=4            # size of value in bytes (max 8 bytes)
#        [sql_key_type]=date    # SQL type of the key
#        [key_in_f]=date_in     # C input function for key
#        [key_out_f]=date_out)  # C output function for key
#


declare -A istore=(
    [name]=IStore
    [keysize]=4
    [valsize]=4
    [sql_key_type]=int4
    [key_in_f]=int4in
    [key_out_f]=int4out)

declare -A bigistore=(
    [name]=BigIStore
    [keysize]=4
    [valsize]=8
    [sql_key_type]=int4
    [key_in_f]=int4in
    [key_out_f]=int4out)

declare -A dateistore=(
    [name]=DateIStore
    [keysize]=4
    [valsize]=8
    [sql_key_type]=date
    [key_in_f]=date_in
    [key_out_f]=date_out)

declare -a types=( istore bigistore dateistore )


generate_sql() {
    template=$1
    output=$2 && shift 2
    typenames=( "$@" )
    code=""

    # extract template
    t=`awk '/{%/{p=1;next}/%}/{p=0}p' $template`

    for arrname in "${typenames[@]}"
    do
        declare -nl arrptr="$arrname"
        store_type=`echo "${arrptr[name]}" | tr '[:upper:]' '[:lower:]'`
        keytype="${arrptr[sql_key_type]}"
        valtype="int${arrptr[valsize]}"

        # replace template params with apropriate values
        code+=`echo "$t" | sed -e "s/\\${store_type}/${store_type}/g" \
                               -e "s/\\${keytype}/${keytype}/g" \
                               -e "s/\\${valtype}/${valtype}/g"`
    done

    # replace template between {% and %} with generated code
    echo "$code" > /tmp/filled_template.tmp
    cat $template | sed -e "/{%/r /tmp/filled_template.tmp" \
                        -e "/{%/,/%}/d" > $output
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
        store="${arrptr[name]}"
        keysize="${arrptr[keysize]}"
        valsize="${arrptr[valsize]}"
        keybits=$(($keysize * 8))
        valbits=$(($valsize * 8))
        store_lower=`echo "$store" | tr '[:upper:]' '[:lower:]'`
        store_upper=`echo "$store" | tr '[:lower:]' '[:upper:]'`

        # replace template params with apropriate values
        code+=`echo "$t" | sed -e "s/\\${store}/${store}/g" \
                               -e "s/\\${store_lower}/${store_lower}/g" \
                               -e "s/\\${store_upper}/${store_upper}/g" \
                               -e "s/\\${keysize}/${keysize}/g" \
                               -e "s/\\${valsize}/${valsize}/g" \
                               -e "s/\\${keybits}/${keybits}/g" \
                               -e "s/\\${valbits}/${valbits}/g" \
                               -e "s/\\${keytype}/int${keybits}/g" \
                               -e "s/\\${valtype}/int${valbits}/g" \
                               -e "s/\\${keyin}/${arrptr[key_in_f]}/g" \
                               -e "s/\\${keyout}/${arrptr[key_out_f]}/g"`
    done

    # replace template between {% and %} with generated code
    echo "$code" > /tmp/filled_template.tmp
    cat $template | sed -e "/{%/r /tmp/filled_template.tmp" \
                        -e "/{%/,/%}/d" > $output
}


echo "Generating C files"
for template in src/*.template
do
    output="${template%.*}"
    echo -ne "\t${output}..."
    generate_c_from_template $template $output "${types[@]}"
    echo "done"
done

echo "Generating SQL files"
for template in sql/*.template
do
    output="${template%.*}"
    echo -ne "\t${output}..."
    generate_sql $template $output "${types[@]}"
    echo "done"
done
#generate_c_from_template 'src/pairs.c.template' 'src/pairs.c' "${types[@]}"
#generate_c_from_template 'src/istore_io.c.template' 'src/istore_io.c' "${types[@]}"
#generate_c_from_template 'src/istore_type.c.template' 'src/istore_type.c' "${types[@]}"
#generate_c_from_template 'src/istore_agg.c.template' 'src/istore_agg.c' "${types[@]}"
#generate_c_from_template 'src/istore.h.template' 'src/istore.h' "${types[@]}"
#
#generate_sql "sql/istore.sql.template" "sql/istore.sql" "${types[@]}"
#generate_sql "sql/types.sql.template" "sql/types.sql" "${types[@]}"
