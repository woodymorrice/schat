#include <stdio.h>
#include <stdlib.h>

#include <list.h>


int main() {
    LIST *testList;
    testList = ListCreate();
    listPool[0] = testList;
    if (listPool[0] == NULL) {
        printf("Get to this point");
    }

    return EXIT_SUCCESS;

}
