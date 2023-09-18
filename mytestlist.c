#include <stdio.h>
#include <stdlib.h>

#include "list.h"


#define LIST_POOL_SIZE 50*sizeof(struct LIST)
#define NODE_POOL_SIZE 50*sizeof(struct NODE)

LIST listPool[LIST_POOL_SIZE];
NODE nodePool[NODE_POOL_SIZE];


<<<<<<< HEAD
if (argc != 2) {
    perror("Usage: perror. wrong number of arguments");
    return -1;
}


return EXIT_SUCCESS;
=======
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
>>>>>>> a981bdfd6db6da28d1b11a2a7bb1259ba105756b
}
