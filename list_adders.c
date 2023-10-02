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
const int LIST_POOL_SIZE = 4;
const int NODE_POOL_SIZE = 10;
 
bool isAllocated = false;
/*
Amount of memory used for LIST / NODE
*/
size_t  memoryListUsed;
size_t  memoryNodeUsed;

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
struct NODE *nextFree;

LIST *ListCreate () {
    LIST *emptyList; 
    if (isAllocated == false) {
        memoryList = malloc(sizeof(LIST) * LIST_POOL_SIZE);
        memoryNode = malloc(sizeof(struct NODE) * NODE_POOL_SIZE);
        
        curFreeList = &memoryList[listBlock];
        curFreeNode = &memoryNode[nodeBlock];
        nextFree = curFreeNode->nextNode;
        nextFree = &memoryNode[nodeBlock + 1];
        isAllocated = true;
    }
    if (memoryListUsed > sizeof(LIST) * LIST_POOL_SIZE) {
        printf("Error ListCreated(): memory list used exceed the limit\n");
        return NULL;
    }
    emptyList = curFreeList;
    emptyList->headPointer = NULL;
    emptyList->tailPointer = NULL;
    emptyList->currentItem = NULL;
    emptyList->totalItem = 0;
    memoryListUsed += sizeof(LIST);
    listBlock += 1;
    curFreeList = &memoryList[listBlock];
    return emptyList;
}
    
int ListCount (LIST *list) {
    return list->totalItem;    
}

int ListAppend (LIST *list, void *item) {
    struct NODE *prevTail;
    struct NODE *newItem;

    if (memoryNodeUsed < sizeof(struct NODE) * NODE_POOL_SIZE) {
        list->currentItem = list->tailPointer;
        newItem = curFreeNode;
        newItem->dataType = item;
        prevTail = list->tailPointer;
         
        if(list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
        }
        else {
            list->tailPointer = newItem;
            newItem->prevNode = prevTail;
            newItem->nextNode = NULL;
            list->currentItem = list->tailPointer;
        }
        list->totalItem += 1;
        memoryNodeUsed += sizeof(struct NODE);
        nodeBlock += 1;
        curFreeNode = curFreeNode->nextNode;
        curFreeNode->nextNode = &memoryNode[nodeBlock];
        return 0;
    }
    printf("Error ListAppend(): memory NODE used exceed the limit\n");
    return -1;
}
    

int ListPrepend (LIST *list, void *item) {
    struct NODE *prevHead;
    struct NODE *newItem;
    prevHead = list->headPointer;
    newItem = curFreeNode;
    newItem->dataType = item;
    /*
    * If the current pointer is at the head of list,
    * item is added at the end.
    */
    if (memoryNodeUsed < sizeof(struct NODE) * NODE_POOL_SIZE) {
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
        memoryNodeUsed += sizeof(struct NODE);
        nodeBlock += 1;
        return 0;
    }
    printf("Error ListPrepend(): memory NODE used exceed the limit\n");
    return -1;
}

int ListAdd(LIST *list, void *item) {
    struct NODE *curItem;
    struct NODE *curNext;
    struct NODE *newItem;

    if (memoryNodeUsed < sizeof(struct NODE) * NODE_POOL_SIZE) {
        newItem = curFreeNode;
        newItem->dataType = item;
        /*
        * if the current list has no item
        */
        if (list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
            list->currentItem = list->headPointer;
        } else if (list->currentItem == 
                   list->tailPointer) {
            /*
            * current item is at tail
            */
            curItem = list->currentItem;
            curItem->nextNode = newItem; 
            newItem->nextNode = NULL;
            newItem->prevNode = curItem;
            list->tailPointer = newItem;
            list->currentItem = list->tailPointer;
        }
        else {
            /*
            * current item is at other positions
            */
            curItem = list->currentItem;
            curNext = curItem->nextNode;
            
            curItem->nextNode = newItem;
            curNext->prevNode = newItem;
            newItem->nextNode = curNext;
            newItem->prevNode = curItem;
            
            list->currentItem = newItem;
        }
        memoryNodeUsed += sizeof(struct NODE);
        list->totalItem += 1;
        nodeBlock += 1;
        curFreeNode = nextFree;
        if (nodeBlock + 1 < NODE_POOL_SIZE) {
            nextFree = curFreeNode->nextNode;
            nextFree = &memoryNode[nodeBlock + 1];
        }
        return 0;
    }
    printf("Error ListAdd(): memory NODE used exceed the limit\n");
    return -1;
}

int ListInsert(LIST *list, void *item) {
    struct NODE *curItem;
    struct NODE *curPrev;
    struct NODE *newItem;
    curItem = list->currentItem;
    curPrev = curItem->prevNode;
    newItem = curFreeNode;
    newItem->dataType = item;
    if (memoryNodeUsed < sizeof(struct NODE) * NODE_POOL_SIZE) {
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
        memoryNodeUsed += sizeof(struct NODE);
        nodeBlock += 1;
        return 0;
    }
    printf("Error ListInsert(): memory NODE used exceed the limit\n");
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
    /*
    * Deleting list2
    */
    list2->headPointer = NULL;
    list2->tailPointer = NULL;
    list2->currentItem = NULL;
    list2->totalItem = 0;
    
    curFreeList = list2;
    memoryListUsed -= sizeof(LIST);
}
