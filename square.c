/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <square.h>

extern struct thrInfo thrArr[NUMTHRDS];

int square(int n) {
    unsigned long int id;
    int index;

    id = getThrId();
    
    for (index = 0; index < (NUMTHRDS - 1) &&
            id != thrArr[index].entryId; index++);

    thrArr[index].sqCalls += 1;

    if (n == 0) {
        return 0;
    } else {
        return (square(n-1) + n + n-1);
    }
}

