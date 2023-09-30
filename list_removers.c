/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <list.h>
extern int memoryNodeUsed;
extern int memoryListUsed;
bool notEmpty = false;

void *ListRemove(LIST *list) {
    struct NODE *curItem;
    struct NODE *prevItem;
    struct NODE *nextItem;

    curItem = list->currentItem;
    /*
    * If current list only has one item/one node
    */
    if(list->totalItem == 1) {
        list->currentItem = NULL;
        list->headPointer = NULL;
        list->tailPointer = NULL;
    } else if (curItem == list->headPointer) {
        /*
        * Current item is at head 
        */
        struct NODE *oldHead;
        
        oldHead = list->headPointer;
        nextItem = curItem->nextNode;
        oldHead->nextNode = NULL;
        nextItem->prevNode = NULL;
        ListNext(list);
        list->headPointer = nextItem;
    } else if (curItem == list->tailPointer) {
        /*
        * Current item is at tail
        */
        struct NODE *oldTail;

        oldTail = list->tailPointer;
        prevItem = curItem->prevNode;
        oldTail->prevNode = NULL;
        prevItem->nextNode = NULL;
        ListPrev(list);
        list->tailPointer = prevItem;        
    }
    else {
        /*
        * Current item is at middle 
        */
        nextItem = curItem->nextNode;
        prevItem = curItem->prevNode;

        curItem->nextNode = NULL;
        curItem->prevNode = NULL;
        nextItem->prevNode = prevItem;
        prevItem->nextNode = nextItem;
        
        ListNext(list); 
    }
    memoryNodeUsed -= sizeof(NODE);
    list->totalItem -= 1;
    return curItem->dataType;
}


void ListFree(LIST *list, void (*itemFree)(void *itemToBeFreed)) {
    struct NODE *curItem;
    ListFirst(list);
    /* Booleans dont exist in c90 so we have to use ints
     * 0 = true, 1 = false */
    while (notEmpty) {
        if (list == NULL) {
            notEmpty = true;
        }
        curItem = list->currentItem;
        itemFree(curItem->dataType);
        ListNext(list);
    }
    list->headPointer = NULL;
    list->tailPointer = NULL;
    list->currentItem = NULL;
    list->totalItem = 0;
    
}

void *ListTrim(LIST *list) {
    struct NODE *oldTail;
    struct NODE *newTail;
    if (list->totalItem == 0) {
        return NULL;
    }
    oldTail = list->tailPointer;
    newTail = oldTail->prevNode;
    oldTail->prevNode = NULL;
    newTail->nextNode = NULL;
    memoryNodeUsed -= sizeof(NODE);
    list->totalItem -= 1;
    return oldTail->dataType;
}
