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
void item_1(void) {
    prinf("item 1\n");
    
}
void producer () {
    int item[5] = {0, 1, 2, 3, 4};
    while (itemProd < 5) {
        
    printf("Producing items in BUFFER\n");
    itemProd ++;
    }
}

void consumer () {
    while (itemCon < itemProd) {
    printf("Consuming BUFFER\n");
    itemCon ++;
    }
}
int main(int argc, char *argv[]) {
}