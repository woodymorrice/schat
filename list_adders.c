#include <stdio.h>
#include <stdlib.h>

#include "list.h"

 
LIST *ListCreate () {
    LIST *newList = NULL;
    newList->headPointer = NULL;
    newList->tailPointer = NULL;
    newList->currentItem = NULL;
    newList->totalItem = 0;
    return newList;
}

int ListCount (LIST *list) {
    return list->totalItem;    
}

int ListAppend (LIST *list, void *item) {
    struct NODE *prevTail = list->tailPointer;
    struct NODE *newItem = NULL;
    newItem->dataType = item;
    /*
    * If the current pointer is at the end of list,
    * item is added at the end.
    */
    if (list->totalItem < MAX_ITEM) {
        ListLast(list);
        list->tailPointer = newItem;
        newItem->prevNode = prevTail;
        newItem->nextNode = NULL;
        /*
        * Making sure the tail is new item and current item
        * at the tail 
        */
        ListLast(list);
        list->totalItem += 1;
        return 0;
    }
    return -1;
}

int ListPrepend (LIST *list, void *item) {
    struct NODE *prevHead = list->headPointer;
    struct NODE *newItem = NULL;
    newItem->dataType = item;
    /*
    * If the current pointer is at the head of list,
    * item is added at the end.
    */
    if (list->totalItem < MAX_ITEM) {
        ListFirst(list);
        list->headPointer = newItem;
        newItem->prevNode = NULL;
        newItem->nextNode = prevHead;
        /*
        * Making sure the head is new item and current item
        * at the head
        */
        ListFirst(list);
        list->totalItem += 1;
        return 0;
    }
    return -1;
}

int ListAdd(LIST *list, void *item) {
    struct NODE *curItem = list->currentItem;
    struct NODE *curNext = curItem->nextNode;
    struct NODE *newItem = NULL;
    newItem->dataType = item;
    if (list->totalItem < MAX_ITEM) {
        if (list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
            ListFirst(list);
        }
        if (list->currentItem == list->tailPointer) {
            /*
            * if current item is at tail
            */
            return ListAppend(list, item);
        }
        curItem->nextNode = newItem; 
        curNext->prevNode = newItem;
        newItem->nextNode = curNext;
        newItem->prevNode = curItem;
        ListNext(list);
        list->totalItem += 1;
        return 0;    
    }
    return -1;
}

int ListInsert(LIST *list, void *item) {
    struct NODE *curItem = list->currentItem;
    struct NODE *curPrev = curItem->prevNode;
    struct NODE *newItem = NULL;
    newItem->dataType = item;
    if (curList->totalItem < MAX_ITEM) {
        /*
        * if current item is at head
        */
        if (list->currentItem == list->headPointer) {
            return ListPrepend(curList, item);
        }
        curItem->prevNode = newItem;
        curPrev->nextNode = newItem;
        newItem->prevNode = curPrev;
        newItem->nextNode = curItem;
        ListPrev(list);
        list->totalItem += 1;
        return 0;
    }
    return -1;
}

void ListConcat(LIST *list1, LIST *list2) {
    if (list1 == NULL) {
        return;
    } else if (list2 == NULL) {
        return;
    }

    struct NODE *list1Tail;
    list1Tail = list1->tailPointer;
    struct NODE *list2Head;
    list2Head = list2->headPointer;
    list1Tail->nextNode = list2->headPointer;
    list2Head->prevNode = list1->tailPointer;
    list1Tail = list2->tailPointer;
    
    list1->totalItem += list2->totalItem;
    
    
}
