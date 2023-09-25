/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#ifndef _HTABLE_H_
#define _HTABLE_H_


struct htEntry {
    unsigned long int entryId = NULL;
    void sqCalls = 0;
    void beginTime = 0;
};

int hashFunc(unsigned long int id);

int hInsert(struct htEntry item);

/*struct htEntry hSearch(unsigned long int id);*/

#endif
