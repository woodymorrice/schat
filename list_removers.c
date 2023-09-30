/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <list.h>
extern const int LIST_POOL_SIZE;
extern const int NODE_POOL_SIZE;

extern size_t memoryNodeUsed;
extern size_t memoryListUsed;

extern LIST *curFreeList;
extern struct NODE *curFreeNode;

extern LIST *memoryList;
extern struct NODE *memoryNode;

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
        list->currentItem = nextItem;
        list->headPointer = nextItem;
        nextItem->prevNode = NULL;
        oldHead->nextNode = NULL;
    } else if (curItem == list->tailPointer) {
        /*
        * Current item is at tail
        */
        struct NODE *oldTail;

        oldTail = list->tailPointer;
        prevItem = curItem->prevNode;
        list->currentItem = prevItem;
        list->tailPointer = prevItem;
        prevItem->nextNode = NULL;
        oldTail->prevNode = NULL;     
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
        
        list->currentItem = nextItem; 
    }
    memoryNodeUsed -= sizeof(struct NODE);
    list->totalItem -= 1;
    return curItem->dataType;
}


void ListFree(LIST *list, void (*itemFree)(void *itemToBeFreed)) {
    struct NODE *curItem;
    LIST *curList;
    int i;
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
    for (i = 0; i < LIST_POOL_SIZE; i++) {
        curList = &memoryList[i];
        if (curList->headPointer == NULL &&
            curList->tailPointer == NULL) {
            curFreeList = &memoryList[i];
        }
    }
    memoryListUsed -= sizeof(LIST);
    
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
    memoryNodeUsed -= sizeof(struct NODE);
    list->totalItem -= 1;
    return oldTail->dataType;
}
