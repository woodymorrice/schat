/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

#include <stdio.h>
#include <stdlib.h>
#include <list.h>


void *ListFirst(LIST *list) {
    list->currentItem = list->headPointer;
    return list->currentItem;
}

void *ListLast(LIST *list) {
    return list->currentItem = list->tailPointer;
}

void *ListCurr(LIST *list) {
    return list->currentItem;
}

void *ListNext(LIST *list) {
    NODE *nextItem;
    NODE *curItem;
    /*
    * if the current item is at the tail of list
    * return NULL  
    */
    if (list->currentItem == list->tailPointer) {
        return NULL;
    }
    curItem = list->currentItem;
    nextItem = curItem->nextNode;
    list->currentItem = nextItem;
    return list->currentItem;
}


void *ListPrev(LIST *list) {
    struct NODE *prev;
    struct NODE *curItem;
    
    curItem = list->currentItem;
    /*
    * if the current item is at head of list
    * return NULL 
    */
    if (list->currentItem == list->headPointer) {
        return NULL;
    }
    prev = curItem->prevNode;
    list->currentItem = prev;
    return list->currentItem;
}

void *ListSearch(LIST* list, int (*comparator)(void *item1, void *item2),
                void *comparisonArg) {
    struct NODE *curNode;
    curNode = list->currentItem;
    if (list == NULL || comparator == NULL || comparisonArg == NULL) {
        return NULL;
    }
    while (comparator(comparisonArg, curNode->dataType) != 1) {
        if (curNode == list->tailPointer) {
            return NULL;
        }
        curNode = curNode->nextNode;
    }
    return curNode->dataType;
    
}
