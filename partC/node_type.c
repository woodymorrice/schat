#include <stdio.h>
#include "list.h"

typedef struct {
    void* prevNode; 
    void* nextNode;
    void* dataType; 
} NODE; 
