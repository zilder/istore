#ifndef ISTORE_AVL_H
#define ISTORE_AVL_H

#include "postgres.h"
#include "intutils.h"
#include "istore_common.h"


#define height(_p) ((_p == NULL) ? -1 : _p->height)

typedef struct AvlNode AvlNode;

struct AvlNode
{
    int32    key;
    int64    value;
    AvlNode  *left;
    AvlNode  *right;
    int      height;
};

AvlNode* istore_make_empty(AvlNode *t);
AvlNode* tree_find(int32 key, AvlNode *t);
AvlNode* tree_insert(AvlNode *t, int32 key, int64 value);
int tree_length(AvlNode* t);
#endif // ISTORE_AVL_H