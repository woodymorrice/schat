#include <stdio.h>
#include <stdlib.h>

#include "list.h"


#define LIST_POOL_SIZE 50*sizeof(struct LIST)
#define NODE_POOL_SIZE 50*sizeof(struct NODE)

LIST listPool[LIST_POOL_SIZE];
NODE nodePool[NODE_POOL_SIZE];


int main() {

    /*
     * struct LIST *testList;
     * int count;
     * struct NODE *testNode; */

    /* Test ListCreate() */
    /* testList = ListCreate();

    if (testList == NULL) {
        printf("Error in procedure *ListCreate(): invalid parameter\n");
    } else {
        printf("Got to procedure *ListCreate()\n");
    } 
    */

    /* Test ListCount() */
    /* count = ListCount(testList); */

    /* Test ListAppend() */
    /* ListAppend(testList, testNode); */


    return EXIT_SUCCESS;
}
