#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    testList = ListCreate();
    if (testList == NULL) {
        printf("ListCreated() not working, point to NULL");
    }

    return EXIT_SUCCESS;

}
