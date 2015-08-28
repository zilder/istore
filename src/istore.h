#ifndef ISTORE_H
#define ISTORE_H

#include "postgres.h"
#include "fmgr.h"
#include "utils/array.h"
#include "catalog/pg_type.h"
#include "libpq/pqformat.h"
#include "access/htup_details.h"
#include "utils/lsyscache.h"
#include "istore_common.h"

Datum array_to_istore(Datum *data, int count, bool *nulls);
Datum istore_out(PG_FUNCTION_ARGS);
Datum istore_in(PG_FUNCTION_ARGS);
Datum istore_recv(PG_FUNCTION_ARGS);
Datum istore_send(PG_FUNCTION_ARGS);
Datum istore_array_add(PG_FUNCTION_ARGS);
Datum istore_agg_finalfn(PG_FUNCTION_ARGS);
Datum istore_from_array(PG_FUNCTION_ARGS);
Datum istore_multiply_integer(PG_FUNCTION_ARGS);
Datum istore_multiply(PG_FUNCTION_ARGS);
Datum istore_divide_integer(PG_FUNCTION_ARGS);
Datum istore_divide_int8(PG_FUNCTION_ARGS);
Datum istore_divide(PG_FUNCTION_ARGS);
Datum istore_subtract_integer(PG_FUNCTION_ARGS);
Datum istore_subtract(PG_FUNCTION_ARGS);
Datum istore_agg(PG_FUNCTION_ARGS);
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

typedef struct {
    int32  key;
    int32  val;
} IStorePair;

typedef struct {
    IStorePair *pairs;
    size_t  size;
    int     used;
    int     buflen;
} IStorePairs;

typedef struct AvlNode AvlNode;
typedef struct AvlNode *Position;
typedef struct AvlNode *AvlTree;

struct AvlNode
{
    int32    key;
    int32    value;
    AvlTree  left;
    AvlTree  right;
    int      height;
};

typedef struct
{
    int32 __varlen;
    int32   buflen;
    int32   len;
} IStore;

void istore_pairs_init(IStorePairs *pairs, size_t initial_size);
void istore_pairs_insert(IStorePairs *pairs, int32 key, int32 val);
int  istore_pairs_cmp(const void *a, const void *b);
void istore_pairs_sort(IStorePairs *pairs);

AvlTree istore_make_empty(AvlTree t);
Position istore_tree_find(int32 key, AvlTree t);
AvlTree istore_insert(AvlTree t, int32 key, int32 value);
int istore_tree_to_pairs(Position p, IStorePairs *pairs, int n);
IStorePair* istore_find(IStore *is, int32 key);

#define PG_GETARG_IS(x) (IStore *)PG_DETOAST_DATUM(PG_GETARG_DATUM(x))
#define PAIRSORTFUNC istore_pairs_cmp
#define ISINSERTFUNC istore_pairs_insert


#define FINALIZE_ISTORE(_istore, _pairs)                                    \
    do {                                                                          \
        qsort(_pairs->pairs, _pairs->used, sizeof(IStorePair), istore_pairs_cmp); \
        FINALIZE_ISTORE_NOSORT(_istore, _pairs);                       \
    } while(0)

#define FINALIZE_ISTORE_NOSORT(_istore, _pairs)                             \
    do {                                                                    \
        _istore = palloc0(ISHDRSZ + PAYLOAD_SIZE(_pairs, IStorePair));                  \
        _istore->buflen = _pairs->buflen;                                   \
        _istore->len    = _pairs->used;                                     \
        SET_VARSIZE(_istore, ISHDRSZ + PAYLOAD_SIZE(_pairs, IStorePair));               \
        memcpy(FIRST_PAIR(_istore, IStorePair), _pairs->pairs, PAYLOAD_SIZE(_pairs, IStorePair)); \
        pfree(_pairs->pairs);                                               \
    } while(0)



#endif // ISTORE_H
