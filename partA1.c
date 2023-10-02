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
    keepRunning = true;

    if (argc != 4) {
        return EXIT_FAILURE;
    } else {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    if (args[0] < 1 || 64    < args[0] ||
        args[1] < 1 || 300   < args[1] ||
        args[2] < 1 || 20000 < args[2]) {
        return EXIT_FAILURE;
    }

    if (NULL == CreateThread(NULL, 16384, 
                parentThread, &args, 0, NULL)) {
        fprintf(stderr, "Error creating parent thread\n");
    }

    Sleep((1000*args[1])+2000);

    return EXIT_SUCCESS;
}


DWORD WINAPI parentThread(LPVOID lPtr) {
    int *args;                  /* ptr to args[] */
    int i;                      /* counting var  */
 
    args = (int*)lPtr;

    for (i = 0; i < args[0]; i++) {
        thrArr[i].beginTime = 0;
        thrArr[i].sqCalls = 0;
        if (NULL == CreateThread(NULL, 131072,
                    childThread, args, 0, &thrArr[i].entryId)) {
            fprintf(stderr, "Error creating child thread\n");
        }
    }

    Sleep(1000*args[1]);

    keepRunning = false;

    Sleep(2000);

    return EXIT_SUCCESS;
}


DWORD WINAPI childThread(LPVOID lPtr) {
    DWORD id;                   /* thread ID     */
    int index;                  /* hashed index  */
    int *args;                  /* ptr to args[] */
    int i;                      /* counting var  */
    unsigned long int elapsed;  /* total time    */
    
    args = (int*)lPtr;

    id = getThrId();

    for (index = 0; index < args[0] &&
            id != thrArr[index].entryId; index++);

    thrArr[index].beginTime = (unsigned)GetTickCount64();
  
    for (i = 1; i <= args[2] && keepRunning; i++) {
        square(i);
    }

    elapsed = (unsigned)GetTickCount64() - thrArr[index].beginTime;

    printf("%d square calls, %ld ms\n",
            thrArr[index].sqCalls, elapsed);
        
    return EXIT_SUCCESS;
}


unsigned long int getThrId() {
    return GetCurrentThreadId();
}

