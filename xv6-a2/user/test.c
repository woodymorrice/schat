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
    printf("Producing items in BUFFER\n");
    itemProd = 1;
    while (itemCons == itemProd) thread_yield();
    
    for (i = 0; i < 10; i++) {
        printf("produced item: %d\n", i);
        itemProd ++;
        thread_yield();
    }
    thread_schedule();
}


void consumer () {
    int i;
    printf("Consuming BUFFER\n");
    while (itemProd != 0) thread_yield();
    for (i = 0; i < 10; i++) {
        printf("consumed item: %d\n", i);
        itemCons ++;
        thread_yield();
    }
    thread_schedule();
}

int tmain(int argc, char *argv[]) {
    /* We could not finish this in time. The uthread executable
     * works though! */

    /*int lock;
    lock = mtx_create(0);
    while (1) {
        mtx_lock(lock);
        thread_create(producer);
        mtx_unlock(lock);
    }
    while (1) {
        mtx_lock(lock);
        thread_create(consumer);
        mtx_unlock(lock);
    }

    itemProd = itemCons = 0;
    thread_init();
    thread_create(producer);
    thread_create(consumer);
    thread_schedule();*/
    exit(0);

}
