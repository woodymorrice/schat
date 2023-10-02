#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    LIST *testList1;
    LIST *testList2;
    LIST *testList3;

    int n0, n1, n2, n3, n4, n5, result;
    char a, b, c, d;
    /*double pFloat, pFloat1;*/
    
    struct NODE *tail;
    struct NODE *head;
    struct NODE *current;
    struct NODE *next;
    struct NODE *prev;
    
    /*
    * Use for testing functions in list_removers.c
    */
    int *resultPointer;
    
    a = 'a';
    b = 'b';
    c = 'c';
    d = 'd';

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
    Attempting to make the exceed error here
    */
    testList3 = ListCreate();
    if (testList3 == NULL) {
        printf("testList3: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList3: ListCreate():\n passed!\n");
    }

    /*
    * Testing ListAdd(LIST*, void*)
    */
    result = ListAdd(testList, &n0);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: ListAdd() return -1 for 'int':\n Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 1st item return:\n passed!\n");
    }
    if (head != tail) {
        printf("testList: ListAdd(), head and tail not the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode != NULL && current->nextNode != NULL) {
        printf("testList: ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList: ListAdd(), head and tail preference:\n passed!\n");
    }
    if (*((int*)current->dataType) != 1) {
        printf("testList: (1st) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: (1st) dataType return correct.\n passed!\n");
    }
   

    result = ListAdd(testList, &n1);
    current = testList->currentItem;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: (2nd) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 2nd item return:\n passed!\n");
    }
    if (head == tail) {
        printf("testList (2nd): ListAdd(), head and tail are the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList (2nd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (2nd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 2) {
        printf("testList: (2nd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: (2nd) dataType return correct.\n passed!\n");
    }

    result = ListAdd(testList1, &n2);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: (1st) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 1st item return:\n passed!\n");
    }
    if (head != tail) {
        printf("testList1 (1st): ListAdd(), head and tail not the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode != NULL && current->nextNode != NULL) {
        printf("testList1 (1st): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (1st): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 3) {
        printf("testList1: (1st) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: (1st) dataType return correct.\n passed!\n");
    }

    result = ListAdd(testList1, &n3);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: (2nd) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 2nd item return:\n passed!\n");
    }
    if (head == tail) {
        printf("testList1 (2nd): ListAdd(), head and tail are the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList1 (2nd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (2nd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 4) {
        printf("testList1: (2nd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: (2nd) dataType return correct.\n passed!\n");
    } 

    result = ListAdd(testList1, &n4);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: (3rd) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 3rd item return:\n passed!\n");
    }
    if (head == tail) {
        printf("testList1 (3rd): ListAdd(), head and tail are the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList1 (3rd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (3rd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 5) {
        printf("testList1: (3rd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: (3rd) dataType return correct.\n passed!\n");
    }
    
    /*
    * Attempting to make error occur here: 
    * when Node is out of memory
    */
    /*
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
    */

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
    * Testing ListRemove(LIST *)
    */
    
    /*
    * Test when the current item is at head
    */
    ListFirst(testList1);
    current = testList1->currentItem;
    next = current->nextNode;
    resultPointer = ListRemove(testList1);
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (current == NULL) {
        printf("testList1: ListRemove(), current return NULL\n");
        printf(" Not passed!\n");
    } 
    else {
        printf("testList1: ListRemove(), current return correct\n");
        printf(" passed!\n");
    }
    if (*((int*)resultPointer) != 3) {
        printf("testList1: ListRemove(), return wrong item's data\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), return correct data\n");
        printf(" passed!\n");
    }
    if (testList1->currentItem != head) {
        printf("testList1: ListRemove(), current supposed at head\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), current at head\n");
        printf(" passed!\n");
    }
    if (testList1->totalItem != 2) {
        printf("testList1: ListRemove(), totalItem greater/lower actual\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), total item return\n");
        printf(" passed!\n");
    }
    if (head->prevNode != NULL || head->nextNode == NULL) {
        printf("testList1: ListRemove(), head node preference wrong\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), new head preference\n");
        printf(" passed!\n");
    }
    if (*((int*)head->dataType) != *((int*)next->dataType)) {
        printf("testList1: ListRemove(), head data is not as planned\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), head data return\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList1: ListRemove(), new head same as tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), successfully acquire new head\n");
        printf(" passed!\n");
    }

    ListLast(testList1);
    current = testList1->currentItem;
    prev = current->prevNode;
    resultPointer = ListRemove(testList1);
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (current == NULL) {
        printf("testList1 (2nd): ListRemove(), current return NULL\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1 (2nd): ListRemove(), current return correct\n");
        printf(" passed!\n");
    }
    if (*((int*)resultPointer) != 5) {
        printf("testList1 (2nd): ListRemove(), return wrong item's data\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1 (2nd): ListRemove(), return correct data\n");
        printf(" passed!\n");
    }
    if (testList1->currentItem != tail) {
        printf("testList1: ListRemove(), new current supposed at tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), current at tail\n");
        printf(" passed!\n");
    }
    if (testList1->totalItem != 1) {
        printf("testList1: (2nd) ListRemove(), totalItem return wrong\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), total item return\n");
        printf(" passed!\n");
    }
    if (tail->prevNode != NULL || tail->nextNode != NULL) {
        printf("testList1 (2nd): ListRemove(), tail node preference wrong\n");
        printf(" Not passed!\n"); 
    }
    else {
        printf("testList1: ListRemove(), new tail preference\n");
        printf(" passed!\n");
    }
    if (*((int*)tail->dataType) != *((int*)prev->dataType)) {
        printf("testList1: ListRemove(), tail data is not as planned\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), tail data return\n");
        printf(" passed!\n");
    }
    if (head != tail) {
        printf("testList1: ListRemove(), new tail not same as head\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove(), successfully acquire new tail\n");
        printf(" passed!\n");
    }
    /*
    * Testing ListAppend(LIST*, void*)
    */
    result = ListAppend(testList2, &a);
    current = testList2->currentItem;
    head = testList2->headPointer;
    tail = testList2->tailPointer;
    if (result == -1) {
        printf("testList2: (1st) ListAppend() return -1 for 'char':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: ListAppend() adding 1st item 'char':\n passed!\n");
    }
    if (head != tail) {
        printf("testList2 (1st): ListAppend(), head and tail not the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode != NULL || current->nextNode != NULL) {
        printf("testList2 (1st): ListAppend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList2 (1st): Listppend(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((char*)current->dataType) != 'a') {
        printf("testList2: (1st) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList2: (1st) dataType return correct.\n passed!\n");
    }

    result = ListAppend(testList2, &b);
    current = testList2->currentItem;
    head = testList2->headPointer;
    tail = testList2->tailPointer;
    if (result == -1) {
        printf("testList2: (2nd) ListAppend() return -1 for 'char':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: ListAppend() adding 2nd item 'char':\n passed!\n");
    }
    if (head == tail) {
        printf("testList2 (2nd): ListAppend(), head and tail are the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList2 (2nd): ListAppend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList2 (2nd): Listppend(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((char*)current->dataType) != 'b') {
        printf("testList2: (2nd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList2: (2nd) dataType return correct.\n passed!\n");
    }

    ListFirst(testList2);
    result = ListAppend(testList2, &c);
    current = testList2->currentItem;
    head = testList2->headPointer;
    tail = testList2->tailPointer;
    if (result == -1) {
        printf("testList2: (3rd) ListAppend() return -1 for 'char':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: ListAppend() adding 3rd item 'char':\n passed!\n");
    }
    if (head == tail) {
        printf("testList2 (3rd): ListAppend(), head and tail are the same\n");
        printf(" Not passed\n");
    } else if (current->prevNode != head || current->nextNode != tail) {
        printf("testList2 (3rd): ListAppend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList2 (3rd): Listppend(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((char*)current->dataType) != 'c') {
        printf("testList2: (3rd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList2: (3rd) dataType return correct.\n passed!\n");
    }
    if (head->nextNode != current && tail->prevNode != current) {
        printf("testList2: (3rd) head and tail preference for new item\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: (3rd) head and tail preference for new item\n");
        printf(" passed!\n");
    }
    
    /*
    * Testing ListPrepend(LIST*, void*)
    */
    current = testList1->currentItem;
    next = current->nextNode;
    result = ListPrepend(testList2, &d);
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList2: (4th) ListPrepend() return -1 for 'char':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: ListPrepend() adding 4th item 'char':\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList2 (4th): ListPrepend(), head and tail are the same\n");
        printf(" Not passed\n");
    } else if (testList2->currentItem == head || 
            testList2->currentItem == tail) {
        printf("testList2 (4th): ListPrepend(),current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList2 (4th): ListPrepend(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (*((char*)current->dataType) != 'd') {
        printf("testList2: (4th) ListPrepend() dataType return different.\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: (4th) ListPrepend() dataType return correct.\n");
        printf(" passed!\n");
    }
    if (head->nextNode != current || tail->prevNode == current) {
        printf("testList2: (4th) head and tail preference for new item\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList2: (4th) head and tail preference for new item\n");
        printf(" passed!\n");
    }
    
    return EXIT_SUCCESS;

}
