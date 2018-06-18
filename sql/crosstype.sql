/*
 * Cross-type functions and casts
 */
CREATE FUNCTION istore(bigistore)
    RETURNS istore
    AS 'istore', 'bigistore_to_istore'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bigistore(istore)
    RETURNS bigistore
    AS 'istore', 'istore_to_big_istore'
    LANGUAGE C IMMUTABLE STRICT;

CREATE CAST (istore as bigistore) WITH FUNCTION bigistore(istore) AS IMPLICIT;
CREATE CAST (bigistore as istore) WITH FUNCTION istore(bigistore) AS ASSIGNMENT;

CREATE FUNCTION istore(integer[])
    RETURNS istore
    AS 'istore', 'istore_from_intarray'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION istore(integer[], integer[])
    RETURNS istore
    AS 'istore', 'istore_array_add'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION istore(integer[], bigint[])
    RETURNS bigistore
    AS 'istore', 'bigistore_array_add'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bigistore(integer[])
    RETURNS bigistore
    AS 'istore', 'bigistore_from_intarray'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bigistore(integer[], integer[])
    RETURNS bigistore
    AS 'istore', 'bigistore_array_add'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bigistore(integer[], bigint[])
    RETURNS bigistore
    AS 'istore', 'bigistore_array_add'
    LANGUAGE C IMMUTABLE STRICT;
