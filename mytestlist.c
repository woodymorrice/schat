#include <stdio.h>
#include <stdlib.h>

#include <list.h>
void itemFreeChar(void *itemToBeFreed) {
    char *addressChar = (char *)itemToBeFreed;
    *addressChar = '&';                                            
}

int comparator (void *item1, void *item2) {
    if (item1 == item2) {
        return 1;
    }
    return 0;
}

int main() {
    LIST *testList;
    LIST *testList1;
    LIST *testList2;
    LIST *testList3;

    int n0, n1, n2, n3, n4, n5, result;
    char a, b, c, d;
    NODE *current;
    NODE *head;
    NODE *tail;
    NODE *next;
    NODE *prev;
    NODE *resultPointer;

    n0 = 0;
    n1 = 1;
    n2 = 2;
    n3 = 3;
    n4 = 4;
    n5 = 5;
    
    a = 'a';
    b = 'b';
    c = 'c';
    d = 'd';

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

 
    testList3 = ListCreate();
    if (testList3 == NULL) {
        printf("testList3: ListCreated() not working, point to NULL\n");
    }
    else {
        printf("testList3: ListCreate():\n passed!\n");
    }

    printf("\n\nBegin testing ListAdd() when currentPointer is at tail.\n\n");

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
    }
    else {
        printf("testList: ListAdd(), head and tail preference:\n passed!\n");
    }
    if (current->prevNode != NULL && current->nextNode != NULL) {
        printf("testList: ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList: ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 0) {
        printf("testList: (1st) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: (1st) dataType return correct.\n passed!\n");
    }
    if (testList->totalItem != 1) {
        printf("testList: (1st) totalItem return different value:\n");
        printf("Return: %d items\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList: (1st) check totalItem return value:\n");
        printf(" passed!\n");
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
    }
    else {
        printf("testList (2nd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList (2nd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (2nd): ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 1) {
        printf("testList: (2nd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: (2nd) dataType return correct.\n passed!\n");
    }
    if (testList->totalItem != 2) {                                             
        printf("testList: (2nd) totalItem return different value:\n");          
        printf("Return: %d items\n", testList->totalItem);                                           
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: (2nd) check totalItem return value:\n");              
        printf(" passed!\n");                                                   
    }

    result = ListAdd(testList, &n2);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: (3rd) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList3: ListAdd() adding 3rd item return:\n passed!\n");
    }
    if (head == tail) {
        printf("testList (3rd): ListAdd(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (3rd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (current->prevNode == NULL || current->nextNode != NULL) {
        printf("testList (3rd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (3rd): ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 2) {
        printf("testList: (3rd) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: (3rd) dataType return correct.\n passed!\n");
    }
    if (testList->totalItem != 3) {                                             
        printf("testList: (3rd) totalItem return different value:\n");          
        printf("Return: %d items\n", testList->totalItem);                                           
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: (3rd) check totalItem return value:\n");              
        printf(" passed!\n");                                                   
    }

    printf("\n\nTesting ListAdd() when the currentPointer at head\n");
    printf("Or at other position, such as middle\n\n");
    
    ListFirst(testList);
    next = (testList->currentItem)->nextNode;
    result = ListAdd(testList, &n3);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: (4th) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 4th item return:\n passed!\n");
    }
    if (head == tail) {
        printf("testList (4th): ListAdd(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (4th): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (current->prevNode != head || current->nextNode != next) {
        printf("testList (4th): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (4th): ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 3) {
        printf("testList: (4th) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList: (4th) dataType return correct.\n passed!\n");
    }
    if (testList->totalItem != 4) {                                             
        printf("testList: (4th) totalItem return different value:\n");          
        printf("Return: %d items\n", testList->totalItem);                                           
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: (4th) check totalItem return value:\n");              
        printf(" passed!\n");                                                   
    } 

    prev = testList->currentItem;
    next = (testList->currentItem)->nextNode;
    result = ListAdd(testList, &n4);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: (5th) ListAdd() return -1 for 'int':\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListAdd() adding 5th item return:\n passed!\n");
    }
    if (head == tail) {
        printf("testList (5th): ListAdd(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (5th): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (current->prevNode != prev || current->nextNode != next) {
        printf("testList (5th): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (5th): ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 4) {
        printf("testList1: (5th) dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: (5th) dataType return correct.\n passed!\n");
    }
    if (testList->totalItem != 5) {                                             
        printf("testList: (5th) totalItem return different value:\n");          
        printf("Return: %d items\n", testList->totalItem);                                           
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: (5th) check totalItem return value:\n");              
        printf(" passed!\n");                                                   
    }
    
    ListFirst(testList);
    next = (testList->currentItem)->nextNode;
    result = ListAdd(testList, &n5);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {                                                         
        printf("testList: (6th) ListAdd() return -1 for 'int':\n");             
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: ListAdd() adding 6th item return:\n passed!\n");      
    }                                                                           
    if (head == tail) {                                                         
        printf("testList (6th): ListAdd(), head and tail are the same\n");      
        printf(" Not passed\n");                                                
    }                                                                           
    else {                                                                      
        printf("testList (6th): ListAdd(), head and tail preference:\n");       
        printf(" passed!\n");                                                   
    }                                                                           
    if (current->prevNode != head || current->nextNode != next) {               
        printf("testList (6th): ListAdd(), current preference is wrong\n");     
        printf(" Not passed\n");                                                
    }                                                                           
    else {                                                                      
        printf("testList (6th): ListAdd(), checking current preference:\n");    
        printf(" passed!\n");                                                   
    }                                                                           
    if (*((int*)current->dataType) != 5) {                                      
        printf("testList1: (6th) dataType return different.\n Not passed!\n");  
    }                                                                           
    else {                                                                      
        printf("testList1: (6th) dataType return correct.\n passed!\n");        
    }                                                                           
    if (testList->totalItem != 6) {                                             
        printf("testList: (6th) totalItem return different value:\n");          
        printf("Return: %d items\n", testList->totalItem);                                           
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: (6th) check totalItem return value:\n");              
        printf(" passed!\n");                                                   
    }

    printf("\n\nTesting ListRemove()\n\n");

    resultPointer = ListRemove(testList1);
    if (resultPointer != NULL) {
        printf("testList1: Removing item in empty list return wrong value\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListRemove() remove an item in empty list\n");
        printf(" passed!\n");
    }

    result = ListAdd(testList1, &a);
    current = testList1->currentItem;                                            
    head = testList1->headPointer;                                               
    tail = testList1->tailPointer;                                               
    if (result == -1) {                                                         
        printf("testList1: ListAdd() return -1 for 'char':\n Not passed!\n");     
    }                                                                           
    else {                                                                      
        printf("testList1: ListAdd() adding 1st item return:\n passed!\n");      
    }                                                                           
    if (head != tail) {                                                         
        printf("testList1: ListAdd(), head and tail not the same\n");            
        printf(" Not passed\n");                                                
    }                                                                           
    else {                                                                      
        printf("testList1: ListAdd(), head and tail preference:\n passed!\n");   
    }                                                                           
    if (current->prevNode != NULL && current->nextNode != NULL) {               
        printf("testList1: ListAdd(), current preference is wrong\n");           
        printf(" Not passed\n");                                                
    }                                                                           
    else {                                                                      
        printf("testList1: ListAdd(), checking current preference:\n");          
        printf(" passed!\n");                                                   
    }                                                                           
    if (*((char*)current->dataType) != 'a') {                                      
        printf("testList1: (1st) dataType return different.\n Not passed!\n");   
    }                                                                           
    else {                                                                      
        printf("testList1: (1st) dataType return correct.\n passed!\n");         
    }                                                                           
    if (testList1->totalItem != 1) {                                             
        printf("testList: (1st) totalItem return different value:\n");          
        printf("Return: %d items\n", testList->totalItem);                      
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList1: (1st) check totalItem return value:\n");              
        printf(" passed!\n");                                                   
    }
    
    resultPointer = ListRemove(testList1);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (current != NULL) {                                                      
        printf("testList1: ListRemove(), current after test return NULL\n");
        printf("This is for removing the list that has 1 item\n");    
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: ListRemove(), current return after remove\n"); 
        printf(" passed!\n");                                                   
    }                                                                           
    if (*((char*)resultPointer) != 'a') {                                          
        printf("testList1: ListRemove(), return wrong item's data at head\n");   
        printf("Return: %c\n ", *((char*)resultPointer));                        
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList1: ListRemove(), return correct when remove head\n");    
        printf(" passed!\n");                                                   
    }
                                                                                                                 
    if (testList1->totalItem != 0) {                                             
        printf("testList1: ListRemove(), totalItem greater/lower actual\n");    
        printf("Return: %d items\n", testList1->totalItem);                      
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList1: ListRemove(), total item return\n");                  
        printf(" passed!\n");                                                   
    }                                                                           
    if (head != NULL || tail != NULL) {                     
        printf("testList1: ListRemove(), node preference wrong\n");         
        printf(" Not passed!\n");                                               
    }                                                                           
    else {                                                                      
        printf("testList: ListRemove(), check head and tail\n");                
        printf(" passed!\n");                                                   
    }                                                                           
    
    result =  ListAdd(testList1, &b);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1: ListAdd() return -1 for 'char'\n");
        printf("Adding another item after first remove\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: ListAdd() adding 1st item return:\n");
        printf("Adding another item after first remove\n");
        printf(" passed!\n");
    }
    if (head != tail) {
        printf("testList1 (2nd): ListAdd(), head and tail not the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (2nd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (current->prevNode != NULL && current->nextNode != NULL) {
        printf("testList1 (2nd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (2nd): ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((char*)current->dataType) != 'b') {
        printf("testList1 (2nd): dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: (2nd) dataType return correct.\n passed!\n");
    }
    if (testList1->totalItem != 1) {
        printf("testList: (2nd) totalItem return different value:\n");
        printf("Return: %d items\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: (2nd) check totalItem return value:\n");
        printf(" passed!\n");
    }                                                                       
    
    result =  ListAdd(testList1, &c);
    current = testList1->currentItem;
    head = testList1->headPointer;
    tail = testList1->tailPointer;
    if (result == -1) {
        printf("testList1 (3rd): ListAdd() return -1 for 'char'\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList1 (3rd): ListAdd() adding 2nd item return:\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList1 (3rd): ListAdd(), head and tail the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (3rd): ListAdd(), head and tail preference:\n");
        printf(" passed!\n");
    }
    if (current->prevNode != head && current->nextNode != NULL) {
        printf("testList1 ((3rd): ListAdd(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList1 (3rd): ListAdd(), checking current preference:\n");
        printf(" passed!\n");
    }
    if (*((char*)current->dataType) != 'c') {
        printf("testList1 (3rd): dataType return different.\n Not passed!\n");
    }
    else {
        printf("testList1: (3rd) dataType return correct.\n passed!\n");
    }
    if (testList1->totalItem != 2) {
        printf("testList: (3rd) totalItem return different value:\n");
        printf("Return: %d items\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList1: (3rd) check totalItem return value:\n");
        printf(" passed!\n");
    }

    printf("\n\nTesting ListRemove() on testList with different scenarioes\n");
    printf("\n");
    
    ListFirst(testList);
    current = testList->currentItem;
    next = current->nextNode;
    prev = next->nextNode;
    resultPointer = ListRemove(testList);
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (current == NULL) {
        printf("testList: ListRemove(), current before test return NULL\n");
        printf(" Not passed!\n");
    } 
    else {
        printf("testList: ListRemove(), current before test return correct\n");
        printf(" passed!\n");
    }
    if (*((int*)resultPointer) != 0) {
        printf("testList: ListRemove(), return wrong item's data at head\n");
        printf("Return: %d\n ", *((int*)resultPointer));
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListRemove(), return correct when remove head\n");
        printf(" passed!\n");
    }
    if (testList->currentItem != head) {
        printf("testList: ListRemove(), current supposed at head\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListRemove(), checking new current position\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 5) {
        printf("testList1: ListRemove(), totalItem greater/lower actual\n");
        printf("Return: %d items\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListRemove(), total item return\n");
        printf(" passed!\n");
    }
    if (head->prevNode != NULL || head->nextNode != prev) {
        printf("testList: ListRemove(), head node preference wrong\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListRemove(), new head preference\n");
        printf(" passed!\n");
    }
    if (*((int*)head->dataType) != *((int*)next->dataType)) {
        printf("testList: ListRemove(), head data is not as planned\n");
        printf("Return value: %d instead of 5\n", *((int*)head->dataType));
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListRemove(), new head data return\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList: ListRemove(), new head same as tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListRemove(), successfully remove old head\n");
        printf(" passed!\n");
    }

    ListFirst(testList);
    current = testList->currentItem;
    next = current->nextNode;
    prev = next->nextNode;
    resultPointer = ListRemove(testList);
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (current == NULL) {
        printf("testList (2nd): ListRemove(), current return NULL\n");
        printf("Remove the 2nd head in the sequence\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListRemove(), current return correct\n");
        printf("Remove the 2nd head in the sequence\n");
        printf(" passed!\n");
    }
    if (*((int*)resultPointer) != 5) {
        printf("testList (2nd): ListRemove(), return wrong item's data\n");
        printf("Return value: %d\n instead of 5", *((int*)resultPointer));
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListRemove(), return correct data\n");
        printf(" passed!\n");
    }
    if (testList->currentItem != head) {
        printf("testList: ListRemove(), new current supposed at head\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListRemove(), current at head\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 4) {
        printf("testList: (2nd) ListRemove(), totalItem return wrong\n");
        printf("Return: %d instead of 4\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListRemove(), total item return\n");
        printf(" passed!\n");
    }
    if (head->prevNode != NULL || head->nextNode != prev) {
        printf("testList (2nd): ListRemove(), head node preference wrong\n");
        printf(" Not passed!\n"); 
    }
    else {
        printf("testList (2nd): ListRemove(), new head preference\n");
        printf(" passed!\n");
    }
    if (*((int*)head->dataType) != *((int*)next->dataType)) {
        printf("testList (2nd): ListRemove(), head data is not as planned\n");
        printf("Return value: %d\n", *((int*)head->dataType));
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListRemove(), new head data return\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList (2nd): ListRemove(), new head same as tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListRemove(), successfully remove head\n");
        printf(" passed!\n");
    }
 
    ListLast(testList);
    current = testList->currentItem;
    prev = current->prevNode;
    next = prev->prevNode;
    resultPointer = ListRemove(testList);
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (current == NULL) {
        printf("testList (3rd): ListRemove(), current return NULL\n");
        printf("Remove tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (3rd): ListRemove(), current return correct\n");
        printf("Remove tail\n");
        printf(" passed!\n");
    }
    if (*((int*)resultPointer) != 2) {
        printf("testList (3rd): ListRemove(), return wrong item's data\n");
        printf("Return value: %d\n instead of 2", *((int*)resultPointer));
        printf(" Not passed!\n");
    }
    else {
        printf("testList (3rd): ListRemove(), return correct data\n");
        printf(" passed!\n");
    }
    if (testList->currentItem != tail) {
        printf("testList: ListRemove(), new current supposed at tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (3rd): ListRemove(), current at tail\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 3) {
        printf("testList: (3rd) ListRemove(), totalItem return wrong\n");
        printf("Return: %d instead of 3\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList (3rd): ListRemove(), total item return\n");
        printf(" passed!\n");
    }
    if (tail->prevNode != next || tail->nextNode != NULL) {
        printf("testList (3rd): ListRemove(), tail node preference wrong\n");
        printf(" Not passed!\n"); 
    }
    else {
        printf("testList (3rd): ListRemove(), new tail preference\n");
        printf(" passed!\n");
    }
    if (*((int*)tail->dataType) != *((int*)prev->dataType)) {
        printf("testList (3rd): ListRemove(), tail data is not as planned\n");
        printf("Return value: %d\n", *((int*)tail->dataType));
        printf(" Not passed!\n");
    }
    else {
        printf("testList (3rd): ListRemove(), new tail data return\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList (3rd): ListRemove(), new head same as tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (3rd): ListRemove(), successfully remove tail\n");
        printf(" passed!\n");
    }
    
    ListLast(testList);
    current = testList->currentItem;
    prev = current->prevNode;
    next = prev->prevNode;
    resultPointer = ListRemove(testList);
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (current == NULL) {
        printf("testList (4th): ListRemove(), current return NULL\n");
        printf("Remove tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (4th): ListRemove(), current return correct\n");
        printf("Remove tail\n");
        printf(" passed!\n");
    }
    if (*((int*)resultPointer) != 1) {
        printf("testList (4th): ListRemove(), return wrong item's data\n");
        printf("Return value: %d\n instead of 1", *((int*)resultPointer));
        printf(" Not passed!\n");
    }
    else {
        printf("testList (4th): ListRemove(), return correct data\n");
        printf(" passed!\n");
    }
    if (testList->currentItem != tail) {
        printf("testList: ListRemove(), new current supposed at tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (4th): ListRemove(), current at tail\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 2) {
        printf("testList: (4th) ListRemove(), totalItem return wrong\n");
        printf("Return: %d instead of 2\n", testList->totalItem);
        printf(" Not passed!\n");
    }
    else {
        printf("testList (4th): ListRemove(), total item return\n");
        printf(" passed!\n");
    }
    if (tail->prevNode != next || tail->nextNode != NULL) {
        printf("testList (4th): ListRemove(), tail node preference wrong\n");
        printf(" Not passed!\n"); 
    }
    else {
        printf("testList (4th): ListRemove(), new tail preference\n");
        printf(" passed!\n");
    }
    if (*((int*)tail->dataType) != *((int*)prev->dataType)) {
        printf("testList (4th): ListRemove(), tail data is not as planned\n");
        printf("Return value: %d\n", *((int*)tail->dataType));
        printf(" Not passed!\n");
    }
    else {
        printf("testList (4th): ListRemove(), new tail data return\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList (4th): ListRemove(), new head same as tail\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (4th): ListRemove(), successfully remove tail\n");
        printf(" passed!\n");
    }       

    printf("\n\nTesting ListAppend() on testList\n\n");
    
    prev = testList->tailPointer;
    result = ListAppend(testList, &n0);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList: ListAppend() return -1 for 'int'\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListAppend() adding 1st item 'int'\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList: ListAppend(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList: ListAppend(), checking current head and tail\n");
        printf(" passed!\n");
    }
    if (current->prevNode != prev || current->nextNode != NULL) {
        printf("testList: ListAppend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList: ListAppend(), check current preference\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 0) {
        printf("testList: ListAppend() dataType return different.\n");
        printf("Not passed!\n");
    }
    else {
        printf("testList: ListAppend() dataType return correct.\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 3) {
        printf("testList: ListAppend() totalItem return different\n");
        printf("Return: &d item, instead of 3\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListAppend() totatlItem return correct\n");
        printf(" passed!\n");
    }
    
    prev = testList->tailPointer;
    result = ListAppend(testList, &n1);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
    if (result == -1) {
        printf("testList (2nd): ListAppend() return -1 for 'int'\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListAppend() adding 2nd item 'int'\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList (2nd): ListAppend(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (2nd): ListAppend(), checking current head and tail");
        printf("\n");
        printf(" passed!\n");
    }
    if (current->prevNode != prev || current->nextNode != NULL) {
        printf("testList (2nd): ListAppend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (2nd): ListAppend(), check current preference\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 1) {
        printf("testList (2nd): ListAppend() dataType return different.\n");
        printf("Not passed!\n");
    }
    else {
        printf("testList (2nd): ListAppend() dataType return correct.\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 4) {
        printf("testList (2nd): ListAppend() totalItem return different\n");
        printf("Return: &d item, instead of 4\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListAppend() totatlItem return correct\n");
        printf(" passed!\n");
    }     
    
    printf("\n\nTesting ListPrepend() on testList\n\n");
    ListFirst(testList);
    prev = testList->headPointer;
    result = ListPrepend(testList, &n2);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
     
    if (result == -1) {
        printf("testList: ListPrepend() return -1 for 'int'\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListPrepend() adding 1st item 'int'\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList: ListPrepend(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList: ListPrepend(), checking current head and tail\n");
        printf(" passed!\n");
    }
    if (current->prevNode != NULL || current->nextNode != prev) {
        printf("testList: ListPrepend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList: ListPrepend(), check current preference\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 2) {
        printf("testList: ListPrepend() dataType return different.\n");
        printf("Not passed!\n");
    }
    else {
        printf("testList: ListPrepend() dataType return correct.\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 5) {
        printf("testList: ListPrepend() totalItem return different\n");
        printf("Return: &d item, instead of 5\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList: ListPrepend() totatlItem return correct\n");
        printf(" passed!\n");
    } 

    
    prev = testList->headPointer;
    result = ListPrepend(testList, &n5);
    current = testList->currentItem;
    head = testList->headPointer;
    tail = testList->tailPointer;
   
    if (result == -1) {
        printf("testList (2nd): ListPrepend() return -1 for 'int'\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListPrepend() adding 2nd item 'int'\n");
        printf(" passed!\n");
    }
    if (head == tail) {
        printf("testList (2nd): ListPrepend(), head and tail are the same\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (2nd): ListPrepend(), checking current head"); 
        printf(" and tail\n");
        printf(" passed!\n");
    }
    if (current->prevNode != NULL || current->nextNode != prev) {
        printf("testList (2nd): ListPrepend(), current preference is wrong\n");
        printf(" Not passed\n");
    }
    else {
        printf("testList (2nd): ListPrepend(), check current preference\n");
        printf(" passed!\n");
    }
    if (*((int*)current->dataType) != 5) {
        printf("testList (2nd): ListPrepend() dataType return different.\n");
        printf("Not passed!\n");
    }
    else {
        printf("testList (2nd): ListPrepend() dataType return correct.\n");
        printf(" passed!\n");
    }
    if (testList->totalItem != 6) {
        printf("testList (2nd): ListPrepend() totalItem return different\n");
        printf("Return: &d item, instead of 6\n");
        printf(" Not passed!\n");
    }
    else {
        printf("testList (2nd): ListPrepend() totatlItem return correct\n");
        printf(" passed!\n");
    } 
    
    printf("\n\nTesting ListFree() on testList1\n\n");   
    ListFree(testList1, itemFreeChar);
     
    return EXIT_SUCCESS;

}
