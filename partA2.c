/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <standards.h>
#include <os.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS]; /* stores thread info */

PROCESS parentThread(void *argPtr);
PROCESS childThread(void *argPtr);
unsigned long int getThrId();

int args[NUMARGS];

int mainp(int argc, char* argv[]) {

    if (argc != 4) {
        return EXIT_FAILURE;
    } else {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    if (args[0] < 1 ||
        args[1] < 1 ||
        args[2] < 1) {
        return EXIT_FAILURE;
    }

    if (PNUL == Create((void(*)())parentThread, 16384,
                "parentThread", (void*)&args, HIGH, USR)) {
        fprintf(stderr, "Error creating parent thread\n");
    }

    return EXIT_SUCCESS;
}


PROCESS parentThread(void *argPtr) {
    int *args;
    int i;

    args = (int*)argPtr;

    printf("parent args: %d, %d, %d\n", args[0], args[1], args[2]);
    for (i = 0; i < args[0]; i++) {
        printf("index at creation: %d\n", i);
        if (PNUL == (int)(thrArr[i].entryId = 
                    Create((void(*)())childThread, 1048576,
                    "childThread", (void*)args, NORM, USR))) {
            fprintf(stderr, "Error creating child thread\n");
        }
        else {
            printf("child pid at creation: %d\n", (int)thrArr[i].entryId);
        }
    }
    
    Pexit();
}


PROCESS childThread(void *argPtr) {
    int *args;
    long unsigned int id;
    int index;
    int i;

    args = (int*)argPtr;

    id = getThrId();
    printf("pid returned in child: %d\n", (int)id);

    printf("child args: %d, %d, %d\n", args[0], args[1], args[2]);

    for (index = 0; thrArr[index].entryId != id &&
            index < args[0]; index++);

    printf("index in child: %d\n", index);

    for (i = 1; i <= args[2]; i++) {
        square(i);
    }

    printf("square calls in child %ld: %d\n", id,
            thrArr[index].sqCalls);

    Pexit();
}


unsigned long int getThrId() {
    return (unsigned)MyPid();
}
