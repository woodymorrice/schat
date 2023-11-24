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
#define NREFS ((PHYSTOP - KERNBASE) >> 12)
#define REFIND(p) ((p - KERNBASE) >> 12)
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
  int refcount[NREFS];
  int freecount;
/* End CMPT 332 group14 change Fall 2023 */
} kmem;

void
kinit()
{
/* Begin CMPT 332 group14 change Fall 2023 */
  kmem.freecount = 0;
/* Begin CMPT 332 group14 change Fall 2023 */

  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
/* Begin CMPT 332 group14 change Fall 2023 */
  int i;
/* Begin CMPT 332 group14 change Fall 2023 */
  char *p;

  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
/* Begin CMPT 332 group14 change Fall 2023 */
    i = REFIND((uint64)p);
    kmem.refcount[i] = 0;
/* Begin CMPT 332 group14 change Fall 2023 */

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
  index = REFIND((uint64)pa);
/* End CMPT 332 group14 change Fall 2023 */

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
/* Begin CMPT 332 group14 change Fall 2023 */
  if ((kmem.refcount[index]) < 2) {
  /* Fill with junk to catch dangling refs. */
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;
    r->next = kmem.freelist;
    kmem.freelist = r;

    kmem.freecount++;
  }
  else {
    kmem.refcount[index]--;
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
  index = REFIND((uint64)r);
  if(r)
    kmem.freelist = r->next;
  kmem.refcount[index] = 1;

  kmem.freecount--;
/* End CMPT 332 group14 change Fall 2023 */
  release(&kmem.lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); /* fill with junk */
  }
  return (void*)r;
}


/* Begin CMPT 332 group14 change Fall 2023 */
int
nfree(void)
{
  /*int n;
  struct run *p;

  n = 0;
  acquire(&kmem.lock);
  p = kmem.freelist;
  if (p != 0) {
    p = p->next;
  }
  for (;(void*)p+PGSIZE <= (void*)PHYSTOP; p += PGSIZE) {
    n++;
  } 
  release(&kmem.lock);
  return n;*/
  return kmem.freecount;
}

void
ref_inc(void *p)
{
    int index;
    index = REFIND((uint64)p);
    acquire(&kmem.lock);
    kmem.refcount[index]++; 
    release(&kmem.lock);

}

void
ref_dec(void *p)
{
    int index;
    index = REFIND((uint64)p);
    acquire(&kmem.lock);
    kmem.refcount[index]--; 
    release(&kmem.lock);
}
/* End CMPT 332 group14 change Fall 2023 */
