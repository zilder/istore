BEGIN;
-- bigistore functions should find keys with exists;
-- ./spec/istore/functions_plain_spec.rb:10;
CREATE EXTENSION istore;
SELECT exist('1=>1'::bigistore, 1);
SELECT exist('1=>1'::bigistore, 2);
SELECT exist('1=>1, -1=>0'::bigistore, 2);
SELECT exist('1=>1, -1=>0'::bigistore, -1);
ROLLBACK;
BEGIN;
-- bigistore functions should fetchvals;
-- ./spec/istore/functions_plain_spec.rb:17;
CREATE EXTENSION istore;
SELECT fetchval('1=>1'::bigistore, 1);
SELECT fetchval('2=>1'::bigistore, 1);
SELECT fetchval('1=>1, 1=>1'::bigistore, 1);
SELECT fetchval('1=>1, 1=>1'::bigistore, 2);
ROLLBACK;
BEGIN;
-- bigistore functions should return set of ints;
-- ./spec/istore/functions_plain_spec.rb:24;
CREATE EXTENSION istore;
SELECT * FROM each('1=>1'::bigistore);
SELECT * FROM each('5=>11, 4=>8'::bigistore);
SELECT * FROM each('5=>-411, 4=>8'::bigistore);
SELECT value + 100 FROM each('5=>-411, 4=>8'::bigistore);
SELECT * FROM each('-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore);
SELECT * FROM each(NULL::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should compact istores;
-- ./spec/istore/functions_plain_spec.rb:49;
CREATE EXTENSION istore;
SELECT compact('0=>2, 1=>2, 3=>0 ,2=>2'::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should add istores;
-- ./spec/istore/functions_plain_spec.rb:54;
CREATE EXTENSION istore;
SELECT add('1=>1, 2=>1'::bigistore, '1=>1, 2=>1'::bigistore);
SELECT add('1=>1, 2=>1'::bigistore, '-1=>1, 2=>1'::bigistore);
SELECT add('1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT add('-1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT add('-1=>-1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT add('-1=>-1, 2=>1'::bigistore, 1);
SELECT add('-1=>-1, 2=>1'::bigistore, -1);
SELECT add('-1=>-1, 2=>1'::bigistore, 0);
SELECT add(bigistore(Array[]::integer[], Array[]::integer[]), '1=>0'::bigistore);;
ROLLBACK;
BEGIN;
-- bigistore functions should substract istores;
-- ./spec/istore/functions_plain_spec.rb:75;
CREATE EXTENSION istore;
SELECT subtract('1=>1, 2=>1'::bigistore, '1=>1, 2=>1'::bigistore);
SELECT subtract('1=>1, 2=>1'::bigistore, '-1=>1, 2=>1'::bigistore);
SELECT subtract('1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT subtract('-1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT subtract('-1=>-1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT subtract('-1=>-1, 2=>1'::bigistore, 1);
SELECT subtract('-1=>-1, 2=>1'::bigistore, -1);
SELECT subtract('-1=>-1, 2=>1'::bigistore, 0);
SELECT subtract(bigistore(Array[]::integer[], Array[]::integer[]), '1=>0'::bigistore);;
ROLLBACK;
BEGIN;
-- bigistore functions should multiply istores;
-- ./spec/istore/functions_plain_spec.rb:96;
CREATE EXTENSION istore;
SELECT multiply('1=>1, 2=>1'::bigistore, '1=>1, 2=>1'::bigistore);
SELECT multiply('1=>1, 2=>1'::bigistore, '-1=>1, 2=>1'::bigistore);
SELECT multiply('1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT multiply('-1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT multiply('-1=>-1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT multiply('-1=>-1, 2=>1'::bigistore, 1);
SELECT multiply('-1=>-1, 2=>1'::bigistore, -1);
SELECT multiply('-1=>-1, 2=>1'::bigistore, 0);
ROLLBACK;
BEGIN;
-- bigistore functions should divide istores;
-- ./spec/istore/functions_plain_spec.rb:115;
CREATE EXTENSION istore;
SELECT divide('1=>1, 2=>1'::bigistore, '1=>1, 2=>1'::bigistore);
SELECT divide('1=>1, 2=>1'::bigistore, '-1=>1, 2=>1'::bigistore);
SELECT divide('1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT divide('-1=>1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT divide('-1=>-1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT divide('-1=>-1, 2=>1'::bigistore, '-1=>-1, 2=>1'::bigistore);
SELECT divide('1=>0, 2=>1'::bigistore, '1=>-1, 2=>1'::bigistore);
SELECT divide('1=>1, 2=>1'::bigistore, '1=>-1, 2=>1, 3=>0'::bigistore);
SELECT divide('1=>1, 2=>1'::bigistore, '3=>0'::bigistore);
SELECT divide('-1=>-1, 2=>1'::bigistore, -1);
ROLLBACK;
BEGIN;
-- bigistore functions should raise division by zero error;
-- ./spec/istore/functions_plain_spec.rb:137;
CREATE EXTENSION istore;
SELECT divide('-1=>-1, 2=>1'::bigistore, 0);
ROLLBACK;
BEGIN;
-- bigistore functions should raise division by zero error;
-- ./spec/istore/functions_plain_spec.rb:141;
CREATE EXTENSION istore;
SELECT divide('-1=>-1, 2=>1'::bigistore, '2=>0');
ROLLBACK;
BEGIN;
-- bigistore functions should generate #{type} from array;
-- ./spec/istore/functions_plain_spec.rb:145;
CREATE EXTENSION istore;
SELECT bigistore(ARRAY[1]);
SELECT bigistore(ARRAY[1,1,1,1]);
SELECT bigistore(NULL);
SELECT bigistore(ARRAY[1,2,3,4]);
SELECT bigistore(ARRAY[1,2,3,4,1,2,3,4]);
SELECT bigistore(ARRAY[1,2,3,4,1,2,3,NULL]);
SELECT bigistore(ARRAY[NULL,2,3,4,1,2,3,4]);
SELECT bigistore(ARRAY[NULL,2,3,4,1,2,3,NULL]);
SELECT bigistore(ARRAY[1,2,3,NULL,1,NULL,3,4,1,2,3]);
SELECT bigistore(ARRAY[NULL,NULL,NULL,NULL]::integer[]);
SELECT bigistore(ARRAY[]::integer[]);
ROLLBACK;
BEGIN;
-- bigistore functions should sum up istores;
-- ./spec/istore/functions_plain_spec.rb:167;
CREATE EXTENSION istore;
SELECT sum_up('1=>1'::bigistore);
SELECT sum_up(NULL::bigistore);
SELECT sum_up('1=>1, 2=>1'::bigistore);
SELECT sum_up('1=>1 ,2=>-1, 1=>1'::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should sum istores from table;
-- ./spec/istore/functions_plain_spec.rb:174;
CREATE EXTENSION istore;
CREATE TABLE test (a bigistore);
INSERT INTO test VALUES('1=>1'),('2=>1'), ('3=>1');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- bigistore functions should sum istores from table;
-- ./spec/istore/functions_plain_spec.rb:181;
CREATE EXTENSION istore;
CREATE TABLE test (a bigistore);
INSERT INTO test VALUES('1=>1'),('2=>1'),('3=>1'),(NULL),('3=>3');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- bigistore functions should sum istores from table;
-- ./spec/istore/functions_plain_spec.rb:188;
CREATE EXTENSION istore;
CREATE TABLE test (a bigistore);
INSERT INTO test VALUES('1=>1'),('2=>1'),('3=>1'),(NULL),('3=>0');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- bigistore functions should return istores from arrays;
-- ./spec/istore/functions_plain_spec.rb:195;
CREATE EXTENSION istore;
SELECT bigistore(Array[5,3,4,5], Array[1,2,3,4]);
SELECT bigistore(Array[5,3,4,5], Array[1,2,3,4]);
SELECT bigistore(Array[5,3,4,5], Array[4000,2,4000,4]);
ROLLBACK;
BEGIN;
-- bigistore functions should fill gaps;
-- ./spec/istore/functions_plain_spec.rb:206;
CREATE EXTENSION istore;
SELECT fill_gaps('2=>17, 4=>3'::bigistore, 5, 0);
SELECT fill_gaps('2=>17, 4=>3'::bigistore, 5);
SELECT fill_gaps('2=>17, 4=>3'::bigistore, 3, 11);
SELECT fill_gaps('2=>17, 4=>3'::bigistore, 0, 0);
SELECT fill_gaps('2=>17'::bigistore, 3, NULL);
SELECT fill_gaps('2=>0, 3=>3'::bigistore, 3, 0);
SELECT fill_gaps(''::bigistore, 3, 0);
SELECT fill_gaps(''::bigistore, 3, 400);
SELECT fill_gaps(NULL::bigistore, 3, 0);
SELECT fill_gaps('2=>17, 4=>3'::bigistore, -5, 0);
ROLLBACK;
BEGIN;
-- bigistore functions should fill accumulate;
-- ./spec/istore/functions_plain_spec.rb:235;
CREATE EXTENSION istore;
SELECT accumulate('2=>17, 4=>3'::bigistore);
SELECT accumulate('2=>0, 4=>3'::bigistore);
SELECT accumulate('1=>3, 2=>0, 4=>3, 6=>2'::bigistore);
SELECT accumulate(''::bigistore);
SELECT accumulate('10=>5'::bigistore);
SELECT accumulate(NULL::bigistore);
SELECT accumulate('-20=> 5, -10=> 5'::bigistore);
SELECT accumulate('-5=> 5, 3=> 5'::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should fill accumulate upto;
-- ./spec/istore/functions_plain_spec.rb:251;
CREATE EXTENSION istore;
SELECT accumulate('2=>17, 4=>3'::bigistore, 8);
SELECT accumulate('2=>0, 4=>3'::bigistore, 8);
SELECT accumulate('1=>3, 2=>0, 4=>3, 6=>2'::bigistore, 8);
SELECT accumulate(''::bigistore, 8);
SELECT accumulate('10=>5'::bigistore, 8);
SELECT accumulate('1=>5'::bigistore, 0);
SELECT accumulate(NULL::bigistore, 8);
SELECT accumulate('-20=> 5, -10=> 5'::bigistore, -8);
SELECT accumulate('-5=> 5, 3=> 5'::bigistore, 2);
ROLLBACK;
BEGIN;
-- bigistore functions should seed an #{type} from integer;
-- ./spec/istore/functions_plain_spec.rb:268;
CREATE EXTENSION istore;
SELECT istore_seed(2,5,8::bigint);
SELECT istore_seed(2,5,NULL::bigint);
SELECT istore_seed(2,5,0::bigint);
SELECT istore_seed(2,2,8::bigint);
SELECT istore_seed(2,0,8::bigint);
ROLLBACK;
BEGIN;
-- bigistore functions should throw an error if negativ seed span;
-- ./spec/istore/functions_plain_spec.rb:279;
CREATE EXTENSION istore;
SELECT istore_seed(-2,0,8);
ROLLBACK;
BEGIN;
-- bigistore functions should merge istores by larger keys;
-- ./spec/istore/functions_plain_spec.rb:283;
CREATE EXTENSION istore;
SELECT istore_val_larger('1=>1,2=>1,3=>3'::bigistore, '1=>2,3=>1,4=>1');
ROLLBACK;
BEGIN;
-- bigistore functions should merge istores by smaller keys;
-- ./spec/istore/functions_plain_spec.rb:288;
CREATE EXTENSION istore;
SELECT istore_val_smaller('1=>1,2=>1,3=>3'::bigistore, '1=>2,3=>1,4=>1');
ROLLBACK;
BEGIN;
-- bigistore functions should return #{type} with maxed values;
-- ./spec/istore/functions_plain_spec.rb:293;
CREATE EXTENSION istore;
SELECT MAX(s) FROM (VALUES('1=>5, 2=>2, 3=>3'::bigistore),('1=>1, 2=>5, 3=>3'),('1=>1, 2=>4, 3=>5'))t(s);
ROLLBACK;
BEGIN;
-- bigistore functions should return #{type} with maxed values;
-- ./spec/istore/functions_plain_spec.rb:298;
CREATE EXTENSION istore;
SELECT MIN(s) FROM (VALUES('1=>5, 2=>2, 3=>3'::bigistore),('1=>1, 2=>5, 3=>3'),('1=>1, 2=>4, 3=>5'))t(s);
ROLLBACK;
BEGIN;
-- bigistore functions should return keys as array;
-- ./spec/istore/functions_plain_spec.rb:303;
CREATE EXTENSION istore;
SELECT akeys('-5=>10, 0=>-5, 5=>0'::bigistore);
SELECT akeys(''::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should return values as array;
-- ./spec/istore/functions_plain_spec.rb:308;
CREATE EXTENSION istore;
SELECT avals('-5=>10, 0=>-5, 5=>0'::bigistore);
SELECT avals(''::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should return keys as set;
-- ./spec/istore/functions_plain_spec.rb:312;
CREATE EXTENSION istore;
SELECT skeys('-5=>10, 0=>-5, 5=>0'::bigistore);
SELECT skeys(''::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should return values set array;
-- ./spec/istore/functions_plain_spec.rb:320;
CREATE EXTENSION istore;
SELECT svals('-5=>10, 0=>-5, 5=>0'::bigistore);
SELECT svals(''::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should sum up istores;
-- ./spec/istore/functions_plain_spec.rb:328;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>10'::istore);
ROLLBACK;
BEGIN;
-- bigistore functions should sum up istores with big numbers;
-- ./spec/istore/functions_plain_spec.rb:331;
CREATE EXTENSION istore;
SELECT sum_up('10=>2000000000, 15=>1000000000'::istore);
ROLLBACK;
BEGIN;
-- bigistore functions should sum up bigistores;
-- ./spec/istore/functions_plain_spec.rb:335;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>10'::bigistore);
ROLLBACK;
BEGIN;
-- bigistore functions should sum up istores with negative values;
-- ./spec/istore/functions_plain_spec.rb:339;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>-10'::istore);
ROLLBACK;
BEGIN;
-- bigistore functions should sum up bigistores with negative values;
-- ./spec/istore/functions_plain_spec.rb:343;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>-10'::bigistore);
ROLLBACK;
BEGIN;
-- istore functions should find keys with exists;
-- ./spec/istore/functions_plain_spec.rb:10;
CREATE EXTENSION istore;
SELECT exist('1=>1'::istore, 1);
SELECT exist('1=>1'::istore, 2);
SELECT exist('1=>1, -1=>0'::istore, 2);
SELECT exist('1=>1, -1=>0'::istore, -1);
ROLLBACK;
BEGIN;
-- istore functions should fetchvals;
-- ./spec/istore/functions_plain_spec.rb:17;
CREATE EXTENSION istore;
SELECT fetchval('1=>1'::istore, 1);
SELECT fetchval('2=>1'::istore, 1);
SELECT fetchval('1=>1, 1=>1'::istore, 1);
SELECT fetchval('1=>1, 1=>1'::istore, 2);
ROLLBACK;
BEGIN;
-- istore functions should return set of ints;
-- ./spec/istore/functions_plain_spec.rb:24;
CREATE EXTENSION istore;
SELECT * FROM each('1=>1'::istore);
SELECT * FROM each('5=>11, 4=>8'::istore);
SELECT * FROM each('5=>-411, 4=>8'::istore);
SELECT value + 100 FROM each('5=>-411, 4=>8'::istore);
SELECT * FROM each('-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore);
SELECT * FROM each(NULL::istore);
ROLLBACK;
BEGIN;
-- istore functions should compact istores;
-- ./spec/istore/functions_plain_spec.rb:49;
CREATE EXTENSION istore;
SELECT compact('0=>2, 1=>2, 3=>0 ,2=>2'::istore);
ROLLBACK;
BEGIN;
-- istore functions should add istores;
-- ./spec/istore/functions_plain_spec.rb:54;
CREATE EXTENSION istore;
SELECT add('1=>1, 2=>1'::istore, '1=>1, 2=>1'::istore);
SELECT add('1=>1, 2=>1'::istore, '-1=>1, 2=>1'::istore);
SELECT add('1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT add('-1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT add('-1=>-1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT add('-1=>-1, 2=>1'::istore, 1);
SELECT add('-1=>-1, 2=>1'::istore, -1);
SELECT add('-1=>-1, 2=>1'::istore, 0);
SELECT add(istore(Array[]::integer[], Array[]::integer[]), '1=>0'::istore);;
ROLLBACK;
BEGIN;
-- istore functions should substract istores;
-- ./spec/istore/functions_plain_spec.rb:75;
CREATE EXTENSION istore;
SELECT subtract('1=>1, 2=>1'::istore, '1=>1, 2=>1'::istore);
SELECT subtract('1=>1, 2=>1'::istore, '-1=>1, 2=>1'::istore);
SELECT subtract('1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT subtract('-1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT subtract('-1=>-1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT subtract('-1=>-1, 2=>1'::istore, 1);
SELECT subtract('-1=>-1, 2=>1'::istore, -1);
SELECT subtract('-1=>-1, 2=>1'::istore, 0);
SELECT subtract(istore(Array[]::integer[], Array[]::integer[]), '1=>0'::istore);;
ROLLBACK;
BEGIN;
-- istore functions should multiply istores;
-- ./spec/istore/functions_plain_spec.rb:96;
CREATE EXTENSION istore;
SELECT multiply('1=>1, 2=>1'::istore, '1=>1, 2=>1'::istore);
SELECT multiply('1=>1, 2=>1'::istore, '-1=>1, 2=>1'::istore);
SELECT multiply('1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT multiply('-1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT multiply('-1=>-1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT multiply('-1=>-1, 2=>1'::istore, 1);
SELECT multiply('-1=>-1, 2=>1'::istore, -1);
SELECT multiply('-1=>-1, 2=>1'::istore, 0);
ROLLBACK;
BEGIN;
-- istore functions should divide istores;
-- ./spec/istore/functions_plain_spec.rb:115;
CREATE EXTENSION istore;
SELECT divide('1=>1, 2=>1'::istore, '1=>1, 2=>1'::istore);
SELECT divide('1=>1, 2=>1'::istore, '-1=>1, 2=>1'::istore);
SELECT divide('1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT divide('-1=>1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT divide('-1=>-1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT divide('-1=>-1, 2=>1'::istore, '-1=>-1, 2=>1'::istore);
SELECT divide('1=>0, 2=>1'::istore, '1=>-1, 2=>1'::istore);
SELECT divide('1=>1, 2=>1'::istore, '1=>-1, 2=>1, 3=>0'::istore);
SELECT divide('1=>1, 2=>1'::istore, '3=>0'::istore);
SELECT divide('-1=>-1, 2=>1'::istore, -1);
ROLLBACK;
BEGIN;
-- istore functions should raise division by zero error;
-- ./spec/istore/functions_plain_spec.rb:137;
CREATE EXTENSION istore;
SELECT divide('-1=>-1, 2=>1'::istore, 0);
ROLLBACK;
BEGIN;
-- istore functions should raise division by zero error;
-- ./spec/istore/functions_plain_spec.rb:141;
CREATE EXTENSION istore;
SELECT divide('-1=>-1, 2=>1'::istore, '2=>0');
ROLLBACK;
BEGIN;
-- istore functions should generate #{type} from array;
-- ./spec/istore/functions_plain_spec.rb:145;
CREATE EXTENSION istore;
SELECT istore(ARRAY[1]);
SELECT istore(ARRAY[1,1,1,1]);
SELECT istore(NULL);
SELECT istore(ARRAY[1,2,3,4]);
SELECT istore(ARRAY[1,2,3,4,1,2,3,4]);
SELECT istore(ARRAY[1,2,3,4,1,2,3,NULL]);
SELECT istore(ARRAY[NULL,2,3,4,1,2,3,4]);
SELECT istore(ARRAY[NULL,2,3,4,1,2,3,NULL]);
SELECT istore(ARRAY[1,2,3,NULL,1,NULL,3,4,1,2,3]);
SELECT istore(ARRAY[NULL,NULL,NULL,NULL]::integer[]);
SELECT istore(ARRAY[]::integer[]);
ROLLBACK;
BEGIN;
-- istore functions should sum up istores;
-- ./spec/istore/functions_plain_spec.rb:167;
CREATE EXTENSION istore;
SELECT sum_up('1=>1'::istore);
SELECT sum_up(NULL::istore);
SELECT sum_up('1=>1, 2=>1'::istore);
SELECT sum_up('1=>1 ,2=>-1, 1=>1'::istore);
ROLLBACK;
BEGIN;
-- istore functions should sum istores from table;
-- ./spec/istore/functions_plain_spec.rb:174;
CREATE EXTENSION istore;
CREATE TABLE test (a istore);
INSERT INTO test VALUES('1=>1'),('2=>1'), ('3=>1');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- istore functions should sum istores from table;
-- ./spec/istore/functions_plain_spec.rb:181;
CREATE EXTENSION istore;
CREATE TABLE test (a istore);
INSERT INTO test VALUES('1=>1'),('2=>1'),('3=>1'),(NULL),('3=>3');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- istore functions should sum istores from table;
-- ./spec/istore/functions_plain_spec.rb:188;
CREATE EXTENSION istore;
CREATE TABLE test (a istore);
INSERT INTO test VALUES('1=>1'),('2=>1'),('3=>1'),(NULL),('3=>0');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- istore functions should return istores from arrays;
-- ./spec/istore/functions_plain_spec.rb:195;
CREATE EXTENSION istore;
SELECT istore(Array[5,3,4,5], Array[1,2,3,4]);
SELECT istore(Array[5,3,4,5], Array[1,2,3,4]);
SELECT istore(Array[5,3,4,5], Array[4000,2,4000,4]);
ROLLBACK;
BEGIN;
-- istore functions should fill gaps;
-- ./spec/istore/functions_plain_spec.rb:206;
CREATE EXTENSION istore;
SELECT fill_gaps('2=>17, 4=>3'::istore, 5, 0);
SELECT fill_gaps('2=>17, 4=>3'::istore, 5);
SELECT fill_gaps('2=>17, 4=>3'::istore, 3, 11);
SELECT fill_gaps('2=>17, 4=>3'::istore, 0, 0);
SELECT fill_gaps('2=>17'::istore, 3, NULL);
SELECT fill_gaps('2=>0, 3=>3'::istore, 3, 0);
SELECT fill_gaps(''::istore, 3, 0);
SELECT fill_gaps(''::istore, 3, 400);
SELECT fill_gaps(NULL::istore, 3, 0);
SELECT fill_gaps('2=>17, 4=>3'::istore, -5, 0);
ROLLBACK;
BEGIN;
-- istore functions should fill accumulate;
-- ./spec/istore/functions_plain_spec.rb:235;
CREATE EXTENSION istore;
SELECT accumulate('2=>17, 4=>3'::istore);
SELECT accumulate('2=>0, 4=>3'::istore);
SELECT accumulate('1=>3, 2=>0, 4=>3, 6=>2'::istore);
SELECT accumulate(''::istore);
SELECT accumulate('10=>5'::istore);
SELECT accumulate(NULL::istore);
SELECT accumulate('-20=> 5, -10=> 5'::istore);
SELECT accumulate('-5=> 5, 3=> 5'::istore);
ROLLBACK;
BEGIN;
-- istore functions should fill accumulate upto;
-- ./spec/istore/functions_plain_spec.rb:251;
CREATE EXTENSION istore;
SELECT accumulate('2=>17, 4=>3'::istore, 8);
SELECT accumulate('2=>0, 4=>3'::istore, 8);
SELECT accumulate('1=>3, 2=>0, 4=>3, 6=>2'::istore, 8);
SELECT accumulate(''::istore, 8);
SELECT accumulate('10=>5'::istore, 8);
SELECT accumulate('1=>5'::istore, 0);
SELECT accumulate(NULL::istore, 8);
SELECT accumulate('-20=> 5, -10=> 5'::istore, -8);
SELECT accumulate('-5=> 5, 3=> 5'::istore, 2);
ROLLBACK;
BEGIN;
-- istore functions should seed an #{type} from integer;
-- ./spec/istore/functions_plain_spec.rb:268;
CREATE EXTENSION istore;
SELECT istore_seed(2,5,8::int);
SELECT istore_seed(2,5,NULL::int);
SELECT istore_seed(2,5,0::int);
SELECT istore_seed(2,2,8::int);
SELECT istore_seed(2,0,8::int);
ROLLBACK;
BEGIN;
-- istore functions should throw an error if negativ seed span;
-- ./spec/istore/functions_plain_spec.rb:279;
CREATE EXTENSION istore;
SELECT istore_seed(-2,0,8);
ROLLBACK;
BEGIN;
-- istore functions should merge istores by larger keys;
-- ./spec/istore/functions_plain_spec.rb:283;
CREATE EXTENSION istore;
SELECT istore_val_larger('1=>1,2=>1,3=>3'::istore, '1=>2,3=>1,4=>1');
ROLLBACK;
BEGIN;
-- istore functions should merge istores by smaller keys;
-- ./spec/istore/functions_plain_spec.rb:288;
CREATE EXTENSION istore;
SELECT istore_val_smaller('1=>1,2=>1,3=>3'::istore, '1=>2,3=>1,4=>1');
ROLLBACK;
BEGIN;
-- istore functions should return #{type} with maxed values;
-- ./spec/istore/functions_plain_spec.rb:293;
CREATE EXTENSION istore;
SELECT MAX(s) FROM (VALUES('1=>5, 2=>2, 3=>3'::istore),('1=>1, 2=>5, 3=>3'),('1=>1, 2=>4, 3=>5'))t(s);
ROLLBACK;
BEGIN;
-- istore functions should return #{type} with maxed values;
-- ./spec/istore/functions_plain_spec.rb:298;
CREATE EXTENSION istore;
SELECT MIN(s) FROM (VALUES('1=>5, 2=>2, 3=>3'::istore),('1=>1, 2=>5, 3=>3'),('1=>1, 2=>4, 3=>5'))t(s);
ROLLBACK;
BEGIN;
-- istore functions should return keys as array;
-- ./spec/istore/functions_plain_spec.rb:303;
CREATE EXTENSION istore;
SELECT akeys('-5=>10, 0=>-5, 5=>0'::istore);
SELECT akeys(''::istore);
ROLLBACK;
BEGIN;
-- istore functions should return values as array;
-- ./spec/istore/functions_plain_spec.rb:308;
CREATE EXTENSION istore;
SELECT avals('-5=>10, 0=>-5, 5=>0'::istore);
SELECT avals(''::istore);
ROLLBACK;
BEGIN;
-- istore functions should return keys as set;
-- ./spec/istore/functions_plain_spec.rb:312;
CREATE EXTENSION istore;
SELECT skeys('-5=>10, 0=>-5, 5=>0'::istore);
SELECT skeys(''::istore);
ROLLBACK;
BEGIN;
-- istore functions should return values set array;
-- ./spec/istore/functions_plain_spec.rb:320;
CREATE EXTENSION istore;
SELECT svals('-5=>10, 0=>-5, 5=>0'::istore);
SELECT svals(''::istore);
ROLLBACK;
BEGIN;
-- istore functions should sum up istores;
-- ./spec/istore/functions_plain_spec.rb:328;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>10'::istore);
ROLLBACK;
BEGIN;
-- istore functions should sum up istores with big numbers;
-- ./spec/istore/functions_plain_spec.rb:331;
CREATE EXTENSION istore;
SELECT sum_up('10=>2000000000, 15=>1000000000'::istore);
ROLLBACK;
BEGIN;
-- istore functions should sum up bigistores;
-- ./spec/istore/functions_plain_spec.rb:335;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>10'::bigistore);
ROLLBACK;
BEGIN;
-- istore functions should sum up istores with negative values;
-- ./spec/istore/functions_plain_spec.rb:339;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>-10'::istore);
ROLLBACK;
BEGIN;
-- istore functions should sum up bigistores with negative values;
-- ./spec/istore/functions_plain_spec.rb:343;
CREATE EXTENSION istore;
SELECT sum_up('10=>5, 15=>-10'::bigistore);
ROLLBACK;
