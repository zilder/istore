#http://blog.pgxn.org/post/4783001135/extension-makefiles pg makefiles
EXTENSION = istore
EXTVERSION = 0.1.8
PG_CONFIG ?= pg_config
DATA_built = istore--$(EXTVERSION).sql
DATA = $(wildcard *--*.sql)
EXTRA_CLEAN = sql/istore.sql sql/bigistore.sql
PGXS := $(shell $(PG_CONFIG) --pgxs)
MODULE_big = istore
OBJS = $(patsubst %.c,%.o,$(wildcard src/*.c))
TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
PG_CPPFLAGS  = --std=c99
include $(PGXS)

istore--$(EXTVERSION).sql: sql/head.sql sql/bigistore.sql sql/istore.sql sql/crosstype.sql
	cat $^ >$@

sql/istore.sql:
	sed -e "s/%type%/istore/g;s/%basetype%/integer/g" sql/istore.sql.template >$@

sql/bigistore.sql:
	sed -e "s/%type%/bigistore/g;s/%basetype%/bigint/g" sql/istore.sql.template >$@
