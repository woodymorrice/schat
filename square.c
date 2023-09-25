/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <square.h>

extern struct htEntry hTable[];


int square(int n) {
    unsigned long int id;
    int index;

    id = getThrId();
    index = hFind(id);
    hTable[index].sqCalls += 1;

    if (n < 0) {
        fprintf(stderr,
                "Error in square: invalid parameter 'size'\n");
    }

    if (n == 0) {
        return 0;
    } else {
        return (square(n-1) + n + n-1);
    }
}


int hashIn(unsigned long int id) {
    int index;

    index = (int)(id % HT_SIZE);
    while (hTable[index].entryId != 0) {
        index += (id % 13) + 1;
        index = index % HT_SIZE;
    }
    return index;
}


int hFind(unsigned long int id) {
    int index;
    
    index = (int)(id % HT_SIZE);
    while (hTable[index].entryId != id) {
        index += (id % 13) + 1;
        index = index % HT_SIZE;
    }
    return index;
}

