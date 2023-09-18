#include <stdio.h>
#include <stdlib.h>
#include "list.h"

void *ListRemove(LIST *list) {
    struct NODE *item1 = list->currentItem;
    /*
    * If current list only has one item/one node
    */
    if(list->totalItem == 1) {
        list->currentItem = NULL;
        list->headPointer = NULL;
        list->tailPointer = NULL;
        list->totalItem -= 1;
        return item1->dataType;
    }
    /*
    * If the current item at head of list
    */
    if (item1->prevNode == NULL) {
        struct NODE *oldHead;
        struct NODE *itemMoved;

        oldHead = list->headPointer;
        ListNext(list);
        oldHead->nextNode = NULL;
        itemMoved = list->currentItem;
        itemMoved->prevNode = NULL;
        list->headPointer = list->currentItem;
        list->totalItem -= 1;
        return oldHead->dataType;
    }
    /*
    * If the current item at tail
    */
    if (item1->nextNode == NULL) {
        struct NODE *oldTail;
        struct NODE *itemMoved;

        oldTail = list->tailPointer;
        ListPrev(list);
        oldTail->prevNode = NULL;
        itemMoved = list->currentItem;
        itemMoved->nextNode = NULL;
        list->tailPointer = list->currentItem;
        list->totalItem -= 1;
        return oldTail->dataType;
    }
    
    struct NODE *rmItem = list->currentItem;
    struct NODE *nextItem = rmItem->nextNode;
    nextItem->prevNode = rmItem->prevNode;
    struct NODE *rmPrev = rmItem->prevNode;
    rmPrev->nextNode = list->currentItem; 
    rmItem->prevNode = NULL;
    rmItem->nextNode = NULL;
    list->totalItem -= 1;
    return rmItem->dataType;
}

void item_free (void *item) {
    /* this line produces an error i dont know how to fix
     * right now, so I'm commenting it out -W
     * free(item->dataType);
     */
}

void ListFree(LIST *list, void (*itemFree)(void *itemToBeFreed)) {
    struct NODE *curItem;
    ListFirst(list);
    /* Booleans dont exist in c90 so we have to use ints
     * 0 = true, 1 = false */
    int empty = 1;
    while (empty) {
        if (list == NULL) {
            empty = 0;
        }
        curItem = list->currentItem;
        itemFree(curItem->dataType);
        ListNext(list);
    }
    list->headPointer = NULL;
    list->tailPointer = NULL;
    list->currentItem = NULL;
    list->totalItem = 0;
}

void *ListTrim(LIST *list) {
    if (list->totalItem == 0) {
        return NULL;
    }
    struct NODE *oldTail = ListLast(list);
    struct NODE *newTail = ListPrev(list);
    oldTail->prevNode = NULL;
    newTail->nextNode = NULL;
    list->totalItem -= 1;
    return oldTail->dataType;
}
