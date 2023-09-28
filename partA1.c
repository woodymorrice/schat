/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <windows.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS];

bool keepRunning; /* global flag for threads */

DWORD WINAPI parentThread(LPVOID lPtr);
DWORD WINAPI childThread(LPVOID lPtr);
unsigned long int getThrId();

int args[NUMARGS];

int main(int argc, char* argv[]) { 
    HANDLE pThread;             /* for checking  */
    keepRunning = true;

    if (argc != 4) {
        fprintf(stderr,
                "Error in main: invalid number of parameters\n");
        return EXIT_FAILURE;
    } else {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    if (args[0] < 1 ||
        args[1] < 1 ||
        args[2] < 1 || args[2] > 32768) {
        return EXIT_FAILURE;
    }

    pThread = CreateThread(NULL, 16384, parentThread, args, 0, NULL);
    if (pThread == NULL) {
        fprintf(stderr,
                "Error in main: failed to create parent thread\n");
    }

    return EXIT_SUCCESS;
}


DWORD WINAPI parentThread(LPVOID lPtr) {
    int *args;                  /* ptr to args[] */
    int i;                      /* counting var  */
    HANDLE cThread;             /* for checking  */
    DWORD id;                   /* thread ID     */
    int index;                  /* hashed index  */
 
    args = (int*)lPtr;

    for (i = 0; i < args[0]; i++) {
        cThread = CreateThread(NULL, 2097152, childThread, args, 0, &id);
        if (cThread == NULL) {
            fprintf(stderr,
                "Error in parentThread: failed to create child thread\n");
        }
        thrArr[i].entryId = id;
        thrArr[i].beginTime = GetTickCount64();
        thrArr[i].sqCalls = 0;
    }

    Sleep(1000*args[1]);

    keepRunning = false;

    return EXIT_SUCCESS;
}


DWORD WINAPI childThread(LPVOID lPtr) {
    DWORD id;                   /* thread ID     */
    int index;                  /* hashed index  */
    int *args;                  /* ptr to args[] */
    int i;                      /* counting var  */
    unsigned long int elapsed;  /* total time    */
    
    id = getThrId();

    for (index = 0; index < (HT_SIZE - 1) &&
            id != thrArr[index].entryId; i++);

    args = (int*)lPtr;
  
    for (i = 1; i <= args[2] && keepRunning; i++) {
        square(i);
    }

    elapsed = GetTickCount64() - thrArr[index].beginTime;

    printf("%d square calls, %d ms\n",
            thrArr[index].sqCalls, (unsigned) elapsed);
        
    return EXIT_SUCCESS;
}


unsigned long int getThrId() {
    return GetCurrentThreadId();
}

