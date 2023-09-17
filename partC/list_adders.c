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
    return curList->totalItem;    
}

int ListAppend (LIST *curList, NODE *item) {
    NODE *prevTail = curList->tailPointer; 
    /*
    * If the current pointer is at the end of list,
    * item is added at the end.
    */
    if (curList->totalItem < MAX_ITEM) {
        ListLast(curList);
        curList->tailPointer = item;
        item->prevNode = prevTail;
        item->nextNode = NULL;
        /*
        * Making sure the tail is new item and current item
        * at the tail 
        */
        ListLast(curList);
        curList->totalItem += 1;
        return 0;
    }
    return -1;
}

int ListPrepend (LIST *curList, NODE *item) {
    NODE *prevHead = curList->headPointer;
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

int ListAdd(LIST *curList, NODE *item) {
    NODE *curItem = ListCurr(curList);
    NODE *curNext = (ListCurr(curList))->nextNode;
    if (curList->totalItem < MAX_ITEM) {
        if (curList->currentItem == curList->tailPointer) {
            /*
            * if current item is at tail
            */
            return ListAppend(curList, item);
        }
        *(NODE *)(curList->currentItem)->nextNode = item; 
        curNext->prevNode = item;
        item->nextNode = curNext;
        item->prevNode = curItem;
        ListNext(curList);
        curList->totalItem += 1;
        return 0;    
    }
    return -1;
}

int ListInsert(LIST *curList, NODE *item) {
    NODE *curItem = ListCurr(curList);
    NODE *curPrev = (ListCurr(curList))->prevNode;
    if (curList->totalItem < MAX_ITEM) {
        /*
        * if current item is at head
        */
        if (curList->currentItem == curList->headPointer) {
            return ListPrepend(curList, item);
        }
        *(NODE *)(curList->currentItem)->prevNode = item;
        curPrev->nextNode = item;
        item->prevNode = curPrev;
        item->nextNode = curItem;
        ListPrev(curList);
        curList->totalItem += 1;
        return 0;
    }
    return -1;
}
