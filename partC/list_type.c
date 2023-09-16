#include <stdio.h>

typedef struct {
    void *headPointer; 
    void *tailPointer;
    void *currentItem;
    int *totalItem; 
} LIST; 
