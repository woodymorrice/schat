/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <square.h>

#ifdef WINTHR
#include <Windows.h>
#endif

#ifdef UBCTHR
#include <standards.h>
#include <os.h>
#endif

#ifdef POSTHR
#endif

#ifdef UNITHR
#endif

extern struct htEntry hTable[];

int square(int n) {
    unsigned long int id;
    /* struct htEntry curThr; */
    int index;

    #ifdef WINTHR
    id = GetCurrentThreadId();
    #endif
    #ifdef UBCTHR
    id = (unsigned) MyPid();
    #endif
    /* printf("%ld\n", id); */
    /* printf("%ld\n", curThr.entryId); */
    /* curThr = hSearch(id);
    
    curThr.sqCalls += 1; */
    index = hSearch(id);
    /* printf("%ld\n", hTable[index].entryId); */
    hTable[index].sqCalls += 1;

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
    while (hTable[index].entryId != 0) {
        index += (id % 13) + 1;
    }
    return index;
}
/*
int hInsert(struct htEntry item) {
    int index;
    index = hashFunc(item->
    return EXIT_SUCCESS;
}
*/
/*struct htEntry hSearch(unsigned long int id) {
    int index;
    
    index = (int)(id % HT_SIZE);
    while (hTable[index].entryId != id) {
        index += (id % 13) + 1;
    }
    return hTable[index];
}*/

int hSearch(unsigned long int id) {
    int index;
    
    index = (int)(id % HT_SIZE);
    while (hTable[index].entryId != id) {
        index += (id % 13) + 1;
    }
    return index;
}


