#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    LIST *testList1;
    LIST *testList2;

    int n0, n1, n2, n3, n4, n5, result;
    /*char a, b, c, d;
    double pFloat, pFloat1;*/
    
    struct NODE *tail;
    struct NODE *head;
    struct NODE *current;
    /*
    a = 'a';
    b = 'b';
    c = 'c';
    d = 'd';
    */
    n0 = 1;
    n1 = 2;
    n2 = 3;
    n3 = 4;
    n4 = 5;
    n5 = 6;

    testList = ListCreate();
    if (testList == NULL) {
        printf("testList: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList: ListCreate():\n passed!\n");
    }

    testList1 = ListCreate();
    if (testList1 == NULL) {
        printf("testList1: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList1: ListCreate():\n passed!\n");
    }
    
    testList2 = ListCreate();
    if (testList2 == NULL) {
        printf("testList2: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList2: ListCreate():\n passed!\n");
    }

    /*
    * Testing ListAdd(LIST*, void*)
    */
    result = ListAdd(testList, &n0);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: ListAdd() adding 1st 'int':\n Not passed!\n");
    } else if (head != tail) {
        printf("testList: (1st) head and tail return wrong\n Not passed!\n");
    } else if (head->prevNode != NULL || head->nextNode != NULL) {
        printf("testList: (1st) node preference return wrong\n Not passed!\n");
    } else if (*((int*)current->dataType) != 1) {
        printf("testList: (1st) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 1st item:\n passed!\n");
    }

    result = ListAdd(testList, &n1);
    current = testList->currentItem;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: ListAdd() adding 2nd 'int':\nNot passed!\n");
    } else if (head == tail) {
        printf("testList: (2nd) head and tail return same\n Not passed!\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList: (2nd) preference does not match!\n Not passed!\n");
    } else if (*((int*)current->dataType) != 2) {
        printf("testList: (2nd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 2nd item:\n passed!\n");
    }

    result = ListAdd(testList1, &n2);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: ListAdd() adding 1st 'int':\n Not passed!\n");
    } else if (head != tail) {
        printf("testList1: (1st) head and tail return wrong\n Not passed!\n");
    } else if (head->prevNode != NULL || head->nextNode != NULL) {
        printf("testList1: (1st) node preference return wrong\n");
        printf(" Not passed!\n");
    } else if (*((int*)current->dataType) != 3) {
        printf("testList1: (1st) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 1st item:\n passed!\n");
    }

    result = ListAdd(testList1, &n3);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: ListAdd() adding 2nd 'int':\n Not passed!\n");
    } else if (head == tail) {
        printf("testList1: (2nd) head and tail return same\n Not passed!\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList1: (2nd) node preference return wrong\n");
        printf(" Not passed!\n");
    } else if (*((int*)current->dataType) != 4) {
        printf("testList1: (2nd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 2nd item:\n passed!\n");
    }

    result = ListAdd(testList1, &n4);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: ListAdd() adding 3rd 'int':\n Not passed!\n");
    } else if (head == tail) {
        printf("testList1: (3rd) head and tail return same\n Not passed!\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList1: (3rd) node preference return wrong\n");
        printf(" Not passed!\n");
    } else if (*((int*)current->dataType) != 5) {
        printf("testList1: (3rd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 3rd item:\n passed!\n");
    }
    
    /*
    * Attempting to make error occur here: 
    * when Node is out of memory
    */
    
    result = ListAdd(testList1, &n5);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: ListAdd() adding 4th 'int':\n Not passed!\n");
    } else if (head == tail) {
        printf("testList1: (4th) head and tail return same\n Not passed!\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList1: (4th) node preference return wrong\n");
        printf(" Not passed\n");
    } else if (*((int*)current->dataType) != 6) {
        printf("testList1: (4th) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 4th item:\n passed!\n");
        printf("     Not supposed to pass here!\n");
    }
    
    /*
    * Testing ListCount(LIST*)
    */
    result = ListCount(testList);
    if (result != 2) {
        printf("testList: result return %d items\n Not passed!\n", result);
    }
    else {
        printf("testList: return item:\n passed!\n");
    }

    result = ListCount(testList1);
    if (result != 3) {
        printf("testList1: result return %d items\n Not passed!\n", result);
    }
    else {
        printf("testList1: return item:\n passed!\n");
    }

    /*
    * Testing ListAppend(LIST*, void*)
    */
   
    
    
    /*
    * Testing ListPrepend(LIST*)
    */
    return EXIT_SUCCESS;

}
