#ifndef ISTORE_PARSER_H
#define ISTORE_PARSER_H

#include "postgres.h"
#include "fmgr.h"
#include "avl.h"

typedef struct ISParser {
    char    *begin;
    char    *ptr;
    int      state;
    PGFunction keyin;  /* key input func */
    PGFunction valin;  /* value input func */
    int      keysize;
    int      valsize;
    AvlNode *tree;
} ISParser;

AvlNode* is_parse(ISParser *parser);

#define EMPTY_ISTORE(_istore)          \
    do {                               \
        _istore = palloc0(ISHDRSZ);    \
        _istore->buflen = 0;           \
        _istore->len = 0;              \
        SET_VARSIZE(_istore, ISHDRSZ); \
    } while(0)


#endif // ISTORE_PARSER_H
