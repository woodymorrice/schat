/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

#include <stdio.h>
#include <stdlib.h>
#include "list.h"


void *ListFirst(LIST *list) {
    return list->currentItem = list->headPointer;
}

void *ListLast(LIST *list) {
    return list->currentItem = list->tailPointer;
}

void *ListCurr(LIST *list) {
    return list->currentItem;
}

void *ListNext(LIST *list) {
    struct NODE *item1;
    struct NODE *itemMoved;

    item1 = list->currentItem;
    /*
    * if the current item is at the tail of list
    * return NULL  
    */
    if (list->currentItem == list->tailPointer) {
        return NULL;
    }
    list->currentItem = item1->nextNode;
    itemMoved = list->currentItem;
    itemMoved->prevNode = item1;
    return itemMoved->dataType; 
}


void *ListPrev(LIST *list) {
    struct NODE *item1;
    struct NODE *itemMoved;
    
    item1 = list->currentItem;
    /*
    * if the current item is at head of list
    * return NULL 
    */
    if (list->currentItem == list->headPointer) {
        return NULL;
    }
    list->currentItem = item1->prevNode;
    itemMoved = list->currentItem;
    itemMoved->nextNode = item1;
    return itemMoved->dataType;
}

