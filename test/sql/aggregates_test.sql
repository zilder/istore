BEGIN;
-- isagg int should skip null keys;
-- ./spec/istore/aggregates_spec.rb:9;
CREATE EXTENSION istore;
SELECT id, isagg(NULLIF(i%10,3), NULLIF(i::int, 50) ) FROM generate_series(1,100) i, generate_series(1,3) id GROUP BY id ORDER BY id;;
ROLLBACK;
BEGIN;
-- isagg int should skip null values;
-- ./spec/istore/aggregates_spec.rb:16;
CREATE EXTENSION istore;
SELECT id, isagg((i%10), NULL::int) FROM generate_series(1,100) i, generate_series(1,3) id GROUP BY id ORDER BY id;;
ROLLBACK;
BEGIN;
-- isagg bigint should skip null keys;
-- ./spec/istore/aggregates_spec.rb:9;
CREATE EXTENSION istore;
SELECT id, isagg(NULLIF(i%10,3), NULLIF(i::bigint, 50) ) FROM generate_series(1,100) i, generate_series(1,3) id GROUP BY id ORDER BY id;;
ROLLBACK;
BEGIN;
-- isagg bigint should skip null values;
-- ./spec/istore/aggregates_spec.rb:16;
CREATE EXTENSION istore;
SELECT id, isagg((i%10), NULL::bigint) FROM generate_series(1,100) i, generate_series(1,3) id GROUP BY id ORDER BY id;;
ROLLBACK;
