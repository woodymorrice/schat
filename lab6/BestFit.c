#include <stdio.h>
#include <rtthreads.h>
#include <RttCommon.h>

#include <BestFitMonitor.h>

#define SLEEP 20
#define STKSIZE 65536

RTTHREAD allocater(void *arg) {
    long myId;
    myId = (long) arg;

    for(;;) {
        printf("%ld start allocate\n", myId);
        Allocate();
        printf("%ld Allocating\n", myId);
        RttSleep((int) (rand() % SLEEPMAX));
    }
    
}


int mainp() {

}
