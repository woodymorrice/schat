#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    int number;
    int *pointerToNumber;
    int result;
    testList = ListCreate();
    if (testList == NULL) {
        printf("ListCreated() not working, point to NULL");
    }

    /*
    * Testing ListAdd(LIST*, void*)
    */

    number = 6;
    pointerToNumber = &number;
    result = ListAdd(testList, pointerToNumber);
    if (result == -1) {
        printf("ListAdd() adding 'int': Not passed!");
    }
    
    /*
    * Testing ListCount(LIST*)
    */
    result = ListCount(testList);
    if (result == 0) {
        printf("Checking total after adding one item: Not passed!");
    }
    return EXIT_SUCCESS;

}
