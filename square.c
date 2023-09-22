/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <stdlib.h>

#include <square.h>


int square(int n) {
    unsigned long int id;

    #ifdef WINTHR
    #endif

    #ifdef UBCTHR
    #endif

    #ifdef POSTHR
    id = (unsigned) MyPid();
    #endif

    #ifdef UNITHR
    #endif


    if (n < 0) {
        printf("Error in procedure square(): invalid parameter n\n");
    }

    if (n == 0) {
        return 0;
    } else {
        return (square(n-1) + n + n-1);
    }

}


int hashFunc(unsigned long int id) {
    int index;

    index = (int)(id % HT_SIZE);

    return index;
}
/*
int hInsert(struct htEntry item) {
    int index;
    index = hashFunc(item->
    return EXIT_SUCCESS;
}

struct htEntry hSearch(unsigned long int id) {
    return NULL;
*/

