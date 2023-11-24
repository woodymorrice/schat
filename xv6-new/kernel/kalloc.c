/* Physical memory allocator, for user processes, */
/* kernel stacks, page-table pages, */
/* and pipe buffers. Allocates whole 4096-byte pages. */

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

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
  /* Phong Thanh Nguyen (David) - wdz468 - 11310824
   * Woody Morrice - wam553 - 11071060 */
  
  /* page ref table - indexed by relative page # */
  int refcnt[NPAGES];
  /* count of free physical pages */
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
 
  int idx;
      
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){

    /* initialize all refcounts to 1 while
     * the allocator is being initialized */
    idx = RCIND((uint64)p);
    kmem.refcnt[idx] = 1;
    
    kfree(p);
  }
  /* End CMPT 332 group14 change Fall 2023 */
}

/* Free the page of physical memory pointed at by pa, */
/* which normally should have been returned by a */
/* call to kalloc().  (The exception is when */
/* initializing the allocator; see kinit above.) */
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
  /* Begin CMPT 332 group14 change Fall 2023 */
  
  /* by default xv6 works as if each page has one
   * reference, so this call to ref_dec() accounts
   * for those existing calls to kfree() */
  ref_dec((void*)pa);
  if (ref_cnt((void*)pa) < 1) {
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
  
  int idx;

  acquire(&kmem.lock);
  r = kmem.freelist;

  idx = RCIND((uint64)r);
  kmem.refcnt[idx] = 1;

  if(r)
    kmem.freelist = r->next;

  kmem.freecnt--;

  /* End CMPT 332 group14 change Fall 2023 */
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); /* fill with junk */
  return (void*)r;
}

/* Begin CMPT 332 group14 change Fall 2023 */
/* since the follow functions all need the lock,
 * they have all been designed in such a way that
 * they can function inside AND outside pre-existing
 * critical sections */

/* returns the total number of free physical pages */
int
nfree(void)
{
  int hold;
  int cnt;

  hold = 0;

  if (!holding(&kmem.lock)){
    acquire(&kmem.lock);
    hold = 1;
  }
  cnt = kmem.freecnt;
  if (hold && holding(&kmem.lock))
    release(&kmem.lock);

  return cnt;
}

/* increments the reference count for page pa */
void
ref_inc(void *pa)
{
  int hold;
  int idx;

  hold = 0;

  idx = RCIND((uint64)pa);
  
  if (!holding(&kmem.lock)){
    acquire(&kmem.lock);
    hold = 1;
  }
  kmem.refcnt[idx]++;
  if (hold && holding(&kmem.lock))
    release(&kmem.lock);

  if (ref_cnt(pa) > 64)
    panic("ref_inc(): too many refs");
}

/* decrements the reference count for page pa */
void
ref_dec(void *pa)
{
  int hold;
  int idx;

  hold = 0;
  idx = RCIND((uint64)pa);

  if (!holding(&kmem.lock)){
    acquire(&kmem.lock);
    hold = 1;
  }
  kmem.refcnt[idx]--;
  if (hold && holding(&kmem.lock))
    release(&kmem.lock);

  if (ref_cnt(pa) < 0)
    panic("ref_dec(): negative refs");
}

/* returns the reference count for page pa */
int
ref_cnt(void *pa)
{
  int hold;
  int idx;
  int cnt;

  hold = 0;
  idx = RCIND((uint64)pa);
  if (idx > NPAGES-1 || idx < 0)
    panic("ref_cnt(): invalid index");

  if (!holding(&kmem.lock)){
    acquire(&kmem.lock);
    hold = 1;
  }
  cnt = kmem.refcnt[idx];
  if (hold && holding(&kmem.lock))
    release(&kmem.lock);

  if (cnt > 64)
    panic("ref_cnt(): too many refs");
  if (cnt < 0)
    panic("ref_cnt(): negative refs");

  return cnt;
}
/* End CMPT 332 group14 change Fall 2023 */
