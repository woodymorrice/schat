typedef struct LIST{
    void *headPointer;
    void *tailPointer;
    void *currentItem;
    int totalItem;
} LIST;

struct NODE{
    struct NODE *prevNode;
    struct NODE *nextNode;
    void *dataType;
};

/*
Makes a new, empty list, and returns its reference on success. Returns a NULL pointer on failure 
*/

LIST *ListCreate();

/*
Returns the number of items in list
*/

int ListCount();

/*
Returns a pointer to the first item in list and makes the first item the currentitem 
*/

void *ListFirst();

/*
Returns a pointer to the last item in list and makes the last item in the current one.
*/

void *ListLast();

/*Advances the list's current node by one and returns a pointer to the new current item. Advance the end item in list, NULL pointer returned*/

void *ListNext();

/*Backs up the list's current node by one and returns a pointer to the new current item. Back up beyond the start of list, NULL pointer returned*/

void *ListPrev();

/*Returns a pointer to the current item in list*/

void *ListCurr();

/*Adds the new item to list directly after the current item, and makes the new item the current item. At end of list, item added at the end

Return 0 on success, -1 on failure
*/

int ListAdd();

int ListInsert();

int ListAppend();

int ListPrepend();

void *ListRemove();

void ListConcat();

void ListFree();

void *ListTrim();

void *ListSearch();

