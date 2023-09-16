#include <stdio.h>
#include <stdlib.h>
#include <list.h>

const int MAX_ITEM = 10;

 
LIST *ListCreate () {
    LIST *newList; 
    newList->headPointer = NULL;
    newList->tailPointer = NULL;
    newList->currentItem = NULL;
    newList->totalItem = 0;
    return newList;
}

int ListCount (LIST *curList) {
    
}

int ListAppend (LIST *curList, NODE *item) {
    LIST *prevItem = newList->tailPointer; 
    /*
    * If the current pointer is at the end of list,
    * item is added at the end.
    */
    if (curList->totalItem < MAX_ITEM) {

        if (curList->tailPointer == curList->currentItem) {

            curList->tailPointer = 
}
}
}
