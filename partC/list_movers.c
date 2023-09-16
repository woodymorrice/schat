#include <stdio.h>
#include <stdlib.h>
#include <list.h>

void *ListFirst(LIST *curList) {
    curList->currentItem = curList->*headPointer;
}

void *ListLast(LIST *curList) {
    curList->currentItem = curList->*tailPointer;
}

void *ListCurr(LIST *curList) {
    return curList->currentItem;
}

void *ListNext(LIST *curList) {
    NODE *item1 = curList->*currentItem;
    /*
    * if the current item is at the tail of list
    * return NULL  
    */
    if (curList->*currentItem == curList->*tailPointer) {
        return NULL;
}
    curList->*currentItem = *((curList->*currentItem)->*nextNode);
    (curList->*currentItem)->*prevNode = item1; 
}

void *ListPrev(LIST *curList) {
    NODE *item1 = *(curList->*currentItem);
    /*
    * if the current item is at head of list
    * return NULL 
    */
    if (curList->*currentItem == curList->*headPointer) {
        return NULL;
}
    curList->currentItem = (curList->currentItem)->*prevNode;
    (curList->currentItem)->*nextNode = item1;
}




