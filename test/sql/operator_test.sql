BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>0'::bigistore -> -1;
SELECT '1=>1, -1=>3'::bigistore -> -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore ? -1;
SELECT '1=>1, -1=>3'::bigistore ? 5;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore + '1=>1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore + '-1=>-1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore + '1=>-1'::bigistore;
SELECT '1=>0, -1=>3'::bigistore + '1=>-1'::bigistore;
SELECT '1=>1, -1=>0'::bigistore + '-1=>-1'::bigistore;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore  + 1;
SELECT '-1=>1, 1=>3'::bigistore  + 1;
SELECT '-1=>1, -1=>3'::bigistore + 1;
SELECT '1=>1, -1=>3'::bigistore  + 0;
SELECT '-1=>1, 1=>3'::bigistore  + 0;
SELECT '-1=>1, -1=>3'::bigistore + 0;
SELECT '1=>1, -1=>3'::bigistore  + -1;
SELECT '-1=>1, 1=>3'::bigistore  + -1;
SELECT '-1=>1, -1=>3'::bigistore + -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore - '1=>1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore - '-1=>-1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore - '1=>-1'::bigistore;
SELECT '1=>0, -1=>3'::bigistore - '1=>-1'::bigistore;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore  - 1;
SELECT '-1=>1, 1=>3'::bigistore  - 1;
SELECT '-1=>1, -1=>3'::bigistore - 1;
SELECT '1=>1, -1=>3'::bigistore  - 0;
SELECT '-1=>1, 1=>3'::bigistore  - 0;
SELECT '-1=>1, -1=>3'::bigistore - 0;
SELECT '1=>1, -1=>3'::bigistore  - -1;
SELECT '-1=>1, 1=>3'::bigistore  - -1;
SELECT '-1=>1, -1=>3'::bigistore - -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>3, 2=>2'::bigistore * '1=>2, 3=>5'::bigistore;
SELECT '-1=>3, 2=>2'::bigistore * '-1=>2, 3=>5'::bigistore;
SELECT '-1=>3, 2=>2'::bigistore * '-1=>-2, 3=>5'::bigistore;
SELECT '-1=>3, 2=>0'::bigistore * '-1=>-2, 3=>5'::bigistore;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore  * 1;
SELECT '-1=>1, 1=>3'::bigistore  * 1;
SELECT '-1=>1, -1=>3'::bigistore * 1;
SELECT '1=>1, -1=>3'::bigistore  * 0;
SELECT '-1=>1, 1=>3'::bigistore  * 0;
SELECT '-1=>1, -1=>3'::bigistore * 0;
SELECT '1=>1, -1=>3'::bigistore  * -1;
SELECT '-1=>1, 1=>3'::bigistore  * -1;
SELECT '-1=>1, -1=>3'::bigistore * -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>0'::istore -> -1;
SELECT '1=>1, -1=>3'::istore -> -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore ? -1;
SELECT '1=>1, -1=>3'::istore ? 5;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore + '1=>1'::istore;
SELECT '1=>1, -1=>3'::istore + '-1=>-1'::istore;
SELECT '1=>1, -1=>3'::istore + '1=>-1'::istore;
SELECT '1=>0, -1=>3'::istore + '1=>-1'::istore;
SELECT '1=>1, -1=>0'::istore + '-1=>-1'::istore;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore  + 1;
SELECT '-1=>1, 1=>3'::istore  + 1;
SELECT '-1=>1, -1=>3'::istore + 1;
SELECT '1=>1, -1=>3'::istore  + 0;
SELECT '-1=>1, 1=>3'::istore  + 0;
SELECT '-1=>1, -1=>3'::istore + 0;
SELECT '1=>1, -1=>3'::istore  + -1;
SELECT '-1=>1, 1=>3'::istore  + -1;
SELECT '-1=>1, -1=>3'::istore + -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore - '1=>1'::istore;
SELECT '1=>1, -1=>3'::istore - '-1=>-1'::istore;
SELECT '1=>1, -1=>3'::istore - '1=>-1'::istore;
SELECT '1=>0, -1=>3'::istore - '1=>-1'::istore;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore  - 1;
SELECT '-1=>1, 1=>3'::istore  - 1;
SELECT '-1=>1, -1=>3'::istore - 1;
SELECT '1=>1, -1=>3'::istore  - 0;
SELECT '-1=>1, 1=>3'::istore  - 0;
SELECT '-1=>1, -1=>3'::istore - 0;
SELECT '1=>1, -1=>3'::istore  - -1;
SELECT '-1=>1, 1=>3'::istore  - -1;
SELECT '-1=>1, -1=>3'::istore - -1;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>3, 2=>2'::istore * '1=>2, 3=>5'::istore;
SELECT '-1=>3, 2=>2'::istore * '-1=>2, 3=>5'::istore;
SELECT '-1=>3, 2=>2'::istore * '-1=>-2, 3=>5'::istore;
SELECT '-1=>3, 2=>0'::istore * '-1=>-2, 3=>5'::istore;
ROLLBACK;
BEGIN;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore  * 1;
SELECT '-1=>1, 1=>3'::istore  * 1;
SELECT '-1=>1, -1=>3'::istore * 1;
SELECT '1=>1, -1=>3'::istore  * 0;
SELECT '-1=>1, 1=>3'::istore  * 0;
SELECT '-1=>1, -1=>3'::istore * 0;
SELECT '1=>1, -1=>3'::istore  * -1;
SELECT '-1=>1, 1=>3'::istore  * -1;
SELECT '-1=>1, -1=>3'::istore * -1;
ROLLBACK;

