/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdlib.h>

#include <htable.h>

#define HT_SIZE 64

int hashFunc(unsigned long int id) {
    int index;

    index = (int) id % HT_SIZE;

    return index;
}

int hInsert(struct htEntry item) {
    return EXIT_SUCCESS;
}
/*
struct htEntry hSearch(unsigned long int id) {
    return NULL;
}
*/
