#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    LIST *testList1;
    int number;
    int number1;
    int *pointerToNumber;
    int result;
    testList = ListCreate();
    if (testList == NULL) {
        printf("testList: ListCreated() not working, point to NULL");
    }
    else {
        printf("testList: ListCreate(): passed!");
    }

    /*
    * Testing ListAdd(LIST*, void*)
    */

    number = 6;
    pointerToNumber = &number;
    result = ListAdd(testList, pointerToNumber);
    if (result == -1) {
        printf("testList: ListAdd() adding 1st 'int': Not passed!");
    }
    else {
        printf("testList: ListAdd() adding 1st item: passed!");
    }

    number = 5;
    pointerToNumber = &number;
    result = ListAdd(testList, pointerToNumber);
    if (result == -1) {
        printf("testList: ListAdd() adding 2nd 'int': Not passed!");
    }
    else {
        printf("testList: ListAdd() adding 2nd item: passed!");
    }
    
    testList1 = ListCreate();
    if (testList == NULL) {
        printf("testList1 : ListCreated() not working, point to NULL");
    }
    else {
        printf("testList1: ListCreate(): passed!");
    }

    number = 1;
    pointerToNumber = &number;
    result = ListAdd(testList1, pointerToNumber);
    if (result == -1) {
        printf("testList1: ListAdd() adding 1 integer: Not passed!");
    }
    else {
        printf("testList1: ListAdd() adding 1st item: passed!");
    }

    number1 = 9;
    pointerToNumber = &number1;
    result = ListAdd(testList1, pointerToNumber);
    if (result == -1) {
        printf("testList1: ListAdd() adding 2nd int: Not passed!");
    }
    else {
        printf("testList1: ListAdd() adding 2nd item: passed!");
    }
    
    number = 10;
     pointerToNumber = &number1;
    result = ListAdd(testList1, pointerToNumber);
    if (result == -1) {
        printf("testList1: ListAdd() adding 3rd int: Not passed!");
    }
    else {
        printf("testList1: ListAdd() adding 3rd item: passed!");
    }

    
    /*
    * Testing ListCount(LIST*)
    */
    result = ListCount(testList);
    if (result == 0) {
        printf("testList: Checking total after adding one item: Not passed!");
    } else if (result != 2) {
        printf("testList: result return %d items", result);
    }
    else {
        printf("testList: return item: passed!");
    }

    result = ListCount(testList1);
    if (result == 0) {
        printf("testList: Checking total after adding one item: Not passed!");
    } else if (result != 3) {
        printf("testList: result return %d items", result);
    }
    else {
        printf("testList: return item: passed!");
    }

    /*
    * Testing ListAppend(LIST*, void*)
    */
    number = 12;
    pointerToNumber = &number;
    result = ListAppend(testList, pointerToNumber);
    
    if (testList->tailPointer == NULL) {
        printf("testList: ListAppend() fails to change tail item");
    }
    else {
        printf("testList: ListAppend() first item: passed!");
    }

    number1 = 15;
    pointerToNumber = &number1;
    result = ListAppend(testList1, pointerToNumber);

    if (testList1->tailPointer == NULL) {
        printf("testList1: ListAppend() fails to change tail item");
    }
    else {
        printf("testList1: ListAppend() first item: passed!");
    }
    
    
    /*
    * Testing ListPrepend(LIST*)
    */


    return EXIT_SUCCESS;

}
