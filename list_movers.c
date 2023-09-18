#include <stdio.h>
#include <stdlib.h>
#include "list.h"

void *ListFirst(LIST *curList) {
    return curList->currentItem = curList->headPointer;
}

void *ListLast(LIST *curList) {
    return curList->currentItem = curList->tailPointer;
}

void *ListCurr(LIST *curList) {
    return curList->currentItem;
}

void *ListNext(LIST *curList) {
    struct NODE *item1;
    struct NODE *itemMoved;

    item1 = curList->currentItem;
    /*
    * if the current item is at the tail of list
    * return NULL  
    */
    if (curList->currentItem == curList->tailPointer) {
        return NULL;
    }
    curList->currentItem = item1->nextNode;
    itemMoved = curList->currentItem;
    itemMoved->prevNode = item1;
    return curList->currentItem; 
}

void *ListPrev(LIST *curList) {
    struct NODE *item1;
    struct NODE *itemMoved;
    
    item1 = curList->currentItem;
    /*
    * if the current item is at head of list
    * return NULL 
    */
    if (curList->currentItem == curList->headPointer) {
        return NULL;
}
    curList->currentItem = item1->prevNode;
    itemMoved = curList->currentItem;
    itemMoved->nextNode = item1;
    return curList->currentItem;
}

