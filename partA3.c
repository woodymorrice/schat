/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <unistd.h>
#include <pthread.h>

#include <square.h>

struct htEntry hTable[HT_SIZE]; /* stores thread info */


void* parentThread(void *argPtr);
void childThread();
unsigned long int getThrId();


int main(int argc, char* argv[]) {
    int args[NUMARGS];          /* pass to thrds */ 
    int pThread;                /* for checking  */
    pthread_t id;
    int index;

    if (argc != 4) {
        /* fprintf(stderr,
                "Error in main: invalid number of parameters\n"); */
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

    pThread = pthread_create(&id, NULL, parentThread, (void*)&args);
    if (pThread != 0) {
        fprintf(stderr,
                "Error in main: failed to create parent thread\n");
    }
    index = hashIn(id);
    hTable[index].entryId = id;

    sleep(args[1]);

    return EXIT_SUCCESS;
}


void* parentThread(void *argPtr) {
    int *args;                  /* ptr to args[] */
    int sq;
    /* pthread_t id;
    int index; */

    args = (int*)argPtr;

    /* id = getThrId();
    index = hashIn(id);
    hTable[index].entryId = id; */
    
    sq = square(1);
    if (sq != 0) {
        printf("Square called successfully from thread\n");
    }
   
    return NULL;
}


void childThread() {
}


unsigned long int getThrId() {
    return pthread_self();
}
