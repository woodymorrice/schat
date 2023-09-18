#include <stdio.h>
#include <stdlib.h>

#include "list.h"

const int MAX_ITEM = 10;

 
struct LIST *ListCreate () {

    struct LIST *newList;

    /* for testing --remove */
    printf("Got to procedure ListCreate()\n");
    
    newList->headPointer = NULL;
    newList->tailPointer = NULL;
    newList->currentItem = NULL;
    newList->totalItem = 0;

    return newList;
}

int ListCount (LIST *curList) {
    /* For testing -- remove */
    if (curList == NULL) {
        printf("Error in procedure ListCount(): invalid parameter *curList\n");
    } else {
        printf("Got to procedure ListCount()\n");
    }
    return 0;

    /* return curList->totalItem; */
}

int ListAppend (LIST *curList, struct NODE *item) {
    /* For testing -- remove */
    if (curList == NULL) {
        printf("Error in procedure ListAppend(): invalid parameter *curList\n");
        return -1;
    } else {
        printf("Got to procedure ListCount()\n");
        return 0;
    }
    if (curList == NULL) {
        printf("Error in procedure ListAppend(): invalid parameter *item\n");
        return -1;
    } else {
        printf("Got to procedure ListCount()\n");
        return 0;
    }

    /* 
     * struct NODE *prevTail = curList->tailPointer;
    * If the current pointer is at the end of list,
    * item is added at the end.
    if (curList->totalItem < MAX_ITEM) {
        ListLast(curList);
        curList->tailPointer = item;
        item->prevNode = prevTail;
        item->nextNode = NULL;
        * Making sure the tail is new item and current item
        * at the tail 
        ListLast(curList);
        curList->totalItem += 1;
        return 0;
    }
    return -1; 
    */
    
}

int ListPrepend (LIST *curList, struct NODE *item) {
    struct NODE *prevHead = curList->headPointer;
    /*
    * If the current pointer is at the head of list,
    * item is added at the end.
    */
    if (curList->totalItem < MAX_ITEM) {
        ListFirst(curList);
        curList->headPointer = item;
        item->prevNode = NULL;
        item->nextNode = prevHead;
        /*
        * Making sure the head is new item and current item
        * at the head
        */
        ListFirst(curList);
        curList->totalItem += 1;
        return 0;
    }
    return -1;
}

int ListAdd(LIST *curList, struct NODE *item) {
    struct NODE *curItem = ListCurr(curList);
    struct NODE *curNext = curItem->nextNode;
    if (curList->totalItem < MAX_ITEM) {
        if (curList->totalItem == 0) {
            curList->headPointer = item;
            curList->tailPointer = item;
            ListFirst(curList);
        }
        if (curList->currentItem == curList->tailPointer) {
            /*
            * if current item is at tail
            */
            return ListAppend(curList, item);
        }
        curItem->nextNode = item; 
        curNext->prevNode = item;
        item->nextNode = curNext;
        item->prevNode = curItem;
        ListNext(curList);
        curList->totalItem += 1;
        return 0;    
    }
    return -1;
}

int ListInsert(LIST *curList, struct NODE *item) {
    struct NODE *curItem = ListCurr(curList);
    struct NODE *curPrev = curItem->prevNode;
    if (curList->totalItem < MAX_ITEM) {
        /*
        * if current item is at head
        */
        if (curList->currentItem == curList->headPointer) {
            return ListPrepend(curList, item);
        }
        curItem->prevNode = item;
        curPrev->nextNode = item;
        item->prevNode = curPrev;
        item->nextNode = curItem;
        ListPrev(curList);
        curList->totalItem += 1;
        return 0;
    }
    return -1;
}

void ListConcat(LIST *list1, LIST *list2) {
    
    /* for testing, remove after implementation */
    if (list1 == NULL) {
        printf("Error in procedure ListConcat: invalid parameter list1");
    } else {
        printf("Got to procedure ListConcat");
    }

    if (list2 == NULL) {
        printf("Error in procedure ListConcat: invalid parameter list2");
    } else {
        printf("Got to procedure ListConcat");
    }
   
}
