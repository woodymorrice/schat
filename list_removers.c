/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <list.h>

extern size_t memoryNodeUsed;
extern size_t memoryListUsed;

extern LIST *memoryList;
extern NODE *memoryNode;

extern NODE *curFreeNode;
extern LIST *curFreeList;

bool notEmpty = true;

void *ListRemove(LIST *list) {
    NODE *curItem;
    NODE *prevItem;
    NODE *nextItem;

    curItem = list->currentItem;
    if (list->totalItem == 0) {
        return NULL;
    } else if(list->totalItem == 1) {
        /*
        * if list only has one item / one node
        */
        curItem->nextNode = curFreeNode;
        curFreeNode = curItem;
        list->currentItem = NULL;
        list->headPointer = NULL;
        list->tailPointer = NULL;
    }
    else {
        if (curItem == list->headPointer) {
            /*
            * Current item is at head 
            */
            nextItem = curItem->nextNode;
            curItem->nextNode = curFreeNode;
            curFreeNode = curItem;
            list->currentItem = nextItem;
            list->headPointer = nextItem;
            nextItem->prevNode = NULL;
        } else if (curItem == list->tailPointer) {
            /*
            * Current item is at tail
            */
            prevItem = curItem->prevNode;
            curItem->nextNode = curFreeNode;
            curFreeNode = curItem;
            curFreeNode->prevNode = NULL;
            list->currentItem = prevItem;
            list->tailPointer = prevItem;
            prevItem->nextNode = NULL;
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
    }
    memoryNodeUsed -= sizeof(NODE);
    list->totalItem -= 1;
    return curItem->dataType;
}


void ListFree(LIST *list, void (*itemFree)(void *itemToBeFreed)) {
    NODE *curItem;

    list->currentItem = list->headPointer;
    for (;;) {
        if (list->currentItem == NULL) {
            break;
        }
        curItem = list->currentItem;
        itemFree(curItem->dataType);
        list->currentItem = curItem->nextNode;
        memoryNodeUsed -= sizeof(NODE);
    }
    list->headPointer = NULL;
    list->tailPointer = NULL;
    list->currentItem = NULL;
    list->totalItem = 0;
    curFreeList->nextLP = curFreeList;
    curFreeList = list;
    memoryListUsed -= sizeof(LIST);
    
}

void *ListTrim(LIST *list) {
    NODE *oldTail;
    NODE *newTail;
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
