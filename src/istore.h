#ifndef ISTORE_H
#define ISTORE_H

#include "postgres.h"

#include "avl.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "utils/memutils.h"

Datum istore_out(PG_FUNCTION_ARGS);
Datum istore_in(PG_FUNCTION_ARGS);
Datum istore_recv(PG_FUNCTION_ARGS);
Datum istore_send(PG_FUNCTION_ARGS);
Datum istore_to_json(PG_FUNCTION_ARGS);
Datum istore_array_add(PG_FUNCTION_ARGS);
Datum istore_from_intarray(PG_FUNCTION_ARGS);
Datum istore_multiply_integer(PG_FUNCTION_ARGS);
Datum istore_multiply(PG_FUNCTION_ARGS);
Datum istore_divide_integer(PG_FUNCTION_ARGS);
Datum istore_divide_int8(PG_FUNCTION_ARGS);
Datum istore_divide(PG_FUNCTION_ARGS);
Datum istore_subtract_integer(PG_FUNCTION_ARGS);
Datum istore_subtract(PG_FUNCTION_ARGS);
Datum istore_add_integer(PG_FUNCTION_ARGS);
Datum istore_add(PG_FUNCTION_ARGS);
Datum istore_fetchval(PG_FUNCTION_ARGS);
Datum istore_exist(PG_FUNCTION_ARGS);
Datum istore_sum_up(PG_FUNCTION_ARGS);
Datum istore_each(PG_FUNCTION_ARGS);
Datum istore_fill_gaps(PG_FUNCTION_ARGS);
Datum istore_accumulate(PG_FUNCTION_ARGS);
Datum istore_seed(PG_FUNCTION_ARGS);
Datum istore_val_larger(PG_FUNCTION_ARGS);
Datum istore_val_smaller(PG_FUNCTION_ARGS);
Datum istore_min_key(PG_FUNCTION_ARGS);
Datum istore_max_key(PG_FUNCTION_ARGS);
Datum istore_compact(PG_FUNCTION_ARGS);
Datum istore_akeys(PG_FUNCTION_ARGS);
Datum istore_avals(PG_FUNCTION_ARGS);
Datum istore_skeys(PG_FUNCTION_ARGS);
Datum istore_svals(PG_FUNCTION_ARGS);
Datum istore_length(PG_FUNCTION_ARGS);
Datum istore_sum_transfn(PG_FUNCTION_ARGS);
Datum istore_sum_finalfn(PG_FUNCTION_ARGS);

Datum bigistore_out(PG_FUNCTION_ARGS);
Datum bigistore_in(PG_FUNCTION_ARGS);
Datum bigistore_recv(PG_FUNCTION_ARGS);
Datum bigistore_send(PG_FUNCTION_ARGS);
Datum bigistore_to_json(PG_FUNCTION_ARGS);
Datum bigistore_array_add(PG_FUNCTION_ARGS);
Datum bigistore_from_intarray(PG_FUNCTION_ARGS);
Datum bigistore_multiply_integer(PG_FUNCTION_ARGS);
Datum bigistore_multiply(PG_FUNCTION_ARGS);
Datum bigistore_divide_integer(PG_FUNCTION_ARGS);
Datum bigistore_divide_int8(PG_FUNCTION_ARGS);
Datum bigistore_divide(PG_FUNCTION_ARGS);
Datum bigistore_subtract_integer(PG_FUNCTION_ARGS);
Datum bigistore_subtract(PG_FUNCTION_ARGS);
Datum bigistore_add_integer(PG_FUNCTION_ARGS);
Datum bigistore_add(PG_FUNCTION_ARGS);
Datum bigistore_fetchval(PG_FUNCTION_ARGS);
Datum bigistore_exist(PG_FUNCTION_ARGS);
Datum bigistore_sum_up(PG_FUNCTION_ARGS);
Datum bigistore_each(PG_FUNCTION_ARGS);
Datum bigistore_fill_gaps(PG_FUNCTION_ARGS);
Datum bigistore_accumulate(PG_FUNCTION_ARGS);
Datum bigistore_seed(PG_FUNCTION_ARGS);
Datum bigistore_val_larger(PG_FUNCTION_ARGS);
Datum bigistore_val_smaller(PG_FUNCTION_ARGS);
Datum bigistore_min_key(PG_FUNCTION_ARGS);
Datum bigistore_max_key(PG_FUNCTION_ARGS);
Datum bigistore_compact(PG_FUNCTION_ARGS);
Datum bigistore_akeys(PG_FUNCTION_ARGS);
Datum bigistore_avals(PG_FUNCTION_ARGS);
Datum bigistore_skeys(PG_FUNCTION_ARGS);
Datum bigistore_svals(PG_FUNCTION_ARGS);
Datum bigistore_length(PG_FUNCTION_ARGS);
Datum bigistore_sum_transfn(PG_FUNCTION_ARGS);

