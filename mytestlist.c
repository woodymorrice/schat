#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    LIST *testList1;
    int number, number1, result;
    char a, b, c, d;
    double pFloat, pFloat1;
    
    int *pointerToNumber;
    double *pointerToDouble;
    char *i:
    struct NODE *tail;
    struct NODE *head;
    

    testList = ListCreate();
    if (testList == NULL) {
        printf("testList: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList: ListCreate(): passed!\n");
    }

    /*
    * Testing ListAdd(LIST*, void*)
    */

    number = 6;
    pointerToNumber = &number;
    result = ListAdd(testList, pointerToNumber);
    if (result == -1) {
        printf("testList: ListAdd() adding 1st 'int': Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 1st item: passed!\n");
    }

    number = 5;
    pointerToNumber = &number;
    result = ListAdd(testList, pointerToNumber);
    if (result == -1) {
        printf("testList: ListAdd() adding 2nd 'int': Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 2nd item: passed!\n");
    }
    
    testList1 = ListCreate();
    if (testList == NULL) {
        printf("testList1 : ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList1: ListCreate(): passed!\n");
    }

    number = 1;
    pointerToNumber = &number;
    result = ListAdd(testList1, pointerToNumber);
    if (result == -1) {
        printf("testList1: ListAdd() adding 1 integer: Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 1st item: passed!\n");
    }

    number1 = 9;
    pointerToNumber = &number1;
    result = ListAdd(testList1, pointerToNumber);
    if (result == -1) {
        printf("testList1: ListAdd() adding 2nd int: Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 2nd item: passed!\n");
    }
    
    number = 10;
    pointerToNumber = &number1;
    result = ListAdd(testList1, pointerToNumber);
    if (result == -1) {
        printf("testList1: ListAdd() adding 3rd int: Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 3rd item: passed!\n");
    }

    
    /*
    * Testing ListCount(LIST*)
    */
    result = ListCount(testList);
    if (result == 0) {
        printf("testList: Checking total after adding one item: Not passed!\n");
    } else if (result != 2) {
        printf("testList: result return %d items\n", result);
    }
    else {
        printf("testList: return item: passed!\n");
    }

    result = ListCount(testList1);
    if (result == 0) {
        printf("testList1: Checking total after adding one item: Not passed!\n");
    } else if (result != 3) {
        printf("testList1: result return %d items\n", result);
    }
    else {
        printf("testList1: return item: passed!\n");
    }

    /*
    * Testing ListAppend(LIST*, void*)
    */
    number = 12;
    pointerToNumber = &number;
    result = ListAppend(testList, pointerToNumber);
    tail = testList->tailPointer;
    number1 = *((int*)tail->dataType); 
    if (testList->tailPointer == NULL) {
        printf("testList: ListAppend() fails to change tail item\n");
    } else if (number1 != 12) {
        printf("testList: tail return %d : Not passed!", number1);
        if (number == 12) {
            printf("testList: tail return the right value: passed!\n");
        }
    }
    else {
        printf("testList: ListAppend() first item: passed!\n");
    }

    number1 = 15;
    pointerToNumber = &number1;
    result = ListAppend(testList1, pointerToNumber);

    if (testList1->tailPointer == NULL) {
        printf("testList1: ListAppend() fails to change tail item\n");
    }
    else {
        printf("testList1: ListAppend() first item: passed!\n");
    }
    
    
    /*
    * Testing ListPrepend(LIST*)
    */
    number = 20;
    pointerToNumber = &number;
    result = ListPrepend(testList, pointerToNumber);
    head = testList->headPointer;
    number1 = *((int*)head->dataType);
    if (testList->headPointer == NULL) {
        printf("testList: ListPrepend() fails to change head item\n");
    } else if (number1 != 20) {
        printf("testList: head return %d : Not passed!", number1);
        if (number == 20) {
            printf("testList: head return the right value: passed!\n");
        }
    }
    else {
        printf("testList: ListPrepend() first item: passed!\n");
    }
    return EXIT_SUCCESS;

}
