/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <list.h>
/*
convenience for testing size
*/
const int LIST_POOL_SIZE = 3;
const int NODE_POOL_SIZE = 5;
 
bool isAllocated = false;
/*
Amount of memory used for LIST / NODE
*/
int  memoryListUsed;
int  memoryNodeUsed;

/*
Each block in the allocation
*/
int listBlock;
int nodeBlock;

/*
LIST POOL
NODE POOL
*/

LIST *memoryList;
struct NODE *memoryNode;

/*
Point to the current free list / free node
*/
LIST *curFreeList;
struct NODE *curFreeNode;


LIST *ListCreate () {
    LIST *emptyList; 
    if (isAllocated == false) {
        memoryList = malloc(sizeof(LIST) * LIST_POOL_SIZE);
        memoryNode = malloc(sizeof(NODE) * NODE_POOL_SIZE);
        isAllocated = true;
    }
    emptyList = &memoryList[listBlock];
    emptyList->headPointer = NULL;
    emptyList->tailPointer = NULL;
    emptyList->currentItem = NULL;
    emptyList->totalItem = 0;
    memoryListUsed += sizeof(LIST);
    listBlock += 1;
    return emptyList;
}
    
int ListCount (LIST *list) {
    return list->totalItem;    
}

int ListAppend (LIST *list, void *item) {
    struct NODE *prevTail;
    struct NODE *newItem;
    newItem = &memoryNode[nodeBlock];
    newItem->dataType = item;
    prevTail = list->tailPointer;
    if (list->totalItem < NODE_POOL_SIZE) { 
        if(list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
        }
        else {
            ListLast(list);
            list->tailPointer = newItem;
            newItem->prevNode = prevTail;
            newItem->nextNode = NULL;
            ListLast(list);
        }
        list->totalItem += 1;
        memoryNodeUsed += sizeof(NODE);
        nodeBlock += 1;
        return 0;
    }
    return -1;
}
    

int ListPrepend (LIST *list, void *item) {
    struct NODE *prevHead;
    struct NODE *newItem;
    prevHead = list->headPointer;
    newItem = &memoryNode[nodeBlock];
    newItem->dataType = item;
    /*
    * If the current pointer is at the head of list,
    * item is added at the end.
    */
    if (list->totalItem < NODE_POOL_SIZE) {
        if (list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = prevHead;
        }
        else {
            ListFirst(list);
            list->headPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = prevHead;
            prevHead->prevNode = newItem;
        }
        ListFirst(list);
        list->totalItem += 1;
        memoryNodeUsed += sizeof(NODE);
        nodeBlock += 1;
        return 0;
    }
    return -1;
}

int ListAdd(LIST *list, void *item) {
    struct NODE *curItem;
    struct NODE *curNext;
    struct NODE *newItem;
    newItem = &memoryNode[nodeBlock];
    newItem->dataType = item;
    if (list->totalItem < NODE_POOL_SIZE) {
        /*
        * if the current list has no item
        */
        if (list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
            ListFirst(list);
        } else if (list->currentItem == 
                   list->tailPointer) {
            curItem = list->currentItem;
            curItem->nextNode = newItem; 
            newItem->nextNode = NULL;
            newItem->prevNode = curItem;
            list->tailPointer = newItem;
            ListNext(list);
        }
        else {
            curItem = list->currentItem;
            curNext = curItem->nextNode;
            
            curItem->nextNode = newItem;
            curNext->prevNode = newItem;
            newItem->nextNode = curNext;
            newItem->prevNode = curItem;
            
            ListNext(list);
        }
        memoryNodeUsed += sizeof(NODE);
        list->totalItem += 1;
        nodeBlock += 1;
        return 0;
    }
    return -1;
}

int ListInsert(LIST *list, void *item) {
    struct NODE *curItem;
    struct NODE *curPrev;
    struct NODE *newItem;
    curItem = list->currentItem;
    curPrev = curItem->prevNode;
    newItem = &memoryNode[nodeBlock];
    newItem->dataType = item;
    if (list->totalItem < NODE_POOL_SIZE) {
        /*
        * if current item is at head
        */
        if (list->currentItem == list->headPointer) {
            list->headPointer = newItem;
            curPrev = newItem;
            newItem->nextNode = curItem;
            newItem->prevNode = NULL;
        }
        else {
        curItem->prevNode = newItem;
        curPrev->nextNode = newItem;
        newItem->prevNode = curPrev;
        newItem->nextNode = curItem;
        ListPrev(list);
        }
        list->totalItem += 1;
        memoryNodeUsed += sizeof(NODE);
        nodeBlock += 1;
        return 0;
    }
    return -1;
}

void ListConcat(LIST *list1, LIST *list2) {
    struct NODE *list1Tail;
    struct NODE *list2Head;
    if (list1 == NULL) {
        return;
    } else if (list2 == NULL) {
        return;
    }

    list1Tail = list1->tailPointer;
    list2Head = list2->headPointer;
    list1Tail->nextNode = list2->headPointer;
    list2Head->prevNode = list1->tailPointer;
    list1Tail = list2->tailPointer;
    
    list1->totalItem += list2->totalItem;
}
