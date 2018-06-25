--require types
--require istore
--require bigistore
--require casts

DO $$
DECLARE version_num integer;
BEGIN
  SELECT current_setting('server_version_num') INTO STRICT version_num;
  IF version_num > 90600 THEN
    EXECUTE "ALTER FUNCTION istore_in(cstring) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_out(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_send(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_recv(internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_in(cstring) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_out(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_send(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_recv(internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION exist(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION fetchval(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION each(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION min_key(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION max_key(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION compact(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION add(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION add(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION subtract(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION subtract(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION multiply(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION multiply(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION divide(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION divide(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION concat(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore(integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION sum_up(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION sum_up(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore(integer[], integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION fill_gaps(istore, integer, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION accumulate(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION accumulate(istore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_seed(integer, integer, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_val_larger(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_val_smaller(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION akeys(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION avals(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION skeys(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION svals(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_sum_transfn(internal, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_min_transfn(internal, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_max_transfn(internal, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_agg_finalfn_pairs(internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_to_json(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_to_array(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_to_matrix(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION slice(istore, integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION slice_array(istore, integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION clamp_below(istore,int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION clamp_above(istore,int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION delete(istore,int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION delete(istore,int[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION exists_all(istore,integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION exists_any(istore,integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION delete(istore, istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_agg_finalfn(internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_avl_transfn(internal, int, int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_avl_finalfn(internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_length(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION gin_extract_istore_key(internal, internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION gin_extract_istore_key_query(internal, internal, int2, internal, internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION gin_consistent_istore_key(internal, int2, internal, int4, internal, internal) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore(istore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION exist(bigistore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION fetchval(bigistore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION each(is bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION min_key(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION max_key(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION compact(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION add(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION add(bigistore, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION subtract(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION subtract(bigistore, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION multiply(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION multiply(bigistore, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION divide(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION divide(bigistore, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION concat(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore(integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION sum_up(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION sum_up(bigistore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore(integer[], integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore(integer[], bigint[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore(integer[], bigint[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION fill_gaps(bigistore, integer, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION accumulate(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION accumulate(bigistore, integer) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_seed(integer, integer, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_val_larger(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_val_smaller(bigistore, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION akeys(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION avals(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION skeys(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION svals(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_length(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_to_json(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_to_array(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_to_matrix(bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION slice(bigistore, integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION slice_array(bigistore, integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION clamp_below(bigistore,int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION clamp_above(bigistore,int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION delete(bigistore,int) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION delete(bigistore,int[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION exists_all(bigistore,integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION exists_any(bigistore,integer[]) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION delete(bigistore,bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_sum_transfn(internal, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_min_transfn(internal, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION istore_max_transfn(internal, bigistore) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_avl_transfn(internal, int, bigint) PARALLEL SAFE";
    EXECUTE "ALTER FUNCTION bigistore_avl_finalfn(internal) PARALLEL SAFE";

    EXECUTE "DROP AGGREGATE SUM (istore)";
    EXECUTE "DROP AGGREGATE MIN (istore)";
    EXECUTE "DROP AGGREGATE MAX (istore)";
    EXECUTE "DROP AGGREGATE SUM (bigistore)";
    EXECUTE "DROP AGGREGATE MIN (bigistore)";
    EXECUTE "DROP AGGREGATE MAX (bigistore)";

    EXECUTE "CREATE FUNCTION istore_agg_sum_combine(internal, internal)
        RETURNS internal
        AS 'istore'
        LANGUAGE C IMMUTABLE PARALLEL SAFE";

    EXECUTE "CREATE FUNCTION istore_agg_max_combine(internal, internal)
        RETURNS internal
        AS 'istore'
        LANGUAGE C IMMUTABLE PARALLEL SAFE";

    EXECUTE "CREATE FUNCTION istore_agg_min_combine(internal, internal)
        RETURNS internal
        AS 'istore'
        LANGUAGE C IMMUTABLE PARALLEL SAFE";

    EXECUTE "CREATE FUNCTION istore_agg_serial(internal)
        RETURNS bytea
        AS 'istore'
        LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE";

    EXECUTE "CREATE FUNCTION istore_agg_deserial(bytea, internal)
        RETURNS internal
        AS 'istore'
        LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE";

    EXECUTE "CREATE AGGREGATE SUM (istore) (
        sfunc = istore_sum_transfn,
        stype = internal,
        finalfunc = bigistore_agg_finalfn,
        combinefunc = istore_agg_sum_combine,
        serialfunc = istore_agg_serial,
        deserialfunc = istore_agg_deserial,
        parallel = SAFE
    )";

    EXECUTE "CREATE AGGREGATE MIN (istore) (
        sfunc = istore_min_transfn,
        stype = internal,
        finalfunc = istore_agg_finalfn_pairs,
        combinefunc = istore_agg_min_combine,
        serialfunc = istore_agg_serial,
        deserialfunc = istore_agg_deserial,
        parallel = SAFE
    )";

    EXECUTE "CREATE AGGREGATE MAX (istore) (
        sfunc = istore_max_transfn,
        stype = internal,
        finalfunc = istore_agg_finalfn_pairs,
        combinefunc = istore_agg_max_combine,
        serialfunc = istore_agg_serial,
        deserialfunc = istore_agg_deserial,
        parallel = SAFE
    )";

    EXECUTE "CREATE AGGREGATE SUM (bigistore) (
        sfunc = istore_sum_transfn,
        stype = internal,
        finalfunc = bigistore_agg_finalfn,
        combinefunc = istore_agg_sum_combine,
        serialfunc = istore_agg_serial,
        deserialfunc = istore_agg_deserial,
        parallel = SAFE
    )";

    EXECUTE "CREATE AGGREGATE MIN (bigistore) (
        sfunc = istore_min_transfn,
        stype = internal,
        finalfunc = bigistore_agg_finalfn,
        combinefunc = istore_agg_min_combine,
        serialfunc = istore_agg_serial,
        deserialfunc = istore_agg_deserial,
        parallel = SAFE
    )";

    EXECUTE "CREATE AGGREGATE MAX (bigistore) (
        sfunc = istore_max_transfn,
        stype = internal,
        finalfunc = bigistore_agg_finalfn,
        combinefunc = istore_agg_max_combine,
        serialfunc = istore_agg_serial,
        deserialfunc = istore_agg_deserial,
        parallel = SAFE
    )";
  END IF;
END;
$$;

