#include <stdio.h>
#include <stdlib.h>
#include <list.h>

void *ListRemove(LIST *curList) {
    /*
    * If the current item at head of list
    */
    if (*(curList->*currentItem)->*prevNode == NULL) {
        NODE *oldHead = *(curList->*headPointer);
        ListNext(curList);
        oldHead->*nextNode = NULL;
        *(curList->currentItem)->*prevNode = NULL;
        curList->*headPointer = curList->*currentItem;
        curList->totalItem -= 1;
    }
    /*
    * If the current item at tail
    */
    if (*(curList->currentItem)->*newNode == NULL) {
        NODE *oldTail = curList->*tailPointer;
        ListPrev(curList);
        oldTail->*prevNode = NULL;
        *(curList->currentItem)->*nextNode = NULL;
        curList->*tailPointer = curList->*currentItem;
        curList->totalItem -= 1;
    }
    
    NODE *rmItem = *(curList->*currentItem);
    ListNext(curList);
    *(curList->*currentItem)->*prevNode = rmItem->*prevNode;
    *(rmItem->*prevNode)->*nextNode = *(curList->*currentItem); 
    rmItem->*prevNode = NULL;
    rmItem->*nextNode = NULL;
    curList->totalItem -= 1;
}
