/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#ifndef _SQUARE_H_
#define _SQUARE_H_

#define HT_SIZE 64


struct htEntry {
    unsigned long int entryId;
    int beginTime;
    int sqCalls;
};

extern struct htEntry hTable[];

int square(int n);

int hashFunc(unsigned long int id);
/*
int hInsert(struct htEntry item);

 *struct htEntry hSearch(unsigned long int id);*/

#endif
