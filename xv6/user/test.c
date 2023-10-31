#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/uthead.h"

#define STKSIZE 2000
int buffer[STKSIZE];
int itemProd;
int itemCons;

itemProd = 0;
itemCons = 0;
void producer () {
    int i;
    int item[5] = {0, 1, 2, 3, 4}; 
    printf("Producing items in BUFFER\n");
    for (i = 0,  i < 5, i++) {
        buffer[i] = item[i];
        thread_yield();
    }
    thread_schedule();
}


void consumer () {
    int i;
    printf("Consuming BUFFER\n");
    for (i = 0, i < 5, i++) {
        thread_yield();
    }
    thread_schedule();
}
int main(int argc, char *argv[]) {
    int lock;
    lock = mtx_create(0);
    while (1) {
        mutex_lock(lock);
        thread_create(producer);
        mutex_unlock(lock);
    }
    while (1) {
        mutex_
    }

}
