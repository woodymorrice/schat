#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/uthread.h"

#define STKSIZE 2000
int buffer[STKSIZE];
int itemProd;
int itemCons;

void producer () {
    int i;
    int item[5] = {0, 1, 2, 3, 4}; 
    printf("Producing items in BUFFER\n");
    for (i = 0;  i < 5; i++) {
        buffer[i] = item[i];
        thread_yield();
    }
    thread_schedule();
}


void consumer () {
    int i;
    printf("Consuming BUFFER\n");
    for (i = 0; i < 5; i++) {
        thread_yield();
    }
    thread_schedule();
}

int tmain(int argc, char *argv[]) {
    int lock;
    lock = mtx_create(0);
    while (1) {
        mtx_lock(lock);
        thread_create(producer);
        mtx_unlock(lock);
    }
    while (1) {
    }

    exit(0);

}
