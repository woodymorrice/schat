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

LIST memoryList[LIST_POOL_SIZE];
NODE memoryNode[NODE_POOL_SIZE];
bool isInited = false;
LIST* firstFreeList;
/*
Point to the current free list / free node
*/
LIST *curFreeList;
NODE *curFreeNode;




LIST *ListCreate () {
    LIST *emptyList; 

    if (!isInited) {
    /*
    * initialize nodes
    */
        int node;
        int list;                                                                    
                                                                                
        memoryNode[0].prevNode= NULL;                                               
        memoryNode[0].dataType = NULL;                                             
        memoryNode[0].nextNode = &memoryNode[1];                                   
                                                                                
        for(node = 1; node < NODE_POOL_SIZE - 1; node++){                                  
            memoryNode[node].prevNode = &memoryNode[node - 1];                         
            memoryNode[node].dataType = NULL;                                       
            memoryNode[node].nextNode = &memoryNode[node + 1];                         
        }                                                                           
                                                                                
        memoryNode[NODE_POOL_SIZE-1].prevNode = &memoryNode[node - 1];                  
        memoryNode[NODE_POOL_SIZE-1].dataType = NULL;                    
        memoryNode[NODE_POOL_SIZE-1].nextNode = NULL;          
   
    /*
    * initialize lists
    */   
        memoryList[0].headPointer = NULL;                                              
        memoryList[0].tailPointer  = NULL;                                             
        memoryList[0].currentItem = NULL;
        memoryList[0].totalItem = 0;
        memoryList[0].nextLP = &memoryList[1];
        memoryList[0].prevLP = NULL;                                   
                                                                                
        for(list = 1; list < LIST_POOL_SIZE - 1; list++){                             
            memoryList[list].headPointer = NULL;                       
            memoryList[list].tailPointer = NULL;                                      
            memoryList[list].currentItem = NULL;
            memoryList[list].totalItem = 0;
            memoryList[list].prevLP = &memoryList[list - 1];
            memoryList[list].nextLP = &memoryList[list + 1];                        
        }                                                                           
                                                                                
        memoryList[LIST_POOL_SIZE - 1].headPointer = NULL;                  
        memoryList[LIST_POOL_SIZE - 1].tailPointer = NULL;                              
        memoryList[LIST_POOL_SIZE - 1].currentItem = NULL;
        memoryList[LIST_POOL_SIZE - 1].totalItem = 0;
        memoryList[LIST_POOL_SIZE - 1].prevLP = &memoryList[list - 1];
        memoryList[LIST_POOL_SIZE - 1].nextLP = NULL;
                       
        curFreeList = &memoryList[listBlock];
        curFreeNode = &memoryNode[nodeBlock];
        isInited = true;
    }


    if (memoryListUsed > sizeof(LIST) * LIST_POOL_SIZE) {
        printf("Error ListCreated(): memory list used exceed the limit\n");
        return NULL;
    }
    emptyList = curFreeList;
    memoryListUsed += sizeof(LIST);
    listBlock += 1;
    curFreeList->nextLP = &memoryList[listBlock];
    curFreeList = curFreeList->nextLP;
    return emptyList;
}
    
int ListCount (LIST *list) {
    return list->totalItem;    
}

int ListAppend (LIST *list, void *item) {
    NODE *prevTail;
    NODE *newItem;

    if (memoryNodeUsed < sizeof(NODE) * NODE_POOL_SIZE) {
        prevTail = list->tailPointer;
        list->currentItem = list->tailPointer;
        newItem = curFreeNode;
        newItem->dataType = item;
         
        if (list->totalItem == 0) {
            curFreeNode = curFreeNode->nextNode;
            list->headPointer = newItem;
            list->tailPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
        }
        else {
            curFreeNode = curFreeNode->nextNode;
            list->tailPointer = newItem;
            prevTail->nextNode = newItem;
            newItem->prevNode = prevTail;
            newItem->nextNode = NULL;
            list->currentItem = list->tailPointer;
        }
        list->totalItem += 1;
        memoryNodeUsed += sizeof(NODE);
        return 0;
    }
    printf("Error ListAppend(): memory NODE used exceed the limit\n");
    return -1;
}
    

int ListPrepend (LIST *list, void *item) {
    NODE *prevHead;
    NODE *newItem;
    /*
    * If the current pointer is at the head of list,
    * item is added at the end.
    */
    if (memoryNodeUsed < sizeof(NODE) * NODE_POOL_SIZE) {
        prevHead = list->headPointer;
        newItem = curFreeNode;
        newItem->dataType = item;

        if (list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            curFreeNode = curFreeNode->nextNode;
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
        }
        else {
            list->currentItem = list->headPointer;
            curFreeNode = curFreeNode->nextNode;
            list->headPointer = newItem;
            newItem->prevNode = NULL;
            newItem->nextNode = prevHead;
            prevHead->prevNode = newItem;
        }
        list->currentItem = newItem;
        list->totalItem += 1;
        memoryNodeUsed += sizeof(NODE);
        return 0;
    }
    printf("Error ListPrepend(): memory NODE used exceed the limit\n");
    return -1;
}

int ListAdd(LIST *list, void *item) {
    NODE *curItem;
    NODE *curNext;
    NODE *newItem;

    if (memoryNodeUsed < sizeof(NODE) * NODE_POOL_SIZE) {
        newItem = curFreeNode;
        newItem->dataType = item;
        /*
        * if the current list has no item
        */
        if (list->totalItem == 0) {
            list->headPointer = newItem;
            list->tailPointer = newItem;
            curFreeNode = curFreeNode->nextNode; 
            newItem->prevNode = NULL;
            newItem->nextNode = NULL;
            list->currentItem = list->headPointer;
        } 
        else { 
            if (list->currentItem == list->tailPointer) {
                /*
                * current item is at tail
                */
                curItem = list->currentItem;
                curItem->nextNode = newItem;
                curFreeNode = curFreeNode->nextNode; 
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
                curFreeNode = curFreeNode->nextNode; 
                curItem->nextNode = newItem;
                curNext->prevNode = newItem;
                newItem->nextNode = curNext;
                newItem->prevNode = curItem;
            
                list->currentItem = newItem;
            }
        }
        memoryNodeUsed += sizeof(NODE);
        list->totalItem += 1;
        return 0;
    }
    printf("Error ListAdd(): memory NODE used exceed the limit\n");
    return -1;
}

int ListInsert(LIST *list, void *item) {
    NODE *curItem;
    NODE *curPrev;
    NODE *newItem;
    curItem = list->currentItem;
    curPrev = curItem->prevNode;
    newItem = curFreeNode;
    newItem->dataType = item;
    if (memoryNodeUsed < sizeof(NODE) * NODE_POOL_SIZE) {
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
        memoryNodeUsed += sizeof(NODE);
        nodeBlock += 1;
        return 0;
    }
    printf("Error ListInsert(): memory NODE used exceed the limit\n");
    return -1;
}

void ListConcat(LIST *list1, LIST *list2) {
    NODE *list1Tail;
    NODE *list2Head;
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
