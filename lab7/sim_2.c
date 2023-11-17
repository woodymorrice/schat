/*
Identification:

Author: Jarrod Pas
Modified by students:  First Last 
		abc123
		11111111
 */

/* Note: code intentionally not commented */

/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 */



#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <math.h>
#include <unistd.h>

struct page {
    int number; /* number == -1 means unused */
    bool reference;
    bool dirty;
};

int npages;
int next_slot;
int nslots;
struct page *slots;
int diff; 

/* Handles a page fault via the second-chance algorithm.
 * Returns the pointer to the slot the victim is in. */
struct page *find_victim_slot() {
    /* TODO: implement second chance page replacement algorithm */
    bool notFindIt = true;
    struct page *pageFinded;
    int reset = next_slot;
    if (reset == nslots) {
        next_slot = next_slot - diff;
    }
    else {
        next_slot = next_slot;
    }
    while (notFindIt) {
        if ((slots + next_slot)->reference == false && 
            (slots + next_slot)->dirty == false) {
                pageFinded = (slots + next_slot);
                if (next_slot == nslots - 1) {
                    diff = nslots;
                }
                else if (next_slot == 0){
                    diff = nslots - 1;
                }
                else {
                    diff = nslots - (next_slot + 1);
                }
                notFindIt = false;
            }
        else {
            if ((slots + next_slot)->reference == true && 
                (slots + next_slot)->dirty == true) {
                (slots + next_slot)->reference=false;
            }
            else {
                (slots + next_slot)->reference=false;
                (slots + next_slot)->dirty=false;
                
            }
            next_slot = (next_slot + 1) % nslots; 
        }
    }
    if (reset == nslots) {
        next_slot = nslots;
    }
    return pageFinded;
    /*return slots + (rand() % nslots);*/
}

int main(int argc, char **argv) {
    int times;
    int page;
    bool fault;
    bool write;
    struct page *p;

    if (argc != 3 && argc != 4) {
        printf("usage: %s npages nslots <times>\n", argv[0]);
        exit(1);
    }

    npages = atoi(argv[1]);
    if (npages <= 0) {
        printf("npages must be greater than 0\n");
        exit(1);
    }

    nslots = atoi(argv[2]);
    if (nslots <= 0) {
        printf("nslots must be greater than 0\n");
        exit(1);
    }
    next_slot = 0;
    slots = malloc(sizeof(struct page) * nslots);
    if (argc == 4) {
        times = atoi(argv[3]);
        if (times <= 0) {
            printf("times must be greater than 0.\n");
            exit(1);
        }
    } else {
        times = -1;
    }

    for (p = slots; p < &slots[nslots]; p++) {
        p->number = -1;
        p->reference = false;
        p->dirty = false;
    }

    while (times < 0 || times-- > 0) {
        page = npages * sqrt((double) rand() / RAND_MAX);
        write = rand() % 2;

        if (write) {
            printf("RW on page %d.", page);
        } else {
            printf("R  on page %d.", page);
        }

        fault = true;
        for (p = slots; p < &slots[nslots]; p++) {
            if (p->number != page) continue;
            p->reference = true;
            p->dirty |= write;
            fault = false;
            break;
        }

        if (fault) {
            printf(" This triggered a page fault.");
            p = find_victim_slot();
            if (next_slot < nslots) {
                printf(" There was a free slot!");
                p = slots + next_slot++;
                /*if(next_slot == nslots){
                    next_slot = 0;
                    hasFreeSlot = false;
                }*/
            } else {
                printf(" The chosen victim was page %d.", p->number);
            }
            p->number = page;
            p->reference = true;
            p->dirty = write;
        }

        if (times < 0) usleep(100 * 1000);

        putchar('\n');
    }

    return 0;
}

