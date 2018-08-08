#ifndef ISTORE_H
#define ISTORE_H

#include <limits.h>

#include "postgres.h"

#include "avl.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "utils/memutils.h"


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

IStore *istore_merge(IStore *arg1, IStore *arg2, PGFunction mergefunc, PGFunction miss1func);
IStore *istore_apply_datum(IStore *arg1, Datum arg2, PGFunction applyfunc);

BigIStore *bigistore_merge(BigIStore *arg1, BigIStore *arg2, PGFunction mergefunc, PGFunction miss1func);
BigIStore *bigistore_apply_datum(BigIStore *arg1, Datum arg2, PGFunction applyfunc);

void           istore_copy_and_add_buflen(IStore *istore, BigIStorePair *pairs);
void           bigistore_add_buflen(BigIStore *istore);
void           istore_pairs_init(IStorePairs *pairs, size_t initial_size);
void           istore_pairs_insert(IStorePairs *pairs, int32 key, int32 val);
int            istore_pairs_cmp(const void *a, const void *b);
void           istore_tree_to_pairs(AvlNode *p, IStorePairs *pairs);
IStorePair *   istore_find(IStore *is, int32 key, int *off_out);
int            istore_pair_buf_len(IStorePair *pair);
int            bigistore_pair_buf_len(BigIStorePair *pair);
void           bigistore_pairs_init(BigIStorePairs *pairs, size_t initial_size);
void           bigistore_pairs_insert(BigIStorePairs *pairs, int32 key, int64 val);
int            bigistore_pairs_cmp(const void *a, const void *b);
void           bigistore_tree_to_pairs(AvlNode *p, BigIStorePairs *pairs);
BigIStorePair *bigistore_find(BigIStore *is, int32 key, int *off_out);

int is_int32_arr_comp(const void *a, const void *b);
int is_int64_arr_comp(const void *a, const void *b);

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

#define PG_GETARG_ISTORE(x) (IStore *) PG_DETOAST_DATUM(PG_GETARG_DATUM(x))
#define PG_GETARG_BIGISTORE(x) (BigIStore *) PG_DETOAST_DATUM(PG_GETARG_DATUM(x))
#define PG_GETARG_ISTORE_COPY(x) (IStore *) PG_DETOAST_DATUM_COPY(PG_GETARG_DATUM(x))
#define PG_GETARG_BIGISTORE_COPY(x) (BigIStore *) PG_DETOAST_DATUM_COPY(PG_GETARG_DATUM(x))

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

/*
 * return the number of digits
 */
static inline int
digits32(int32 num)
{
    int sign = 0;
    if (num < 0)
    {
        if (num == INT_MIN)
            // special case for -2^31 because 2^31 can't fit in a two's complement 32-bit integer
            return 12;
        sign = 1;
        num  = -num;
    }

    if (num < 1e5)
    {
        if (num < 1e3)
        {
            if (num < 10)
                return 1 + sign;
            else if (num < 1e2)
                return 2 + sign;
            else
                return 3 + sign;
        }
        else
        {
            if (num < 1e4)
                return 4 + sign;
            else
                return 5 + sign;
        }
    }
    else
    {
        if (num < 1e7)
        {
            if (num < 1e6)
                return 6 + sign;
            else
                return 7 + sign;
        }
        else
        {
            if (num < 1e8)
                return 8 + sign;
            else if (num < 1e9)
                return 9 + sign;
            else
                return 10 + sign;
        }
    }
}

/*
 * return the number of digits
 */
static inline int
digits64(int64 num)
{
    int sign = 0;
    if (num < 0)
    {
        if (num == LLONG_MIN)
            // special case for -2^63 because 2^63 can't fit in a two's complement 64-bit integer
            return 19;
        sign = 1;
        num  = -num;
    }

    if (num < 1e10)
    {
        if (num < 1e5)
        {
            if (num < 1e3)
            {
                if (num < 10)
                    return 1 + sign;
                else if (num < 1e2)
                    return 2 + sign;
                else
                    return 3 + sign;
            }
            else
            {
                if (num < 1e4)
                    return 4 + sign;
                else
                    return 5 + sign;
            }
        }
        else
        {
            if (num < 1e7)
            {
                if (num < 1e6)
                    return 6 + sign;
                else
                    return 7 + sign;
            }
            else
            {
                if (num < 1e8)
                    return 8 + sign;
                else if (num < 1e9)
                    return 9 + sign;
                else
                    return 10 + sign;
            }
        }
    }
    else
    {
        if (num < 1e15)
        {
            if (num < 1e12)
            {
                if (num < 1e11)
                    return 11 + sign;
                else
                    return 12 + sign;
            }
            else
            {
                if (num < 1e13)
                    return 13 + sign;
                else if (num < 1e14)
                    return 14 + sign;
                else
                    return 15 + sign;
            }
        }
        else
        {
            if (num < 1e17)
            {
                if (num < 1e16)
                    return 16 + sign;
                else
                    return 17 + sign;
            }
            else
            {
                if (num < 1e18)
                    return 18 + sign;
                else
                    return 19 + sign;
            }
        }
    }
}

#endif // ISTORE_H
