#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    LIST *testList1;
    /*LIST *testList2;*/
    int number, number1, result, number2, number3;
    /*char a, b, c, d;
    double pFloat, pFloat1;*/
    
    int *pointerToNumber;
    struct NODE *tail;
    struct NODE *head;
    struct NODE *middle;
    /*
    a = 'a';
    b = 'b';
    c = 'c';
    d = 'd';
    */

    testList = ListCreate();
    if (testList == NULL) {
        printf("testList: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList: ListCreate():\npassed!\n");
    }

    /*
    * Testing ListAdd(LIST*, void*)
    */

    number = 6;
    pointerToNumber = &number;
    result = ListAdd(testList, pointerToNumber);
    head = testList->headPointer;
    tail = testList->tailPointer;
    number1 = *((int*)head->dataType);
    number2 = *((int*)tail->dataType);
    if (result == -1) {
        printf("testList: ListAdd() adding 1st 'int':\nNot passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 1st item:\npassed!\n");
    }

    if(number1 == number2) {
        printf("testList: assigning head and tail :\npassed!\n");
    }
    else {
        printf("testList: head and tail different:\n Not passed!\n");
    }

    number3 = 5;
    pointerToNumber = &number3;
    result = ListAdd(testList, pointerToNumber);
    head = testList->headPointer;
    tail = testList->tailPointer;
    number1 = *((int*)head->dataType);
    number2 = *((int*)tail->dataType);
    if (result == -1) {
        printf("testList: ListAdd() adding 2nd 'int':\nNot passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 2nd item:\npassed!\n");
    }
    
    if(number1 == number2) {
        printf("testList: (2nd) false head and tail:\nNot passed!\n");
    }
    else {
        printf("testList: (2nd) head and tail correct:\npassed!\n");
    }
    
    testList1 = ListCreate();
    if (testList == NULL) {
        printf("testList1 : ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList1: ListCreate():\npassed!\n");
    }

    number = 1;
    pointerToNumber = &number;
    result = ListAdd(testList1, pointerToNumber);
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    number1 = *((int*)head->dataType);
    number2 = *((int*)tail->dataType);
    if (result == -1) {
        printf("testList1: ListAdd() adding 1 integer:\nNot passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 1st item:\npassed!\n");
    }
    
    
    if(number1 != number2) {
        printf("testList1: fail to assign head and tail:\nNot passed!\n");
    }
    else {
        printf("testList1: head and tail point the same:\npassed!\n");
    }

    number3 = 9;
    pointerToNumber = &number3;
    result = ListAdd(testList1, pointerToNumber);
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    number1 = *((int*)head->dataType);
    number2 = *((int*)tail->dataType);
    if (result == -1) {
        printf("testList1: ListAdd() adding 2nd int:\nNot passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 2nd item:\npassed!\n");
    }
    
    if(number1 == number2) {
        printf("testList1:(2nd) false head and tail:\nNot passed!\n");
    }
    else {
        printf("testList1: (2nd) head and tail correct:\npassed!\n");
    }
    
    number = 10;
    pointerToNumber = &number1;
    result = ListAdd(testList1, pointerToNumber);
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    number1 = *((int*)head->dataType);
    number2 = *((int*)tail->dataType);
    middle = head->nextNode;
    number3 = *((int*)middle->dataType);
    if (result == -1) {
        printf("testList1: ListAdd() adding 3rd int:\nNot passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 3rd item:\npassed!\n");
    }
    
    if(number1 == number3) {
        printf("testList1: nextNode conflict:\nNot passed!\n");
    }
    else {
        printf("testList1: nextNode assigning:\npassed!\n");
    }

    if(number2 == number3) {
        printf("testList1: tail prevNode conflict:\nNot passed!\n");
    }
    else {
        printf("testList1: tail prevNode assigning:\npassed!\n");
    }

    
    
    /*
    * Testing ListCount(LIST*)
    */
    result = ListCount(testList);
    if (result == 0) {
        printf("testList: Check total after adding one item:\nNot passed!\n");
    } else if (result != 2) {
        printf("testList: result return %d items\n", result);
    }
    else {
        printf("testList: return item:\npassed!\n");
    }

    result = ListCount(testList1);
    if (result == 0) {
        printf("testList1: Check total after adding one item:\nNot passed!\n");
    } else if (result != 3) {
        printf("testList1: result return %d items\n", result);
    }
    else {
        printf("testList1: return item:\npassed!\n");
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
        printf("testList: tail return %d :\nNot passed!\n", number1);
        if (number == 12) {
            printf("testList: tail return the right value:\npassed!\n");
        }
    }
    else {
        printf("testList: ListAppend() first item:\npassed!\n");
    }

    number1 = 15;
    pointerToNumber = &number1;
    result = ListAppend(testList1, pointerToNumber);

    if (testList1->tailPointer == NULL) {
        printf("testList1: ListAppend() fails to change tail item\n");
    }
    else {
        printf("testList1: ListAppend() first item:\npassed!\n");
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
        printf("testList: head return %d :\nNot passed!\n", number1);
        if (number == 20) {
            printf("testList: head return the right value:\npassed!\n");
        }
    }
    else {
        printf("testList: ListPrepend() first item:\npassed!\n");
    }

    /*
    * Testing ListInsert(LIST*, void*)
    */
    number = 21;
    pointerToNumber = &number;
    result = ListInsert(testList, pointerToNumber);
    head = testList->headPointer;
    number1 = *((int*)head->dataType);
    ListFirst(testList);
    if (testList->headPointer == NULL) {
        printf("testList: ListInsert() fails to change head item\n");
    } else if (number1 == 21) {
        printf("testList: head return %d :\npassed!\n", number1);
    }
    else {
        printf("testList: ListInsert() first item:\npassed!\n");
    }
    
    ListNext(testList);
    number3 = 22;
    pointerToNumber = &number3;
    result = ListInsert(testList, pointerToNumber);
    head = testList->headPointer;
    number1 = *((int*)head->dataType);
    middle = head->nextNode;
    number2 = *((int*)middle->dataType);
    if (number1 == number2) {
        printf("testList: ListInsert() fails to change item\n");
    } else if (number1 == 22) {
        printf("testList: head return %d :\nNot passed!\n", number1);
    }
    else {
        printf("testList: ListInsert() second item:\npassed!\n");
    }
    return EXIT_SUCCESS;

}
