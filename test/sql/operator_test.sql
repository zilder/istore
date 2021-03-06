BEGIN;
-- bigistore operators bigistore should fetch values;
-- ./spec/istore/operator_spec.rb:10;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>0'::bigistore -> -1;
SELECT '1=>1, -1=>3'::bigistore -> -1;
SELECT '0=>40000000000'::bigistore->0;
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore -> 10;
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore -> Array[10,0];
ROLLBACK;
BEGIN;
-- bigistore operators bigistore should check existense of a key;
-- ./spec/istore/operator_spec.rb:20;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore ? -1;
SELECT '1=>1, -1=>3'::bigistore ? 5;
ROLLBACK;
BEGIN;
-- bigistore operators bigistore should add two bigistore;
-- ./spec/istore/operator_spec.rb:25;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore + '1=>1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore + '-1=>-1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore + '1=>-1'::bigistore;
SELECT '1=>0, -1=>3'::bigistore + '1=>-1'::bigistore;
SELECT '1=>1, -1=>0'::bigistore + '-1=>-1'::bigistore;
ROLLBACK;
BEGIN;
-- bigistore operators bigistore should add an integer to #{type};
-- ./spec/istore/operator_spec.rb:39;
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
-- bigistore operators bigistore should substract two bigistore;
-- ./spec/istore/operator_spec.rb:60;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::bigistore - '1=>1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore - '-1=>-1'::bigistore;
SELECT '1=>1, -1=>3'::bigistore - '1=>-1'::bigistore;
SELECT '1=>0, -1=>3'::bigistore - '1=>-1'::bigistore;
ROLLBACK;
BEGIN;
-- bigistore operators bigistore should substract integer from bigistore;
-- ./spec/istore/operator_spec.rb:71;
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
-- bigistore operators bigistore should multiply two bigistore;
-- ./spec/istore/operator_spec.rb:92;
CREATE EXTENSION istore;
SELECT '1=>3, 2=>2'::bigistore * '1=>2, 3=>5'::bigistore;
SELECT '-1=>3, 2=>2'::bigistore * '-1=>2, 3=>5'::bigistore;
SELECT '-1=>3, 2=>2'::bigistore * '-1=>-2, 3=>5'::bigistore;
SELECT '-1=>3, 2=>0'::bigistore * '-1=>-2, 3=>5'::bigistore;
ROLLBACK;
BEGIN;
-- bigistore operators bigistore should multiply #{type} with integer;
-- ./spec/istore/operator_spec.rb:103;
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
-- bigistore operators bigistore should return convert to array;
-- ./spec/istore/operator_spec.rb:124;
CREATE EXTENSION istore;
SELECT %%'-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore;
SELECT %#'-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore;
ROLLBACK;
BEGIN;
-- bigistore operators bigistore existence should check presence of a key;
-- ./spec/istore/operator_spec.rb:132;
CREATE EXTENSION istore;
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore ? 10;
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore ? 25;
ROLLBACK;
BEGIN;
-- bigistore operators bigistore existence should check presence of any key;
-- ./spec/istore/operator_spec.rb:136;
CREATE EXTENSION istore;
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore ?| Array[10,0];
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore ?| Array[27,25];
ROLLBACK;
BEGIN;
-- bigistore operators bigistore existence should check presence of all key;
-- ./spec/istore/operator_spec.rb:140;
CREATE EXTENSION istore;
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore ?& Array[10,0];
SELECT '-2147483647 => 10, -10 => -9223372036854775807, 0 => 5, 10 => 9223372036854775806, 2147483647 => 10'::bigistore ?& Array[27,25];
ROLLBACK;
BEGIN;
-- istore operators istore should fetch values;
-- ./spec/istore/operator_spec.rb:10;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>0'::istore -> -1;
SELECT '1=>1, -1=>3'::istore -> -1;
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore -> 10;
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore -> Array[10,0];
ROLLBACK;
BEGIN;
-- istore operators istore should check existense of a key;
-- ./spec/istore/operator_spec.rb:20;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore ? -1;
SELECT '1=>1, -1=>3'::istore ? 5;
ROLLBACK;
BEGIN;
-- istore operators istore should add two istore;
-- ./spec/istore/operator_spec.rb:25;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore + '1=>1'::istore;
SELECT '1=>1, -1=>3'::istore + '-1=>-1'::istore;
SELECT '1=>1, -1=>3'::istore + '1=>-1'::istore;
SELECT '1=>0, -1=>3'::istore + '1=>-1'::istore;
SELECT '1=>1, -1=>0'::istore + '-1=>-1'::istore;
ROLLBACK;
BEGIN;
-- istore operators istore should add an integer to #{type};
-- ./spec/istore/operator_spec.rb:39;
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
-- istore operators istore should substract two istore;
-- ./spec/istore/operator_spec.rb:60;
CREATE EXTENSION istore;
SELECT '1=>1, -1=>3'::istore - '1=>1'::istore;
SELECT '1=>1, -1=>3'::istore - '-1=>-1'::istore;
SELECT '1=>1, -1=>3'::istore - '1=>-1'::istore;
SELECT '1=>0, -1=>3'::istore - '1=>-1'::istore;
ROLLBACK;
BEGIN;
-- istore operators istore should substract integer from istore;
-- ./spec/istore/operator_spec.rb:71;
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
-- istore operators istore should multiply two istore;
-- ./spec/istore/operator_spec.rb:92;
CREATE EXTENSION istore;
SELECT '1=>3, 2=>2'::istore * '1=>2, 3=>5'::istore;
SELECT '-1=>3, 2=>2'::istore * '-1=>2, 3=>5'::istore;
SELECT '-1=>3, 2=>2'::istore * '-1=>-2, 3=>5'::istore;
SELECT '-1=>3, 2=>0'::istore * '-1=>-2, 3=>5'::istore;
ROLLBACK;
BEGIN;
-- istore operators istore should multiply #{type} with integer;
-- ./spec/istore/operator_spec.rb:103;
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
BEGIN;
-- istore operators istore should return convert to array;
-- ./spec/istore/operator_spec.rb:124;
CREATE EXTENSION istore;
SELECT %%'-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore;
SELECT %#'-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore;
ROLLBACK;
BEGIN;
-- istore operators istore existence should check presence of a key;
-- ./spec/istore/operator_spec.rb:132;
CREATE EXTENSION istore;
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore ? 10;
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore ? 25;
ROLLBACK;
BEGIN;
-- istore operators istore existence should check presence of any key;
-- ./spec/istore/operator_spec.rb:136;
CREATE EXTENSION istore;
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore ?| Array[10,0];
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore ?| Array[27,25];
ROLLBACK;
BEGIN;
-- istore operators istore existence should check presence of all key;
-- ./spec/istore/operator_spec.rb:140;
CREATE EXTENSION istore;
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore ?& Array[10,0];
SELECT '-2147483647 => 10, -10 => -2147483647, 0 => 5, 10 => 2147483647, 2147483647 => 10'::istore ?& Array[27,25];
ROLLBACK;
