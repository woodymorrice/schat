/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <windows.h>

#include <square.h>

#define NUMARGS 3 /* # of CMD line args */

struct htEntry hTable[HT_SIZE]; /* stores thread info */

bool keepRunning; /* global flag for threads */

int args[NUMARGS]; /* args always in scope */

DWORD WINAPI parentThread(LPVOID lPtr);
DWORD WINAPI childThread(LPVOID lPtr);
unsigned long int getThrId();


int main(int argc, char* argv[]) {
    HANDLE pThread;

    keepRunning = true;

    if (argc != 4) {
        fprintf(stderr,
                "Fatal error in main(): invalid number of parameters\n");
        return EXIT_FAILURE;
    } else {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    pThread = CreateThread(NULL, 0, parentThread, args, 0, NULL);
    if (pThread == NULL) {
        fprintf(stderr,
                "Error in main: failed to create parent thread\n");
    }

    Sleep(1000*args[1]+1000);
    return EXIT_SUCCESS;
}


DWORD WINAPI parentThread(LPVOID lPtr) {
    int *args;
    int i;
    DWORD id;
    int index;
    HANDLE cThread;
 
    args = (int*)lPtr;

    if (args[0] < 0) {
        printf("Error in parentThread: invalid parameter 'threads'\n");
    }
    
    if (args[1] < 0) {
        printf("Error in parentThread: invalid parameter 'deadline'\n");
    }

    for (i = 0; i < args[0]; i++) {
        cThread = CreateThread(NULL, 0, childThread, args, 0, &id);
        if (cThread == NULL) {
            fprintf(stderr, "Error in parentThread: failed to create child thread\n");
        index = hashFunc(id);
        hTable[index].entryId = id;
        hTable[index].beginTime = 0;
        hTable[index].sqCalls = 0;
        }
    }

    Sleep(1000*args[1]);

    keepRunning = false;

    return EXIT_SUCCESS;
}


DWORD WINAPI childThread(LPVOID lPtr) {
    int i;              /* counting var  */
    DWORD id;           /* thread ID     */
    int index;
    ULONGLONG elapsed;  /* time running  */
    int *args;          /* ptr to args[] */

    id = GetCurrentThreadId();
    index = hashFunc(id);
    hTable[index].entryId = id;
    hTable[index].beginTime = GetTickCount64();
    hTable[index].sqCalls = 0;

    args = (int*)lPtr;
  
    if (args[2] < 0) {
        printf("Error in procedure parentThread: invalid parameter size\n");
    }
    
    for (i = 1; i <= args[2] && keepRunning; i++) {
        square(i);
    }

    elapsed = GetTickCount64() - hTable[index].beginTime;

    printf("Thread %ld\n", hTable[index].entryId);
    printf("Square Calls: %d\n", hTable[index].sqCalls);
    printf("Elapsed: %d ms\n", (unsigned)elapsed);
        
    return EXIT_SUCCESS;
}


unsigned long int getThrId() {
    return EXIT_SUCCESS;
}

