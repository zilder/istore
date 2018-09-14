EXTENSION = istore
EXTVERSION = 1.0
PG_CONFIG ?= pg_config
DATA_built = istore--$(EXTVERSION).sql
DATA = $(wildcard *--*.sql)
PGXS := $(shell $(PG_CONFIG) --pgxs)
MODULE_big = istore
OBJS = src/istore.o src/avl.o src/is_parser.o src/istore_cast.o src/istore_io.o src/istore_key_gin.o src/pairs.o src/istore_agg.o src/istore_type.o
TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
PG_CPPFLAGS  = --std=c99
include $(PGXS)
istore--$(EXTVERSION).sql: sql/types.sql sql/istore.sql sql/x-parallel.sql
	cat $^ >$@
