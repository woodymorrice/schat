#include <stdio.h>
#include "list.h"

struct LIST{
    void *headPointer;
    void *tailPointer;
    void *currentItem;
    int totalItem;
};
