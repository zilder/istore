EXTENSION = istore
EXTVERSION = 0.1.8
PG_CONFIG ?= pg_config
DATA_built = istore--$(EXTVERSION).sql
DATA = $(wildcard *--*.sql)
EXTRA_CLEAN = src/istore_type.c src/istore_io.c src/istore_agg.c sql/istore.sql sql/types.sql
PGXS := $(shell $(PG_CONFIG) --pgxs)
MODULE_big = istore
OBJS = src/istore.o src/avl.o src/depcode.o src/is_parser.o src/istore_cast.o src/istore_io.o src/istore_key_gin.o src/pairs.o src/istore_agg.o src/istore_type.o
TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
PG_CPPFLAGS  = --std=c99
include $(PGXS)

istore--$(EXTVERSION).sql: sql/types.sql sql/istore.sql
	cat $^ >$@

src/istore_type.c src/istore_agg.c src/istore_io.c src/pairs.c sql/istore.sql sql/types.sql:
	./generate.sh