-- ISTORE = and <> operators
BEGIN;
CREATE EXTENSION istore;
-- = TRUE
SELECT '1=>1, -1=>0'::istore = '1=>1, -1=>0'::istore;
SELECT '1=>1, -1=>0'::istore = '-1=>0, 1=>1'::istore;
SELECT '1=>1, 1=>1'::istore  = '1=>2'::istore;
SELECT ''::istore = ''::istore;
SELECT NULLIF('1=>1, -1=>100'::istore, '1=>1, -1=>0'::istore);
-- <> TRUE
SELECT '1=>1, -1=>0'::istore <> '1=>1'::istore;
-- = FALSE
SELECT '1=>1, -1=>0, -2=>-2'::istore = '1=>1, -1=>0'::istore;
-- <> FALSE
SELECT '1=>1, -1=>0'::istore != '1=>1, -1=>0'::istore;
-- NULL cases
SELECT (NULL::istore = '1=>1, -1=>0'::istore) is null;
SELECT (NULL::istore = NULL::istore) is null;
SELECT (NULLIF('1=>1, -1=>0'::istore, '1=>1, -1=>0'::istore)) is null;
ROLLBACK;

-- BIGISTORE = and <> operators
BEGIN;
CREATE EXTENSION istore;
-- = TRUE
SELECT '1=>1234123412341234, -1=>1234123412341234'::bigistore = '1=>1234123412341234, -1=>1234123412341234'::bigistore;
SELECT '1=>1, -1=>0'::bigistore = '-1=>0, 1=>1'::bigistore;
SELECT '1=>1, 1=>1'::bigistore  = '1=>2'::bigistore;
SELECT ''::bigistore = ''::bigistore;
SELECT NULLIF('1=>1, -1=>100'::bigistore, '1=>1, -1=>0'::bigistore);
-- <> TRUE
SELECT '1=>1, -1=>0'::bigistore <> '1=>1'::bigistore;
-- = FALSE
SELECT '1=>1234123412341234, -1=>1234123412341234'::bigistore = '100=>1234123412341234, -100=>1234123412341234'::bigistore;
-- <> FALSE
SELECT '1=>1, -1=>0'::bigistore != '1=>1, -1=>0'::bigistore;
-- NULL cases
SELECT (NULL::bigistore = '1=>1, -1=>0'::bigistore) is null;
SELECT (NULL::bigistore = NULL::bigistore) is null;
SELECT (NULLIF('1=>1, -1=>0'::bigistore, '1=>1, -1=>0'::bigistore)) is null;
ROLLBACK;
