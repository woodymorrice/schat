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

<<<<<<< HEAD
void *ListNext(LIST *list) {
    struct NODE *item1 = list->currentItem;
=======
void *ListNext(LIST *curList) {
    struct NODE *item1;
    struct NODE *itemMoved;

    item1 = curList->currentItem;
>>>>>>> a981bdfd6db6da28d1b11a2a7bb1259ba105756b
    /*
    * if the current item is at the tail of list
    * return NULL  
    */
    if (list->currentItem == list->tailPointer) {
        return NULL;
    }
<<<<<<< HEAD
    list->currentItem = item1->nextNode;
    struct NODE *itemMoved = list->currentItem;
=======
    curList->currentItem = item1->nextNode;
    itemMoved = curList->currentItem;
>>>>>>> a981bdfd6db6da28d1b11a2a7bb1259ba105756b
    itemMoved->prevNode = item1;
    return itemMoved->dataType; 
}

<<<<<<< HEAD
void *ListPrev(LIST *list) {
    struct NODE *item1 = list->currentItem;
=======
void *ListPrev(LIST *curList) {
    struct NODE *item1;
    struct NODE *itemMoved;
    
    item1 = curList->currentItem;
>>>>>>> a981bdfd6db6da28d1b11a2a7bb1259ba105756b
    /*
    * if the current item is at head of list
    * return NULL 
    */
    if (list->currentItem == list->headPointer) {
        return NULL;
}
<<<<<<< HEAD
    list->currentItem = item1->prevNode;
    struct NODE *itemMoved = list->currentItem;
=======
    curList->currentItem = item1->prevNode;
    itemMoved = curList->currentItem;
>>>>>>> a981bdfd6db6da28d1b11a2a7bb1259ba105756b
    itemMoved->nextNode = item1;
    return itemMoved->dataType;
}

