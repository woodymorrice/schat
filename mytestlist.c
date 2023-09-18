#include <stdio.h>
#include <stdlib.h>

#include "list.h"


#define LIST_POOL_SIZE 50*sizeof(LIST)
#define NODE_POOL_SIZE 50*sizeof(struct NODE)

LIST listPool[LIST_POOL_SIZE];
NODE nodePool[NODE_POOL_SIZE];

int main() {

    
    LIST *testList;
    int count;
    int number = 6;
    int *pointer = &number;
    /*Test ListCreate()*/
    testList = ListCreate();

    if (testList == NULL) {
        printf("Error in procedure *ListCreate(): invalid parameter\n");
    } else {
        printf("Got to procedure *ListCreate()\n");
    } 

    /* Test ListCount() */
    count = ListCount(testList);
    printf("%d", count);

    /* Test ListAppend() */
    ListAppend(testList, pointer);


    return EXIT_SUCCESS;

}