/*
 * a single key/value pair
 */
typedef struct
{
    int32 key;
    int32 val;
} IStorePair;

/*
 * collection of pairs
 */
typedef struct
{
    IStorePair *pairs;
    size_t      size;
    int         used;
    int         buflen;
} IStorePairs;

/*
 * the istore
 */
typedef struct
{
    int32 __varlen;
    int32 buflen;
    int32 len;
} IStore;

typedef struct
{
    int32 key;
    int64 val;
} BigIStorePair;

typedef struct
{
    BigIStorePair *pairs;
    size_t         size;
    int            used;
    int            buflen;
} BigIStorePairs;

typedef struct
{
    int32 __varlen;
    int32 buflen;
    int32 len;
} BigIStore;

void           istore_copy_and_add_buflen(IStore *istore, BigIStorePair *pairs);
void           istore_pairs_init(IStorePairs *pairs, size_t initial_size);
void           istore_pairs_insert(IStorePairs *pairs, int32 key, int32 val);
void           istore_tree_to_pairs(AvlNode *p, IStorePairs *pairs);
int            is_pair_buf_len(IStorePair *pair);
void           bigistore_add_buflen(BigIStore *istore);
void           bigistore_pairs_init(BigIStorePairs *pairs, size_t initial_size);
void           bigistore_pairs_insert(BigIStorePairs *pairs, int32 key, int64 val);
void           bigistore_tree_to_pairs(AvlNode *p, BigIStorePairs *pairs);
int            bigis_pair_buf_len(BigIStorePair *pair);

int is_int32_arr_comp(const void *a, const void *b);

#define BUFLEN_OFFSET 8
#define MAX(_a, _b) ((_a > _b) ? _a : _b)
#define MIN(_a, _b) ((_a < _b) ? _a : _b)

#define PAIRS_MAX(_pairtype) (MaxAllocSize / sizeof(_pairtype))
#define PAYLOAD_SIZE(_pairs, _pairtype) (_pairs->used * sizeof(_pairtype))
#define ISHDRSZ VARHDRSZ + sizeof(int32) + sizeof(int32)

#define ISTORE_SIZE(x, _pairtype) (ISHDRSZ + x->len * sizeof(_pairtype))

/*
 * get the first pair of type
 */
#define FIRST_PAIR(x, _pairtype) ((_pairtype *) ((char *) x + ISHDRSZ))
#define LAST_PAIR(x, _pairtype)  ((_pairtype *) ((char *) x + ISHDRSZ + (x->len-1) * sizeof(_pairtype)))

/*
 * get the istore
 */
#define PG_GETARG_IS(x) (IStore *) PG_DETOAST_DATUM(PG_GETARG_DATUM(x))
#define PG_GETARG_BIGIS(x) (BigIStore *) PG_DETOAST_DATUM(PG_GETARG_DATUM(x))
#define PG_GETARG_IS_COPY(x) (IStore *) PG_DETOAST_DATUM_COPY(PG_GETARG_DATUM(x))
#define PG_GETARG_BIGIS_COPY(x) (BigIStore *) PG_DETOAST_DATUM_COPY(PG_GETARG_DATUM(x))

/*
 * creates the internal representation from a pairs collection
 */
#define FINALIZE_ISTORE_BASE(_istore, _pairs, _pairtype) \
        _istore         = palloc0(ISHDRSZ + PAYLOAD_SIZE(_pairs, _pairtype));\
        _istore->buflen = _pairs->buflen;\
        _istore->len    = _pairs->used;\
        SET_VARSIZE(_istore, ISHDRSZ + PAYLOAD_SIZE(_pairs, _pairtype));\
        memcpy(FIRST_PAIR(_istore, _pairtype), _pairs->pairs, PAYLOAD_SIZE(_pairs, _pairtype));

#define FINALIZE_ISTORE(_istore, _pairs)                   \
    do                                                     \
    {                                                      \
        FINALIZE_ISTORE_BASE(_istore, _pairs, IStorePair); \
        pfree(_pairs->pairs);                              \
    } while (0)

#define FINALIZE_BIGISTORE(_istore, _pairs)                   \
    do                                                        \
    {                                                         \
        FINALIZE_ISTORE_BASE(_istore, _pairs, BigIStorePair); \
        pfree(_pairs->pairs);                                 \
    } while (0)

#define SAMESIGN(a,b)   (((a) < 0) == ((b) < 0))
#define INTPL(_a, _b, _r)                                                                                              \
    do                                                                                                                 \
    {                                                                                                                  \
        _r = _a + _b;                                                                                                  \
        if (SAMESIGN(_a, _b) && !SAMESIGN(_r, _a))                                                                     \
            ereport(ERROR, (errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE), errmsg("integer out of range")));             \
    } while (0)

#endif // ISTORE_H
