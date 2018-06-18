/*
 * istore extension for PostgreSQL
 */

/* Complain if script is sourced in psql, rather than via CREATE EXTENSION */
\echo Use "CREATE EXTENSION istore" to load this file. \quit

/* GIN index support */
CREATE FUNCTION gin_extract_istore_key_query(internal, internal, int2, internal, internal)
RETURNS internal
AS 'istore'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION gin_consistent_istore_key(internal, int2, internal, int4, internal, internal)
RETURNS bool
AS 'istore'
LANGUAGE C IMMUTABLE STRICT;
