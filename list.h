
/*
CMPT332 - Group 14
Phong Thanh Nguyen (David) - wdz468 - 11310824
Woody Morrice - wam553 - 11071060
*/

typedef struct {
    struct NODE *headPointer;
    struct NODE *tailPointer;
    struct NODE *currentItem;
    int totalItem;
} LIST;

typedef struct NODE{
    struct NODE *prevNode;
    struct NODE *nextNode;
    void *dataType;
} NODE;

#define LIST_POOL_SIZE 50
#define NODE_POOL_SIZE 50

extern LIST listPool[LIST_POOL_SIZE];
extern struct NODE nodePool[NODE_POOL_SIZE];

/*
A list pointer which points to the available spot in list pool
*/
extern LIST *openList; 

/*
A node pointer which points to the available spot in node pool
*/
extern NODE *openNode;

extern size_t memorySize;
/*
Makes a new, empty list, and returns its reference on success. Returns a NULL pointer on failure 
*/

LIST *ListCreate();

/*
Returns the number of items in list
*/

int ListCount(LIST*);

/*
Returns a pointer to the first item in list and makes the first item the currentitem 
*/

void *ListFirst(LIST*);

/*
Returns a pointer to the last item in list and makes the last item in the current one.
*/

void *ListLast(LIST*);

/*Advances the list's current node by one and returns a pointer to the new current item. Advance the end item in list, NULL pointer returned*/

void *ListNext(LIST*);

/*Backs up the list's current node by one and returns a pointer to the new current item. Back up beyond the start of list, NULL pointer returned*/

void *ListPrev(LIST*);

/*Returns a pointer to the current item in list*/

void *ListCurr(LIST*);

/*Adds the new item to list directly after the current item, and makes the new item the current item. At end of list, item added at the end

Return 0 on success, -1 on failure
*/

int ListAdd(LIST*, void*);

/*
Adds item to list directly before the current item, and makes the new item the current one. If the current pointer is at the start of the list, the itemis added at the start.  Returns 0 on success, -1 on failure.
*/

int ListInsert(LIST*, void*);

/*
Adds item to the end of list, and makes the new item the current one. Returns 0 on success, -1 on failure
*/

int ListAppend(LIST*, void*);

/*
Adds item to the front of list, and makes the new item the current one. Returns 0 on success, -1 on failure
*/

int ListPrepend(LIST*, void*);

/*
Return current item and take it out of list. Make the next item the current one
*/

void *ListRemove(LIST*);

/*
Adds list2 to the end of list1. The current pointer is set to the current pointer of list1. List2 no longer exists after the operation.
*/

void ListConcat(LIST*, LIST*);

/*
Delete list. itemFree is a pointer to a routine that frees an item. It should be invoked (within ListFree) as: (*itemFree)(itemToBeFreed);
*/

void ListFree(LIST*, void (*) (void*));

/*
Return last item and take it out of list. The current pointer shall be the new last item in the list.
*/

void *ListTrim(LIST*);

/*
Searches list starting at the current item until the end is reached or a match is found. In this context, a match is determined by the comparator parameter. This parameter is a pointer to a routine that takes as its first argument an item pointer, and as its second argument comparisonArg. Comparator returns 0 if the item and comparisonArg don't match (i.e. didn't find it), or 1 if they do (i.e. found it). Exactly what constitutes a match is up to the implementor of comparator. If a match is found, the current pointer is left at the matched item and the pointer to that item is returned. If no match is found, the current pointer is left at the end of the list and a NULL pointer is returned. 
*/

void *ListSearch(LIST*, int (*)(void*, void*), void*);

