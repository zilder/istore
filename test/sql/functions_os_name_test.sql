BEGIN;
-- functions_os_name should find presence of a key;
-- ./spec/functions_os_name_spec.rb:8;
CREATE EXTENSION istore;
SELECT exist('ios=>1'::os_name_istore, 'ios');
SELECT exist('ios=>1'::os_name_istore, 'android');
SELECT exist('ios=>1, android=>0'::os_name_istore, 'ios');
SELECT exist('ios=>1, android=>0'::os_name_istore, 'windows');
ROLLBACK;
BEGIN;
-- functions_os_name should fetch values;
-- ./spec/functions_os_name_spec.rb:15;
CREATE EXTENSION istore;
SELECT fetchval('ios=>1'::os_name_istore, 'ios');
SELECT fetchval('windows=>1'::os_name_istore, 'ios');
SELECT fetchval('ios=>1, ios=>1'::os_name_istore, 'ios');
SELECT fetchval('ios=>1, ios=>1'::os_name_istore, 'windows');
ROLLBACK;
BEGIN;
-- functions_os_name should add to os_name_istores;
-- ./spec/functions_os_name_spec.rb:22;
CREATE EXTENSION istore;
SELECT add('ios=>1, windows=>1'::os_name_istore, 'ios=>1, windows=>1'::os_name_istore);
SELECT add('ios=>1, windows=>1'::os_name_istore, 'android=>1, windows=>1'::os_name_istore);
SELECT add('ios=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT add('android=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT add('android=>-1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT add('android=>-1, windows=>1'::os_name_istore, 1);
SELECT add('android=>-1, windows=>1'::os_name_istore, -1);
SELECT add('android=>-1, windows=>1'::os_name_istore, 0);
ROLLBACK;
BEGIN;
-- functions_os_name should substract to os_name_istores;
-- ./spec/functions_os_name_spec.rb:48;
CREATE EXTENSION istore;
SELECT subtract('ios=>1, windows=>1'::os_name_istore, 'ios=>1, windows=>1'::os_name_istore);
SELECT subtract('ios=>1, windows=>1'::os_name_istore, 'android=>1, windows=>1'::os_name_istore);
SELECT subtract('ios=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT subtract('android=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT subtract('android=>-1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT subtract('android=>-1, windows=>1'::os_name_istore, 1);
SELECT subtract('android=>-1, windows=>1'::os_name_istore, -1);
SELECT subtract('android=>-1, windows=>1'::os_name_istore, 0);
ROLLBACK;
BEGIN;
-- functions_os_name should multiply two os_name_istores;
-- ./spec/functions_os_name_spec.rb:74;
CREATE EXTENSION istore;
SELECT multiply('ios=>1, windows=>1'::os_name_istore, 'ios=>1, windows=>1'::os_name_istore);
SELECT multiply('ios=>1, windows=>1'::os_name_istore, 'android=>1, windows=>1'::os_name_istore);
SELECT multiply('ios=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT multiply('android=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT multiply('android=>-1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT multiply('android=>-1, windows=>1'::os_name_istore, 1);
SELECT multiply('android=>-1, windows=>1'::os_name_istore, -1);
SELECT multiply('android=>-1, windows=>1'::os_name_istore, 0);
ROLLBACK;
BEGIN;
-- functions_os_name should divide two os_name_istores;
-- ./spec/functions_os_name_spec.rb:100;
CREATE EXTENSION istore;
SELECT divide('ios=>1, windows=>1'::os_name_istore, 'ios=>1, windows=>1'::os_name_istore);
SELECT divide('ios=>1, windows=>1'::os_name_istore, 'android=>1, windows=>1'::os_name_istore);
SELECT divide('ios=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT divide('android=>1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT divide('android=>-1, windows=>1'::os_name_istore, 'android=>-1, windows=>1'::os_name_istore);
SELECT divide('android=>-1, windows=>1'::os_name_istore, 1);
SELECT divide('android=>-1, windows=>1'::os_name_istore, -1);
SELECT divide('android=>-1, windows=>1'::os_name_istore, 0);
SELECT divide('android=>-1, windows=>1'::os_name_istore, 1::bigint);
SELECT divide('android=>-1, windows=>1'::os_name_istore, -1::bigint);
SELECT divide('android=>-1, windows=>1'::os_name_istore, 0::bigint);
SELECT divide('android=>-8000000000, windows=>8000000000'::os_name_istore, 4000000000);
ROLLBACK;
BEGIN;
-- functions_os_name should generate an os_name_istore from array;
-- ./spec/functions_os_name_spec.rb:138;
CREATE EXTENSION istore;
SELECT os_name_istore_from_array(ARRAY['android']);
SELECT os_name_istore_from_array(ARRAY['android','android','android','android']);
SELECT os_name_istore_from_array(NULL::text[]);
SELECT os_name_istore_from_array(ARRAY['android','ios','windows','windows-phone']);
SELECT os_name_istore_from_array(ARRAY['android','ios','windows','windows-phone','android','ios','windows','windows-phone']);
SELECT os_name_istore_from_array(ARRAY['android','ios','windows','windows-phone','android','ios','windows',NULL]);
SELECT os_name_istore_from_array(ARRAY[NULL,'ios','windows','windows-phone','android','ios','windows','windows-phone']);
SELECT os_name_istore_from_array(ARRAY[NULL,'ios','windows','windows-phone','android','ios','windows',NULL]);
SELECT os_name_istore_from_array(ARRAY['android','ios','windows',NULL,'android',NULL,'windows','windows-phone','android','ios','windows']);
SELECT os_name_istore_from_array(ARRAY['android'::os_name]);
SELECT os_name_istore_from_array(ARRAY['android'::os_name,'android'::os_name,'android'::os_name,'android'::os_name]);
SELECT os_name_istore_from_array(NULL::text[]);
SELECT os_name_istore_from_array(ARRAY['android'::os_name,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name]);
SELECT os_name_istore_from_array(ARRAY['android'::os_name,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name,'android'::os_name,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name]);
SELECT os_name_istore_from_array(ARRAY['android'::os_name,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name,'android'::os_name,'ios'::os_name,'windows'::os_name,NULL]);
SELECT os_name_istore_from_array(ARRAY[NULL,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name,'android'::os_name,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name]);
SELECT os_name_istore_from_array(ARRAY[NULL,'ios'::os_name,'windows'::os_name,'windows-phone'::os_name,'android'::os_name,'ios'::os_name,'windows'::os_name, NULL]);
SELECT os_name_istore_from_array(ARRAY['android'::os_name,'ios'::os_name,'windows'::os_name,NULL,'android'::os_name,NULL,'windows'::os_name,'windows-phone'::os_name,'android'::os_name,'ios'::os_name,'windows'::os_name]);
SELECT os_name_istore_from_array(ARRAY[NULL::os_name,NULL::os_name,NULL::os_name,NULL::os_name,NULL::os_name,NULL::os_name,NULL::os_name,NULL::os_name,NULL,NULL::os_name,NULL]);
SELECT os_name_istore_from_array(ARRAY[]::os_name[]);
ROLLBACK;
BEGIN;
-- functions_os_name should agg an array of os_name_istores;
-- ./spec/functions_os_name_spec.rb:196;
CREATE EXTENSION istore;
SELECT os_name_istore_agg(ARRAY['ios=>1']::os_name_istore[]);
SELECT os_name_istore_agg(ARRAY['ios=>1','ios=>1']::os_name_istore[]);
SELECT os_name_istore_agg(ARRAY['ios=>1,windows=>1','ios=>1,windows=>-1']::os_name_istore[]);
SELECT os_name_istore_agg(ARRAY['ios=>1,windows=>1','ios=>1,windows=>-1',NULL]::os_name_istore[]);
SELECT os_name_istore_agg(ARRAY[NULL,'ios=>1,windows=>1','ios=>1,windows=>-1']::os_name_istore[]);
SELECT os_name_istore_agg(ARRAY[NULL,'ios=>1,windows=>1','ios=>1,windows=>-1',NULL]::os_name_istore[]);
ROLLBACK;
BEGIN;
-- functions_os_name should sum_up os_name_istores;
-- ./spec/functions_os_name_spec.rb:216;
CREATE EXTENSION istore;
SELECT os_name_istore_sum_up('ios=>1'::os_name_istore);
SELECT os_name_istore_sum_up(NULL::os_name_istore);
SELECT os_name_istore_sum_up('ios=>1, windows=>1'::os_name_istore);
SELECT os_name_istore_sum_up('ios=>1 ,windows=>-1, ios=>1'::os_name_istore);
ROLLBACK;
BEGIN;
-- functions_os_name should SUM os_names FROM table;
-- ./spec/functions_os_name_spec.rb:226;
CREATE EXTENSION istore;
CREATE TABLE test (a os_name_istore);
INSERT INTO test VALUES('ios=>1'),('windows=>1'),('windows-phone=>1');
SELECT SUM(a) FROM test;
ROLLBACK;
BEGIN;
-- functions_os_name should SUM os_names FROM table;
-- ./spec/functions_os_name_spec.rb:233;
CREATE EXTENSION istore;
CREATE TABLE test (a os_name_istore);
INSERT INTO test VALUES('ios=>1'),('windows=>1'),('windows-phone=>1'),(NULL),('windows-phone=>3');
SELECT SUM(a) FROM test;
ROLLBACK;
