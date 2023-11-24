/* Physical memory allocator, for user processes, */
/* kernel stacks, page-table pages, */
/* and pipe buffers. Allocates whole 4096-byte pages. */

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"
/* Begin CMPT 332 group14 change Fall 2023 */
/* Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* page size in bits for bit shifting instead of division */
#define PGSZNBITS 12
/* the number of physical pages */ 
#define NPAGES ((PHYSTOP - KERNBASE) >> PGSZNBITS)
/* the index into the reference count table for the given page p */
#define RCIND(p) ((p - KERNBASE) >> PGSZNBITS)
/* End CMPT 332 group14 change Fall 2023 */

void freerange(void *pa_start, void *pa_end);

extern char end[]; /* first address after kernel. */
                   /* defined by kernel.ld. */

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  /* Begin CMPT 332 group14 change Fall 2023 */
  int refcnt[NPAGES];
  int freecnt;
  /* End CMPT 332 group14 change Fall 2023 */
} kmem;

void
kinit()
{
  /* Begin CMPT 332 group14 change Fall 2023 */
  kmem.freecnt = 0; /* don't need lock here */
  /* End CMPT 332 group14 change Fall 2023 */
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  /* Begin CMPT 332 group14 change Fall 2023 */
  int index; 
  /* End CMPT 332 group14 change Fall 2023 */
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    /* Begin CMPT 332 group14 change Fall 2023 */
    /* initialize all refcounts to 0 while the allocator
     * is being initialized */
    index = RCIND((uint64)p);
    kmem. refcnt [index] = 0;
    /* End CMPT 332 group14 change Fall 2023 */
    kfree(p);
  }
}

/* Free the page of physical memory pointed at by pa, */
/* which normally should have been returned by a */
/* call to kalloc().  (The exception is when */
/* initializing the allocator; see kinit above.) */
void
kfree(void *pa)
{
  struct run *r;
  /* Begin CMPT 332 group14 change Fall 2023 */
  int index;

  index = RCIND((uint64)pa);
  /* End CMPT 332 group14 change Fall 2023 */

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
  kmem.refcnt[index]--;
  /* Begin CMPT 332 group14 change Fall 2023 */
  if (kmem.refcnt[index] < 1) {
    /* Fill with junk to catch dangling refs. */
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;
    r->next = kmem.freelist;
    kmem.freelist = r; 

    kmem.freecnt++;
  }
  /* End CMPT 332 group14 change Fall 2023 */
  release(&kmem.lock);
}

/* Allocate one 4096-byte page of physical memory. */
/* Returns a pointer that the kernel can use. */
/* Returns 0 if the memory cannot be allocated. */
void *
kalloc(void)
{
  struct run *r;
  /* Begin CMPT 332 group14 change Fall 2023 */
  int index;
  /* End CMPT 332 group14 change Fall 2023 */

  acquire(&kmem.lock);
  r = kmem.freelist;
  /* Begin CMPT 332 group14 change Fall 2023 */
  index = RCIND((uint64)r);
  if(r)
    kmem.freelist = r->next;
  kmem.refcnt[index] = 1;

  kmem.freecnt--;
  /* End CMPT 332 group14 change Fall 2023 */
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); /* fill with junk */
  return (void*)r;
}

/* Begin CMPT 332 group14 change Fall 2023 */
int
nfree(void)
{
  return kmem.freecnt;
}

void
ref_inc(void *p)
{
  int index;
  index = RCIND((uint64)p);
  acquire(&kmem.lock);
  kmem.refcnt[index]++;
  release(&kmem.lock);
}

void
ref_dec(void *p)
{
  int index;
  index = RCIND((uint64)p);
  acquire(&kmem.lock);
  kmem.refcnt[index]--;
  release(&kmem.lock);
}

int
ref_cnt(void *p)
{
  int index;
  index = RCIND((uint64)p);
  return kmem.refcnt[index];
}
/* End CMPT 332 group14 change Fall 2023 */
