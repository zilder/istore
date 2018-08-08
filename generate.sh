#!/usr/bin/bash

generate() {
    typename=$1
    keybytes=$2
    valbytes=$3
    keybits=$(($keybytes * 8))
    valbits=$(($valbytes * 8))
    lowertypename=`echo $typename | tr '[:upper:]' '[:lower:]'`
    uppertypename=`echo $typename | tr '[:lower:]' '[:upper:]'`

    if [ $keybytes = 4 ]; then
        align="'i'"
    else
        align="'d'"
    fi

    defines="
        typedef $typename Store;\n
        typedef ${typename}Pair StorePair;\n
        typedef ${typename}Pairs StorePairs;\n
        typedef int${keybits} Key;\n
        typedef int${valbits} StoreValue;\n
        \n
        #define KEYSIZE ${keybytes}\n
        #define VALUESIZE ${valbytes}\n
        #define KEYOID INT${keybytes}OID\n
        #define VALUEOID INT${valbytes}OID\n
        #define VALUE_ALIGN $align\n
        #define KeyGetDatum Int${keybits}GetDatum\n
        #define ValueGetDatum Int${valbits}GetDatum\n
        #define key_cmp is_int${keybits}_arr_comp\n
        \n
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
        #define store_pair_buf_len ${lowertypename}_pair_buf_len\n
        #define store_pairs_init ${lowertypename}_pairs_init\n
        #define store_pairs_insert ${lowertypename}_pairs_insert\n
        #define plus_func int${valbytes}pl\n
        #define minus_func int${valbytes}mi\n
        #define div_func int${valbytes}div\n
        #define mul_func int${valbytes}mul\n
        #define keydigits digits${keybits}\n
        #define valdigits digits${valbits}\n
    "

    defines=`echo $defines | tr '\n' "\\n"`
    sed -e "s/\${defines}/$defines/" src/istore_type.c.template > src/${lowertypename}_type.c
}

generate IStore 4 4
generate BigIStore 4 8

