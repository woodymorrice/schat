/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#ifndef _SQUARE_H_
#define _SQUARE_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <time.h>

#define HT_SIZE 128

struct htEntry {
    unsigned long int entryId;
    unsigned long int beginTime;
    unsigned int sqCalls;
};

int square(int n);

int hashIn(unsigned long int id);

int hFind(unsigned long int id);

unsigned long int getThrId();

#endif

