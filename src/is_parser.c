#include "is_parser.h"
#include <limits.h>

#define WKEY 0
#define WVAL 1
#define WEQ  2
#define WGT  3
#define WDEL 4

#define GET_NUM(_parser, _num)                                               \
    do {                                                                     \
        long _l;                                                             \
        bool neg = false;                                                    \
        if (*(_parser->ptr) == '-')                                          \
            neg = true;                                                      \
        _l   = strtol(_parser->ptr, &_parser->ptr, 10);                      \
        _num = _l;                                                           \
        if ((neg && _num > 0) || (_l == LONG_MIN) )                          \
            ereport(ERROR,                                                   \
                (errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),                \
                errmsg("istore \"%s\" is out of range", _parser->begin)));   \
        else if ((!neg && _num < 0) || (_l == LONG_MAX ))                    \
            ereport(ERROR,                                                   \
                (errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),                \
                errmsg("istore \"%s\" is out of range", _parser->begin)));   \
    } while (0)


#define SKIP_SPACES(_ptr)  \
    while (isspace(*_ptr)) \
        _ptr++;

/* TODO really respect quotes and dont just skip them */
#define SKIP_ESCAPED(_ptr) \
    if (*_ptr == '"')      \
            _ptr++;

static char *
read_value(char *str, PGFunction input_func, int size, int64 *value)
{
    char   *c = str;
    char    prev = '\0';

    while(*c != '\0')
    {
        // At this point do it stupid way: just look for quote,
        // eqaulity sign (which is the start of =>) or comma and
        // consider it as the end of lexeme.
        if (*c == '"' || *c == '=' || *c == ',')
        {
            prev = *c;
            // Put terminator here so that input function could
            // determine the end of lexeme. We'll restore the
            // original character later.
            *c = '\0';
            break;
        }
        c++;
    }

    *value = DatumGetInt64(
            DirectFunctionCall1(input_func, CStringGetDatum(str)));

    /*
     * Convert key value to a 8 byte value. This step is important for
     * the cases when we have 4 byte input key type (like in IStore) with
     * negative value. Without this fix, for example, the value -1 will
     * turn to 4294967295 for the key of size 4.
     */
    switch (size)
    {
        case 2: *value = (int16) *value; break;
        case 4: *value = (int32) *value; break;
        case 8: break; /* do nothing */
        default:
            elog(ERROR, "Value size %d is not supported", size);
    }

    // Restore the original charachter
    if (*c != prev)
        *c = prev;

    return c;
}

/*
 * parse cstring into an AVL tree
 */
AvlNode*
is_parse(ISParser *parser)
{
    int64    key;
    int64    val;

    parser->state = WKEY;
    parser->ptr   = parser->begin;
    parser->tree  = NULL;

    while(1)
    {
        if (parser->state == WKEY)
        {
            SKIP_SPACES(parser->ptr);
            SKIP_ESCAPED(parser->ptr);
            parser->ptr = read_value(parser->ptr, parser->keyin, parser->keysize, &key);
            parser->state = WEQ;
            SKIP_ESCAPED(parser->ptr);
        }
        else if (parser->state == WEQ)
        {
            SKIP_SPACES(parser->ptr);
            if (*(parser->ptr) == '=')
            {
                parser->state = WGT;
                parser->ptr++;
            }
            else
                ereport(ERROR,
                    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                     errmsg("invalid input syntax for istore: \"%s\"",
                            parser->begin),
                     errdetail("unexpected sign %c, in istore key", *(parser->ptr))
                     ));
        }
        else if (parser->state == WGT)
        {
            if (*(parser->ptr) == '>')
            {
                parser->state = WVAL;
                parser->ptr++;
            }
            else
                ereport(ERROR,
                    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                     errmsg("invalid input syntax for istore: \"%s\"",
                            parser->begin),
                     errdetail("unexpected sign %c, expected '>'", *(parser->ptr))
                     ));
        }
        else if (parser->state == WVAL)
        {
            SKIP_SPACES(parser->ptr);
            SKIP_ESCAPED(parser->ptr);
            //GET_NUM(parser, val);
            parser->ptr = read_value(parser->ptr, parser->valin, parser->valsize, &val);
            SKIP_ESCAPED(parser->ptr);
            parser->state = WDEL;
            parser->tree = is_tree_insert(parser->tree, key, val);
        }
        else if (parser->state == WDEL)
        {
            SKIP_SPACES(parser->ptr);

            if (*(parser->ptr) == '\0')
                break;
            else if (*(parser->ptr) == ',')
                parser->state = WKEY;
            else
                ereport(ERROR,
                    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                     errmsg("invalid input syntax for istore: \"%s\"",
                            parser->begin),
                     errdetail("unexpected sign %c, in istore value", *(parser->ptr))
                     ));

            parser->ptr++;
        }
        else
        {
            elog(ERROR, "unknown parser state");
        }
    }

    return parser->tree;
}
