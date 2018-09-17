#!/usr/bin/env bash

#
# Source code generator
#
# Basicly it takes template files, extracts part between {% and %} and
# replaces template parameters (e.g. ${store}) with actual values. To generate
# new extension create `config` file (see config.sample as reference) and
# run
#   ./generate
#

extname=mystore      # defualt extension name
dependencies=
libs=
declare -a types=()

# load config
if [ -z "$1" ]
then
    source config
else
    source $1
fi

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
        store=`echo "${arrptr[name]}" | tr '[:upper:]' '[:lower:]'`
        keytype="${arrptr[key_sql_type]}"
        valtype="int${arrptr[valsize]}"

        # replace template params with apropriate values
        code+=`echo "$t" | sed -e "s/\\${store}/${store}/g" \
                               -e "s/\\${keysize}/${arrptr[keysize]}/g" \
                               -e "s/\\${keytype}/${keytype}/g" \
                               -e "s/\\${valtype}/${valtype}/g" \
                               -e "s/\\${keycmp}/${arrptr[key_cmp_f]}/g"`
    done

    # Replace template between {% and %} with generated code. Also put
    # module name to function definitions
    echo "$code" > /tmp/filled_template.tmp
    cat $template | sed -e "/{%/r /tmp/filled_template.tmp" -e "/{%/,/%}/d" \
                  | sed -e "s/\${extname}/${extname}/g" > $output
}

generate_c() {
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
                               -e "s/\\${keysql}/${arrptr[key_sql_type]}/g" \
                               -e "s/\\${keyin}/${arrptr[key_in_f]}/g" \
                               -e "s/\\${keyout}/${arrptr[key_out_f]}/g"`
    done

    # replace template between {% and %} with generated code
    echo "$code" > /tmp/filled_template.tmp
    cat $template | sed -e "/{%/r /tmp/filled_template.tmp" \
                        -e "/{%/,/%}/d" > $output
}

generate_makefile() {
    extname=$1
    cat > Makefile <<EOL
EXTENSION = $extname
EXTVERSION = 1.0
PG_CONFIG ?= pg_config
DATA_built = $extname--\$(EXTVERSION).sql
DATA = \$(wildcard *--*.sql)
PGXS := \$(shell \$(PG_CONFIG) --pgxs)
MODULE_big = $extname
OBJS = src/avl.o src/is_parser.o src/istore_io.o src/istore_key_gin.o src/pairs.o src/istore_agg.o src/istore_type.o
TESTS        = \$(wildcard test/sql/*.sql)
REGRESS      = \$(patsubst test/sql/%.sql,%,\$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
PG_CPPFLAGS += --std=c99
SHLIB_LINK  += $libs
include \$(PGXS)
$extname--\$(EXTVERSION).sql: sql/types.sql sql/istore.sql sql/x-parallel.sql
	cat \$^ >\$@
EOL
}

generate_control_file() {
    extname=$1
    cat > $extname.control <<EOL
comment = 'an integer based hstore'
default_version = '1.0'
relocatable = true
module_pathname = '\$libdir/$extname'
requires = '$dependencies'
EOL
}

echo "Generating Makefile"
generate_makefile $extname

echo "Generating control-file"
generate_control_file $extname

echo "Generating C files"
for template in src/*.template
do
    output="${template%.*}"
    echo -ne "\t${output}..."
    generate_c $template $output "${types[@]}"
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

