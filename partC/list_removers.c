#include <stdio.h>
#include <stdlib.h>
#include <list.h>

void *ListRemove(LIST *curList) {
    /*
    * If the current item at head of list
    */
    struct NODE *item1 = curList->currentItem;
    if (item1->prevNode == NULL) {
        struct NODE *oldHead = curList->headPointer;
        ListNext(curList);
        oldHead->nextNode = NULL;
        struct NODE *itemMoved = curList->currentItem;
        itemMoved->prevNode = NULL;
        curList->headPointer = curList->currentItem;
        curList->totalItem -= 1;
        return oldHead;
    }
    /*
    * If the current item at tail
    */
    if (item1->nextNode == NULL) {
        struct NODE *oldTail = curList->tailPointer;
        ListPrev(curList);
        oldTail->prevNode = NULL;
        struct NODE *itemMoved = curList->currentItem;
        itemMoved->nextNode = NULL;
        curList->tailPointer = curList->currentItem;
        curList->totalItem -= 1;
        return oldTail;
    }
    
    struct NODE *rmItem = curList->currentItem;
    struct NODE *nextItem = ListNext(curList);
    nextItem->prevNode = rmItem->prevNode;
    struct NODE *rmPrev = rmItem->prevNode;
    rmPrev->nextNode = curList->currentItem; 
    rmItem->prevNode = NULL;
    rmItem->nextNode = NULL;
    curList->totalItem -= 1;
    return rmItem;
}
