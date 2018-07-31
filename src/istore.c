#include "istore.h"

PG_MODULE_MAGIC;

int
is_int32_arr_comp(const void *a, const void *b)
{
    if (*(const int32 *) a == *(const int32 *) b)
        return 0;
    return (*(const int32 *) a > *(const int32 *) b) ? 1 : -1;
}
