
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	fe010113          	add	sp,sp,-32 # 80019fe0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	790050ef          	jal	800057a6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
/* which normally should have been returned by a */
/* call to kalloc().  (The exception is when */
/* initializing the allocator; see kinit above.) */
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	0b078793          	add	a5,a5,176 # 800220e0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  /* Fill with junk to catch dangling refs. */
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a2090913          	add	s2,s2,-1504 # 80008a70 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	134080e7          	jalr	308(ra) # 8000618e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1d4080e7          	jalr	468(ra) # 80006242 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	add	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	bcc080e7          	jalr	-1076(ra) # 80005c56 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	add	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	98250513          	add	a0,a0,-1662 # 80008a70 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	008080e7          	jalr	8(ra) # 800060fe <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	fde50513          	add	a0,a0,-34 # 800220e0 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
/* Allocate one 4096-byte page of physical memory. */
/* Returns a pointer that the kernel can use. */
/* Returns 0 if the memory cannot be allocated. */
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	94c48493          	add	s1,s1,-1716 # 80008a70 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	060080e7          	jalr	96(ra) # 8000618e <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	93450513          	add	a0,a0,-1740 # 80008a70 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	0fc080e7          	jalr	252(ra) # 80006242 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); /* fill with junk */
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	90850513          	add	a0,a0,-1784 # 80008a70 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	0d2080e7          	jalr	210(ra) # 80006242 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	add	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	sll	a2,a2,0x20
    80000186:	9201                	srl	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	add	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	add	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	add	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	sll	a3,a3,0x20
    800001aa:	9281                	srl	a3,a3,0x20
    800001ac:	0685                	add	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	add	a0,a0,1
    800001be:	0585                	add	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	add	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	add	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	sll	a2,a2,0x20
    800001e4:	9201                	srl	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	add	a1,a1,1
    800001ee:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcf21>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	add	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	sll	a3,a2,0x20
    80000206:	9281                	srl	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addw	a5,a2,-1
    80000216:	1782                	sll	a5,a5,0x20
    80000218:	9381                	srl	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	add	a4,a4,-1
    80000222:	16fd                	add	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

/* memcpy exists to placate GCC.  Use memmove. */
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	add	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	add	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addw	a2,a2,-1
    80000262:	0505                	add	a0,a0,1
    80000264:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	add	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	add	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	add	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	add	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	add	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	add	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

/* Like strncpy but guaranteed to NUL-terminate. */
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	add	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addw	a3,a2,-1
    800002d0:	1682                	sll	a3,a3,0x20
    800002d2:	9281                	srl	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	add	a1,a1,1
    800002de:	0785                	add	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	add	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	add	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	add	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	add	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	add	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

/* start() jumps here in supervisor mode on all CPUs. */
void
main()
{
    8000031e:	1141                	add	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b58080e7          	jalr	-1192(ra) # 80000e7e <cpuid>
    virtio_disk_init(); /* emulated hard disk */
    userinit();      /* first user process */
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	71270713          	add	a4,a4,1810 # 80008a40 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	b3c080e7          	jalr	-1220(ra) # 80000e7e <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	add	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	94c080e7          	jalr	-1716(ra) # 80005ca0 <printf>
    kvminithart();    /* turn on paging */
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   /* install kernel trap vector */
    80000364:	00002097          	auipc	ra,0x2
    80000368:	812080e7          	jalr	-2030(ra) # 80001b76 <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	df4080e7          	jalr	-524(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	038080e7          	jalr	56(ra) # 800013ac <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	7ea080e7          	jalr	2026(ra) # 80005b66 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	afc080e7          	jalr	-1284(ra) # 80005e80 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	add	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	90c080e7          	jalr	-1780(ra) # 80005ca0 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	add	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	8fc080e7          	jalr	-1796(ra) # 80005ca0 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	add	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	8ec080e7          	jalr	-1812(ra) # 80005ca0 <printf>
    kinit();         /* physical page allocator */
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       /* create kernel page table */
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	34a080e7          	jalr	842(ra) # 8000070e <kvminit>
    kvminithart();   /* turn on paging */
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      /* process table */
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	9f6080e7          	jalr	-1546(ra) # 80000dca <procinit>
    trapinit();      /* trap vectors */
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	772080e7          	jalr	1906(ra) # 80001b4e <trapinit>
    trapinithart();  /* install kernel trap vector */
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	792080e7          	jalr	1938(ra) # 80001b76 <trapinithart>
    plicinit();      /* set up interrupt controller */
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d5e080e7          	jalr	-674(ra) # 8000514a <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d6c080e7          	jalr	-660(ra) # 80005160 <plicinithart>
    binit();         /* buffer cache */
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f60080e7          	jalr	-160(ra) # 8000235c <binit>
    iinit();         /* inode table */
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5fe080e7          	jalr	1534(ra) # 80002a02 <iinit>
    fileinit();      /* file table */
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	574080e7          	jalr	1396(ra) # 80003980 <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e54080e7          	jalr	-428(ra) # 80005268 <virtio_disk_init>
    userinit();      /* first user process */
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d6a080e7          	jalr	-662(ra) # 80001186 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	60f72b23          	sw	a5,1558(a4) # 80008a40 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

/* Switch h/w page table register to the kernel's page table, */
/* and enable paging. */
void
kvminithart()
{
    80000434:	1141                	add	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	add	s0,sp,16
/* flush the TLB. */
static inline void
sfence_vma()
{
  /* the zero, zero means flush all TLB entries. */
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  /* wait for any previous writes to the page table memory to finish. */
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	60a7b783          	ld	a5,1546(a5) # 80008a48 <kernel_pagetable>
    80000446:	83b1                	srl	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	sll	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  /* flush stale entries from the TLB. */
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	add	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
/*   21..29 -- 9 bits of level-1 index. */
/*   12..20 -- 9 bits of level-0 index. */
/*    0..11 -- 12 bits of byte offset within the page. */
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	add	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	add	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srl	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	add	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	7cc080e7          	jalr	1996(ra) # 80005c56 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srl	a5,s1,0xc
    800004b2:	07aa                	sll	a5,a5,0xa
    800004b4:	0017e793          	or	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcf17>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	and	s2,s2,511
    800004ca:	090e                	sll	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	and	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srl	s1,s1,0xa
    800004da:	04b2                	sll	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srl	a0,s3,0xc
    800004e2:	1ff57513          	and	a0,a0,511
    800004e6:	050e                	sll	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	add	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srl	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	add	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	and	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	add	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srl	a5,a5,0xa
    8000053a:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
/* va and size MUST be page-aligned. */
/* Returns 0 on success, -1 if walk() couldn't */
/* allocate a needed page-table page. */
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	add	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000055a:	03459793          	sll	a5,a1,0x34
    8000055e:	e7b9                	bnez	a5,800005ac <mappages+0x68>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000564:	03461793          	sll	a5,a2,0x34
    80000568:	ebb1                	bnez	a5,800005bc <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    8000056a:	c22d                	beqz	a2,800005cc <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000056c:	77fd                	lui	a5,0xfffff
    8000056e:	963e                	add	a2,a2,a5
    80000570:	00b609b3          	add	s3,a2,a1
  a = va;
    80000574:	892e                	mv	s2,a1
    80000576:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000580:	4605                	li	a2,1
    80000582:	85ca                	mv	a1,s2
    80000584:	8556                	mv	a0,s5
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	ed6080e7          	jalr	-298(ra) # 8000045c <walk>
    8000058e:	cd39                	beqz	a0,800005ec <mappages+0xa8>
    if(*pte & PTE_V)
    80000590:	611c                	ld	a5,0(a0)
    80000592:	8b85                	and	a5,a5,1
    80000594:	e7a1                	bnez	a5,800005dc <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000596:	80b1                	srl	s1,s1,0xc
    80000598:	04aa                	sll	s1,s1,0xa
    8000059a:	0164e4b3          	or	s1,s1,s6
    8000059e:	0014e493          	or	s1,s1,1
    800005a2:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a4:	07390063          	beq	s2,s3,80000604 <mappages+0xc0>
    a += PGSIZE;
    800005a8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005aa:	bfc9                	j	8000057c <mappages+0x38>
    panic("mappages: va not aligned");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	aac50513          	add	a0,a0,-1364 # 80008058 <etext+0x58>
    800005b4:	00005097          	auipc	ra,0x5
    800005b8:	6a2080e7          	jalr	1698(ra) # 80005c56 <panic>
    panic("mappages: size not aligned");
    800005bc:	00008517          	auipc	a0,0x8
    800005c0:	abc50513          	add	a0,a0,-1348 # 80008078 <etext+0x78>
    800005c4:	00005097          	auipc	ra,0x5
    800005c8:	692080e7          	jalr	1682(ra) # 80005c56 <panic>
    panic("mappages: size");
    800005cc:	00008517          	auipc	a0,0x8
    800005d0:	acc50513          	add	a0,a0,-1332 # 80008098 <etext+0x98>
    800005d4:	00005097          	auipc	ra,0x5
    800005d8:	682080e7          	jalr	1666(ra) # 80005c56 <panic>
      panic("mappages: remap");
    800005dc:	00008517          	auipc	a0,0x8
    800005e0:	acc50513          	add	a0,a0,-1332 # 800080a8 <etext+0xa8>
    800005e4:	00005097          	auipc	ra,0x5
    800005e8:	672080e7          	jalr	1650(ra) # 80005c56 <panic>
      return -1;
    800005ec:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ee:	60a6                	ld	ra,72(sp)
    800005f0:	6406                	ld	s0,64(sp)
    800005f2:	74e2                	ld	s1,56(sp)
    800005f4:	7942                	ld	s2,48(sp)
    800005f6:	79a2                	ld	s3,40(sp)
    800005f8:	7a02                	ld	s4,32(sp)
    800005fa:	6ae2                	ld	s5,24(sp)
    800005fc:	6b42                	ld	s6,16(sp)
    800005fe:	6ba2                	ld	s7,8(sp)
    80000600:	6161                	add	sp,sp,80
    80000602:	8082                	ret
  return 0;
    80000604:	4501                	li	a0,0
    80000606:	b7e5                	j	800005ee <mappages+0xaa>

0000000080000608 <kvmmap>:
{
    80000608:	1141                	add	sp,sp,-16
    8000060a:	e406                	sd	ra,8(sp)
    8000060c:	e022                	sd	s0,0(sp)
    8000060e:	0800                	add	s0,sp,16
    80000610:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000612:	86b2                	mv	a3,a2
    80000614:	863e                	mv	a2,a5
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	f2e080e7          	jalr	-210(ra) # 80000544 <mappages>
    8000061e:	e509                	bnez	a0,80000628 <kvmmap+0x20>
}
    80000620:	60a2                	ld	ra,8(sp)
    80000622:	6402                	ld	s0,0(sp)
    80000624:	0141                	add	sp,sp,16
    80000626:	8082                	ret
    panic("kvmmap");
    80000628:	00008517          	auipc	a0,0x8
    8000062c:	a9050513          	add	a0,a0,-1392 # 800080b8 <etext+0xb8>
    80000630:	00005097          	auipc	ra,0x5
    80000634:	626080e7          	jalr	1574(ra) # 80005c56 <panic>

0000000080000638 <kvmmake>:
{
    80000638:	1101                	add	sp,sp,-32
    8000063a:	ec06                	sd	ra,24(sp)
    8000063c:	e822                	sd	s0,16(sp)
    8000063e:	e426                	sd	s1,8(sp)
    80000640:	e04a                	sd	s2,0(sp)
    80000642:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000644:	00000097          	auipc	ra,0x0
    80000648:	ad6080e7          	jalr	-1322(ra) # 8000011a <kalloc>
    8000064c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000064e:	6605                	lui	a2,0x1
    80000650:	4581                	li	a1,0
    80000652:	00000097          	auipc	ra,0x0
    80000656:	b28080e7          	jalr	-1240(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000065a:	4719                	li	a4,6
    8000065c:	6685                	lui	a3,0x1
    8000065e:	10000637          	lui	a2,0x10000
    80000662:	100005b7          	lui	a1,0x10000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	fa0080e7          	jalr	-96(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000670:	4719                	li	a4,6
    80000672:	6685                	lui	a3,0x1
    80000674:	10001637          	lui	a2,0x10001
    80000678:	100015b7          	lui	a1,0x10001
    8000067c:	8526                	mv	a0,s1
    8000067e:	00000097          	auipc	ra,0x0
    80000682:	f8a080e7          	jalr	-118(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000686:	4719                	li	a4,6
    80000688:	004006b7          	lui	a3,0x400
    8000068c:	0c000637          	lui	a2,0xc000
    80000690:	0c0005b7          	lui	a1,0xc000
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f72080e7          	jalr	-142(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000069e:	00008917          	auipc	s2,0x8
    800006a2:	96290913          	add	s2,s2,-1694 # 80008000 <etext>
    800006a6:	4729                	li	a4,10
    800006a8:	80008697          	auipc	a3,0x80008
    800006ac:	95868693          	add	a3,a3,-1704 # 8000 <_entry-0x7fff8000>
    800006b0:	4605                	li	a2,1
    800006b2:	067e                	sll	a2,a2,0x1f
    800006b4:	85b2                	mv	a1,a2
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f50080e7          	jalr	-176(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c0:	4719                	li	a4,6
    800006c2:	46c5                	li	a3,17
    800006c4:	06ee                	sll	a3,a3,0x1b
    800006c6:	412686b3          	sub	a3,a3,s2
    800006ca:	864a                	mv	a2,s2
    800006cc:	85ca                	mv	a1,s2
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	f38080e7          	jalr	-200(ra) # 80000608 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d8:	4729                	li	a4,10
    800006da:	6685                	lui	a3,0x1
    800006dc:	00007617          	auipc	a2,0x7
    800006e0:	92460613          	add	a2,a2,-1756 # 80007000 <_trampoline>
    800006e4:	040005b7          	lui	a1,0x4000
    800006e8:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006ea:	05b2                	sll	a1,a1,0xc
    800006ec:	8526                	mv	a0,s1
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f1a080e7          	jalr	-230(ra) # 80000608 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	63c080e7          	jalr	1596(ra) # 80000d34 <proc_mapstacks>
}
    80000700:	8526                	mv	a0,s1
    80000702:	60e2                	ld	ra,24(sp)
    80000704:	6442                	ld	s0,16(sp)
    80000706:	64a2                	ld	s1,8(sp)
    80000708:	6902                	ld	s2,0(sp)
    8000070a:	6105                	add	sp,sp,32
    8000070c:	8082                	ret

000000008000070e <kvminit>:
{
    8000070e:	1141                	add	sp,sp,-16
    80000710:	e406                	sd	ra,8(sp)
    80000712:	e022                	sd	s0,0(sp)
    80000714:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	f22080e7          	jalr	-222(ra) # 80000638 <kvmmake>
    8000071e:	00008797          	auipc	a5,0x8
    80000722:	32a7b523          	sd	a0,810(a5) # 80008a48 <kernel_pagetable>
}
    80000726:	60a2                	ld	ra,8(sp)
    80000728:	6402                	ld	s0,0(sp)
    8000072a:	0141                	add	sp,sp,16
    8000072c:	8082                	ret

000000008000072e <uvmunmap>:
/* Remove npages of mappings starting from va. va must be */
/* page-aligned. The mappings must exist. */
/* Optionally free the physical memory. */
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000072e:	715d                	add	sp,sp,-80
    80000730:	e486                	sd	ra,72(sp)
    80000732:	e0a2                	sd	s0,64(sp)
    80000734:	fc26                	sd	s1,56(sp)
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000744:	03459793          	sll	a5,a1,0x34
    80000748:	e795                	bnez	a5,80000774 <uvmunmap+0x46>
    8000074a:	8a2a                	mv	s4,a0
    8000074c:	892e                	mv	s2,a1
    8000074e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	0632                	sll	a2,a2,0xc
    80000752:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000756:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	6b05                	lui	s6,0x1
    8000075a:	0735e263          	bltu	a1,s3,800007be <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000075e:	60a6                	ld	ra,72(sp)
    80000760:	6406                	ld	s0,64(sp)
    80000762:	74e2                	ld	s1,56(sp)
    80000764:	7942                	ld	s2,48(sp)
    80000766:	79a2                	ld	s3,40(sp)
    80000768:	7a02                	ld	s4,32(sp)
    8000076a:	6ae2                	ld	s5,24(sp)
    8000076c:	6b42                	ld	s6,16(sp)
    8000076e:	6ba2                	ld	s7,8(sp)
    80000770:	6161                	add	sp,sp,80
    80000772:	8082                	ret
    panic("uvmunmap: not aligned");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	94c50513          	add	a0,a0,-1716 # 800080c0 <etext+0xc0>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	4da080e7          	jalr	1242(ra) # 80005c56 <panic>
      panic("uvmunmap: walk");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	95450513          	add	a0,a0,-1708 # 800080d8 <etext+0xd8>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	4ca080e7          	jalr	1226(ra) # 80005c56 <panic>
      panic("uvmunmap: not mapped");
    80000794:	00008517          	auipc	a0,0x8
    80000798:	95450513          	add	a0,a0,-1708 # 800080e8 <etext+0xe8>
    8000079c:	00005097          	auipc	ra,0x5
    800007a0:	4ba080e7          	jalr	1210(ra) # 80005c56 <panic>
      panic("uvmunmap: not a leaf");
    800007a4:	00008517          	auipc	a0,0x8
    800007a8:	95c50513          	add	a0,a0,-1700 # 80008100 <etext+0x100>
    800007ac:	00005097          	auipc	ra,0x5
    800007b0:	4aa080e7          	jalr	1194(ra) # 80005c56 <panic>
    *pte = 0;
    800007b4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b8:	995a                	add	s2,s2,s6
    800007ba:	fb3972e3          	bgeu	s2,s3,8000075e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007be:	4601                	li	a2,0
    800007c0:	85ca                	mv	a1,s2
    800007c2:	8552                	mv	a0,s4
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	c98080e7          	jalr	-872(ra) # 8000045c <walk>
    800007cc:	84aa                	mv	s1,a0
    800007ce:	d95d                	beqz	a0,80000784 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007d0:	6108                	ld	a0,0(a0)
    800007d2:	00157793          	and	a5,a0,1
    800007d6:	dfdd                	beqz	a5,80000794 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007d8:	3ff57793          	and	a5,a0,1023
    800007dc:	fd7784e3          	beq	a5,s7,800007a4 <uvmunmap+0x76>
    if(do_free){
    800007e0:	fc0a8ae3          	beqz	s5,800007b4 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007e4:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800007e6:	0532                	sll	a0,a0,0xc
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	834080e7          	jalr	-1996(ra) # 8000001c <kfree>
    800007f0:	b7d1                	j	800007b4 <uvmunmap+0x86>

00000000800007f2 <uvmcreate>:

/* create an empty user page table. */
/* returns 0 if out of memory. */
pagetable_t
uvmcreate()
{
    800007f2:	1101                	add	sp,sp,-32
    800007f4:	ec06                	sd	ra,24(sp)
    800007f6:	e822                	sd	s0,16(sp)
    800007f8:	e426                	sd	s1,8(sp)
    800007fa:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	91e080e7          	jalr	-1762(ra) # 8000011a <kalloc>
    80000804:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000806:	c519                	beqz	a0,80000814 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000808:	6605                	lui	a2,0x1
    8000080a:	4581                	li	a1,0
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	96e080e7          	jalr	-1682(ra) # 8000017a <memset>
  return pagetable;
}
    80000814:	8526                	mv	a0,s1
    80000816:	60e2                	ld	ra,24(sp)
    80000818:	6442                	ld	s0,16(sp)
    8000081a:	64a2                	ld	s1,8(sp)
    8000081c:	6105                	add	sp,sp,32
    8000081e:	8082                	ret

0000000080000820 <uvmfirst>:
/* Load the user initcode into address 0 of pagetable, */
/* for the very first process. */
/* sz must be less than a page. */
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000820:	7179                	add	sp,sp,-48
    80000822:	f406                	sd	ra,40(sp)
    80000824:	f022                	sd	s0,32(sp)
    80000826:	ec26                	sd	s1,24(sp)
    80000828:	e84a                	sd	s2,16(sp)
    8000082a:	e44e                	sd	s3,8(sp)
    8000082c:	e052                	sd	s4,0(sp)
    8000082e:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000830:	6785                	lui	a5,0x1
    80000832:	04f67863          	bgeu	a2,a5,80000882 <uvmfirst+0x62>
    80000836:	8a2a                	mv	s4,a0
    80000838:	89ae                	mv	s3,a1
    8000083a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	8de080e7          	jalr	-1826(ra) # 8000011a <kalloc>
    80000844:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000846:	6605                	lui	a2,0x1
    80000848:	4581                	li	a1,0
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	930080e7          	jalr	-1744(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000852:	4779                	li	a4,30
    80000854:	86ca                	mv	a3,s2
    80000856:	6605                	lui	a2,0x1
    80000858:	4581                	li	a1,0
    8000085a:	8552                	mv	a0,s4
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	ce8080e7          	jalr	-792(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000864:	8626                	mv	a2,s1
    80000866:	85ce                	mv	a1,s3
    80000868:	854a                	mv	a0,s2
    8000086a:	00000097          	auipc	ra,0x0
    8000086e:	96c080e7          	jalr	-1684(ra) # 800001d6 <memmove>
}
    80000872:	70a2                	ld	ra,40(sp)
    80000874:	7402                	ld	s0,32(sp)
    80000876:	64e2                	ld	s1,24(sp)
    80000878:	6942                	ld	s2,16(sp)
    8000087a:	69a2                	ld	s3,8(sp)
    8000087c:	6a02                	ld	s4,0(sp)
    8000087e:	6145                	add	sp,sp,48
    80000880:	8082                	ret
    panic("uvmfirst: more than a page");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	89650513          	add	a0,a0,-1898 # 80008118 <etext+0x118>
    8000088a:	00005097          	auipc	ra,0x5
    8000088e:	3cc080e7          	jalr	972(ra) # 80005c56 <panic>

0000000080000892 <uvmdealloc>:
/* newsz.  oldsz and newsz need not be page-aligned, nor does newsz */
/* need to be less than oldsz.  oldsz can be larger than the actual */
/* process size.  Returns the new process size. */
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000892:	1101                	add	sp,sp,-32
    80000894:	ec06                	sd	ra,24(sp)
    80000896:	e822                	sd	s0,16(sp)
    80000898:	e426                	sd	s1,8(sp)
    8000089a:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000089e:	00b67d63          	bgeu	a2,a1,800008b8 <uvmdealloc+0x26>
    800008a2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a4:	6785                	lui	a5,0x1
    800008a6:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008a8:	00f60733          	add	a4,a2,a5
    800008ac:	76fd                	lui	a3,0xfffff
    800008ae:	8f75                	and	a4,a4,a3
    800008b0:	97ae                	add	a5,a5,a1
    800008b2:	8ff5                	and	a5,a5,a3
    800008b4:	00f76863          	bltu	a4,a5,800008c4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008b8:	8526                	mv	a0,s1
    800008ba:	60e2                	ld	ra,24(sp)
    800008bc:	6442                	ld	s0,16(sp)
    800008be:	64a2                	ld	s1,8(sp)
    800008c0:	6105                	add	sp,sp,32
    800008c2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c4:	8f99                	sub	a5,a5,a4
    800008c6:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008c8:	4685                	li	a3,1
    800008ca:	0007861b          	sext.w	a2,a5
    800008ce:	85ba                	mv	a1,a4
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	e5e080e7          	jalr	-418(ra) # 8000072e <uvmunmap>
    800008d8:	b7c5                	j	800008b8 <uvmdealloc+0x26>

00000000800008da <uvmalloc>:
  if(newsz < oldsz)
    800008da:	0ab66563          	bltu	a2,a1,80000984 <uvmalloc+0xaa>
{
    800008de:	7139                	add	sp,sp,-64
    800008e0:	fc06                	sd	ra,56(sp)
    800008e2:	f822                	sd	s0,48(sp)
    800008e4:	f426                	sd	s1,40(sp)
    800008e6:	f04a                	sd	s2,32(sp)
    800008e8:	ec4e                	sd	s3,24(sp)
    800008ea:	e852                	sd	s4,16(sp)
    800008ec:	e456                	sd	s5,8(sp)
    800008ee:	e05a                	sd	s6,0(sp)
    800008f0:	0080                	add	s0,sp,64
    800008f2:	8aaa                	mv	s5,a0
    800008f4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f6:	6785                	lui	a5,0x1
    800008f8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fa:	95be                	add	a1,a1,a5
    800008fc:	77fd                	lui	a5,0xfffff
    800008fe:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000902:	08c9f363          	bgeu	s3,a2,80000988 <uvmalloc+0xae>
    80000906:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	80e080e7          	jalr	-2034(ra) # 8000011a <kalloc>
    80000914:	84aa                	mv	s1,a0
    if(mem == 0){
    80000916:	c51d                	beqz	a0,80000944 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000918:	6605                	lui	a2,0x1
    8000091a:	4581                	li	a1,0
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	85e080e7          	jalr	-1954(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000924:	875a                	mv	a4,s6
    80000926:	86a6                	mv	a3,s1
    80000928:	6605                	lui	a2,0x1
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	c16080e7          	jalr	-1002(ra) # 80000544 <mappages>
    80000936:	e90d                	bnez	a0,80000968 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000938:	6785                	lui	a5,0x1
    8000093a:	993e                	add	s2,s2,a5
    8000093c:	fd4968e3          	bltu	s2,s4,8000090c <uvmalloc+0x32>
  return newsz;
    80000940:	8552                	mv	a0,s4
    80000942:	a809                	j	80000954 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f48080e7          	jalr	-184(ra) # 80000892 <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
}
    80000954:	70e2                	ld	ra,56(sp)
    80000956:	7442                	ld	s0,48(sp)
    80000958:	74a2                	ld	s1,40(sp)
    8000095a:	7902                	ld	s2,32(sp)
    8000095c:	69e2                	ld	s3,24(sp)
    8000095e:	6a42                	ld	s4,16(sp)
    80000960:	6aa2                	ld	s5,8(sp)
    80000962:	6b02                	ld	s6,0(sp)
    80000964:	6121                	add	sp,sp,64
    80000966:	8082                	ret
      kfree(mem);
    80000968:	8526                	mv	a0,s1
    8000096a:	fffff097          	auipc	ra,0xfffff
    8000096e:	6b2080e7          	jalr	1714(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000972:	864e                	mv	a2,s3
    80000974:	85ca                	mv	a1,s2
    80000976:	8556                	mv	a0,s5
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	f1a080e7          	jalr	-230(ra) # 80000892 <uvmdealloc>
      return 0;
    80000980:	4501                	li	a0,0
    80000982:	bfc9                	j	80000954 <uvmalloc+0x7a>
    return oldsz;
    80000984:	852e                	mv	a0,a1
}
    80000986:	8082                	ret
  return newsz;
    80000988:	8532                	mv	a0,a2
    8000098a:	b7e9                	j	80000954 <uvmalloc+0x7a>

000000008000098c <freewalk>:

/* Recursively free page-table pages. */
/* All leaf mappings must already have been removed. */
void
freewalk(pagetable_t pagetable)
{
    8000098c:	7179                	add	sp,sp,-48
    8000098e:	f406                	sd	ra,40(sp)
    80000990:	f022                	sd	s0,32(sp)
    80000992:	ec26                	sd	s1,24(sp)
    80000994:	e84a                	sd	s2,16(sp)
    80000996:	e44e                	sd	s3,8(sp)
    80000998:	e052                	sd	s4,0(sp)
    8000099a:	1800                	add	s0,sp,48
    8000099c:	8a2a                	mv	s4,a0
  /* there are 2^9 = 512 PTEs in a page table. */
  for(int i = 0; i < 512; i++){
    8000099e:	84aa                	mv	s1,a0
    800009a0:	6905                	lui	s2,0x1
    800009a2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	4985                	li	s3,1
    800009a6:	a829                	j	800009c0 <freewalk+0x34>
      /* this PTE points to a lower-level page table. */
      uint64 child = PTE2PA(pte);
    800009a8:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009aa:	00c79513          	sll	a0,a5,0xc
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fde080e7          	jalr	-34(ra) # 8000098c <freewalk>
      pagetable[i] = 0;
    800009b6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009ba:	04a1                	add	s1,s1,8
    800009bc:	03248163          	beq	s1,s2,800009de <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009c0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c2:	00f7f713          	and	a4,a5,15
    800009c6:	ff3701e3          	beq	a4,s3,800009a8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ca:	8b85                	and	a5,a5,1
    800009cc:	d7fd                	beqz	a5,800009ba <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ce:	00007517          	auipc	a0,0x7
    800009d2:	76a50513          	add	a0,a0,1898 # 80008138 <etext+0x138>
    800009d6:	00005097          	auipc	ra,0x5
    800009da:	280080e7          	jalr	640(ra) # 80005c56 <panic>
    }
  }
  kfree((void*)pagetable);
    800009de:	8552                	mv	a0,s4
    800009e0:	fffff097          	auipc	ra,0xfffff
    800009e4:	63c080e7          	jalr	1596(ra) # 8000001c <kfree>
}
    800009e8:	70a2                	ld	ra,40(sp)
    800009ea:	7402                	ld	s0,32(sp)
    800009ec:	64e2                	ld	s1,24(sp)
    800009ee:	6942                	ld	s2,16(sp)
    800009f0:	69a2                	ld	s3,8(sp)
    800009f2:	6a02                	ld	s4,0(sp)
    800009f4:	6145                	add	sp,sp,48
    800009f6:	8082                	ret

00000000800009f8 <uvmfree>:

/* Free user memory pages, */
/* then free page-table pages. */
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f8:	1101                	add	sp,sp,-32
    800009fa:	ec06                	sd	ra,24(sp)
    800009fc:	e822                	sd	s0,16(sp)
    800009fe:	e426                	sd	s1,8(sp)
    80000a00:	1000                	add	s0,sp,32
    80000a02:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a04:	e999                	bnez	a1,80000a1a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a06:	8526                	mv	a0,s1
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	f84080e7          	jalr	-124(ra) # 8000098c <freewalk>
}
    80000a10:	60e2                	ld	ra,24(sp)
    80000a12:	6442                	ld	s0,16(sp)
    80000a14:	64a2                	ld	s1,8(sp)
    80000a16:	6105                	add	sp,sp,32
    80000a18:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a1a:	6785                	lui	a5,0x1
    80000a1c:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a1e:	95be                	add	a1,a1,a5
    80000a20:	4685                	li	a3,1
    80000a22:	00c5d613          	srl	a2,a1,0xc
    80000a26:	4581                	li	a1,0
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	d06080e7          	jalr	-762(ra) # 8000072e <uvmunmap>
    80000a30:	bfd9                	j	80000a06 <uvmfree+0xe>

0000000080000a32 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	c679                	beqz	a2,80000b00 <uvmcopy+0xce>
{
    80000a34:	715d                	add	sp,sp,-80
    80000a36:	e486                	sd	ra,72(sp)
    80000a38:	e0a2                	sd	s0,64(sp)
    80000a3a:	fc26                	sd	s1,56(sp)
    80000a3c:	f84a                	sd	s2,48(sp)
    80000a3e:	f44e                	sd	s3,40(sp)
    80000a40:	f052                	sd	s4,32(sp)
    80000a42:	ec56                	sd	s5,24(sp)
    80000a44:	e85a                	sd	s6,16(sp)
    80000a46:	e45e                	sd	s7,8(sp)
    80000a48:	0880                	add	s0,sp,80
    80000a4a:	8b2a                	mv	s6,a0
    80000a4c:	8aae                	mv	s5,a1
    80000a4e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a52:	4601                	li	a2,0
    80000a54:	85ce                	mv	a1,s3
    80000a56:	855a                	mv	a0,s6
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	a04080e7          	jalr	-1532(ra) # 8000045c <walk>
    80000a60:	c531                	beqz	a0,80000aac <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a62:	6118                	ld	a4,0(a0)
    80000a64:	00177793          	and	a5,a4,1
    80000a68:	cbb1                	beqz	a5,80000abc <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6a:	00a75593          	srl	a1,a4,0xa
    80000a6e:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a72:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a76:	fffff097          	auipc	ra,0xfffff
    80000a7a:	6a4080e7          	jalr	1700(ra) # 8000011a <kalloc>
    80000a7e:	892a                	mv	s2,a0
    80000a80:	c939                	beqz	a0,80000ad6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a82:	6605                	lui	a2,0x1
    80000a84:	85de                	mv	a1,s7
    80000a86:	fffff097          	auipc	ra,0xfffff
    80000a8a:	750080e7          	jalr	1872(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a8e:	8726                	mv	a4,s1
    80000a90:	86ca                	mv	a3,s2
    80000a92:	6605                	lui	a2,0x1
    80000a94:	85ce                	mv	a1,s3
    80000a96:	8556                	mv	a0,s5
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	aac080e7          	jalr	-1364(ra) # 80000544 <mappages>
    80000aa0:	e515                	bnez	a0,80000acc <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa2:	6785                	lui	a5,0x1
    80000aa4:	99be                	add	s3,s3,a5
    80000aa6:	fb49e6e3          	bltu	s3,s4,80000a52 <uvmcopy+0x20>
    80000aaa:	a081                	j	80000aea <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aac:	00007517          	auipc	a0,0x7
    80000ab0:	69c50513          	add	a0,a0,1692 # 80008148 <etext+0x148>
    80000ab4:	00005097          	auipc	ra,0x5
    80000ab8:	1a2080e7          	jalr	418(ra) # 80005c56 <panic>
      panic("uvmcopy: page not present");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	6ac50513          	add	a0,a0,1708 # 80008168 <etext+0x168>
    80000ac4:	00005097          	auipc	ra,0x5
    80000ac8:	192080e7          	jalr	402(ra) # 80005c56 <panic>
      kfree(mem);
    80000acc:	854a                	mv	a0,s2
    80000ace:	fffff097          	auipc	ra,0xfffff
    80000ad2:	54e080e7          	jalr	1358(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ad6:	4685                	li	a3,1
    80000ad8:	00c9d613          	srl	a2,s3,0xc
    80000adc:	4581                	li	a1,0
    80000ade:	8556                	mv	a0,s5
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	c4e080e7          	jalr	-946(ra) # 8000072e <uvmunmap>
  return -1;
    80000ae8:	557d                	li	a0,-1
}
    80000aea:	60a6                	ld	ra,72(sp)
    80000aec:	6406                	ld	s0,64(sp)
    80000aee:	74e2                	ld	s1,56(sp)
    80000af0:	7942                	ld	s2,48(sp)
    80000af2:	79a2                	ld	s3,40(sp)
    80000af4:	7a02                	ld	s4,32(sp)
    80000af6:	6ae2                	ld	s5,24(sp)
    80000af8:	6b42                	ld	s6,16(sp)
    80000afa:	6ba2                	ld	s7,8(sp)
    80000afc:	6161                	add	sp,sp,80
    80000afe:	8082                	ret
  return 0;
    80000b00:	4501                	li	a0,0
}
    80000b02:	8082                	ret

0000000080000b04 <uvmclear>:

/* mark a PTE invalid for user access. */
/* used by exec for the user stack guard page. */
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b04:	1141                	add	sp,sp,-16
    80000b06:	e406                	sd	ra,8(sp)
    80000b08:	e022                	sd	s0,0(sp)
    80000b0a:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b0c:	4601                	li	a2,0
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	94e080e7          	jalr	-1714(ra) # 8000045c <walk>
  if(pte == 0)
    80000b16:	c901                	beqz	a0,80000b26 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b18:	611c                	ld	a5,0(a0)
    80000b1a:	9bbd                	and	a5,a5,-17
    80000b1c:	e11c                	sd	a5,0(a0)
}
    80000b1e:	60a2                	ld	ra,8(sp)
    80000b20:	6402                	ld	s0,0(sp)
    80000b22:	0141                	add	sp,sp,16
    80000b24:	8082                	ret
    panic("uvmclear");
    80000b26:	00007517          	auipc	a0,0x7
    80000b2a:	66250513          	add	a0,a0,1634 # 80008188 <etext+0x188>
    80000b2e:	00005097          	auipc	ra,0x5
    80000b32:	128080e7          	jalr	296(ra) # 80005c56 <panic>

0000000080000b36 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b36:	cac9                	beqz	a3,80000bc8 <copyout+0x92>
{
    80000b38:	711d                	add	sp,sp,-96
    80000b3a:	ec86                	sd	ra,88(sp)
    80000b3c:	e8a2                	sd	s0,80(sp)
    80000b3e:	e4a6                	sd	s1,72(sp)
    80000b40:	e0ca                	sd	s2,64(sp)
    80000b42:	fc4e                	sd	s3,56(sp)
    80000b44:	f852                	sd	s4,48(sp)
    80000b46:	f456                	sd	s5,40(sp)
    80000b48:	f05a                	sd	s6,32(sp)
    80000b4a:	ec5e                	sd	s7,24(sp)
    80000b4c:	e862                	sd	s8,16(sp)
    80000b4e:	e466                	sd	s9,8(sp)
    80000b50:	e06a                	sd	s10,0(sp)
    80000b52:	1080                	add	s0,sp,96
    80000b54:	8baa                	mv	s7,a0
    80000b56:	8aae                	mv	s5,a1
    80000b58:	8b32                	mv	s6,a2
    80000b5a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	74fd                	lui	s1,0xfffff
    80000b5e:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b60:	57fd                	li	a5,-1
    80000b62:	83e9                	srl	a5,a5,0x1a
    80000b64:	0697e463          	bltu	a5,s1,80000bcc <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b68:	4cd5                	li	s9,21
    80000b6a:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b6c:	8c3e                	mv	s8,a5
    80000b6e:	a035                	j	80000b9a <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b70:	83a9                	srl	a5,a5,0xa
    80000b72:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b74:	409a8533          	sub	a0,s5,s1
    80000b78:	0009061b          	sext.w	a2,s2
    80000b7c:	85da                	mv	a1,s6
    80000b7e:	953e                	add	a0,a0,a5
    80000b80:	fffff097          	auipc	ra,0xfffff
    80000b84:	656080e7          	jalr	1622(ra) # 800001d6 <memmove>

    len -= n;
    80000b88:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b8c:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b8e:	02098b63          	beqz	s3,80000bc4 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b92:	034c6f63          	bltu	s8,s4,80000bd0 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b96:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b98:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b9a:	4601                	li	a2,0
    80000b9c:	85a6                	mv	a1,s1
    80000b9e:	855e                	mv	a0,s7
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	8bc080e7          	jalr	-1860(ra) # 8000045c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000ba8:	c515                	beqz	a0,80000bd4 <copyout+0x9e>
    80000baa:	611c                	ld	a5,0(a0)
    80000bac:	0157f713          	and	a4,a5,21
    80000bb0:	05971163          	bne	a4,s9,80000bf2 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb4:	01a48a33          	add	s4,s1,s10
    80000bb8:	415a0933          	sub	s2,s4,s5
    80000bbc:	fb29fae3          	bgeu	s3,s2,80000b70 <copyout+0x3a>
    80000bc0:	894e                	mv	s2,s3
    80000bc2:	b77d                	j	80000b70 <copyout+0x3a>
  }
  return 0;
    80000bc4:	4501                	li	a0,0
    80000bc6:	a801                	j	80000bd6 <copyout+0xa0>
    80000bc8:	4501                	li	a0,0
}
    80000bca:	8082                	ret
      return -1;
    80000bcc:	557d                	li	a0,-1
    80000bce:	a021                	j	80000bd6 <copyout+0xa0>
    80000bd0:	557d                	li	a0,-1
    80000bd2:	a011                	j	80000bd6 <copyout+0xa0>
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60e6                	ld	ra,88(sp)
    80000bd8:	6446                	ld	s0,80(sp)
    80000bda:	64a6                	ld	s1,72(sp)
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	79e2                	ld	s3,56(sp)
    80000be0:	7a42                	ld	s4,48(sp)
    80000be2:	7aa2                	ld	s5,40(sp)
    80000be4:	7b02                	ld	s6,32(sp)
    80000be6:	6be2                	ld	s7,24(sp)
    80000be8:	6c42                	ld	s8,16(sp)
    80000bea:	6ca2                	ld	s9,8(sp)
    80000bec:	6d02                	ld	s10,0(sp)
    80000bee:	6125                	add	sp,sp,96
    80000bf0:	8082                	ret
      return -1;
    80000bf2:	557d                	li	a0,-1
    80000bf4:	b7cd                	j	80000bd6 <copyout+0xa0>

0000000080000bf6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bf6:	caa5                	beqz	a3,80000c66 <copyin+0x70>
{
    80000bf8:	715d                	add	sp,sp,-80
    80000bfa:	e486                	sd	ra,72(sp)
    80000bfc:	e0a2                	sd	s0,64(sp)
    80000bfe:	fc26                	sd	s1,56(sp)
    80000c00:	f84a                	sd	s2,48(sp)
    80000c02:	f44e                	sd	s3,40(sp)
    80000c04:	f052                	sd	s4,32(sp)
    80000c06:	ec56                	sd	s5,24(sp)
    80000c08:	e85a                	sd	s6,16(sp)
    80000c0a:	e45e                	sd	s7,8(sp)
    80000c0c:	e062                	sd	s8,0(sp)
    80000c0e:	0880                	add	s0,sp,80
    80000c10:	8b2a                	mv	s6,a0
    80000c12:	8a2e                	mv	s4,a1
    80000c14:	8c32                	mv	s8,a2
    80000c16:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c18:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1a:	6a85                	lui	s5,0x1
    80000c1c:	a01d                	j	80000c42 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c1e:	018505b3          	add	a1,a0,s8
    80000c22:	0004861b          	sext.w	a2,s1
    80000c26:	412585b3          	sub	a1,a1,s2
    80000c2a:	8552                	mv	a0,s4
    80000c2c:	fffff097          	auipc	ra,0xfffff
    80000c30:	5aa080e7          	jalr	1450(ra) # 800001d6 <memmove>

    len -= n;
    80000c34:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c38:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c3e:	02098263          	beqz	s3,80000c62 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c42:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c46:	85ca                	mv	a1,s2
    80000c48:	855a                	mv	a0,s6
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	8b8080e7          	jalr	-1864(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c52:	cd01                	beqz	a0,80000c6a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c54:	418904b3          	sub	s1,s2,s8
    80000c58:	94d6                	add	s1,s1,s5
    80000c5a:	fc99f2e3          	bgeu	s3,s1,80000c1e <copyin+0x28>
    80000c5e:	84ce                	mv	s1,s3
    80000c60:	bf7d                	j	80000c1e <copyin+0x28>
  }
  return 0;
    80000c62:	4501                	li	a0,0
    80000c64:	a021                	j	80000c6c <copyin+0x76>
    80000c66:	4501                	li	a0,0
}
    80000c68:	8082                	ret
      return -1;
    80000c6a:	557d                	li	a0,-1
}
    80000c6c:	60a6                	ld	ra,72(sp)
    80000c6e:	6406                	ld	s0,64(sp)
    80000c70:	74e2                	ld	s1,56(sp)
    80000c72:	7942                	ld	s2,48(sp)
    80000c74:	79a2                	ld	s3,40(sp)
    80000c76:	7a02                	ld	s4,32(sp)
    80000c78:	6ae2                	ld	s5,24(sp)
    80000c7a:	6b42                	ld	s6,16(sp)
    80000c7c:	6ba2                	ld	s7,8(sp)
    80000c7e:	6c02                	ld	s8,0(sp)
    80000c80:	6161                	add	sp,sp,80
    80000c82:	8082                	ret

0000000080000c84 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c84:	c2dd                	beqz	a3,80000d2a <copyinstr+0xa6>
{
    80000c86:	715d                	add	sp,sp,-80
    80000c88:	e486                	sd	ra,72(sp)
    80000c8a:	e0a2                	sd	s0,64(sp)
    80000c8c:	fc26                	sd	s1,56(sp)
    80000c8e:	f84a                	sd	s2,48(sp)
    80000c90:	f44e                	sd	s3,40(sp)
    80000c92:	f052                	sd	s4,32(sp)
    80000c94:	ec56                	sd	s5,24(sp)
    80000c96:	e85a                	sd	s6,16(sp)
    80000c98:	e45e                	sd	s7,8(sp)
    80000c9a:	0880                	add	s0,sp,80
    80000c9c:	8a2a                	mv	s4,a0
    80000c9e:	8b2e                	mv	s6,a1
    80000ca0:	8bb2                	mv	s7,a2
    80000ca2:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca6:	6985                	lui	s3,0x1
    80000ca8:	a02d                	j	80000cd2 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000caa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cae:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb0:	37fd                	addw	a5,a5,-1
    80000cb2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cb6:	60a6                	ld	ra,72(sp)
    80000cb8:	6406                	ld	s0,64(sp)
    80000cba:	74e2                	ld	s1,56(sp)
    80000cbc:	7942                	ld	s2,48(sp)
    80000cbe:	79a2                	ld	s3,40(sp)
    80000cc0:	7a02                	ld	s4,32(sp)
    80000cc2:	6ae2                	ld	s5,24(sp)
    80000cc4:	6b42                	ld	s6,16(sp)
    80000cc6:	6ba2                	ld	s7,8(sp)
    80000cc8:	6161                	add	sp,sp,80
    80000cca:	8082                	ret
    srcva = va0 + PGSIZE;
    80000ccc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd0:	c8a9                	beqz	s1,80000d22 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cd2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cd6:	85ca                	mv	a1,s2
    80000cd8:	8552                	mv	a0,s4
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	828080e7          	jalr	-2008(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000ce2:	c131                	beqz	a0,80000d26 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ce4:	417906b3          	sub	a3,s2,s7
    80000ce8:	96ce                	add	a3,a3,s3
    80000cea:	00d4f363          	bgeu	s1,a3,80000cf0 <copyinstr+0x6c>
    80000cee:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf0:	955e                	add	a0,a0,s7
    80000cf2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cf6:	daf9                	beqz	a3,80000ccc <copyinstr+0x48>
    80000cf8:	87da                	mv	a5,s6
    80000cfa:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cfc:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d00:	96da                	add	a3,a3,s6
    80000d02:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d04:	00f60733          	add	a4,a2,a5
    80000d08:	00074703          	lbu	a4,0(a4)
    80000d0c:	df59                	beqz	a4,80000caa <copyinstr+0x26>
        *dst = *p;
    80000d0e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d12:	0785                	add	a5,a5,1
    while(n > 0){
    80000d14:	fed797e3          	bne	a5,a3,80000d02 <copyinstr+0x7e>
    80000d18:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffdcf1f>
    80000d1a:	94c2                	add	s1,s1,a6
      --max;
    80000d1c:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d1e:	8b3e                	mv	s6,a5
    80000d20:	b775                	j	80000ccc <copyinstr+0x48>
    80000d22:	4781                	li	a5,0
    80000d24:	b771                	j	80000cb0 <copyinstr+0x2c>
      return -1;
    80000d26:	557d                	li	a0,-1
    80000d28:	b779                	j	80000cb6 <copyinstr+0x32>
  int got_null = 0;
    80000d2a:	4781                	li	a5,0
  if(got_null){
    80000d2c:	37fd                	addw	a5,a5,-1
    80000d2e:	0007851b          	sext.w	a0,a5
}
    80000d32:	8082                	ret

0000000080000d34 <proc_mapstacks>:
/* Allocate a page for each process's kernel stack. */
/* Map it high in memory, followed by an invalid */
/* guard page. */
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d34:	7139                	add	sp,sp,-64
    80000d36:	fc06                	sd	ra,56(sp)
    80000d38:	f822                	sd	s0,48(sp)
    80000d3a:	f426                	sd	s1,40(sp)
    80000d3c:	f04a                	sd	s2,32(sp)
    80000d3e:	ec4e                	sd	s3,24(sp)
    80000d40:	e852                	sd	s4,16(sp)
    80000d42:	e456                	sd	s5,8(sp)
    80000d44:	e05a                	sd	s6,0(sp)
    80000d46:	0080                	add	s0,sp,64
    80000d48:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	00008497          	auipc	s1,0x8
    80000d4e:	17648493          	add	s1,s1,374 # 80008ec0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d52:	8b26                	mv	s6,s1
    80000d54:	00007a97          	auipc	s5,0x7
    80000d58:	2aca8a93          	add	s5,s5,684 # 80008000 <etext>
    80000d5c:	04000937          	lui	s2,0x4000
    80000d60:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d62:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d64:	0000ea17          	auipc	s4,0xe
    80000d68:	d5ca0a13          	add	s4,s4,-676 # 8000eac0 <tickslock>
    char *pa = kalloc();
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	3ae080e7          	jalr	942(ra) # 8000011a <kalloc>
    80000d74:	862a                	mv	a2,a0
    if(pa == 0)
    80000d76:	c131                	beqz	a0,80000dba <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d78:	416485b3          	sub	a1,s1,s6
    80000d7c:	8591                	sra	a1,a1,0x4
    80000d7e:	000ab783          	ld	a5,0(s5)
    80000d82:	02f585b3          	mul	a1,a1,a5
    80000d86:	2585                	addw	a1,a1,1
    80000d88:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d8c:	4719                	li	a4,6
    80000d8e:	6685                	lui	a3,0x1
    80000d90:	40b905b3          	sub	a1,s2,a1
    80000d94:	854e                	mv	a0,s3
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	872080e7          	jalr	-1934(ra) # 80000608 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9e:	17048493          	add	s1,s1,368
    80000da2:	fd4495e3          	bne	s1,s4,80000d6c <proc_mapstacks+0x38>
  }
}
    80000da6:	70e2                	ld	ra,56(sp)
    80000da8:	7442                	ld	s0,48(sp)
    80000daa:	74a2                	ld	s1,40(sp)
    80000dac:	7902                	ld	s2,32(sp)
    80000dae:	69e2                	ld	s3,24(sp)
    80000db0:	6a42                	ld	s4,16(sp)
    80000db2:	6aa2                	ld	s5,8(sp)
    80000db4:	6b02                	ld	s6,0(sp)
    80000db6:	6121                	add	sp,sp,64
    80000db8:	8082                	ret
      panic("kalloc");
    80000dba:	00007517          	auipc	a0,0x7
    80000dbe:	3de50513          	add	a0,a0,990 # 80008198 <etext+0x198>
    80000dc2:	00005097          	auipc	ra,0x5
    80000dc6:	e94080e7          	jalr	-364(ra) # 80005c56 <panic>

0000000080000dca <procinit>:

/* initialize the proc table. */
void
procinit(void)
{
    80000dca:	7139                	add	sp,sp,-64
    80000dcc:	fc06                	sd	ra,56(sp)
    80000dce:	f822                	sd	s0,48(sp)
    80000dd0:	f426                	sd	s1,40(sp)
    80000dd2:	f04a                	sd	s2,32(sp)
    80000dd4:	ec4e                	sd	s3,24(sp)
    80000dd6:	e852                	sd	s4,16(sp)
    80000dd8:	e456                	sd	s5,8(sp)
    80000dda:	e05a                	sd	s6,0(sp)
    80000ddc:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dde:	00007597          	auipc	a1,0x7
    80000de2:	3c258593          	add	a1,a1,962 # 800081a0 <etext+0x1a0>
    80000de6:	00008517          	auipc	a0,0x8
    80000dea:	caa50513          	add	a0,a0,-854 # 80008a90 <pid_lock>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	310080e7          	jalr	784(ra) # 800060fe <initlock>
  initlock(&wait_lock, "wait_lock");
    80000df6:	00007597          	auipc	a1,0x7
    80000dfa:	3b258593          	add	a1,a1,946 # 800081a8 <etext+0x1a8>
    80000dfe:	00008517          	auipc	a0,0x8
    80000e02:	caa50513          	add	a0,a0,-854 # 80008aa8 <wait_lock>
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	2f8080e7          	jalr	760(ra) # 800060fe <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0e:	00008497          	auipc	s1,0x8
    80000e12:	0b248493          	add	s1,s1,178 # 80008ec0 <proc>
      initlock(&p->lock, "proc");
    80000e16:	00007b17          	auipc	s6,0x7
    80000e1a:	3a2b0b13          	add	s6,s6,930 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	8aa6                	mv	s5,s1
    80000e20:	00007a17          	auipc	s4,0x7
    80000e24:	1e0a0a13          	add	s4,s4,480 # 80008000 <etext>
    80000e28:	04000937          	lui	s2,0x4000
    80000e2c:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e2e:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e30:	0000e997          	auipc	s3,0xe
    80000e34:	c9098993          	add	s3,s3,-880 # 8000eac0 <tickslock>
      initlock(&p->lock, "proc");
    80000e38:	85da                	mv	a1,s6
    80000e3a:	8526                	mv	a0,s1
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	2c2080e7          	jalr	706(ra) # 800060fe <initlock>
      p->state = UNUSED;
    80000e44:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e48:	415487b3          	sub	a5,s1,s5
    80000e4c:	8791                	sra	a5,a5,0x4
    80000e4e:	000a3703          	ld	a4,0(s4)
    80000e52:	02e787b3          	mul	a5,a5,a4
    80000e56:	2785                	addw	a5,a5,1
    80000e58:	00d7979b          	sllw	a5,a5,0xd
    80000e5c:	40f907b3          	sub	a5,s2,a5
    80000e60:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	17048493          	add	s1,s1,368
    80000e66:	fd3499e3          	bne	s1,s3,80000e38 <procinit+0x6e>
  }
}
    80000e6a:	70e2                	ld	ra,56(sp)
    80000e6c:	7442                	ld	s0,48(sp)
    80000e6e:	74a2                	ld	s1,40(sp)
    80000e70:	7902                	ld	s2,32(sp)
    80000e72:	69e2                	ld	s3,24(sp)
    80000e74:	6a42                	ld	s4,16(sp)
    80000e76:	6aa2                	ld	s5,8(sp)
    80000e78:	6b02                	ld	s6,0(sp)
    80000e7a:	6121                	add	sp,sp,64
    80000e7c:	8082                	ret

0000000080000e7e <cpuid>:
/* Must be called with interrupts disabled, */
/* to prevent race with process being moved */
/* to a different CPU. */
int
cpuid()
{
    80000e7e:	1141                	add	sp,sp,-16
    80000e80:	e422                	sd	s0,8(sp)
    80000e82:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e84:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e86:	2501                	sext.w	a0,a0
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	add	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <mycpu>:

/* Return this CPU's cpu struct. */
/* Interrupts must be disabled. */
struct cpu*
mycpu(void)
{
    80000e8e:	1141                	add	sp,sp,-16
    80000e90:	e422                	sd	s0,8(sp)
    80000e92:	0800                	add	s0,sp,16
    80000e94:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	079e                	sll	a5,a5,0x7
  return c;
}
    80000e9a:	00008517          	auipc	a0,0x8
    80000e9e:	c2650513          	add	a0,a0,-986 # 80008ac0 <cpus>
    80000ea2:	953e                	add	a0,a0,a5
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	add	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    80000eaa:	1101                	add	sp,sp,-32
    80000eac:	ec06                	sd	ra,24(sp)
    80000eae:	e822                	sd	s0,16(sp)
    80000eb0:	e426                	sd	s1,8(sp)
    80000eb2:	1000                	add	s0,sp,32
  push_off();
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	28e080e7          	jalr	654(ra) # 80006142 <push_off>
    80000ebc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ebe:	2781                	sext.w	a5,a5
    80000ec0:	079e                	sll	a5,a5,0x7
    80000ec2:	00008717          	auipc	a4,0x8
    80000ec6:	bce70713          	add	a4,a4,-1074 # 80008a90 <pid_lock>
    80000eca:	97ba                	add	a5,a5,a4
    80000ecc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ece:	00005097          	auipc	ra,0x5
    80000ed2:	314080e7          	jalr	788(ra) # 800061e2 <pop_off>
  return p;
}
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	60e2                	ld	ra,24(sp)
    80000eda:	6442                	ld	s0,16(sp)
    80000edc:	64a2                	ld	s1,8(sp)
    80000ede:	6105                	add	sp,sp,32
    80000ee0:	8082                	ret

0000000080000ee2 <forkret>:

/* A fork child's very first scheduling by scheduler() */
/* will swtch to forkret. */
void
forkret(void)
{
    80000ee2:	1141                	add	sp,sp,-16
    80000ee4:	e406                	sd	ra,8(sp)
    80000ee6:	e022                	sd	s0,0(sp)
    80000ee8:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	fc0080e7          	jalr	-64(ra) # 80000eaa <myproc>
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	350080e7          	jalr	848(ra) # 80006242 <release>

  if (first) {
    80000efa:	00008797          	auipc	a5,0x8
    80000efe:	a467a783          	lw	a5,-1466(a5) # 80008940 <first.1>
    80000f02:	eb89                	bnez	a5,80000f14 <forkret+0x32>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	c8a080e7          	jalr	-886(ra) # 80001b8e <usertrapret>
}
    80000f0c:	60a2                	ld	ra,8(sp)
    80000f0e:	6402                	ld	s0,0(sp)
    80000f10:	0141                	add	sp,sp,16
    80000f12:	8082                	ret
    fsinit(ROOTDEV);
    80000f14:	4505                	li	a0,1
    80000f16:	00002097          	auipc	ra,0x2
    80000f1a:	a6c080e7          	jalr	-1428(ra) # 80002982 <fsinit>
    first = 0;
    80000f1e:	00008797          	auipc	a5,0x8
    80000f22:	a207a123          	sw	zero,-1502(a5) # 80008940 <first.1>
    __sync_synchronize();
    80000f26:	0ff0000f          	fence
    80000f2a:	bfe9                	j	80000f04 <forkret+0x22>

0000000080000f2c <allocpid>:
{
    80000f2c:	1101                	add	sp,sp,-32
    80000f2e:	ec06                	sd	ra,24(sp)
    80000f30:	e822                	sd	s0,16(sp)
    80000f32:	e426                	sd	s1,8(sp)
    80000f34:	e04a                	sd	s2,0(sp)
    80000f36:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000f38:	00008917          	auipc	s2,0x8
    80000f3c:	b5890913          	add	s2,s2,-1192 # 80008a90 <pid_lock>
    80000f40:	854a                	mv	a0,s2
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	24c080e7          	jalr	588(ra) # 8000618e <acquire>
  pid = nextpid;
    80000f4a:	00008797          	auipc	a5,0x8
    80000f4e:	9fa78793          	add	a5,a5,-1542 # 80008944 <nextpid>
    80000f52:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f54:	0014871b          	addw	a4,s1,1
    80000f58:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f5a:	854a                	mv	a0,s2
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	2e6080e7          	jalr	742(ra) # 80006242 <release>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	add	sp,sp,32
    80000f70:	8082                	ret

0000000080000f72 <proc_pagetable>:
{
    80000f72:	1101                	add	sp,sp,-32
    80000f74:	ec06                	sd	ra,24(sp)
    80000f76:	e822                	sd	s0,16(sp)
    80000f78:	e426                	sd	s1,8(sp)
    80000f7a:	e04a                	sd	s2,0(sp)
    80000f7c:	1000                	add	s0,sp,32
    80000f7e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	872080e7          	jalr	-1934(ra) # 800007f2 <uvmcreate>
    80000f88:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f8a:	c121                	beqz	a0,80000fca <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f8c:	4729                	li	a4,10
    80000f8e:	00006697          	auipc	a3,0x6
    80000f92:	07268693          	add	a3,a3,114 # 80007000 <_trampoline>
    80000f96:	6605                	lui	a2,0x1
    80000f98:	040005b7          	lui	a1,0x4000
    80000f9c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f9e:	05b2                	sll	a1,a1,0xc
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	5a4080e7          	jalr	1444(ra) # 80000544 <mappages>
    80000fa8:	02054863          	bltz	a0,80000fd8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fac:	4719                	li	a4,6
    80000fae:	05893683          	ld	a3,88(s2)
    80000fb2:	6605                	lui	a2,0x1
    80000fb4:	020005b7          	lui	a1,0x2000
    80000fb8:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fba:	05b6                	sll	a1,a1,0xd
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	586080e7          	jalr	1414(ra) # 80000544 <mappages>
    80000fc6:	02054163          	bltz	a0,80000fe8 <proc_pagetable+0x76>
}
    80000fca:	8526                	mv	a0,s1
    80000fcc:	60e2                	ld	ra,24(sp)
    80000fce:	6442                	ld	s0,16(sp)
    80000fd0:	64a2                	ld	s1,8(sp)
    80000fd2:	6902                	ld	s2,0(sp)
    80000fd4:	6105                	add	sp,sp,32
    80000fd6:	8082                	ret
    uvmfree(pagetable, 0);
    80000fd8:	4581                	li	a1,0
    80000fda:	8526                	mv	a0,s1
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	a1c080e7          	jalr	-1508(ra) # 800009f8 <uvmfree>
    return 0;
    80000fe4:	4481                	li	s1,0
    80000fe6:	b7d5                	j	80000fca <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe8:	4681                	li	a3,0
    80000fea:	4605                	li	a2,1
    80000fec:	040005b7          	lui	a1,0x4000
    80000ff0:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff2:	05b2                	sll	a1,a1,0xc
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	fffff097          	auipc	ra,0xfffff
    80000ffa:	738080e7          	jalr	1848(ra) # 8000072e <uvmunmap>
    uvmfree(pagetable, 0);
    80000ffe:	4581                	li	a1,0
    80001000:	8526                	mv	a0,s1
    80001002:	00000097          	auipc	ra,0x0
    80001006:	9f6080e7          	jalr	-1546(ra) # 800009f8 <uvmfree>
    return 0;
    8000100a:	4481                	li	s1,0
    8000100c:	bf7d                	j	80000fca <proc_pagetable+0x58>

000000008000100e <proc_freepagetable>:
{
    8000100e:	1101                	add	sp,sp,-32
    80001010:	ec06                	sd	ra,24(sp)
    80001012:	e822                	sd	s0,16(sp)
    80001014:	e426                	sd	s1,8(sp)
    80001016:	e04a                	sd	s2,0(sp)
    80001018:	1000                	add	s0,sp,32
    8000101a:	84aa                	mv	s1,a0
    8000101c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000101e:	4681                	li	a3,0
    80001020:	4605                	li	a2,1
    80001022:	040005b7          	lui	a1,0x4000
    80001026:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001028:	05b2                	sll	a1,a1,0xc
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	704080e7          	jalr	1796(ra) # 8000072e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001032:	4681                	li	a3,0
    80001034:	4605                	li	a2,1
    80001036:	020005b7          	lui	a1,0x2000
    8000103a:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000103c:	05b6                	sll	a1,a1,0xd
    8000103e:	8526                	mv	a0,s1
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	6ee080e7          	jalr	1774(ra) # 8000072e <uvmunmap>
  uvmfree(pagetable, sz);
    80001048:	85ca                	mv	a1,s2
    8000104a:	8526                	mv	a0,s1
    8000104c:	00000097          	auipc	ra,0x0
    80001050:	9ac080e7          	jalr	-1620(ra) # 800009f8 <uvmfree>
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	add	sp,sp,32
    8000105e:	8082                	ret

0000000080001060 <freeproc>:
{
    80001060:	1101                	add	sp,sp,-32
    80001062:	ec06                	sd	ra,24(sp)
    80001064:	e822                	sd	s0,16(sp)
    80001066:	e426                	sd	s1,8(sp)
    80001068:	1000                	add	s0,sp,32
    8000106a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000106c:	6d28                	ld	a0,88(a0)
    8000106e:	c509                	beqz	a0,80001078 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	fac080e7          	jalr	-84(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001078:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000107c:	68a8                	ld	a0,80(s1)
    8000107e:	c511                	beqz	a0,8000108a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001080:	64ac                	ld	a1,72(s1)
    80001082:	00000097          	auipc	ra,0x0
    80001086:	f8c080e7          	jalr	-116(ra) # 8000100e <proc_freepagetable>
  p->pagetable = 0;
    8000108a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000108e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001092:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001096:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000109a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000109e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010a2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010a6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010aa:	0004ac23          	sw	zero,24(s1)
}
    800010ae:	60e2                	ld	ra,24(sp)
    800010b0:	6442                	ld	s0,16(sp)
    800010b2:	64a2                	ld	s1,8(sp)
    800010b4:	6105                	add	sp,sp,32
    800010b6:	8082                	ret

00000000800010b8 <allocproc>:
{
    800010b8:	1101                	add	sp,sp,-32
    800010ba:	ec06                	sd	ra,24(sp)
    800010bc:	e822                	sd	s0,16(sp)
    800010be:	e426                	sd	s1,8(sp)
    800010c0:	e04a                	sd	s2,0(sp)
    800010c2:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c4:	00008497          	auipc	s1,0x8
    800010c8:	dfc48493          	add	s1,s1,-516 # 80008ec0 <proc>
    800010cc:	0000e917          	auipc	s2,0xe
    800010d0:	9f490913          	add	s2,s2,-1548 # 8000eac0 <tickslock>
    acquire(&p->lock);
    800010d4:	8526                	mv	a0,s1
    800010d6:	00005097          	auipc	ra,0x5
    800010da:	0b8080e7          	jalr	184(ra) # 8000618e <acquire>
    if(p->state == UNUSED) {
    800010de:	4c9c                	lw	a5,24(s1)
    800010e0:	cf81                	beqz	a5,800010f8 <allocproc+0x40>
      release(&p->lock);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00005097          	auipc	ra,0x5
    800010e8:	15e080e7          	jalr	350(ra) # 80006242 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ec:	17048493          	add	s1,s1,368
    800010f0:	ff2492e3          	bne	s1,s2,800010d4 <allocproc+0x1c>
  return 0;
    800010f4:	4481                	li	s1,0
    800010f6:	a889                	j	80001148 <allocproc+0x90>
  p->pid = allocpid();
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	e34080e7          	jalr	-460(ra) # 80000f2c <allocpid>
    80001100:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001102:	4785                	li	a5,1
    80001104:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	014080e7          	jalr	20(ra) # 8000011a <kalloc>
    8000110e:	892a                	mv	s2,a0
    80001110:	eca8                	sd	a0,88(s1)
    80001112:	c131                	beqz	a0,80001156 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	e5c080e7          	jalr	-420(ra) # 80000f72 <proc_pagetable>
    8000111e:	892a                	mv	s2,a0
    80001120:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001122:	c531                	beqz	a0,8000116e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001124:	07000613          	li	a2,112
    80001128:	4581                	li	a1,0
    8000112a:	06048513          	add	a0,s1,96
    8000112e:	fffff097          	auipc	ra,0xfffff
    80001132:	04c080e7          	jalr	76(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001136:	00000797          	auipc	a5,0x0
    8000113a:	dac78793          	add	a5,a5,-596 # 80000ee2 <forkret>
    8000113e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001140:	60bc                	ld	a5,64(s1)
    80001142:	6705                	lui	a4,0x1
    80001144:	97ba                	add	a5,a5,a4
    80001146:	f4bc                	sd	a5,104(s1)
}
    80001148:	8526                	mv	a0,s1
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6902                	ld	s2,0(sp)
    80001152:	6105                	add	sp,sp,32
    80001154:	8082                	ret
    freeproc(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	f08080e7          	jalr	-248(ra) # 80001060 <freeproc>
    release(&p->lock);
    80001160:	8526                	mv	a0,s1
    80001162:	00005097          	auipc	ra,0x5
    80001166:	0e0080e7          	jalr	224(ra) # 80006242 <release>
    return 0;
    8000116a:	84ca                	mv	s1,s2
    8000116c:	bff1                	j	80001148 <allocproc+0x90>
    freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ef0080e7          	jalr	-272(ra) # 80001060 <freeproc>
    release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	0c8080e7          	jalr	200(ra) # 80006242 <release>
    return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	b7d1                	j	80001148 <allocproc+0x90>

0000000080001186 <userinit>:
{
    80001186:	1101                	add	sp,sp,-32
    80001188:	ec06                	sd	ra,24(sp)
    8000118a:	e822                	sd	s0,16(sp)
    8000118c:	e426                	sd	s1,8(sp)
    8000118e:	1000                	add	s0,sp,32
  p = allocproc();
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f28080e7          	jalr	-216(ra) # 800010b8 <allocproc>
    80001198:	84aa                	mv	s1,a0
  initproc = p;
    8000119a:	00008797          	auipc	a5,0x8
    8000119e:	8aa7bb23          	sd	a0,-1866(a5) # 80008a50 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a2:	03400613          	li	a2,52
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	7aa58593          	add	a1,a1,1962 # 80008950 <initcode>
    800011ae:	6928                	ld	a0,80(a0)
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	670080e7          	jalr	1648(ra) # 80000820 <uvmfirst>
  p->sz = PGSIZE;
    800011b8:	6785                	lui	a5,0x1
    800011ba:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      /* user program counter */
    800011bc:	6cb8                	ld	a4,88(s1)
    800011be:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c6:	4641                	li	a2,16
    800011c8:	00007597          	auipc	a1,0x7
    800011cc:	ff858593          	add	a1,a1,-8 # 800081c0 <etext+0x1c0>
    800011d0:	15848513          	add	a0,s1,344
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	0ee080e7          	jalr	238(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011dc:	00007517          	auipc	a0,0x7
    800011e0:	ff450513          	add	a0,a0,-12 # 800081d0 <etext+0x1d0>
    800011e4:	00002097          	auipc	ra,0x2
    800011e8:	1bc080e7          	jalr	444(ra) # 800033a0 <namei>
    800011ec:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f0:	478d                	li	a5,3
    800011f2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	04c080e7          	jalr	76(ra) # 80006242 <release>
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6105                	add	sp,sp,32
    80001206:	8082                	ret

0000000080001208 <growproc>:
{
    80001208:	1101                	add	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	e04a                	sd	s2,0(sp)
    80001212:	1000                	add	s0,sp,32
    80001214:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	c94080e7          	jalr	-876(ra) # 80000eaa <myproc>
    8000121e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001220:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001222:	01204c63          	bgtz	s2,8000123a <growproc+0x32>
  } else if(n < 0){
    80001226:	02094663          	bltz	s2,80001252 <growproc+0x4a>
  p->sz = sz;
    8000122a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000122c:	4501                	li	a0,0
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	add	sp,sp,32
    80001238:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000123a:	4691                	li	a3,4
    8000123c:	00b90633          	add	a2,s2,a1
    80001240:	6928                	ld	a0,80(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	698080e7          	jalr	1688(ra) # 800008da <uvmalloc>
    8000124a:	85aa                	mv	a1,a0
    8000124c:	fd79                	bnez	a0,8000122a <growproc+0x22>
      return -1;
    8000124e:	557d                	li	a0,-1
    80001250:	bff9                	j	8000122e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001252:	00b90633          	add	a2,s2,a1
    80001256:	6928                	ld	a0,80(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	63a080e7          	jalr	1594(ra) # 80000892 <uvmdealloc>
    80001260:	85aa                	mv	a1,a0
    80001262:	b7e1                	j	8000122a <growproc+0x22>

0000000080001264 <fork>:
{
    80001264:	7139                	add	sp,sp,-64
    80001266:	fc06                	sd	ra,56(sp)
    80001268:	f822                	sd	s0,48(sp)
    8000126a:	f426                	sd	s1,40(sp)
    8000126c:	f04a                	sd	s2,32(sp)
    8000126e:	ec4e                	sd	s3,24(sp)
    80001270:	e852                	sd	s4,16(sp)
    80001272:	e456                	sd	s5,8(sp)
    80001274:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	c34080e7          	jalr	-972(ra) # 80000eaa <myproc>
    8000127e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001280:	00000097          	auipc	ra,0x0
    80001284:	e38080e7          	jalr	-456(ra) # 800010b8 <allocproc>
    80001288:	12050063          	beqz	a0,800013a8 <fork+0x144>
    8000128c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128e:	048ab603          	ld	a2,72(s5)
    80001292:	692c                	ld	a1,80(a0)
    80001294:	050ab503          	ld	a0,80(s5)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	79a080e7          	jalr	1946(ra) # 80000a32 <uvmcopy>
    800012a0:	04054863          	bltz	a0,800012f0 <fork+0x8c>
  np->sz = p->sz;
    800012a4:	048ab783          	ld	a5,72(s5)
    800012a8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012ac:	058ab683          	ld	a3,88(s5)
    800012b0:	87b6                	mv	a5,a3
    800012b2:	0589b703          	ld	a4,88(s3)
    800012b6:	12068693          	add	a3,a3,288
    800012ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012be:	6788                	ld	a0,8(a5)
    800012c0:	6b8c                	ld	a1,16(a5)
    800012c2:	6f90                	ld	a2,24(a5)
    800012c4:	01073023          	sd	a6,0(a4)
    800012c8:	e708                	sd	a0,8(a4)
    800012ca:	eb0c                	sd	a1,16(a4)
    800012cc:	ef10                	sd	a2,24(a4)
    800012ce:	02078793          	add	a5,a5,32
    800012d2:	02070713          	add	a4,a4,32
    800012d6:	fed792e3          	bne	a5,a3,800012ba <fork+0x56>
  np->trapframe->a0 = 0;
    800012da:	0589b783          	ld	a5,88(s3)
    800012de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e2:	0d0a8493          	add	s1,s5,208
    800012e6:	0d098913          	add	s2,s3,208
    800012ea:	150a8a13          	add	s4,s5,336
    800012ee:	a00d                	j	80001310 <fork+0xac>
    freeproc(np);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	d6e080e7          	jalr	-658(ra) # 80001060 <freeproc>
    release(&np->lock);
    800012fa:	854e                	mv	a0,s3
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	f46080e7          	jalr	-186(ra) # 80006242 <release>
    return -1;
    80001304:	597d                	li	s2,-1
    80001306:	a079                	j	80001394 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001308:	04a1                	add	s1,s1,8
    8000130a:	0921                	add	s2,s2,8
    8000130c:	01448b63          	beq	s1,s4,80001322 <fork+0xbe>
    if(p->ofile[i])
    80001310:	6088                	ld	a0,0(s1)
    80001312:	d97d                	beqz	a0,80001308 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001314:	00002097          	auipc	ra,0x2
    80001318:	6fe080e7          	jalr	1790(ra) # 80003a12 <filedup>
    8000131c:	00a93023          	sd	a0,0(s2)
    80001320:	b7e5                	j	80001308 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001322:	150ab503          	ld	a0,336(s5)
    80001326:	00002097          	auipc	ra,0x2
    8000132a:	896080e7          	jalr	-1898(ra) # 80002bbc <idup>
    8000132e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001332:	4641                	li	a2,16
    80001334:	158a8593          	add	a1,s5,344
    80001338:	15898513          	add	a0,s3,344
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	f86080e7          	jalr	-122(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001344:	0309a903          	lw	s2,48(s3)
  np->tmask = p->tmask;
    80001348:	168aa783          	lw	a5,360(s5)
    8000134c:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    80001350:	854e                	mv	a0,s3
    80001352:	00005097          	auipc	ra,0x5
    80001356:	ef0080e7          	jalr	-272(ra) # 80006242 <release>
  acquire(&wait_lock);
    8000135a:	00007497          	auipc	s1,0x7
    8000135e:	74e48493          	add	s1,s1,1870 # 80008aa8 <wait_lock>
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	e2a080e7          	jalr	-470(ra) # 8000618e <acquire>
  np->parent = p;
    8000136c:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001370:	8526                	mv	a0,s1
    80001372:	00005097          	auipc	ra,0x5
    80001376:	ed0080e7          	jalr	-304(ra) # 80006242 <release>
  acquire(&np->lock);
    8000137a:	854e                	mv	a0,s3
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	e12080e7          	jalr	-494(ra) # 8000618e <acquire>
  np->state = RUNNABLE;
    80001384:	478d                	li	a5,3
    80001386:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	eb6080e7          	jalr	-330(ra) # 80006242 <release>
}
    80001394:	854a                	mv	a0,s2
    80001396:	70e2                	ld	ra,56(sp)
    80001398:	7442                	ld	s0,48(sp)
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	69e2                	ld	s3,24(sp)
    800013a0:	6a42                	ld	s4,16(sp)
    800013a2:	6aa2                	ld	s5,8(sp)
    800013a4:	6121                	add	sp,sp,64
    800013a6:	8082                	ret
    return -1;
    800013a8:	597d                	li	s2,-1
    800013aa:	b7ed                	j	80001394 <fork+0x130>

00000000800013ac <scheduler>:
{
    800013ac:	7139                	add	sp,sp,-64
    800013ae:	fc06                	sd	ra,56(sp)
    800013b0:	f822                	sd	s0,48(sp)
    800013b2:	f426                	sd	s1,40(sp)
    800013b4:	f04a                	sd	s2,32(sp)
    800013b6:	ec4e                	sd	s3,24(sp)
    800013b8:	e852                	sd	s4,16(sp)
    800013ba:	e456                	sd	s5,8(sp)
    800013bc:	e05a                	sd	s6,0(sp)
    800013be:	0080                	add	s0,sp,64
    800013c0:	8792                	mv	a5,tp
  int id = r_tp();
    800013c2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c4:	00779a93          	sll	s5,a5,0x7
    800013c8:	00007717          	auipc	a4,0x7
    800013cc:	6c870713          	add	a4,a4,1736 # 80008a90 <pid_lock>
    800013d0:	9756                	add	a4,a4,s5
    800013d2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d6:	00007717          	auipc	a4,0x7
    800013da:	6f270713          	add	a4,a4,1778 # 80008ac8 <cpus+0x8>
    800013de:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013e0:	498d                	li	s3,3
        p->state = RUNNING;
    800013e2:	4b11                	li	s6,4
        c->proc = p;
    800013e4:	079e                	sll	a5,a5,0x7
    800013e6:	00007a17          	auipc	s4,0x7
    800013ea:	6aaa0a13          	add	s4,s4,1706 # 80008a90 <pid_lock>
    800013ee:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f0:	0000d917          	auipc	s2,0xd
    800013f4:	6d090913          	add	s2,s2,1744 # 8000eac0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fc:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001400:	10079073          	csrw	sstatus,a5
    80001404:	00008497          	auipc	s1,0x8
    80001408:	abc48493          	add	s1,s1,-1348 # 80008ec0 <proc>
    8000140c:	a811                	j	80001420 <scheduler+0x74>
      release(&p->lock);
    8000140e:	8526                	mv	a0,s1
    80001410:	00005097          	auipc	ra,0x5
    80001414:	e32080e7          	jalr	-462(ra) # 80006242 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001418:	17048493          	add	s1,s1,368
    8000141c:	fd248ee3          	beq	s1,s2,800013f8 <scheduler+0x4c>
      acquire(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	d6c080e7          	jalr	-660(ra) # 8000618e <acquire>
      if(p->state == RUNNABLE) {
    8000142a:	4c9c                	lw	a5,24(s1)
    8000142c:	ff3791e3          	bne	a5,s3,8000140e <scheduler+0x62>
        p->state = RUNNING;
    80001430:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001434:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001438:	06048593          	add	a1,s1,96
    8000143c:	8556                	mv	a0,s5
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	6a6080e7          	jalr	1702(ra) # 80001ae4 <swtch>
        c->proc = 0;
    80001446:	020a3823          	sd	zero,48(s4)
    8000144a:	b7d1                	j	8000140e <scheduler+0x62>

000000008000144c <sched>:
{
    8000144c:	7179                	add	sp,sp,-48
    8000144e:	f406                	sd	ra,40(sp)
    80001450:	f022                	sd	s0,32(sp)
    80001452:	ec26                	sd	s1,24(sp)
    80001454:	e84a                	sd	s2,16(sp)
    80001456:	e44e                	sd	s3,8(sp)
    80001458:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	a50080e7          	jalr	-1456(ra) # 80000eaa <myproc>
    80001462:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001464:	00005097          	auipc	ra,0x5
    80001468:	cb0080e7          	jalr	-848(ra) # 80006114 <holding>
    8000146c:	c93d                	beqz	a0,800014e2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	sll	a5,a5,0x7
    80001474:	00007717          	auipc	a4,0x7
    80001478:	61c70713          	add	a4,a4,1564 # 80008a90 <pid_lock>
    8000147c:	97ba                	add	a5,a5,a4
    8000147e:	0a87a703          	lw	a4,168(a5)
    80001482:	4785                	li	a5,1
    80001484:	06f71763          	bne	a4,a5,800014f2 <sched+0xa6>
  if(p->state == RUNNING)
    80001488:	4c98                	lw	a4,24(s1)
    8000148a:	4791                	li	a5,4
    8000148c:	06f70b63          	beq	a4,a5,80001502 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001490:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001494:	8b89                	and	a5,a5,2
  if(intr_get())
    80001496:	efb5                	bnez	a5,80001512 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001498:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000149a:	00007917          	auipc	s2,0x7
    8000149e:	5f690913          	add	s2,s2,1526 # 80008a90 <pid_lock>
    800014a2:	2781                	sext.w	a5,a5
    800014a4:	079e                	sll	a5,a5,0x7
    800014a6:	97ca                	add	a5,a5,s2
    800014a8:	0ac7a983          	lw	s3,172(a5)
    800014ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	sll	a5,a5,0x7
    800014b2:	00007597          	auipc	a1,0x7
    800014b6:	61658593          	add	a1,a1,1558 # 80008ac8 <cpus+0x8>
    800014ba:	95be                	add	a1,a1,a5
    800014bc:	06048513          	add	a0,s1,96
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	624080e7          	jalr	1572(ra) # 80001ae4 <swtch>
    800014c8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ca:	2781                	sext.w	a5,a5
    800014cc:	079e                	sll	a5,a5,0x7
    800014ce:	993e                	add	s2,s2,a5
    800014d0:	0b392623          	sw	s3,172(s2)
}
    800014d4:	70a2                	ld	ra,40(sp)
    800014d6:	7402                	ld	s0,32(sp)
    800014d8:	64e2                	ld	s1,24(sp)
    800014da:	6942                	ld	s2,16(sp)
    800014dc:	69a2                	ld	s3,8(sp)
    800014de:	6145                	add	sp,sp,48
    800014e0:	8082                	ret
    panic("sched p->lock");
    800014e2:	00007517          	auipc	a0,0x7
    800014e6:	cf650513          	add	a0,a0,-778 # 800081d8 <etext+0x1d8>
    800014ea:	00004097          	auipc	ra,0x4
    800014ee:	76c080e7          	jalr	1900(ra) # 80005c56 <panic>
    panic("sched locks");
    800014f2:	00007517          	auipc	a0,0x7
    800014f6:	cf650513          	add	a0,a0,-778 # 800081e8 <etext+0x1e8>
    800014fa:	00004097          	auipc	ra,0x4
    800014fe:	75c080e7          	jalr	1884(ra) # 80005c56 <panic>
    panic("sched running");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	cf650513          	add	a0,a0,-778 # 800081f8 <etext+0x1f8>
    8000150a:	00004097          	auipc	ra,0x4
    8000150e:	74c080e7          	jalr	1868(ra) # 80005c56 <panic>
    panic("sched interruptible");
    80001512:	00007517          	auipc	a0,0x7
    80001516:	cf650513          	add	a0,a0,-778 # 80008208 <etext+0x208>
    8000151a:	00004097          	auipc	ra,0x4
    8000151e:	73c080e7          	jalr	1852(ra) # 80005c56 <panic>

0000000080001522 <yield>:
{
    80001522:	1101                	add	sp,sp,-32
    80001524:	ec06                	sd	ra,24(sp)
    80001526:	e822                	sd	s0,16(sp)
    80001528:	e426                	sd	s1,8(sp)
    8000152a:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	97e080e7          	jalr	-1666(ra) # 80000eaa <myproc>
    80001534:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	c58080e7          	jalr	-936(ra) # 8000618e <acquire>
  p->state = RUNNABLE;
    8000153e:	478d                	li	a5,3
    80001540:	cc9c                	sw	a5,24(s1)
  sched();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	f0a080e7          	jalr	-246(ra) # 8000144c <sched>
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	cf6080e7          	jalr	-778(ra) # 80006242 <release>
}
    80001554:	60e2                	ld	ra,24(sp)
    80001556:	6442                	ld	s0,16(sp)
    80001558:	64a2                	ld	s1,8(sp)
    8000155a:	6105                	add	sp,sp,32
    8000155c:	8082                	ret

000000008000155e <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    8000155e:	7179                	add	sp,sp,-48
    80001560:	f406                	sd	ra,40(sp)
    80001562:	f022                	sd	s0,32(sp)
    80001564:	ec26                	sd	s1,24(sp)
    80001566:	e84a                	sd	s2,16(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	1800                	add	s0,sp,48
    8000156c:	89aa                	mv	s3,a0
    8000156e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	93a080e7          	jalr	-1734(ra) # 80000eaa <myproc>
    80001578:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	c14080e7          	jalr	-1004(ra) # 8000618e <acquire>
  release(lk);
    80001582:	854a                	mv	a0,s2
    80001584:	00005097          	auipc	ra,0x5
    80001588:	cbe080e7          	jalr	-834(ra) # 80006242 <release>

  /* Go to sleep. */
  p->chan = chan;
    8000158c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001590:	4789                	li	a5,2
    80001592:	cc9c                	sw	a5,24(s1)

  sched();
    80001594:	00000097          	auipc	ra,0x0
    80001598:	eb8080e7          	jalr	-328(ra) # 8000144c <sched>

  /* Tidy up. */
  p->chan = 0;
    8000159c:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	ca0080e7          	jalr	-864(ra) # 80006242 <release>
  acquire(lk);
    800015aa:	854a                	mv	a0,s2
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	be2080e7          	jalr	-1054(ra) # 8000618e <acquire>
}
    800015b4:	70a2                	ld	ra,40(sp)
    800015b6:	7402                	ld	s0,32(sp)
    800015b8:	64e2                	ld	s1,24(sp)
    800015ba:	6942                	ld	s2,16(sp)
    800015bc:	69a2                	ld	s3,8(sp)
    800015be:	6145                	add	sp,sp,48
    800015c0:	8082                	ret

00000000800015c2 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    800015c2:	7139                	add	sp,sp,-64
    800015c4:	fc06                	sd	ra,56(sp)
    800015c6:	f822                	sd	s0,48(sp)
    800015c8:	f426                	sd	s1,40(sp)
    800015ca:	f04a                	sd	s2,32(sp)
    800015cc:	ec4e                	sd	s3,24(sp)
    800015ce:	e852                	sd	s4,16(sp)
    800015d0:	e456                	sd	s5,8(sp)
    800015d2:	0080                	add	s0,sp,64
    800015d4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015d6:	00008497          	auipc	s1,0x8
    800015da:	8ea48493          	add	s1,s1,-1814 # 80008ec0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015de:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015e0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015e2:	0000d917          	auipc	s2,0xd
    800015e6:	4de90913          	add	s2,s2,1246 # 8000eac0 <tickslock>
    800015ea:	a811                	j	800015fe <wakeup+0x3c>
      }
      release(&p->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	c54080e7          	jalr	-940(ra) # 80006242 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015f6:	17048493          	add	s1,s1,368
    800015fa:	03248663          	beq	s1,s2,80001626 <wakeup+0x64>
    if(p != myproc()){
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	8ac080e7          	jalr	-1876(ra) # 80000eaa <myproc>
    80001606:	fea488e3          	beq	s1,a0,800015f6 <wakeup+0x34>
      acquire(&p->lock);
    8000160a:	8526                	mv	a0,s1
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	b82080e7          	jalr	-1150(ra) # 8000618e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001614:	4c9c                	lw	a5,24(s1)
    80001616:	fd379be3          	bne	a5,s3,800015ec <wakeup+0x2a>
    8000161a:	709c                	ld	a5,32(s1)
    8000161c:	fd4798e3          	bne	a5,s4,800015ec <wakeup+0x2a>
        p->state = RUNNABLE;
    80001620:	0154ac23          	sw	s5,24(s1)
    80001624:	b7e1                	j	800015ec <wakeup+0x2a>
    }
  }
}
    80001626:	70e2                	ld	ra,56(sp)
    80001628:	7442                	ld	s0,48(sp)
    8000162a:	74a2                	ld	s1,40(sp)
    8000162c:	7902                	ld	s2,32(sp)
    8000162e:	69e2                	ld	s3,24(sp)
    80001630:	6a42                	ld	s4,16(sp)
    80001632:	6aa2                	ld	s5,8(sp)
    80001634:	6121                	add	sp,sp,64
    80001636:	8082                	ret

0000000080001638 <reparent>:
{
    80001638:	7179                	add	sp,sp,-48
    8000163a:	f406                	sd	ra,40(sp)
    8000163c:	f022                	sd	s0,32(sp)
    8000163e:	ec26                	sd	s1,24(sp)
    80001640:	e84a                	sd	s2,16(sp)
    80001642:	e44e                	sd	s3,8(sp)
    80001644:	e052                	sd	s4,0(sp)
    80001646:	1800                	add	s0,sp,48
    80001648:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000164a:	00008497          	auipc	s1,0x8
    8000164e:	87648493          	add	s1,s1,-1930 # 80008ec0 <proc>
      pp->parent = initproc;
    80001652:	00007a17          	auipc	s4,0x7
    80001656:	3fea0a13          	add	s4,s4,1022 # 80008a50 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000165a:	0000d997          	auipc	s3,0xd
    8000165e:	46698993          	add	s3,s3,1126 # 8000eac0 <tickslock>
    80001662:	a029                	j	8000166c <reparent+0x34>
    80001664:	17048493          	add	s1,s1,368
    80001668:	01348d63          	beq	s1,s3,80001682 <reparent+0x4a>
    if(pp->parent == p){
    8000166c:	7c9c                	ld	a5,56(s1)
    8000166e:	ff279be3          	bne	a5,s2,80001664 <reparent+0x2c>
      pp->parent = initproc;
    80001672:	000a3503          	ld	a0,0(s4)
    80001676:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001678:	00000097          	auipc	ra,0x0
    8000167c:	f4a080e7          	jalr	-182(ra) # 800015c2 <wakeup>
    80001680:	b7d5                	j	80001664 <reparent+0x2c>
}
    80001682:	70a2                	ld	ra,40(sp)
    80001684:	7402                	ld	s0,32(sp)
    80001686:	64e2                	ld	s1,24(sp)
    80001688:	6942                	ld	s2,16(sp)
    8000168a:	69a2                	ld	s3,8(sp)
    8000168c:	6a02                	ld	s4,0(sp)
    8000168e:	6145                	add	sp,sp,48
    80001690:	8082                	ret

0000000080001692 <exit>:
{
    80001692:	7179                	add	sp,sp,-48
    80001694:	f406                	sd	ra,40(sp)
    80001696:	f022                	sd	s0,32(sp)
    80001698:	ec26                	sd	s1,24(sp)
    8000169a:	e84a                	sd	s2,16(sp)
    8000169c:	e44e                	sd	s3,8(sp)
    8000169e:	e052                	sd	s4,0(sp)
    800016a0:	1800                	add	s0,sp,48
    800016a2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	806080e7          	jalr	-2042(ra) # 80000eaa <myproc>
    800016ac:	89aa                	mv	s3,a0
  if(p == initproc)
    800016ae:	00007797          	auipc	a5,0x7
    800016b2:	3a27b783          	ld	a5,930(a5) # 80008a50 <initproc>
    800016b6:	0d050493          	add	s1,a0,208
    800016ba:	15050913          	add	s2,a0,336
    800016be:	02a79363          	bne	a5,a0,800016e4 <exit+0x52>
    panic("init exiting");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	b5e50513          	add	a0,a0,-1186 # 80008220 <etext+0x220>
    800016ca:	00004097          	auipc	ra,0x4
    800016ce:	58c080e7          	jalr	1420(ra) # 80005c56 <panic>
      fileclose(f);
    800016d2:	00002097          	auipc	ra,0x2
    800016d6:	392080e7          	jalr	914(ra) # 80003a64 <fileclose>
      p->ofile[fd] = 0;
    800016da:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016de:	04a1                	add	s1,s1,8
    800016e0:	01248563          	beq	s1,s2,800016ea <exit+0x58>
    if(p->ofile[fd]){
    800016e4:	6088                	ld	a0,0(s1)
    800016e6:	f575                	bnez	a0,800016d2 <exit+0x40>
    800016e8:	bfdd                	j	800016de <exit+0x4c>
  begin_op();
    800016ea:	00002097          	auipc	ra,0x2
    800016ee:	eb6080e7          	jalr	-330(ra) # 800035a0 <begin_op>
  iput(p->cwd);
    800016f2:	1509b503          	ld	a0,336(s3)
    800016f6:	00001097          	auipc	ra,0x1
    800016fa:	6be080e7          	jalr	1726(ra) # 80002db4 <iput>
  end_op();
    800016fe:	00002097          	auipc	ra,0x2
    80001702:	f1c080e7          	jalr	-228(ra) # 8000361a <end_op>
  p->cwd = 0;
    80001706:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000170a:	00007497          	auipc	s1,0x7
    8000170e:	39e48493          	add	s1,s1,926 # 80008aa8 <wait_lock>
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	a7a080e7          	jalr	-1414(ra) # 8000618e <acquire>
  reparent(p);
    8000171c:	854e                	mv	a0,s3
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	f1a080e7          	jalr	-230(ra) # 80001638 <reparent>
  wakeup(p->parent);
    80001726:	0389b503          	ld	a0,56(s3)
    8000172a:	00000097          	auipc	ra,0x0
    8000172e:	e98080e7          	jalr	-360(ra) # 800015c2 <wakeup>
  acquire(&p->lock);
    80001732:	854e                	mv	a0,s3
    80001734:	00005097          	auipc	ra,0x5
    80001738:	a5a080e7          	jalr	-1446(ra) # 8000618e <acquire>
  p->xstate = status;
    8000173c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001740:	4795                	li	a5,5
    80001742:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001746:	8526                	mv	a0,s1
    80001748:	00005097          	auipc	ra,0x5
    8000174c:	afa080e7          	jalr	-1286(ra) # 80006242 <release>
  sched();
    80001750:	00000097          	auipc	ra,0x0
    80001754:	cfc080e7          	jalr	-772(ra) # 8000144c <sched>
  panic("zombie exit");
    80001758:	00007517          	auipc	a0,0x7
    8000175c:	ad850513          	add	a0,a0,-1320 # 80008230 <etext+0x230>
    80001760:	00004097          	auipc	ra,0x4
    80001764:	4f6080e7          	jalr	1270(ra) # 80005c56 <panic>

0000000080001768 <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    80001768:	7179                	add	sp,sp,-48
    8000176a:	f406                	sd	ra,40(sp)
    8000176c:	f022                	sd	s0,32(sp)
    8000176e:	ec26                	sd	s1,24(sp)
    80001770:	e84a                	sd	s2,16(sp)
    80001772:	e44e                	sd	s3,8(sp)
    80001774:	1800                	add	s0,sp,48
    80001776:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001778:	00007497          	auipc	s1,0x7
    8000177c:	74848493          	add	s1,s1,1864 # 80008ec0 <proc>
    80001780:	0000d997          	auipc	s3,0xd
    80001784:	34098993          	add	s3,s3,832 # 8000eac0 <tickslock>
    acquire(&p->lock);
    80001788:	8526                	mv	a0,s1
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	a04080e7          	jalr	-1532(ra) # 8000618e <acquire>
    if(p->pid == pid){
    80001792:	589c                	lw	a5,48(s1)
    80001794:	01278d63          	beq	a5,s2,800017ae <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001798:	8526                	mv	a0,s1
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	aa8080e7          	jalr	-1368(ra) # 80006242 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017a2:	17048493          	add	s1,s1,368
    800017a6:	ff3491e3          	bne	s1,s3,80001788 <kill+0x20>
  }
  return -1;
    800017aa:	557d                	li	a0,-1
    800017ac:	a829                	j	800017c6 <kill+0x5e>
      p->killed = 1;
    800017ae:	4785                	li	a5,1
    800017b0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017b2:	4c98                	lw	a4,24(s1)
    800017b4:	4789                	li	a5,2
    800017b6:	00f70f63          	beq	a4,a5,800017d4 <kill+0x6c>
      release(&p->lock);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	a86080e7          	jalr	-1402(ra) # 80006242 <release>
      return 0;
    800017c4:	4501                	li	a0,0
}
    800017c6:	70a2                	ld	ra,40(sp)
    800017c8:	7402                	ld	s0,32(sp)
    800017ca:	64e2                	ld	s1,24(sp)
    800017cc:	6942                	ld	s2,16(sp)
    800017ce:	69a2                	ld	s3,8(sp)
    800017d0:	6145                	add	sp,sp,48
    800017d2:	8082                	ret
        p->state = RUNNABLE;
    800017d4:	478d                	li	a5,3
    800017d6:	cc9c                	sw	a5,24(s1)
    800017d8:	b7cd                	j	800017ba <kill+0x52>

00000000800017da <setkilled>:

void
setkilled(struct proc *p)
{
    800017da:	1101                	add	sp,sp,-32
    800017dc:	ec06                	sd	ra,24(sp)
    800017de:	e822                	sd	s0,16(sp)
    800017e0:	e426                	sd	s1,8(sp)
    800017e2:	1000                	add	s0,sp,32
    800017e4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	9a8080e7          	jalr	-1624(ra) # 8000618e <acquire>
  p->killed = 1;
    800017ee:	4785                	li	a5,1
    800017f0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017f2:	8526                	mv	a0,s1
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	a4e080e7          	jalr	-1458(ra) # 80006242 <release>
}
    800017fc:	60e2                	ld	ra,24(sp)
    800017fe:	6442                	ld	s0,16(sp)
    80001800:	64a2                	ld	s1,8(sp)
    80001802:	6105                	add	sp,sp,32
    80001804:	8082                	ret

0000000080001806 <killed>:

int
killed(struct proc *p)
{
    80001806:	1101                	add	sp,sp,-32
    80001808:	ec06                	sd	ra,24(sp)
    8000180a:	e822                	sd	s0,16(sp)
    8000180c:	e426                	sd	s1,8(sp)
    8000180e:	e04a                	sd	s2,0(sp)
    80001810:	1000                	add	s0,sp,32
    80001812:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001814:	00005097          	auipc	ra,0x5
    80001818:	97a080e7          	jalr	-1670(ra) # 8000618e <acquire>
  k = p->killed;
    8000181c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001820:	8526                	mv	a0,s1
    80001822:	00005097          	auipc	ra,0x5
    80001826:	a20080e7          	jalr	-1504(ra) # 80006242 <release>
  return k;
}
    8000182a:	854a                	mv	a0,s2
    8000182c:	60e2                	ld	ra,24(sp)
    8000182e:	6442                	ld	s0,16(sp)
    80001830:	64a2                	ld	s1,8(sp)
    80001832:	6902                	ld	s2,0(sp)
    80001834:	6105                	add	sp,sp,32
    80001836:	8082                	ret

0000000080001838 <wait>:
{
    80001838:	715d                	add	sp,sp,-80
    8000183a:	e486                	sd	ra,72(sp)
    8000183c:	e0a2                	sd	s0,64(sp)
    8000183e:	fc26                	sd	s1,56(sp)
    80001840:	f84a                	sd	s2,48(sp)
    80001842:	f44e                	sd	s3,40(sp)
    80001844:	f052                	sd	s4,32(sp)
    80001846:	ec56                	sd	s5,24(sp)
    80001848:	e85a                	sd	s6,16(sp)
    8000184a:	e45e                	sd	s7,8(sp)
    8000184c:	e062                	sd	s8,0(sp)
    8000184e:	0880                	add	s0,sp,80
    80001850:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001852:	fffff097          	auipc	ra,0xfffff
    80001856:	658080e7          	jalr	1624(ra) # 80000eaa <myproc>
    8000185a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000185c:	00007517          	auipc	a0,0x7
    80001860:	24c50513          	add	a0,a0,588 # 80008aa8 <wait_lock>
    80001864:	00005097          	auipc	ra,0x5
    80001868:	92a080e7          	jalr	-1750(ra) # 8000618e <acquire>
    havekids = 0;
    8000186c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000186e:	4a15                	li	s4,5
        havekids = 1;
    80001870:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001872:	0000d997          	auipc	s3,0xd
    80001876:	24e98993          	add	s3,s3,590 # 8000eac0 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    8000187a:	00007c17          	auipc	s8,0x7
    8000187e:	22ec0c13          	add	s8,s8,558 # 80008aa8 <wait_lock>
    80001882:	a0d1                	j	80001946 <wait+0x10e>
          pid = pp->pid;
    80001884:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001888:	000b0e63          	beqz	s6,800018a4 <wait+0x6c>
    8000188c:	4691                	li	a3,4
    8000188e:	02c48613          	add	a2,s1,44
    80001892:	85da                	mv	a1,s6
    80001894:	05093503          	ld	a0,80(s2)
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	29e080e7          	jalr	670(ra) # 80000b36 <copyout>
    800018a0:	04054163          	bltz	a0,800018e2 <wait+0xaa>
          freeproc(pp);
    800018a4:	8526                	mv	a0,s1
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	7ba080e7          	jalr	1978(ra) # 80001060 <freeproc>
          release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	992080e7          	jalr	-1646(ra) # 80006242 <release>
          release(&wait_lock);
    800018b8:	00007517          	auipc	a0,0x7
    800018bc:	1f050513          	add	a0,a0,496 # 80008aa8 <wait_lock>
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	982080e7          	jalr	-1662(ra) # 80006242 <release>
}
    800018c8:	854e                	mv	a0,s3
    800018ca:	60a6                	ld	ra,72(sp)
    800018cc:	6406                	ld	s0,64(sp)
    800018ce:	74e2                	ld	s1,56(sp)
    800018d0:	7942                	ld	s2,48(sp)
    800018d2:	79a2                	ld	s3,40(sp)
    800018d4:	7a02                	ld	s4,32(sp)
    800018d6:	6ae2                	ld	s5,24(sp)
    800018d8:	6b42                	ld	s6,16(sp)
    800018da:	6ba2                	ld	s7,8(sp)
    800018dc:	6c02                	ld	s8,0(sp)
    800018de:	6161                	add	sp,sp,80
    800018e0:	8082                	ret
            release(&pp->lock);
    800018e2:	8526                	mv	a0,s1
    800018e4:	00005097          	auipc	ra,0x5
    800018e8:	95e080e7          	jalr	-1698(ra) # 80006242 <release>
            release(&wait_lock);
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	1bc50513          	add	a0,a0,444 # 80008aa8 <wait_lock>
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	94e080e7          	jalr	-1714(ra) # 80006242 <release>
            return -1;
    800018fc:	59fd                	li	s3,-1
    800018fe:	b7e9                	j	800018c8 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001900:	17048493          	add	s1,s1,368
    80001904:	03348463          	beq	s1,s3,8000192c <wait+0xf4>
      if(pp->parent == p){
    80001908:	7c9c                	ld	a5,56(s1)
    8000190a:	ff279be3          	bne	a5,s2,80001900 <wait+0xc8>
        acquire(&pp->lock);
    8000190e:	8526                	mv	a0,s1
    80001910:	00005097          	auipc	ra,0x5
    80001914:	87e080e7          	jalr	-1922(ra) # 8000618e <acquire>
        if(pp->state == ZOMBIE){
    80001918:	4c9c                	lw	a5,24(s1)
    8000191a:	f74785e3          	beq	a5,s4,80001884 <wait+0x4c>
        release(&pp->lock);
    8000191e:	8526                	mv	a0,s1
    80001920:	00005097          	auipc	ra,0x5
    80001924:	922080e7          	jalr	-1758(ra) # 80006242 <release>
        havekids = 1;
    80001928:	8756                	mv	a4,s5
    8000192a:	bfd9                	j	80001900 <wait+0xc8>
    if(!havekids || killed(p)){
    8000192c:	c31d                	beqz	a4,80001952 <wait+0x11a>
    8000192e:	854a                	mv	a0,s2
    80001930:	00000097          	auipc	ra,0x0
    80001934:	ed6080e7          	jalr	-298(ra) # 80001806 <killed>
    80001938:	ed09                	bnez	a0,80001952 <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    8000193a:	85e2                	mv	a1,s8
    8000193c:	854a                	mv	a0,s2
    8000193e:	00000097          	auipc	ra,0x0
    80001942:	c20080e7          	jalr	-992(ra) # 8000155e <sleep>
    havekids = 0;
    80001946:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001948:	00007497          	auipc	s1,0x7
    8000194c:	57848493          	add	s1,s1,1400 # 80008ec0 <proc>
    80001950:	bf65                	j	80001908 <wait+0xd0>
      release(&wait_lock);
    80001952:	00007517          	auipc	a0,0x7
    80001956:	15650513          	add	a0,a0,342 # 80008aa8 <wait_lock>
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	8e8080e7          	jalr	-1816(ra) # 80006242 <release>
      return -1;
    80001962:	59fd                	li	s3,-1
    80001964:	b795                	j	800018c8 <wait+0x90>

0000000080001966 <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001966:	7179                	add	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	e052                	sd	s4,0(sp)
    80001974:	1800                	add	s0,sp,48
    80001976:	84aa                	mv	s1,a0
    80001978:	892e                	mv	s2,a1
    8000197a:	89b2                	mv	s3,a2
    8000197c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	52c080e7          	jalr	1324(ra) # 80000eaa <myproc>
  if(user_dst){
    80001986:	c08d                	beqz	s1,800019a8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001988:	86d2                	mv	a3,s4
    8000198a:	864e                	mv	a2,s3
    8000198c:	85ca                	mv	a1,s2
    8000198e:	6928                	ld	a0,80(a0)
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	1a6080e7          	jalr	422(ra) # 80000b36 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001998:	70a2                	ld	ra,40(sp)
    8000199a:	7402                	ld	s0,32(sp)
    8000199c:	64e2                	ld	s1,24(sp)
    8000199e:	6942                	ld	s2,16(sp)
    800019a0:	69a2                	ld	s3,8(sp)
    800019a2:	6a02                	ld	s4,0(sp)
    800019a4:	6145                	add	sp,sp,48
    800019a6:	8082                	ret
    memmove((char *)dst, src, len);
    800019a8:	000a061b          	sext.w	a2,s4
    800019ac:	85ce                	mv	a1,s3
    800019ae:	854a                	mv	a0,s2
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	826080e7          	jalr	-2010(ra) # 800001d6 <memmove>
    return 0;
    800019b8:	8526                	mv	a0,s1
    800019ba:	bff9                	j	80001998 <either_copyout+0x32>

00000000800019bc <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019bc:	7179                	add	sp,sp,-48
    800019be:	f406                	sd	ra,40(sp)
    800019c0:	f022                	sd	s0,32(sp)
    800019c2:	ec26                	sd	s1,24(sp)
    800019c4:	e84a                	sd	s2,16(sp)
    800019c6:	e44e                	sd	s3,8(sp)
    800019c8:	e052                	sd	s4,0(sp)
    800019ca:	1800                	add	s0,sp,48
    800019cc:	892a                	mv	s2,a0
    800019ce:	84ae                	mv	s1,a1
    800019d0:	89b2                	mv	s3,a2
    800019d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	4d6080e7          	jalr	1238(ra) # 80000eaa <myproc>
  if(user_src){
    800019dc:	c08d                	beqz	s1,800019fe <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019de:	86d2                	mv	a3,s4
    800019e0:	864e                	mv	a2,s3
    800019e2:	85ca                	mv	a1,s2
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	210080e7          	jalr	528(ra) # 80000bf6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019ee:	70a2                	ld	ra,40(sp)
    800019f0:	7402                	ld	s0,32(sp)
    800019f2:	64e2                	ld	s1,24(sp)
    800019f4:	6942                	ld	s2,16(sp)
    800019f6:	69a2                	ld	s3,8(sp)
    800019f8:	6a02                	ld	s4,0(sp)
    800019fa:	6145                	add	sp,sp,48
    800019fc:	8082                	ret
    memmove(dst, (char*)src, len);
    800019fe:	000a061b          	sext.w	a2,s4
    80001a02:	85ce                	mv	a1,s3
    80001a04:	854a                	mv	a0,s2
    80001a06:	ffffe097          	auipc	ra,0xffffe
    80001a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
    return 0;
    80001a0e:	8526                	mv	a0,s1
    80001a10:	bff9                	j	800019ee <either_copyin+0x32>

0000000080001a12 <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    80001a12:	715d                	add	sp,sp,-80
    80001a14:	e486                	sd	ra,72(sp)
    80001a16:	e0a2                	sd	s0,64(sp)
    80001a18:	fc26                	sd	s1,56(sp)
    80001a1a:	f84a                	sd	s2,48(sp)
    80001a1c:	f44e                	sd	s3,40(sp)
    80001a1e:	f052                	sd	s4,32(sp)
    80001a20:	ec56                	sd	s5,24(sp)
    80001a22:	e85a                	sd	s6,16(sp)
    80001a24:	e45e                	sd	s7,8(sp)
    80001a26:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a28:	00006517          	auipc	a0,0x6
    80001a2c:	62050513          	add	a0,a0,1568 # 80008048 <etext+0x48>
    80001a30:	00004097          	auipc	ra,0x4
    80001a34:	270080e7          	jalr	624(ra) # 80005ca0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a38:	00007497          	auipc	s1,0x7
    80001a3c:	5e048493          	add	s1,s1,1504 # 80009018 <proc+0x158>
    80001a40:	0000d917          	auipc	s2,0xd
    80001a44:	1d890913          	add	s2,s2,472 # 8000ec18 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a48:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a4a:	00006997          	auipc	s3,0x6
    80001a4e:	7f698993          	add	s3,s3,2038 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a52:	00006a97          	auipc	s5,0x6
    80001a56:	7f6a8a93          	add	s5,s5,2038 # 80008248 <etext+0x248>
    printf("\n");
    80001a5a:	00006a17          	auipc	s4,0x6
    80001a5e:	5eea0a13          	add	s4,s4,1518 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a62:	00007b97          	auipc	s7,0x7
    80001a66:	826b8b93          	add	s7,s7,-2010 # 80008288 <states.0>
    80001a6a:	a00d                	j	80001a8c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a6c:	ed86a583          	lw	a1,-296(a3)
    80001a70:	8556                	mv	a0,s5
    80001a72:	00004097          	auipc	ra,0x4
    80001a76:	22e080e7          	jalr	558(ra) # 80005ca0 <printf>
    printf("\n");
    80001a7a:	8552                	mv	a0,s4
    80001a7c:	00004097          	auipc	ra,0x4
    80001a80:	224080e7          	jalr	548(ra) # 80005ca0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a84:	17048493          	add	s1,s1,368
    80001a88:	03248263          	beq	s1,s2,80001aac <procdump+0x9a>
    if(p->state == UNUSED)
    80001a8c:	86a6                	mv	a3,s1
    80001a8e:	ec04a783          	lw	a5,-320(s1)
    80001a92:	dbed                	beqz	a5,80001a84 <procdump+0x72>
      state = "???";
    80001a94:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a96:	fcfb6be3          	bltu	s6,a5,80001a6c <procdump+0x5a>
    80001a9a:	02079713          	sll	a4,a5,0x20
    80001a9e:	01d75793          	srl	a5,a4,0x1d
    80001aa2:	97de                	add	a5,a5,s7
    80001aa4:	6390                	ld	a2,0(a5)
    80001aa6:	f279                	bnez	a2,80001a6c <procdump+0x5a>
      state = "???";
    80001aa8:	864e                	mv	a2,s3
    80001aaa:	b7c9                	j	80001a6c <procdump+0x5a>
  }
}
    80001aac:	60a6                	ld	ra,72(sp)
    80001aae:	6406                	ld	s0,64(sp)
    80001ab0:	74e2                	ld	s1,56(sp)
    80001ab2:	7942                	ld	s2,48(sp)
    80001ab4:	79a2                	ld	s3,40(sp)
    80001ab6:	7a02                	ld	s4,32(sp)
    80001ab8:	6ae2                	ld	s5,24(sp)
    80001aba:	6b42                	ld	s6,16(sp)
    80001abc:	6ba2                	ld	s7,8(sp)
    80001abe:	6161                	add	sp,sp,80
    80001ac0:	8082                	ret

0000000080001ac2 <trace>:
/* Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

void
trace(int mask)
{
    80001ac2:	1101                	add	sp,sp,-32
    80001ac4:	ec06                	sd	ra,24(sp)
    80001ac6:	e822                	sd	s0,16(sp)
    80001ac8:	e426                	sd	s1,8(sp)
    80001aca:	1000                	add	s0,sp,32
    80001acc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	3dc080e7          	jalr	988(ra) # 80000eaa <myproc>
  p->tmask = mask;
    80001ad6:	16952423          	sw	s1,360(a0)
}
    80001ada:	60e2                	ld	ra,24(sp)
    80001adc:	6442                	ld	s0,16(sp)
    80001ade:	64a2                	ld	s1,8(sp)
    80001ae0:	6105                	add	sp,sp,32
    80001ae2:	8082                	ret

0000000080001ae4 <swtch>:
    80001ae4:	00153023          	sd	ra,0(a0)
    80001ae8:	00253423          	sd	sp,8(a0)
    80001aec:	e900                	sd	s0,16(a0)
    80001aee:	ed04                	sd	s1,24(a0)
    80001af0:	03253023          	sd	s2,32(a0)
    80001af4:	03353423          	sd	s3,40(a0)
    80001af8:	03453823          	sd	s4,48(a0)
    80001afc:	03553c23          	sd	s5,56(a0)
    80001b00:	05653023          	sd	s6,64(a0)
    80001b04:	05753423          	sd	s7,72(a0)
    80001b08:	05853823          	sd	s8,80(a0)
    80001b0c:	05953c23          	sd	s9,88(a0)
    80001b10:	07a53023          	sd	s10,96(a0)
    80001b14:	07b53423          	sd	s11,104(a0)
    80001b18:	0005b083          	ld	ra,0(a1)
    80001b1c:	0085b103          	ld	sp,8(a1)
    80001b20:	6980                	ld	s0,16(a1)
    80001b22:	6d84                	ld	s1,24(a1)
    80001b24:	0205b903          	ld	s2,32(a1)
    80001b28:	0285b983          	ld	s3,40(a1)
    80001b2c:	0305ba03          	ld	s4,48(a1)
    80001b30:	0385ba83          	ld	s5,56(a1)
    80001b34:	0405bb03          	ld	s6,64(a1)
    80001b38:	0485bb83          	ld	s7,72(a1)
    80001b3c:	0505bc03          	ld	s8,80(a1)
    80001b40:	0585bc83          	ld	s9,88(a1)
    80001b44:	0605bd03          	ld	s10,96(a1)
    80001b48:	0685bd83          	ld	s11,104(a1)
    80001b4c:	8082                	ret

0000000080001b4e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b4e:	1141                	add	sp,sp,-16
    80001b50:	e406                	sd	ra,8(sp)
    80001b52:	e022                	sd	s0,0(sp)
    80001b54:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b56:	00006597          	auipc	a1,0x6
    80001b5a:	76258593          	add	a1,a1,1890 # 800082b8 <states.0+0x30>
    80001b5e:	0000d517          	auipc	a0,0xd
    80001b62:	f6250513          	add	a0,a0,-158 # 8000eac0 <tickslock>
    80001b66:	00004097          	auipc	ra,0x4
    80001b6a:	598080e7          	jalr	1432(ra) # 800060fe <initlock>
}
    80001b6e:	60a2                	ld	ra,8(sp)
    80001b70:	6402                	ld	s0,0(sp)
    80001b72:	0141                	add	sp,sp,16
    80001b74:	8082                	ret

0000000080001b76 <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    80001b76:	1141                	add	sp,sp,-16
    80001b78:	e422                	sd	s0,8(sp)
    80001b7a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7c:	00003797          	auipc	a5,0x3
    80001b80:	51478793          	add	a5,a5,1300 # 80005090 <kernelvec>
    80001b84:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b88:	6422                	ld	s0,8(sp)
    80001b8a:	0141                	add	sp,sp,16
    80001b8c:	8082                	ret

0000000080001b8e <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80001b8e:	1141                	add	sp,sp,-16
    80001b90:	e406                	sd	ra,8(sp)
    80001b92:	e022                	sd	s0,0(sp)
    80001b94:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	314080e7          	jalr	788(ra) # 80000eaa <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba4:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ba8:	00005697          	auipc	a3,0x5
    80001bac:	45868693          	add	a3,a3,1112 # 80007000 <_trampoline>
    80001bb0:	00005717          	auipc	a4,0x5
    80001bb4:	45070713          	add	a4,a4,1104 # 80007000 <_trampoline>
    80001bb8:	8f15                	sub	a4,a4,a3
    80001bba:	040007b7          	lui	a5,0x4000
    80001bbe:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bc0:	07b2                	sll	a5,a5,0xc
    80001bc2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    80001bc8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bca:	18002673          	csrr	a2,satp
    80001bce:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80001bd0:	6d30                	ld	a2,88(a0)
    80001bd2:	6138                	ld	a4,64(a0)
    80001bd4:	6585                	lui	a1,0x1
    80001bd6:	972e                	add	a4,a4,a1
    80001bd8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bda:	6d38                	ld	a4,88(a0)
    80001bdc:	00000617          	auipc	a2,0x0
    80001be0:	13460613          	add	a2,a2,308 # 80001d10 <usertrap>
    80001be4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    80001be6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001be8:	8612                	mv	a2,tp
    80001bea:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bec:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    80001bf0:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    80001bf4:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bfe:	6f18                	ld	a4,24(a4)
    80001c00:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c04:	6928                	ld	a0,80(a0)
    80001c06:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c08:	00005717          	auipc	a4,0x5
    80001c0c:	49470713          	add	a4,a4,1172 # 8000709c <userret>
    80001c10:	8f15                	sub	a4,a4,a3
    80001c12:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c14:	577d                	li	a4,-1
    80001c16:	177e                	sll	a4,a4,0x3f
    80001c18:	8d59                	or	a0,a0,a4
    80001c1a:	9782                	jalr	a5
}
    80001c1c:	60a2                	ld	ra,8(sp)
    80001c1e:	6402                	ld	s0,0(sp)
    80001c20:	0141                	add	sp,sp,16
    80001c22:	8082                	ret

0000000080001c24 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c24:	1101                	add	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001c2e:	0000d497          	auipc	s1,0xd
    80001c32:	e9248493          	add	s1,s1,-366 # 8000eac0 <tickslock>
    80001c36:	8526                	mv	a0,s1
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	556080e7          	jalr	1366(ra) # 8000618e <acquire>
  ticks++;
    80001c40:	00007517          	auipc	a0,0x7
    80001c44:	e1850513          	add	a0,a0,-488 # 80008a58 <ticks>
    80001c48:	411c                	lw	a5,0(a0)
    80001c4a:	2785                	addw	a5,a5,1
    80001c4c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c4e:	00000097          	auipc	ra,0x0
    80001c52:	974080e7          	jalr	-1676(ra) # 800015c2 <wakeup>
  release(&tickslock);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	5ea080e7          	jalr	1514(ra) # 80006242 <release>
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	add	sp,sp,32
    80001c68:	8082                	ret

0000000080001c6a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6a:	142027f3          	csrr	a5,scause
    /* the SSIP bit in sip. */
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c6e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c70:	0807df63          	bgez	a5,80001d0e <devintr+0xa4>
{
    80001c74:	1101                	add	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001c7e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c82:	46a5                	li	a3,9
    80001c84:	00d70d63          	beq	a4,a3,80001c9e <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c88:	577d                	li	a4,-1
    80001c8a:	177e                	sll	a4,a4,0x3f
    80001c8c:	0705                	add	a4,a4,1
    return 0;
    80001c8e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c90:	04e78e63          	beq	a5,a4,80001cec <devintr+0x82>
  }
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	add	sp,sp,32
    80001c9c:	8082                	ret
    int irq = plic_claim();
    80001c9e:	00003097          	auipc	ra,0x3
    80001ca2:	4fa080e7          	jalr	1274(ra) # 80005198 <plic_claim>
    80001ca6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ca8:	47a9                	li	a5,10
    80001caa:	02f50763          	beq	a0,a5,80001cd8 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001cae:	4785                	li	a5,1
    80001cb0:	02f50963          	beq	a0,a5,80001ce2 <devintr+0x78>
    return 1;
    80001cb4:	4505                	li	a0,1
    } else if(irq){
    80001cb6:	dcf9                	beqz	s1,80001c94 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb8:	85a6                	mv	a1,s1
    80001cba:	00006517          	auipc	a0,0x6
    80001cbe:	60650513          	add	a0,a0,1542 # 800082c0 <states.0+0x38>
    80001cc2:	00004097          	auipc	ra,0x4
    80001cc6:	fde080e7          	jalr	-34(ra) # 80005ca0 <printf>
      plic_complete(irq);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00003097          	auipc	ra,0x3
    80001cd0:	4f0080e7          	jalr	1264(ra) # 800051bc <plic_complete>
    return 1;
    80001cd4:	4505                	li	a0,1
    80001cd6:	bf7d                	j	80001c94 <devintr+0x2a>
      uartintr();
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	3d6080e7          	jalr	982(ra) # 800060ae <uartintr>
    if(irq)
    80001ce0:	b7ed                	j	80001cca <devintr+0x60>
      virtio_disk_intr();
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	9a0080e7          	jalr	-1632(ra) # 80005682 <virtio_disk_intr>
    if(irq)
    80001cea:	b7c5                	j	80001cca <devintr+0x60>
    if(cpuid() == 0){
    80001cec:	fffff097          	auipc	ra,0xfffff
    80001cf0:	192080e7          	jalr	402(ra) # 80000e7e <cpuid>
    80001cf4:	c901                	beqz	a0,80001d04 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cf6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cfa:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cfc:	14479073          	csrw	sip,a5
    return 2;
    80001d00:	4509                	li	a0,2
    80001d02:	bf49                	j	80001c94 <devintr+0x2a>
      clockintr();
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	f20080e7          	jalr	-224(ra) # 80001c24 <clockintr>
    80001d0c:	b7ed                	j	80001cf6 <devintr+0x8c>
}
    80001d0e:	8082                	ret

0000000080001d10 <usertrap>:
{
    80001d10:	1101                	add	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	e426                	sd	s1,8(sp)
    80001d18:	e04a                	sd	s2,0(sp)
    80001d1a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d20:	1007f793          	and	a5,a5,256
    80001d24:	e3b1                	bnez	a5,80001d68 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d26:	00003797          	auipc	a5,0x3
    80001d2a:	36a78793          	add	a5,a5,874 # 80005090 <kernelvec>
    80001d2e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	178080e7          	jalr	376(ra) # 80000eaa <myproc>
    80001d3a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3e:	14102773          	csrr	a4,sepc
    80001d42:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d44:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d48:	47a1                	li	a5,8
    80001d4a:	02f70763          	beq	a4,a5,80001d78 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	f1c080e7          	jalr	-228(ra) # 80001c6a <devintr>
    80001d56:	892a                	mv	s2,a0
    80001d58:	c151                	beqz	a0,80001ddc <usertrap+0xcc>
  if(killed(p))
    80001d5a:	8526                	mv	a0,s1
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	aaa080e7          	jalr	-1366(ra) # 80001806 <killed>
    80001d64:	c929                	beqz	a0,80001db6 <usertrap+0xa6>
    80001d66:	a099                	j	80001dac <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d68:	00006517          	auipc	a0,0x6
    80001d6c:	57850513          	add	a0,a0,1400 # 800082e0 <states.0+0x58>
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	ee6080e7          	jalr	-282(ra) # 80005c56 <panic>
    if(killed(p))
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	a8e080e7          	jalr	-1394(ra) # 80001806 <killed>
    80001d80:	e921                	bnez	a0,80001dd0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d82:	6cb8                	ld	a4,88(s1)
    80001d84:	6f1c                	ld	a5,24(a4)
    80001d86:	0791                	add	a5,a5,4
    80001d88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d8e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d92:	10079073          	csrw	sstatus,a5
    syscall();
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	2d4080e7          	jalr	724(ra) # 8000206a <syscall>
  if(killed(p))
    80001d9e:	8526                	mv	a0,s1
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	a66080e7          	jalr	-1434(ra) # 80001806 <killed>
    80001da8:	c911                	beqz	a0,80001dbc <usertrap+0xac>
    80001daa:	4901                	li	s2,0
    exit(-1);
    80001dac:	557d                	li	a0,-1
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	8e4080e7          	jalr	-1820(ra) # 80001692 <exit>
  if(which_dev == 2)
    80001db6:	4789                	li	a5,2
    80001db8:	04f90f63          	beq	s2,a5,80001e16 <usertrap+0x106>
  usertrapret();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	dd2080e7          	jalr	-558(ra) # 80001b8e <usertrapret>
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	6902                	ld	s2,0(sp)
    80001dcc:	6105                	add	sp,sp,32
    80001dce:	8082                	ret
      exit(-1);
    80001dd0:	557d                	li	a0,-1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	8c0080e7          	jalr	-1856(ra) # 80001692 <exit>
    80001dda:	b765                	j	80001d82 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ddc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001de0:	5890                	lw	a2,48(s1)
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	51e50513          	add	a0,a0,1310 # 80008300 <states.0+0x78>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	eb6080e7          	jalr	-330(ra) # 80005ca0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	53650513          	add	a0,a0,1334 # 80008330 <states.0+0xa8>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	e9e080e7          	jalr	-354(ra) # 80005ca0 <printf>
    setkilled(p);
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	9ce080e7          	jalr	-1586(ra) # 800017da <setkilled>
    80001e14:	b769                	j	80001d9e <usertrap+0x8e>
    yield();
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	70c080e7          	jalr	1804(ra) # 80001522 <yield>
    80001e1e:	bf79                	j	80001dbc <usertrap+0xac>

0000000080001e20 <kerneltrap>:
{
    80001e20:	7179                	add	sp,sp,-48
    80001e22:	f406                	sd	ra,40(sp)
    80001e24:	f022                	sd	s0,32(sp)
    80001e26:	ec26                	sd	s1,24(sp)
    80001e28:	e84a                	sd	s2,16(sp)
    80001e2a:	e44e                	sd	s3,8(sp)
    80001e2c:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e32:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e36:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e3a:	1004f793          	and	a5,s1,256
    80001e3e:	cb85                	beqz	a5,80001e6e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e40:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e44:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001e46:	ef85                	bnez	a5,80001e7e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e48:	00000097          	auipc	ra,0x0
    80001e4c:	e22080e7          	jalr	-478(ra) # 80001c6a <devintr>
    80001e50:	cd1d                	beqz	a0,80001e8e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e52:	4789                	li	a5,2
    80001e54:	06f50a63          	beq	a0,a5,80001ec8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e58:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5c:	10049073          	csrw	sstatus,s1
}
    80001e60:	70a2                	ld	ra,40(sp)
    80001e62:	7402                	ld	s0,32(sp)
    80001e64:	64e2                	ld	s1,24(sp)
    80001e66:	6942                	ld	s2,16(sp)
    80001e68:	69a2                	ld	s3,8(sp)
    80001e6a:	6145                	add	sp,sp,48
    80001e6c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	4e250513          	add	a0,a0,1250 # 80008350 <states.0+0xc8>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	de0080e7          	jalr	-544(ra) # 80005c56 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	4fa50513          	add	a0,a0,1274 # 80008378 <states.0+0xf0>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	dd0080e7          	jalr	-560(ra) # 80005c56 <panic>
    printf("scause %p\n", scause);
    80001e8e:	85ce                	mv	a1,s3
    80001e90:	00006517          	auipc	a0,0x6
    80001e94:	50850513          	add	a0,a0,1288 # 80008398 <states.0+0x110>
    80001e98:	00004097          	auipc	ra,0x4
    80001e9c:	e08080e7          	jalr	-504(ra) # 80005ca0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ea4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea8:	00006517          	auipc	a0,0x6
    80001eac:	50050513          	add	a0,a0,1280 # 800083a8 <states.0+0x120>
    80001eb0:	00004097          	auipc	ra,0x4
    80001eb4:	df0080e7          	jalr	-528(ra) # 80005ca0 <printf>
    panic("kerneltrap");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	50850513          	add	a0,a0,1288 # 800083c0 <states.0+0x138>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	d96080e7          	jalr	-618(ra) # 80005c56 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	fe2080e7          	jalr	-30(ra) # 80000eaa <myproc>
    80001ed0:	d541                	beqz	a0,80001e58 <kerneltrap+0x38>
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	fd8080e7          	jalr	-40(ra) # 80000eaa <myproc>
    80001eda:	4d18                	lw	a4,24(a0)
    80001edc:	4791                	li	a5,4
    80001ede:	f6f71de3          	bne	a4,a5,80001e58 <kerneltrap+0x38>
    yield();
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	640080e7          	jalr	1600(ra) # 80001522 <yield>
    80001eea:	b7bd                	j	80001e58 <kerneltrap+0x38>

0000000080001eec <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eec:	1101                	add	sp,sp,-32
    80001eee:	ec06                	sd	ra,24(sp)
    80001ef0:	e822                	sd	s0,16(sp)
    80001ef2:	e426                	sd	s1,8(sp)
    80001ef4:	1000                	add	s0,sp,32
    80001ef6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	fb2080e7          	jalr	-78(ra) # 80000eaa <myproc>
  switch (n) {
    80001f00:	4795                	li	a5,5
    80001f02:	0497e163          	bltu	a5,s1,80001f44 <argraw+0x58>
    80001f06:	048a                	sll	s1,s1,0x2
    80001f08:	00006717          	auipc	a4,0x6
    80001f0c:	5b070713          	add	a4,a4,1456 # 800084b8 <states.0+0x230>
    80001f10:	94ba                	add	s1,s1,a4
    80001f12:	409c                	lw	a5,0(s1)
    80001f14:	97ba                	add	a5,a5,a4
    80001f16:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f18:	6d3c                	ld	a5,88(a0)
    80001f1a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f1c:	60e2                	ld	ra,24(sp)
    80001f1e:	6442                	ld	s0,16(sp)
    80001f20:	64a2                	ld	s1,8(sp)
    80001f22:	6105                	add	sp,sp,32
    80001f24:	8082                	ret
    return p->trapframe->a1;
    80001f26:	6d3c                	ld	a5,88(a0)
    80001f28:	7fa8                	ld	a0,120(a5)
    80001f2a:	bfcd                	j	80001f1c <argraw+0x30>
    return p->trapframe->a2;
    80001f2c:	6d3c                	ld	a5,88(a0)
    80001f2e:	63c8                	ld	a0,128(a5)
    80001f30:	b7f5                	j	80001f1c <argraw+0x30>
    return p->trapframe->a3;
    80001f32:	6d3c                	ld	a5,88(a0)
    80001f34:	67c8                	ld	a0,136(a5)
    80001f36:	b7dd                	j	80001f1c <argraw+0x30>
    return p->trapframe->a4;
    80001f38:	6d3c                	ld	a5,88(a0)
    80001f3a:	6bc8                	ld	a0,144(a5)
    80001f3c:	b7c5                	j	80001f1c <argraw+0x30>
    return p->trapframe->a5;
    80001f3e:	6d3c                	ld	a5,88(a0)
    80001f40:	6fc8                	ld	a0,152(a5)
    80001f42:	bfe9                	j	80001f1c <argraw+0x30>
  panic("argraw");
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	48c50513          	add	a0,a0,1164 # 800083d0 <states.0+0x148>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	d0a080e7          	jalr	-758(ra) # 80005c56 <panic>

0000000080001f54 <fetchaddr>:
{
    80001f54:	1101                	add	sp,sp,-32
    80001f56:	ec06                	sd	ra,24(sp)
    80001f58:	e822                	sd	s0,16(sp)
    80001f5a:	e426                	sd	s1,8(sp)
    80001f5c:	e04a                	sd	s2,0(sp)
    80001f5e:	1000                	add	s0,sp,32
    80001f60:	84aa                	mv	s1,a0
    80001f62:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	f46080e7          	jalr	-186(ra) # 80000eaa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80001f6c:	653c                	ld	a5,72(a0)
    80001f6e:	02f4f863          	bgeu	s1,a5,80001f9e <fetchaddr+0x4a>
    80001f72:	00848713          	add	a4,s1,8
    80001f76:	02e7e663          	bltu	a5,a4,80001fa2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f7a:	46a1                	li	a3,8
    80001f7c:	8626                	mv	a2,s1
    80001f7e:	85ca                	mv	a1,s2
    80001f80:	6928                	ld	a0,80(a0)
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	c74080e7          	jalr	-908(ra) # 80000bf6 <copyin>
    80001f8a:	00a03533          	snez	a0,a0
    80001f8e:	40a00533          	neg	a0,a0
}
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6902                	ld	s2,0(sp)
    80001f9a:	6105                	add	sp,sp,32
    80001f9c:	8082                	ret
    return -1;
    80001f9e:	557d                	li	a0,-1
    80001fa0:	bfcd                	j	80001f92 <fetchaddr+0x3e>
    80001fa2:	557d                	li	a0,-1
    80001fa4:	b7fd                	j	80001f92 <fetchaddr+0x3e>

0000000080001fa6 <fetchstr>:
{
    80001fa6:	7179                	add	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	e44e                	sd	s3,8(sp)
    80001fb2:	1800                	add	s0,sp,48
    80001fb4:	892a                	mv	s2,a0
    80001fb6:	84ae                	mv	s1,a1
    80001fb8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	ef0080e7          	jalr	-272(ra) # 80000eaa <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fc2:	86ce                	mv	a3,s3
    80001fc4:	864a                	mv	a2,s2
    80001fc6:	85a6                	mv	a1,s1
    80001fc8:	6928                	ld	a0,80(a0)
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	cba080e7          	jalr	-838(ra) # 80000c84 <copyinstr>
    80001fd2:	00054e63          	bltz	a0,80001fee <fetchstr+0x48>
  return strlen(buf);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	ffffe097          	auipc	ra,0xffffe
    80001fdc:	31c080e7          	jalr	796(ra) # 800002f4 <strlen>
}
    80001fe0:	70a2                	ld	ra,40(sp)
    80001fe2:	7402                	ld	s0,32(sp)
    80001fe4:	64e2                	ld	s1,24(sp)
    80001fe6:	6942                	ld	s2,16(sp)
    80001fe8:	69a2                	ld	s3,8(sp)
    80001fea:	6145                	add	sp,sp,48
    80001fec:	8082                	ret
    return -1;
    80001fee:	557d                	li	a0,-1
    80001ff0:	bfc5                	j	80001fe0 <fetchstr+0x3a>

0000000080001ff2 <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    80001ff2:	1101                	add	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	1000                	add	s0,sp,32
    80001ffc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ffe:	00000097          	auipc	ra,0x0
    80002002:	eee080e7          	jalr	-274(ra) # 80001eec <argraw>
    80002006:	c088                	sw	a0,0(s1)
}
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6105                	add	sp,sp,32
    80002010:	8082                	ret

0000000080002012 <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80002012:	1101                	add	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	1000                	add	s0,sp,32
    8000201c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	ece080e7          	jalr	-306(ra) # 80001eec <argraw>
    80002026:	e088                	sd	a0,0(s1)
}
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	64a2                	ld	s1,8(sp)
    8000202e:	6105                	add	sp,sp,32
    80002030:	8082                	ret

0000000080002032 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002032:	7179                	add	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	1800                	add	s0,sp,48
    8000203e:	84ae                	mv	s1,a1
    80002040:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002042:	fd840593          	add	a1,s0,-40
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	fcc080e7          	jalr	-52(ra) # 80002012 <argaddr>
  return fetchstr(addr, buf, max);
    8000204e:	864a                	mv	a2,s2
    80002050:	85a6                	mv	a1,s1
    80002052:	fd843503          	ld	a0,-40(s0)
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	f50080e7          	jalr	-176(ra) # 80001fa6 <fetchstr>
}
    8000205e:	70a2                	ld	ra,40(sp)
    80002060:	7402                	ld	s0,32(sp)
    80002062:	64e2                	ld	s1,24(sp)
    80002064:	6942                	ld	s2,16(sp)
    80002066:	6145                	add	sp,sp,48
    80002068:	8082                	ret

000000008000206a <syscall>:

/* End CMPT 332 group14 change Fall 2023 */

void
syscall(void)
{
    8000206a:	715d                	add	sp,sp,-80
    8000206c:	e486                	sd	ra,72(sp)
    8000206e:	e0a2                	sd	s0,64(sp)
    80002070:	fc26                	sd	s1,56(sp)
    80002072:	f84a                	sd	s2,48(sp)
    80002074:	f44e                	sd	s3,40(sp)
    80002076:	f052                	sd	s4,32(sp)
    80002078:	ec56                	sd	s5,24(sp)
    8000207a:	e85a                	sd	s6,16(sp)
    8000207c:	e45e                	sd	s7,8(sp)
    8000207e:	0880                	add	s0,sp,80
  int num;
  struct proc *p = myproc();
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	e2a080e7          	jalr	-470(ra) # 80000eaa <myproc>
    80002088:	89aa                	mv	s3,a0
  int i;
  int bit;

  /* End CMPT 332 group14 change Fall 2023 */

  num = p->trapframe->a7;
    8000208a:	6d24                	ld	s1,88(a0)
    8000208c:	74dc                	ld	a5,168(s1)
    8000208e:	00078b1b          	sext.w	s6,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002092:	37fd                	addw	a5,a5,-1
    80002094:	4755                	li	a4,21
    80002096:	06f76863          	bltu	a4,a5,80002106 <syscall+0x9c>
    8000209a:	003b1713          	sll	a4,s6,0x3
    8000209e:	00006797          	auipc	a5,0x6
    800020a2:	43278793          	add	a5,a5,1074 # 800084d0 <syscalls>
    800020a6:	97ba                	add	a5,a5,a4
    800020a8:	639c                	ld	a5,0(a5)
    800020aa:	cfb1                	beqz	a5,80002106 <syscall+0x9c>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    800020ac:	9782                	jalr	a5
    800020ae:	f8a8                	sd	a0,112(s1)

    /* Begin CMPT 332 group14 change Fall 2023 */

    if (p->tmask > 0) {
    800020b0:	1689a783          	lw	a5,360(s3)
    800020b4:	06f05a63          	blez	a5,80002128 <syscall+0xbe>
    800020b8:	00007917          	auipc	s2,0x7
    800020bc:	8d090913          	add	s2,s2,-1840 # 80008988 <syscall_names>
      for (i = 1; i < 32; i++) {
    800020c0:	4485                	li	s1,1
        bit = p->tmask & (1 << i);
    800020c2:	4a85                	li	s5,1
        if (bit != 0) {
          if (i == num) {
            printf("%d: syscall %s -> %d\n",
    800020c4:	00006b97          	auipc	s7,0x6
    800020c8:	314b8b93          	add	s7,s7,788 # 800083d8 <states.0+0x150>
      for (i = 1; i < 32; i++) {
    800020cc:	02000a13          	li	s4,32
    800020d0:	a029                	j	800020da <syscall+0x70>
    800020d2:	2485                	addw	s1,s1,1
    800020d4:	0921                	add	s2,s2,8
    800020d6:	05448963          	beq	s1,s4,80002128 <syscall+0xbe>
        bit = p->tmask & (1 << i);
    800020da:	009a973b          	sllw	a4,s5,s1
    800020de:	1689a783          	lw	a5,360(s3)
    800020e2:	8ff9                	and	a5,a5,a4
        if (bit != 0) {
    800020e4:	2781                	sext.w	a5,a5
    800020e6:	d7f5                	beqz	a5,800020d2 <syscall+0x68>
          if (i == num) {
    800020e8:	fe9b15e3          	bne	s6,s1,800020d2 <syscall+0x68>
            printf("%d: syscall %s -> %d\n",
    800020ec:	0589b783          	ld	a5,88(s3)
    800020f0:	7bb4                	ld	a3,112(a5)
    800020f2:	00093603          	ld	a2,0(s2)
    800020f6:	0309a583          	lw	a1,48(s3)
    800020fa:	855e                	mv	a0,s7
    800020fc:	00004097          	auipc	ra,0x4
    80002100:	ba4080e7          	jalr	-1116(ra) # 80005ca0 <printf>
    80002104:	b7f9                	j	800020d2 <syscall+0x68>
    }

    /* End CMPT 332 group14 change Fall 2023 */

  } else {
    printf("%d %s: unknown sys call %d\n",
    80002106:	86da                	mv	a3,s6
    80002108:	15898613          	add	a2,s3,344
    8000210c:	0309a583          	lw	a1,48(s3)
    80002110:	00006517          	auipc	a0,0x6
    80002114:	2e050513          	add	a0,a0,736 # 800083f0 <states.0+0x168>
    80002118:	00004097          	auipc	ra,0x4
    8000211c:	b88080e7          	jalr	-1144(ra) # 80005ca0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002120:	0589b783          	ld	a5,88(s3)
    80002124:	577d                	li	a4,-1
    80002126:	fbb8                	sd	a4,112(a5)
  }
}
    80002128:	60a6                	ld	ra,72(sp)
    8000212a:	6406                	ld	s0,64(sp)
    8000212c:	74e2                	ld	s1,56(sp)
    8000212e:	7942                	ld	s2,48(sp)
    80002130:	79a2                	ld	s3,40(sp)
    80002132:	7a02                	ld	s4,32(sp)
    80002134:	6ae2                	ld	s5,24(sp)
    80002136:	6b42                	ld	s6,16(sp)
    80002138:	6ba2                	ld	s7,8(sp)
    8000213a:	6161                	add	sp,sp,80
    8000213c:	8082                	ret

000000008000213e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000213e:	1101                	add	sp,sp,-32
    80002140:	ec06                	sd	ra,24(sp)
    80002142:	e822                	sd	s0,16(sp)
    80002144:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002146:	fec40593          	add	a1,s0,-20
    8000214a:	4501                	li	a0,0
    8000214c:	00000097          	auipc	ra,0x0
    80002150:	ea6080e7          	jalr	-346(ra) # 80001ff2 <argint>
  exit(n);
    80002154:	fec42503          	lw	a0,-20(s0)
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	53a080e7          	jalr	1338(ra) # 80001692 <exit>
  return 0;  /* not reached */
}
    80002160:	4501                	li	a0,0
    80002162:	60e2                	ld	ra,24(sp)
    80002164:	6442                	ld	s0,16(sp)
    80002166:	6105                	add	sp,sp,32
    80002168:	8082                	ret

000000008000216a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000216a:	1141                	add	sp,sp,-16
    8000216c:	e406                	sd	ra,8(sp)
    8000216e:	e022                	sd	s0,0(sp)
    80002170:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	d38080e7          	jalr	-712(ra) # 80000eaa <myproc>
}
    8000217a:	5908                	lw	a0,48(a0)
    8000217c:	60a2                	ld	ra,8(sp)
    8000217e:	6402                	ld	s0,0(sp)
    80002180:	0141                	add	sp,sp,16
    80002182:	8082                	ret

0000000080002184 <sys_fork>:

uint64
sys_fork(void)
{
    80002184:	1141                	add	sp,sp,-16
    80002186:	e406                	sd	ra,8(sp)
    80002188:	e022                	sd	s0,0(sp)
    8000218a:	0800                	add	s0,sp,16
  return fork();
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	0d8080e7          	jalr	216(ra) # 80001264 <fork>
}
    80002194:	60a2                	ld	ra,8(sp)
    80002196:	6402                	ld	s0,0(sp)
    80002198:	0141                	add	sp,sp,16
    8000219a:	8082                	ret

000000008000219c <sys_wait>:

uint64
sys_wait(void)
{
    8000219c:	1101                	add	sp,sp,-32
    8000219e:	ec06                	sd	ra,24(sp)
    800021a0:	e822                	sd	s0,16(sp)
    800021a2:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021a4:	fe840593          	add	a1,s0,-24
    800021a8:	4501                	li	a0,0
    800021aa:	00000097          	auipc	ra,0x0
    800021ae:	e68080e7          	jalr	-408(ra) # 80002012 <argaddr>
  return wait(p);
    800021b2:	fe843503          	ld	a0,-24(s0)
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	682080e7          	jalr	1666(ra) # 80001838 <wait>
}
    800021be:	60e2                	ld	ra,24(sp)
    800021c0:	6442                	ld	s0,16(sp)
    800021c2:	6105                	add	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021c6:	7179                	add	sp,sp,-48
    800021c8:	f406                	sd	ra,40(sp)
    800021ca:	f022                	sd	s0,32(sp)
    800021cc:	ec26                	sd	s1,24(sp)
    800021ce:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021d0:	fdc40593          	add	a1,s0,-36
    800021d4:	4501                	li	a0,0
    800021d6:	00000097          	auipc	ra,0x0
    800021da:	e1c080e7          	jalr	-484(ra) # 80001ff2 <argint>
  addr = myproc()->sz;
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	ccc080e7          	jalr	-820(ra) # 80000eaa <myproc>
    800021e6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021e8:	fdc42503          	lw	a0,-36(s0)
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	01c080e7          	jalr	28(ra) # 80001208 <growproc>
    800021f4:	00054863          	bltz	a0,80002204 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021f8:	8526                	mv	a0,s1
    800021fa:	70a2                	ld	ra,40(sp)
    800021fc:	7402                	ld	s0,32(sp)
    800021fe:	64e2                	ld	s1,24(sp)
    80002200:	6145                	add	sp,sp,48
    80002202:	8082                	ret
    return -1;
    80002204:	54fd                	li	s1,-1
    80002206:	bfcd                	j	800021f8 <sys_sbrk+0x32>

0000000080002208 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002208:	7139                	add	sp,sp,-64
    8000220a:	fc06                	sd	ra,56(sp)
    8000220c:	f822                	sd	s0,48(sp)
    8000220e:	f426                	sd	s1,40(sp)
    80002210:	f04a                	sd	s2,32(sp)
    80002212:	ec4e                	sd	s3,24(sp)
    80002214:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002216:	fcc40593          	add	a1,s0,-52
    8000221a:	4501                	li	a0,0
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	dd6080e7          	jalr	-554(ra) # 80001ff2 <argint>
  if(n < 0)
    80002224:	fcc42783          	lw	a5,-52(s0)
    80002228:	0607cf63          	bltz	a5,800022a6 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000222c:	0000d517          	auipc	a0,0xd
    80002230:	89450513          	add	a0,a0,-1900 # 8000eac0 <tickslock>
    80002234:	00004097          	auipc	ra,0x4
    80002238:	f5a080e7          	jalr	-166(ra) # 8000618e <acquire>
  ticks0 = ticks;
    8000223c:	00007917          	auipc	s2,0x7
    80002240:	81c92903          	lw	s2,-2020(s2) # 80008a58 <ticks>
  while(ticks - ticks0 < n){
    80002244:	fcc42783          	lw	a5,-52(s0)
    80002248:	cf9d                	beqz	a5,80002286 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000224a:	0000d997          	auipc	s3,0xd
    8000224e:	87698993          	add	s3,s3,-1930 # 8000eac0 <tickslock>
    80002252:	00007497          	auipc	s1,0x7
    80002256:	80648493          	add	s1,s1,-2042 # 80008a58 <ticks>
    if(killed(myproc())){
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	c50080e7          	jalr	-944(ra) # 80000eaa <myproc>
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	5a4080e7          	jalr	1444(ra) # 80001806 <killed>
    8000226a:	e129                	bnez	a0,800022ac <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000226c:	85ce                	mv	a1,s3
    8000226e:	8526                	mv	a0,s1
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	2ee080e7          	jalr	750(ra) # 8000155e <sleep>
  while(ticks - ticks0 < n){
    80002278:	409c                	lw	a5,0(s1)
    8000227a:	412787bb          	subw	a5,a5,s2
    8000227e:	fcc42703          	lw	a4,-52(s0)
    80002282:	fce7ece3          	bltu	a5,a4,8000225a <sys_sleep+0x52>
  }
  release(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	83a50513          	add	a0,a0,-1990 # 8000eac0 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	fb4080e7          	jalr	-76(ra) # 80006242 <release>
  return 0;
    80002296:	4501                	li	a0,0
}
    80002298:	70e2                	ld	ra,56(sp)
    8000229a:	7442                	ld	s0,48(sp)
    8000229c:	74a2                	ld	s1,40(sp)
    8000229e:	7902                	ld	s2,32(sp)
    800022a0:	69e2                	ld	s3,24(sp)
    800022a2:	6121                	add	sp,sp,64
    800022a4:	8082                	ret
    n = 0;
    800022a6:	fc042623          	sw	zero,-52(s0)
    800022aa:	b749                	j	8000222c <sys_sleep+0x24>
      release(&tickslock);
    800022ac:	0000d517          	auipc	a0,0xd
    800022b0:	81450513          	add	a0,a0,-2028 # 8000eac0 <tickslock>
    800022b4:	00004097          	auipc	ra,0x4
    800022b8:	f8e080e7          	jalr	-114(ra) # 80006242 <release>
      return -1;
    800022bc:	557d                	li	a0,-1
    800022be:	bfe9                	j	80002298 <sys_sleep+0x90>

00000000800022c0 <sys_kill>:

uint64
sys_kill(void)
{
    800022c0:	1101                	add	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    800022c8:	fec40593          	add	a1,s0,-20
    800022cc:	4501                	li	a0,0
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	d24080e7          	jalr	-732(ra) # 80001ff2 <argint>
  return kill(pid);
    800022d6:	fec42503          	lw	a0,-20(s0)
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	48e080e7          	jalr	1166(ra) # 80001768 <kill>
}
    800022e2:	60e2                	ld	ra,24(sp)
    800022e4:	6442                	ld	s0,16(sp)
    800022e6:	6105                	add	sp,sp,32
    800022e8:	8082                	ret

00000000800022ea <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    800022ea:	1101                	add	sp,sp,-32
    800022ec:	ec06                	sd	ra,24(sp)
    800022ee:	e822                	sd	s0,16(sp)
    800022f0:	e426                	sd	s1,8(sp)
    800022f2:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022f4:	0000c517          	auipc	a0,0xc
    800022f8:	7cc50513          	add	a0,a0,1996 # 8000eac0 <tickslock>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	e92080e7          	jalr	-366(ra) # 8000618e <acquire>
  xticks = ticks;
    80002304:	00006497          	auipc	s1,0x6
    80002308:	7544a483          	lw	s1,1876(s1) # 80008a58 <ticks>
  release(&tickslock);
    8000230c:	0000c517          	auipc	a0,0xc
    80002310:	7b450513          	add	a0,a0,1972 # 8000eac0 <tickslock>
    80002314:	00004097          	auipc	ra,0x4
    80002318:	f2e080e7          	jalr	-210(ra) # 80006242 <release>
  return xticks;
}
    8000231c:	02049513          	sll	a0,s1,0x20
    80002320:	9101                	srl	a0,a0,0x20
    80002322:	60e2                	ld	ra,24(sp)
    80002324:	6442                	ld	s0,16(sp)
    80002326:	64a2                	ld	s1,8(sp)
    80002328:	6105                	add	sp,sp,32
    8000232a:	8082                	ret

000000008000232c <sys_trace>:

/* enables tracing for the process that calls it */
/* and children that it subsequently forks. */
uint64
sys_trace(void)
{
    8000232c:	1101                	add	sp,sp,-32
    8000232e:	ec06                	sd	ra,24(sp)
    80002330:	e822                	sd	s0,16(sp)
    80002332:	1000                	add	s0,sp,32
  int mask;

  argint(0, &mask);
    80002334:	fec40593          	add	a1,s0,-20
    80002338:	4501                	li	a0,0
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	cb8080e7          	jalr	-840(ra) # 80001ff2 <argint>
  myproc()->tmask = mask;
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	b68080e7          	jalr	-1176(ra) # 80000eaa <myproc>
    8000234a:	fec42783          	lw	a5,-20(s0)
    8000234e:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002352:	4501                	li	a0,0
    80002354:	60e2                	ld	ra,24(sp)
    80002356:	6442                	ld	s0,16(sp)
    80002358:	6105                	add	sp,sp,32
    8000235a:	8082                	ret

000000008000235c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000235c:	7179                	add	sp,sp,-48
    8000235e:	f406                	sd	ra,40(sp)
    80002360:	f022                	sd	s0,32(sp)
    80002362:	ec26                	sd	s1,24(sp)
    80002364:	e84a                	sd	s2,16(sp)
    80002366:	e44e                	sd	s3,8(sp)
    80002368:	e052                	sd	s4,0(sp)
    8000236a:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000236c:	00006597          	auipc	a1,0x6
    80002370:	21c58593          	add	a1,a1,540 # 80008588 <syscalls+0xb8>
    80002374:	0000c517          	auipc	a0,0xc
    80002378:	76450513          	add	a0,a0,1892 # 8000ead8 <bcache>
    8000237c:	00004097          	auipc	ra,0x4
    80002380:	d82080e7          	jalr	-638(ra) # 800060fe <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    80002384:	00014797          	auipc	a5,0x14
    80002388:	75478793          	add	a5,a5,1876 # 80016ad8 <bcache+0x8000>
    8000238c:	00015717          	auipc	a4,0x15
    80002390:	9b470713          	add	a4,a4,-1612 # 80016d40 <bcache+0x8268>
    80002394:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002398:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000239c:	0000c497          	auipc	s1,0xc
    800023a0:	75448493          	add	s1,s1,1876 # 8000eaf0 <bcache+0x18>
    b->next = bcache.head.next;
    800023a4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a8:	00006a17          	auipc	s4,0x6
    800023ac:	1e8a0a13          	add	s4,s4,488 # 80008590 <syscalls+0xc0>
    b->next = bcache.head.next;
    800023b0:	2b893783          	ld	a5,696(s2)
    800023b4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ba:	85d2                	mv	a1,s4
    800023bc:	01048513          	add	a0,s1,16
    800023c0:	00001097          	auipc	ra,0x1
    800023c4:	496080e7          	jalr	1174(ra) # 80003856 <initsleeplock>
    bcache.head.next->prev = b;
    800023c8:	2b893783          	ld	a5,696(s2)
    800023cc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023ce:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d2:	45848493          	add	s1,s1,1112
    800023d6:	fd349de3          	bne	s1,s3,800023b0 <binit+0x54>
  }
}
    800023da:	70a2                	ld	ra,40(sp)
    800023dc:	7402                	ld	s0,32(sp)
    800023de:	64e2                	ld	s1,24(sp)
    800023e0:	6942                	ld	s2,16(sp)
    800023e2:	69a2                	ld	s3,8(sp)
    800023e4:	6a02                	ld	s4,0(sp)
    800023e6:	6145                	add	sp,sp,48
    800023e8:	8082                	ret

00000000800023ea <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    800023ea:	7179                	add	sp,sp,-48
    800023ec:	f406                	sd	ra,40(sp)
    800023ee:	f022                	sd	s0,32(sp)
    800023f0:	ec26                	sd	s1,24(sp)
    800023f2:	e84a                	sd	s2,16(sp)
    800023f4:	e44e                	sd	s3,8(sp)
    800023f6:	1800                	add	s0,sp,48
    800023f8:	892a                	mv	s2,a0
    800023fa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023fc:	0000c517          	auipc	a0,0xc
    80002400:	6dc50513          	add	a0,a0,1756 # 8000ead8 <bcache>
    80002404:	00004097          	auipc	ra,0x4
    80002408:	d8a080e7          	jalr	-630(ra) # 8000618e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000240c:	00015497          	auipc	s1,0x15
    80002410:	9844b483          	ld	s1,-1660(s1) # 80016d90 <bcache+0x82b8>
    80002414:	00015797          	auipc	a5,0x15
    80002418:	92c78793          	add	a5,a5,-1748 # 80016d40 <bcache+0x8268>
    8000241c:	02f48f63          	beq	s1,a5,8000245a <bread+0x70>
    80002420:	873e                	mv	a4,a5
    80002422:	a021                	j	8000242a <bread+0x40>
    80002424:	68a4                	ld	s1,80(s1)
    80002426:	02e48a63          	beq	s1,a4,8000245a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000242a:	449c                	lw	a5,8(s1)
    8000242c:	ff279ce3          	bne	a5,s2,80002424 <bread+0x3a>
    80002430:	44dc                	lw	a5,12(s1)
    80002432:	ff3799e3          	bne	a5,s3,80002424 <bread+0x3a>
      b->refcnt++;
    80002436:	40bc                	lw	a5,64(s1)
    80002438:	2785                	addw	a5,a5,1
    8000243a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000243c:	0000c517          	auipc	a0,0xc
    80002440:	69c50513          	add	a0,a0,1692 # 8000ead8 <bcache>
    80002444:	00004097          	auipc	ra,0x4
    80002448:	dfe080e7          	jalr	-514(ra) # 80006242 <release>
      acquiresleep(&b->lock);
    8000244c:	01048513          	add	a0,s1,16
    80002450:	00001097          	auipc	ra,0x1
    80002454:	440080e7          	jalr	1088(ra) # 80003890 <acquiresleep>
      return b;
    80002458:	a8b9                	j	800024b6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000245a:	00015497          	auipc	s1,0x15
    8000245e:	92e4b483          	ld	s1,-1746(s1) # 80016d88 <bcache+0x82b0>
    80002462:	00015797          	auipc	a5,0x15
    80002466:	8de78793          	add	a5,a5,-1826 # 80016d40 <bcache+0x8268>
    8000246a:	00f48863          	beq	s1,a5,8000247a <bread+0x90>
    8000246e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002470:	40bc                	lw	a5,64(s1)
    80002472:	cf81                	beqz	a5,8000248a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002474:	64a4                	ld	s1,72(s1)
    80002476:	fee49de3          	bne	s1,a4,80002470 <bread+0x86>
  panic("bget: no buffers");
    8000247a:	00006517          	auipc	a0,0x6
    8000247e:	11e50513          	add	a0,a0,286 # 80008598 <syscalls+0xc8>
    80002482:	00003097          	auipc	ra,0x3
    80002486:	7d4080e7          	jalr	2004(ra) # 80005c56 <panic>
      b->dev = dev;
    8000248a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000248e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002492:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002496:	4785                	li	a5,1
    80002498:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000249a:	0000c517          	auipc	a0,0xc
    8000249e:	63e50513          	add	a0,a0,1598 # 8000ead8 <bcache>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	da0080e7          	jalr	-608(ra) # 80006242 <release>
      acquiresleep(&b->lock);
    800024aa:	01048513          	add	a0,s1,16
    800024ae:	00001097          	auipc	ra,0x1
    800024b2:	3e2080e7          	jalr	994(ra) # 80003890 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b6:	409c                	lw	a5,0(s1)
    800024b8:	cb89                	beqz	a5,800024ca <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ba:	8526                	mv	a0,s1
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6145                	add	sp,sp,48
    800024c8:	8082                	ret
    virtio_disk_rw(b, 0);
    800024ca:	4581                	li	a1,0
    800024cc:	8526                	mv	a0,s1
    800024ce:	00003097          	auipc	ra,0x3
    800024d2:	f84080e7          	jalr	-124(ra) # 80005452 <virtio_disk_rw>
    b->valid = 1;
    800024d6:	4785                	li	a5,1
    800024d8:	c09c                	sw	a5,0(s1)
  return b;
    800024da:	b7c5                	j	800024ba <bread+0xd0>

00000000800024dc <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    800024dc:	1101                	add	sp,sp,-32
    800024de:	ec06                	sd	ra,24(sp)
    800024e0:	e822                	sd	s0,16(sp)
    800024e2:	e426                	sd	s1,8(sp)
    800024e4:	1000                	add	s0,sp,32
    800024e6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e8:	0541                	add	a0,a0,16
    800024ea:	00001097          	auipc	ra,0x1
    800024ee:	440080e7          	jalr	1088(ra) # 8000392a <holdingsleep>
    800024f2:	cd01                	beqz	a0,8000250a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024f4:	4585                	li	a1,1
    800024f6:	8526                	mv	a0,s1
    800024f8:	00003097          	auipc	ra,0x3
    800024fc:	f5a080e7          	jalr	-166(ra) # 80005452 <virtio_disk_rw>
}
    80002500:	60e2                	ld	ra,24(sp)
    80002502:	6442                	ld	s0,16(sp)
    80002504:	64a2                	ld	s1,8(sp)
    80002506:	6105                	add	sp,sp,32
    80002508:	8082                	ret
    panic("bwrite");
    8000250a:	00006517          	auipc	a0,0x6
    8000250e:	0a650513          	add	a0,a0,166 # 800085b0 <syscalls+0xe0>
    80002512:	00003097          	auipc	ra,0x3
    80002516:	744080e7          	jalr	1860(ra) # 80005c56 <panic>

000000008000251a <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    8000251a:	1101                	add	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	e426                	sd	s1,8(sp)
    80002522:	e04a                	sd	s2,0(sp)
    80002524:	1000                	add	s0,sp,32
    80002526:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002528:	01050913          	add	s2,a0,16
    8000252c:	854a                	mv	a0,s2
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	3fc080e7          	jalr	1020(ra) # 8000392a <holdingsleep>
    80002536:	c925                	beqz	a0,800025a6 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002538:	854a                	mv	a0,s2
    8000253a:	00001097          	auipc	ra,0x1
    8000253e:	3ac080e7          	jalr	940(ra) # 800038e6 <releasesleep>

  acquire(&bcache.lock);
    80002542:	0000c517          	auipc	a0,0xc
    80002546:	59650513          	add	a0,a0,1430 # 8000ead8 <bcache>
    8000254a:	00004097          	auipc	ra,0x4
    8000254e:	c44080e7          	jalr	-956(ra) # 8000618e <acquire>
  b->refcnt--;
    80002552:	40bc                	lw	a5,64(s1)
    80002554:	37fd                	addw	a5,a5,-1
    80002556:	0007871b          	sext.w	a4,a5
    8000255a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000255c:	e71d                	bnez	a4,8000258a <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    8000255e:	68b8                	ld	a4,80(s1)
    80002560:	64bc                	ld	a5,72(s1)
    80002562:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002564:	68b8                	ld	a4,80(s1)
    80002566:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002568:	00014797          	auipc	a5,0x14
    8000256c:	57078793          	add	a5,a5,1392 # 80016ad8 <bcache+0x8000>
    80002570:	2b87b703          	ld	a4,696(a5)
    80002574:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002576:	00014717          	auipc	a4,0x14
    8000257a:	7ca70713          	add	a4,a4,1994 # 80016d40 <bcache+0x8268>
    8000257e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002580:	2b87b703          	ld	a4,696(a5)
    80002584:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002586:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000258a:	0000c517          	auipc	a0,0xc
    8000258e:	54e50513          	add	a0,a0,1358 # 8000ead8 <bcache>
    80002592:	00004097          	auipc	ra,0x4
    80002596:	cb0080e7          	jalr	-848(ra) # 80006242 <release>
}
    8000259a:	60e2                	ld	ra,24(sp)
    8000259c:	6442                	ld	s0,16(sp)
    8000259e:	64a2                	ld	s1,8(sp)
    800025a0:	6902                	ld	s2,0(sp)
    800025a2:	6105                	add	sp,sp,32
    800025a4:	8082                	ret
    panic("brelse");
    800025a6:	00006517          	auipc	a0,0x6
    800025aa:	01250513          	add	a0,a0,18 # 800085b8 <syscalls+0xe8>
    800025ae:	00003097          	auipc	ra,0x3
    800025b2:	6a8080e7          	jalr	1704(ra) # 80005c56 <panic>

00000000800025b6 <bpin>:

void
bpin(struct buf *b) {
    800025b6:	1101                	add	sp,sp,-32
    800025b8:	ec06                	sd	ra,24(sp)
    800025ba:	e822                	sd	s0,16(sp)
    800025bc:	e426                	sd	s1,8(sp)
    800025be:	1000                	add	s0,sp,32
    800025c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c2:	0000c517          	auipc	a0,0xc
    800025c6:	51650513          	add	a0,a0,1302 # 8000ead8 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	bc4080e7          	jalr	-1084(ra) # 8000618e <acquire>
  b->refcnt++;
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	2785                	addw	a5,a5,1
    800025d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d8:	0000c517          	auipc	a0,0xc
    800025dc:	50050513          	add	a0,a0,1280 # 8000ead8 <bcache>
    800025e0:	00004097          	auipc	ra,0x4
    800025e4:	c62080e7          	jalr	-926(ra) # 80006242 <release>
}
    800025e8:	60e2                	ld	ra,24(sp)
    800025ea:	6442                	ld	s0,16(sp)
    800025ec:	64a2                	ld	s1,8(sp)
    800025ee:	6105                	add	sp,sp,32
    800025f0:	8082                	ret

00000000800025f2 <bunpin>:

void
bunpin(struct buf *b) {
    800025f2:	1101                	add	sp,sp,-32
    800025f4:	ec06                	sd	ra,24(sp)
    800025f6:	e822                	sd	s0,16(sp)
    800025f8:	e426                	sd	s1,8(sp)
    800025fa:	1000                	add	s0,sp,32
    800025fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fe:	0000c517          	auipc	a0,0xc
    80002602:	4da50513          	add	a0,a0,1242 # 8000ead8 <bcache>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	b88080e7          	jalr	-1144(ra) # 8000618e <acquire>
  b->refcnt--;
    8000260e:	40bc                	lw	a5,64(s1)
    80002610:	37fd                	addw	a5,a5,-1
    80002612:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002614:	0000c517          	auipc	a0,0xc
    80002618:	4c450513          	add	a0,a0,1220 # 8000ead8 <bcache>
    8000261c:	00004097          	auipc	ra,0x4
    80002620:	c26080e7          	jalr	-986(ra) # 80006242 <release>
}
    80002624:	60e2                	ld	ra,24(sp)
    80002626:	6442                	ld	s0,16(sp)
    80002628:	64a2                	ld	s1,8(sp)
    8000262a:	6105                	add	sp,sp,32
    8000262c:	8082                	ret

000000008000262e <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    8000262e:	1101                	add	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	e426                	sd	s1,8(sp)
    80002636:	e04a                	sd	s2,0(sp)
    80002638:	1000                	add	s0,sp,32
    8000263a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000263c:	00d5d59b          	srlw	a1,a1,0xd
    80002640:	00015797          	auipc	a5,0x15
    80002644:	b747a783          	lw	a5,-1164(a5) # 800171b4 <sb+0x1c>
    80002648:	9dbd                	addw	a1,a1,a5
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	da0080e7          	jalr	-608(ra) # 800023ea <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002652:	0074f713          	and	a4,s1,7
    80002656:	4785                	li	a5,1
    80002658:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000265c:	14ce                	sll	s1,s1,0x33
    8000265e:	90d9                	srl	s1,s1,0x36
    80002660:	00950733          	add	a4,a0,s1
    80002664:	05874703          	lbu	a4,88(a4)
    80002668:	00e7f6b3          	and	a3,a5,a4
    8000266c:	c69d                	beqz	a3,8000269a <bfree+0x6c>
    8000266e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002670:	94aa                	add	s1,s1,a0
    80002672:	fff7c793          	not	a5,a5
    80002676:	8f7d                	and	a4,a4,a5
    80002678:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000267c:	00001097          	auipc	ra,0x1
    80002680:	0f6080e7          	jalr	246(ra) # 80003772 <log_write>
  brelse(bp);
    80002684:	854a                	mv	a0,s2
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	e94080e7          	jalr	-364(ra) # 8000251a <brelse>
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6902                	ld	s2,0(sp)
    80002696:	6105                	add	sp,sp,32
    80002698:	8082                	ret
    panic("freeing free block");
    8000269a:	00006517          	auipc	a0,0x6
    8000269e:	f2650513          	add	a0,a0,-218 # 800085c0 <syscalls+0xf0>
    800026a2:	00003097          	auipc	ra,0x3
    800026a6:	5b4080e7          	jalr	1460(ra) # 80005c56 <panic>

00000000800026aa <balloc>:
{
    800026aa:	711d                	add	sp,sp,-96
    800026ac:	ec86                	sd	ra,88(sp)
    800026ae:	e8a2                	sd	s0,80(sp)
    800026b0:	e4a6                	sd	s1,72(sp)
    800026b2:	e0ca                	sd	s2,64(sp)
    800026b4:	fc4e                	sd	s3,56(sp)
    800026b6:	f852                	sd	s4,48(sp)
    800026b8:	f456                	sd	s5,40(sp)
    800026ba:	f05a                	sd	s6,32(sp)
    800026bc:	ec5e                	sd	s7,24(sp)
    800026be:	e862                	sd	s8,16(sp)
    800026c0:	e466                	sd	s9,8(sp)
    800026c2:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026c4:	00015797          	auipc	a5,0x15
    800026c8:	ad87a783          	lw	a5,-1320(a5) # 8001719c <sb+0x4>
    800026cc:	cff5                	beqz	a5,800027c8 <balloc+0x11e>
    800026ce:	8baa                	mv	s7,a0
    800026d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026d2:	00015b17          	auipc	s6,0x15
    800026d6:	ac6b0b13          	add	s6,s6,-1338 # 80017198 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026da:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026e0:	6c89                	lui	s9,0x2
    800026e2:	a061                	j	8000276a <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    800026e4:	97ca                	add	a5,a5,s2
    800026e6:	8e55                	or	a2,a2,a3
    800026e8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026ec:	854a                	mv	a0,s2
    800026ee:	00001097          	auipc	ra,0x1
    800026f2:	084080e7          	jalr	132(ra) # 80003772 <log_write>
        brelse(bp);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	e22080e7          	jalr	-478(ra) # 8000251a <brelse>
  bp = bread(dev, bno);
    80002700:	85a6                	mv	a1,s1
    80002702:	855e                	mv	a0,s7
    80002704:	00000097          	auipc	ra,0x0
    80002708:	ce6080e7          	jalr	-794(ra) # 800023ea <bread>
    8000270c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000270e:	40000613          	li	a2,1024
    80002712:	4581                	li	a1,0
    80002714:	05850513          	add	a0,a0,88
    80002718:	ffffe097          	auipc	ra,0xffffe
    8000271c:	a62080e7          	jalr	-1438(ra) # 8000017a <memset>
  log_write(bp);
    80002720:	854a                	mv	a0,s2
    80002722:	00001097          	auipc	ra,0x1
    80002726:	050080e7          	jalr	80(ra) # 80003772 <log_write>
  brelse(bp);
    8000272a:	854a                	mv	a0,s2
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	dee080e7          	jalr	-530(ra) # 8000251a <brelse>
}
    80002734:	8526                	mv	a0,s1
    80002736:	60e6                	ld	ra,88(sp)
    80002738:	6446                	ld	s0,80(sp)
    8000273a:	64a6                	ld	s1,72(sp)
    8000273c:	6906                	ld	s2,64(sp)
    8000273e:	79e2                	ld	s3,56(sp)
    80002740:	7a42                	ld	s4,48(sp)
    80002742:	7aa2                	ld	s5,40(sp)
    80002744:	7b02                	ld	s6,32(sp)
    80002746:	6be2                	ld	s7,24(sp)
    80002748:	6c42                	ld	s8,16(sp)
    8000274a:	6ca2                	ld	s9,8(sp)
    8000274c:	6125                	add	sp,sp,96
    8000274e:	8082                	ret
    brelse(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	00000097          	auipc	ra,0x0
    80002756:	dc8080e7          	jalr	-568(ra) # 8000251a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000275a:	015c87bb          	addw	a5,s9,s5
    8000275e:	00078a9b          	sext.w	s5,a5
    80002762:	004b2703          	lw	a4,4(s6)
    80002766:	06eaf163          	bgeu	s5,a4,800027c8 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000276a:	41fad79b          	sraw	a5,s5,0x1f
    8000276e:	0137d79b          	srlw	a5,a5,0x13
    80002772:	015787bb          	addw	a5,a5,s5
    80002776:	40d7d79b          	sraw	a5,a5,0xd
    8000277a:	01cb2583          	lw	a1,28(s6)
    8000277e:	9dbd                	addw	a1,a1,a5
    80002780:	855e                	mv	a0,s7
    80002782:	00000097          	auipc	ra,0x0
    80002786:	c68080e7          	jalr	-920(ra) # 800023ea <bread>
    8000278a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000278c:	004b2503          	lw	a0,4(s6)
    80002790:	000a849b          	sext.w	s1,s5
    80002794:	8762                	mv	a4,s8
    80002796:	faa4fde3          	bgeu	s1,a0,80002750 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000279a:	00777693          	and	a3,a4,7
    8000279e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    800027a2:	41f7579b          	sraw	a5,a4,0x1f
    800027a6:	01d7d79b          	srlw	a5,a5,0x1d
    800027aa:	9fb9                	addw	a5,a5,a4
    800027ac:	4037d79b          	sraw	a5,a5,0x3
    800027b0:	00f90633          	add	a2,s2,a5
    800027b4:	05864603          	lbu	a2,88(a2)
    800027b8:	00c6f5b3          	and	a1,a3,a2
    800027bc:	d585                	beqz	a1,800026e4 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027be:	2705                	addw	a4,a4,1
    800027c0:	2485                	addw	s1,s1,1
    800027c2:	fd471ae3          	bne	a4,s4,80002796 <balloc+0xec>
    800027c6:	b769                	j	80002750 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027c8:	00006517          	auipc	a0,0x6
    800027cc:	e1050513          	add	a0,a0,-496 # 800085d8 <syscalls+0x108>
    800027d0:	00003097          	auipc	ra,0x3
    800027d4:	4d0080e7          	jalr	1232(ra) # 80005ca0 <printf>
  return 0;
    800027d8:	4481                	li	s1,0
    800027da:	bfa9                	j	80002734 <balloc+0x8a>

00000000800027dc <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    800027dc:	7179                	add	sp,sp,-48
    800027de:	f406                	sd	ra,40(sp)
    800027e0:	f022                	sd	s0,32(sp)
    800027e2:	ec26                	sd	s1,24(sp)
    800027e4:	e84a                	sd	s2,16(sp)
    800027e6:	e44e                	sd	s3,8(sp)
    800027e8:	e052                	sd	s4,0(sp)
    800027ea:	1800                	add	s0,sp,48
    800027ec:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027ee:	47ad                	li	a5,11
    800027f0:	02b7e863          	bltu	a5,a1,80002820 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800027f4:	02059793          	sll	a5,a1,0x20
    800027f8:	01e7d593          	srl	a1,a5,0x1e
    800027fc:	00b504b3          	add	s1,a0,a1
    80002800:	0504a903          	lw	s2,80(s1)
    80002804:	06091e63          	bnez	s2,80002880 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002808:	4108                	lw	a0,0(a0)
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	ea0080e7          	jalr	-352(ra) # 800026aa <balloc>
    80002812:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002816:	06090563          	beqz	s2,80002880 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000281a:	0524a823          	sw	s2,80(s1)
    8000281e:	a08d                	j	80002880 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002820:	ff45849b          	addw	s1,a1,-12
    80002824:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002828:	0ff00793          	li	a5,255
    8000282c:	08e7e563          	bltu	a5,a4,800028b6 <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002830:	08052903          	lw	s2,128(a0)
    80002834:	00091d63          	bnez	s2,8000284e <bmap+0x72>
      addr = balloc(ip->dev);
    80002838:	4108                	lw	a0,0(a0)
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e70080e7          	jalr	-400(ra) # 800026aa <balloc>
    80002842:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002846:	02090d63          	beqz	s2,80002880 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000284a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000284e:	85ca                	mv	a1,s2
    80002850:	0009a503          	lw	a0,0(s3)
    80002854:	00000097          	auipc	ra,0x0
    80002858:	b96080e7          	jalr	-1130(ra) # 800023ea <bread>
    8000285c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000285e:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002862:	02049713          	sll	a4,s1,0x20
    80002866:	01e75593          	srl	a1,a4,0x1e
    8000286a:	00b784b3          	add	s1,a5,a1
    8000286e:	0004a903          	lw	s2,0(s1)
    80002872:	02090063          	beqz	s2,80002892 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002876:	8552                	mv	a0,s4
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	ca2080e7          	jalr	-862(ra) # 8000251a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002880:	854a                	mv	a0,s2
    80002882:	70a2                	ld	ra,40(sp)
    80002884:	7402                	ld	s0,32(sp)
    80002886:	64e2                	ld	s1,24(sp)
    80002888:	6942                	ld	s2,16(sp)
    8000288a:	69a2                	ld	s3,8(sp)
    8000288c:	6a02                	ld	s4,0(sp)
    8000288e:	6145                	add	sp,sp,48
    80002890:	8082                	ret
      addr = balloc(ip->dev);
    80002892:	0009a503          	lw	a0,0(s3)
    80002896:	00000097          	auipc	ra,0x0
    8000289a:	e14080e7          	jalr	-492(ra) # 800026aa <balloc>
    8000289e:	0005091b          	sext.w	s2,a0
      if(addr){
    800028a2:	fc090ae3          	beqz	s2,80002876 <bmap+0x9a>
        a[bn] = addr;
    800028a6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028aa:	8552                	mv	a0,s4
    800028ac:	00001097          	auipc	ra,0x1
    800028b0:	ec6080e7          	jalr	-314(ra) # 80003772 <log_write>
    800028b4:	b7c9                	j	80002876 <bmap+0x9a>
  panic("bmap: out of range");
    800028b6:	00006517          	auipc	a0,0x6
    800028ba:	d3a50513          	add	a0,a0,-710 # 800085f0 <syscalls+0x120>
    800028be:	00003097          	auipc	ra,0x3
    800028c2:	398080e7          	jalr	920(ra) # 80005c56 <panic>

00000000800028c6 <iget>:
{
    800028c6:	7179                	add	sp,sp,-48
    800028c8:	f406                	sd	ra,40(sp)
    800028ca:	f022                	sd	s0,32(sp)
    800028cc:	ec26                	sd	s1,24(sp)
    800028ce:	e84a                	sd	s2,16(sp)
    800028d0:	e44e                	sd	s3,8(sp)
    800028d2:	e052                	sd	s4,0(sp)
    800028d4:	1800                	add	s0,sp,48
    800028d6:	89aa                	mv	s3,a0
    800028d8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028da:	00015517          	auipc	a0,0x15
    800028de:	8de50513          	add	a0,a0,-1826 # 800171b8 <itable>
    800028e2:	00004097          	auipc	ra,0x4
    800028e6:	8ac080e7          	jalr	-1876(ra) # 8000618e <acquire>
  empty = 0;
    800028ea:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ec:	00015497          	auipc	s1,0x15
    800028f0:	8e448493          	add	s1,s1,-1820 # 800171d0 <itable+0x18>
    800028f4:	00016697          	auipc	a3,0x16
    800028f8:	36c68693          	add	a3,a3,876 # 80018c60 <log>
    800028fc:	a039                	j	8000290a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800028fe:	02090b63          	beqz	s2,80002934 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002902:	08848493          	add	s1,s1,136
    80002906:	02d48a63          	beq	s1,a3,8000293a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000290a:	449c                	lw	a5,8(s1)
    8000290c:	fef059e3          	blez	a5,800028fe <iget+0x38>
    80002910:	4098                	lw	a4,0(s1)
    80002912:	ff3716e3          	bne	a4,s3,800028fe <iget+0x38>
    80002916:	40d8                	lw	a4,4(s1)
    80002918:	ff4713e3          	bne	a4,s4,800028fe <iget+0x38>
      ip->ref++;
    8000291c:	2785                	addw	a5,a5,1
    8000291e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002920:	00015517          	auipc	a0,0x15
    80002924:	89850513          	add	a0,a0,-1896 # 800171b8 <itable>
    80002928:	00004097          	auipc	ra,0x4
    8000292c:	91a080e7          	jalr	-1766(ra) # 80006242 <release>
      return ip;
    80002930:	8926                	mv	s2,s1
    80002932:	a03d                	j	80002960 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002934:	f7f9                	bnez	a5,80002902 <iget+0x3c>
    80002936:	8926                	mv	s2,s1
    80002938:	b7e9                	j	80002902 <iget+0x3c>
  if(empty == 0)
    8000293a:	02090c63          	beqz	s2,80002972 <iget+0xac>
  ip->dev = dev;
    8000293e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002942:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002946:	4785                	li	a5,1
    80002948:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000294c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002950:	00015517          	auipc	a0,0x15
    80002954:	86850513          	add	a0,a0,-1944 # 800171b8 <itable>
    80002958:	00004097          	auipc	ra,0x4
    8000295c:	8ea080e7          	jalr	-1814(ra) # 80006242 <release>
}
    80002960:	854a                	mv	a0,s2
    80002962:	70a2                	ld	ra,40(sp)
    80002964:	7402                	ld	s0,32(sp)
    80002966:	64e2                	ld	s1,24(sp)
    80002968:	6942                	ld	s2,16(sp)
    8000296a:	69a2                	ld	s3,8(sp)
    8000296c:	6a02                	ld	s4,0(sp)
    8000296e:	6145                	add	sp,sp,48
    80002970:	8082                	ret
    panic("iget: no inodes");
    80002972:	00006517          	auipc	a0,0x6
    80002976:	c9650513          	add	a0,a0,-874 # 80008608 <syscalls+0x138>
    8000297a:	00003097          	auipc	ra,0x3
    8000297e:	2dc080e7          	jalr	732(ra) # 80005c56 <panic>

0000000080002982 <fsinit>:
fsinit(int dev) {
    80002982:	7179                	add	sp,sp,-48
    80002984:	f406                	sd	ra,40(sp)
    80002986:	f022                	sd	s0,32(sp)
    80002988:	ec26                	sd	s1,24(sp)
    8000298a:	e84a                	sd	s2,16(sp)
    8000298c:	e44e                	sd	s3,8(sp)
    8000298e:	1800                	add	s0,sp,48
    80002990:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002992:	4585                	li	a1,1
    80002994:	00000097          	auipc	ra,0x0
    80002998:	a56080e7          	jalr	-1450(ra) # 800023ea <bread>
    8000299c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000299e:	00014997          	auipc	s3,0x14
    800029a2:	7fa98993          	add	s3,s3,2042 # 80017198 <sb>
    800029a6:	02000613          	li	a2,32
    800029aa:	05850593          	add	a1,a0,88
    800029ae:	854e                	mv	a0,s3
    800029b0:	ffffe097          	auipc	ra,0xffffe
    800029b4:	826080e7          	jalr	-2010(ra) # 800001d6 <memmove>
  brelse(bp);
    800029b8:	8526                	mv	a0,s1
    800029ba:	00000097          	auipc	ra,0x0
    800029be:	b60080e7          	jalr	-1184(ra) # 8000251a <brelse>
  if(sb.magic != FSMAGIC)
    800029c2:	0009a703          	lw	a4,0(s3)
    800029c6:	102037b7          	lui	a5,0x10203
    800029ca:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ce:	02f71263          	bne	a4,a5,800029f2 <fsinit+0x70>
  initlog(dev, &sb);
    800029d2:	00014597          	auipc	a1,0x14
    800029d6:	7c658593          	add	a1,a1,1990 # 80017198 <sb>
    800029da:	854a                	mv	a0,s2
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	b2c080e7          	jalr	-1236(ra) # 80003508 <initlog>
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6145                	add	sp,sp,48
    800029f0:	8082                	ret
    panic("invalid file system");
    800029f2:	00006517          	auipc	a0,0x6
    800029f6:	c2650513          	add	a0,a0,-986 # 80008618 <syscalls+0x148>
    800029fa:	00003097          	auipc	ra,0x3
    800029fe:	25c080e7          	jalr	604(ra) # 80005c56 <panic>

0000000080002a02 <iinit>:
{
    80002a02:	7179                	add	sp,sp,-48
    80002a04:	f406                	sd	ra,40(sp)
    80002a06:	f022                	sd	s0,32(sp)
    80002a08:	ec26                	sd	s1,24(sp)
    80002a0a:	e84a                	sd	s2,16(sp)
    80002a0c:	e44e                	sd	s3,8(sp)
    80002a0e:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a10:	00006597          	auipc	a1,0x6
    80002a14:	c2058593          	add	a1,a1,-992 # 80008630 <syscalls+0x160>
    80002a18:	00014517          	auipc	a0,0x14
    80002a1c:	7a050513          	add	a0,a0,1952 # 800171b8 <itable>
    80002a20:	00003097          	auipc	ra,0x3
    80002a24:	6de080e7          	jalr	1758(ra) # 800060fe <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a28:	00014497          	auipc	s1,0x14
    80002a2c:	7b848493          	add	s1,s1,1976 # 800171e0 <itable+0x28>
    80002a30:	00016997          	auipc	s3,0x16
    80002a34:	24098993          	add	s3,s3,576 # 80018c70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a38:	00006917          	auipc	s2,0x6
    80002a3c:	c0090913          	add	s2,s2,-1024 # 80008638 <syscalls+0x168>
    80002a40:	85ca                	mv	a1,s2
    80002a42:	8526                	mv	a0,s1
    80002a44:	00001097          	auipc	ra,0x1
    80002a48:	e12080e7          	jalr	-494(ra) # 80003856 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a4c:	08848493          	add	s1,s1,136
    80002a50:	ff3498e3          	bne	s1,s3,80002a40 <iinit+0x3e>
}
    80002a54:	70a2                	ld	ra,40(sp)
    80002a56:	7402                	ld	s0,32(sp)
    80002a58:	64e2                	ld	s1,24(sp)
    80002a5a:	6942                	ld	s2,16(sp)
    80002a5c:	69a2                	ld	s3,8(sp)
    80002a5e:	6145                	add	sp,sp,48
    80002a60:	8082                	ret

0000000080002a62 <ialloc>:
{
    80002a62:	7139                	add	sp,sp,-64
    80002a64:	fc06                	sd	ra,56(sp)
    80002a66:	f822                	sd	s0,48(sp)
    80002a68:	f426                	sd	s1,40(sp)
    80002a6a:	f04a                	sd	s2,32(sp)
    80002a6c:	ec4e                	sd	s3,24(sp)
    80002a6e:	e852                	sd	s4,16(sp)
    80002a70:	e456                	sd	s5,8(sp)
    80002a72:	e05a                	sd	s6,0(sp)
    80002a74:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a76:	00014717          	auipc	a4,0x14
    80002a7a:	72e72703          	lw	a4,1838(a4) # 800171a4 <sb+0xc>
    80002a7e:	4785                	li	a5,1
    80002a80:	04e7f863          	bgeu	a5,a4,80002ad0 <ialloc+0x6e>
    80002a84:	8aaa                	mv	s5,a0
    80002a86:	8b2e                	mv	s6,a1
    80002a88:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a8a:	00014a17          	auipc	s4,0x14
    80002a8e:	70ea0a13          	add	s4,s4,1806 # 80017198 <sb>
    80002a92:	00495593          	srl	a1,s2,0x4
    80002a96:	018a2783          	lw	a5,24(s4)
    80002a9a:	9dbd                	addw	a1,a1,a5
    80002a9c:	8556                	mv	a0,s5
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	94c080e7          	jalr	-1716(ra) # 800023ea <bread>
    80002aa6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aa8:	05850993          	add	s3,a0,88
    80002aac:	00f97793          	and	a5,s2,15
    80002ab0:	079a                	sll	a5,a5,0x6
    80002ab2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    80002ab4:	00099783          	lh	a5,0(s3)
    80002ab8:	cf9d                	beqz	a5,80002af6 <ialloc+0x94>
    brelse(bp);
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	a60080e7          	jalr	-1440(ra) # 8000251a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac2:	0905                	add	s2,s2,1
    80002ac4:	00ca2703          	lw	a4,12(s4)
    80002ac8:	0009079b          	sext.w	a5,s2
    80002acc:	fce7e3e3          	bltu	a5,a4,80002a92 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002ad0:	00006517          	auipc	a0,0x6
    80002ad4:	b7050513          	add	a0,a0,-1168 # 80008640 <syscalls+0x170>
    80002ad8:	00003097          	auipc	ra,0x3
    80002adc:	1c8080e7          	jalr	456(ra) # 80005ca0 <printf>
  return 0;
    80002ae0:	4501                	li	a0,0
}
    80002ae2:	70e2                	ld	ra,56(sp)
    80002ae4:	7442                	ld	s0,48(sp)
    80002ae6:	74a2                	ld	s1,40(sp)
    80002ae8:	7902                	ld	s2,32(sp)
    80002aea:	69e2                	ld	s3,24(sp)
    80002aec:	6a42                	ld	s4,16(sp)
    80002aee:	6aa2                	ld	s5,8(sp)
    80002af0:	6b02                	ld	s6,0(sp)
    80002af2:	6121                	add	sp,sp,64
    80002af4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002af6:	04000613          	li	a2,64
    80002afa:	4581                	li	a1,0
    80002afc:	854e                	mv	a0,s3
    80002afe:	ffffd097          	auipc	ra,0xffffd
    80002b02:	67c080e7          	jalr	1660(ra) # 8000017a <memset>
      dip->type = type;
    80002b06:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80002b0a:	8526                	mv	a0,s1
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	c66080e7          	jalr	-922(ra) # 80003772 <log_write>
      brelse(bp);
    80002b14:	8526                	mv	a0,s1
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	a04080e7          	jalr	-1532(ra) # 8000251a <brelse>
      return iget(dev, inum);
    80002b1e:	0009059b          	sext.w	a1,s2
    80002b22:	8556                	mv	a0,s5
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	da2080e7          	jalr	-606(ra) # 800028c6 <iget>
    80002b2c:	bf5d                	j	80002ae2 <ialloc+0x80>

0000000080002b2e <iupdate>:
{
    80002b2e:	1101                	add	sp,sp,-32
    80002b30:	ec06                	sd	ra,24(sp)
    80002b32:	e822                	sd	s0,16(sp)
    80002b34:	e426                	sd	s1,8(sp)
    80002b36:	e04a                	sd	s2,0(sp)
    80002b38:	1000                	add	s0,sp,32
    80002b3a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b3c:	415c                	lw	a5,4(a0)
    80002b3e:	0047d79b          	srlw	a5,a5,0x4
    80002b42:	00014597          	auipc	a1,0x14
    80002b46:	66e5a583          	lw	a1,1646(a1) # 800171b0 <sb+0x18>
    80002b4a:	9dbd                	addw	a1,a1,a5
    80002b4c:	4108                	lw	a0,0(a0)
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	89c080e7          	jalr	-1892(ra) # 800023ea <bread>
    80002b56:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b58:	05850793          	add	a5,a0,88
    80002b5c:	40d8                	lw	a4,4(s1)
    80002b5e:	8b3d                	and	a4,a4,15
    80002b60:	071a                	sll	a4,a4,0x6
    80002b62:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b64:	04449703          	lh	a4,68(s1)
    80002b68:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b6c:	04649703          	lh	a4,70(s1)
    80002b70:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b74:	04849703          	lh	a4,72(s1)
    80002b78:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b7c:	04a49703          	lh	a4,74(s1)
    80002b80:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b84:	44f8                	lw	a4,76(s1)
    80002b86:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b88:	03400613          	li	a2,52
    80002b8c:	05048593          	add	a1,s1,80
    80002b90:	00c78513          	add	a0,a5,12
    80002b94:	ffffd097          	auipc	ra,0xffffd
    80002b98:	642080e7          	jalr	1602(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b9c:	854a                	mv	a0,s2
    80002b9e:	00001097          	auipc	ra,0x1
    80002ba2:	bd4080e7          	jalr	-1068(ra) # 80003772 <log_write>
  brelse(bp);
    80002ba6:	854a                	mv	a0,s2
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	972080e7          	jalr	-1678(ra) # 8000251a <brelse>
}
    80002bb0:	60e2                	ld	ra,24(sp)
    80002bb2:	6442                	ld	s0,16(sp)
    80002bb4:	64a2                	ld	s1,8(sp)
    80002bb6:	6902                	ld	s2,0(sp)
    80002bb8:	6105                	add	sp,sp,32
    80002bba:	8082                	ret

0000000080002bbc <idup>:
{
    80002bbc:	1101                	add	sp,sp,-32
    80002bbe:	ec06                	sd	ra,24(sp)
    80002bc0:	e822                	sd	s0,16(sp)
    80002bc2:	e426                	sd	s1,8(sp)
    80002bc4:	1000                	add	s0,sp,32
    80002bc6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bc8:	00014517          	auipc	a0,0x14
    80002bcc:	5f050513          	add	a0,a0,1520 # 800171b8 <itable>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	5be080e7          	jalr	1470(ra) # 8000618e <acquire>
  ip->ref++;
    80002bd8:	449c                	lw	a5,8(s1)
    80002bda:	2785                	addw	a5,a5,1
    80002bdc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bde:	00014517          	auipc	a0,0x14
    80002be2:	5da50513          	add	a0,a0,1498 # 800171b8 <itable>
    80002be6:	00003097          	auipc	ra,0x3
    80002bea:	65c080e7          	jalr	1628(ra) # 80006242 <release>
}
    80002bee:	8526                	mv	a0,s1
    80002bf0:	60e2                	ld	ra,24(sp)
    80002bf2:	6442                	ld	s0,16(sp)
    80002bf4:	64a2                	ld	s1,8(sp)
    80002bf6:	6105                	add	sp,sp,32
    80002bf8:	8082                	ret

0000000080002bfa <ilock>:
{
    80002bfa:	1101                	add	sp,sp,-32
    80002bfc:	ec06                	sd	ra,24(sp)
    80002bfe:	e822                	sd	s0,16(sp)
    80002c00:	e426                	sd	s1,8(sp)
    80002c02:	e04a                	sd	s2,0(sp)
    80002c04:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c06:	c115                	beqz	a0,80002c2a <ilock+0x30>
    80002c08:	84aa                	mv	s1,a0
    80002c0a:	451c                	lw	a5,8(a0)
    80002c0c:	00f05f63          	blez	a5,80002c2a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c10:	0541                	add	a0,a0,16
    80002c12:	00001097          	auipc	ra,0x1
    80002c16:	c7e080e7          	jalr	-898(ra) # 80003890 <acquiresleep>
  if(ip->valid == 0){
    80002c1a:	40bc                	lw	a5,64(s1)
    80002c1c:	cf99                	beqz	a5,80002c3a <ilock+0x40>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	6105                	add	sp,sp,32
    80002c28:	8082                	ret
    panic("ilock");
    80002c2a:	00006517          	auipc	a0,0x6
    80002c2e:	a2e50513          	add	a0,a0,-1490 # 80008658 <syscalls+0x188>
    80002c32:	00003097          	auipc	ra,0x3
    80002c36:	024080e7          	jalr	36(ra) # 80005c56 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3a:	40dc                	lw	a5,4(s1)
    80002c3c:	0047d79b          	srlw	a5,a5,0x4
    80002c40:	00014597          	auipc	a1,0x14
    80002c44:	5705a583          	lw	a1,1392(a1) # 800171b0 <sb+0x18>
    80002c48:	9dbd                	addw	a1,a1,a5
    80002c4a:	4088                	lw	a0,0(s1)
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	79e080e7          	jalr	1950(ra) # 800023ea <bread>
    80002c54:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c56:	05850593          	add	a1,a0,88
    80002c5a:	40dc                	lw	a5,4(s1)
    80002c5c:	8bbd                	and	a5,a5,15
    80002c5e:	079a                	sll	a5,a5,0x6
    80002c60:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c62:	00059783          	lh	a5,0(a1)
    80002c66:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c6a:	00259783          	lh	a5,2(a1)
    80002c6e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c72:	00459783          	lh	a5,4(a1)
    80002c76:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c7a:	00659783          	lh	a5,6(a1)
    80002c7e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c82:	459c                	lw	a5,8(a1)
    80002c84:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c86:	03400613          	li	a2,52
    80002c8a:	05b1                	add	a1,a1,12
    80002c8c:	05048513          	add	a0,s1,80
    80002c90:	ffffd097          	auipc	ra,0xffffd
    80002c94:	546080e7          	jalr	1350(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c98:	854a                	mv	a0,s2
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	880080e7          	jalr	-1920(ra) # 8000251a <brelse>
    ip->valid = 1;
    80002ca2:	4785                	li	a5,1
    80002ca4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca6:	04449783          	lh	a5,68(s1)
    80002caa:	fbb5                	bnez	a5,80002c1e <ilock+0x24>
      panic("ilock: no type");
    80002cac:	00006517          	auipc	a0,0x6
    80002cb0:	9b450513          	add	a0,a0,-1612 # 80008660 <syscalls+0x190>
    80002cb4:	00003097          	auipc	ra,0x3
    80002cb8:	fa2080e7          	jalr	-94(ra) # 80005c56 <panic>

0000000080002cbc <iunlock>:
{
    80002cbc:	1101                	add	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	e426                	sd	s1,8(sp)
    80002cc4:	e04a                	sd	s2,0(sp)
    80002cc6:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cc8:	c905                	beqz	a0,80002cf8 <iunlock+0x3c>
    80002cca:	84aa                	mv	s1,a0
    80002ccc:	01050913          	add	s2,a0,16
    80002cd0:	854a                	mv	a0,s2
    80002cd2:	00001097          	auipc	ra,0x1
    80002cd6:	c58080e7          	jalr	-936(ra) # 8000392a <holdingsleep>
    80002cda:	cd19                	beqz	a0,80002cf8 <iunlock+0x3c>
    80002cdc:	449c                	lw	a5,8(s1)
    80002cde:	00f05d63          	blez	a5,80002cf8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ce2:	854a                	mv	a0,s2
    80002ce4:	00001097          	auipc	ra,0x1
    80002ce8:	c02080e7          	jalr	-1022(ra) # 800038e6 <releasesleep>
}
    80002cec:	60e2                	ld	ra,24(sp)
    80002cee:	6442                	ld	s0,16(sp)
    80002cf0:	64a2                	ld	s1,8(sp)
    80002cf2:	6902                	ld	s2,0(sp)
    80002cf4:	6105                	add	sp,sp,32
    80002cf6:	8082                	ret
    panic("iunlock");
    80002cf8:	00006517          	auipc	a0,0x6
    80002cfc:	97850513          	add	a0,a0,-1672 # 80008670 <syscalls+0x1a0>
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	f56080e7          	jalr	-170(ra) # 80005c56 <panic>

0000000080002d08 <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    80002d08:	7179                	add	sp,sp,-48
    80002d0a:	f406                	sd	ra,40(sp)
    80002d0c:	f022                	sd	s0,32(sp)
    80002d0e:	ec26                	sd	s1,24(sp)
    80002d10:	e84a                	sd	s2,16(sp)
    80002d12:	e44e                	sd	s3,8(sp)
    80002d14:	e052                	sd	s4,0(sp)
    80002d16:	1800                	add	s0,sp,48
    80002d18:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d1a:	05050493          	add	s1,a0,80
    80002d1e:	08050913          	add	s2,a0,128
    80002d22:	a021                	j	80002d2a <itrunc+0x22>
    80002d24:	0491                	add	s1,s1,4
    80002d26:	01248d63          	beq	s1,s2,80002d40 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d2a:	408c                	lw	a1,0(s1)
    80002d2c:	dde5                	beqz	a1,80002d24 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d2e:	0009a503          	lw	a0,0(s3)
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	8fc080e7          	jalr	-1796(ra) # 8000262e <bfree>
      ip->addrs[i] = 0;
    80002d3a:	0004a023          	sw	zero,0(s1)
    80002d3e:	b7dd                	j	80002d24 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d40:	0809a583          	lw	a1,128(s3)
    80002d44:	e185                	bnez	a1,80002d64 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d46:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d4a:	854e                	mv	a0,s3
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	de2080e7          	jalr	-542(ra) # 80002b2e <iupdate>
}
    80002d54:	70a2                	ld	ra,40(sp)
    80002d56:	7402                	ld	s0,32(sp)
    80002d58:	64e2                	ld	s1,24(sp)
    80002d5a:	6942                	ld	s2,16(sp)
    80002d5c:	69a2                	ld	s3,8(sp)
    80002d5e:	6a02                	ld	s4,0(sp)
    80002d60:	6145                	add	sp,sp,48
    80002d62:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d64:	0009a503          	lw	a0,0(s3)
    80002d68:	fffff097          	auipc	ra,0xfffff
    80002d6c:	682080e7          	jalr	1666(ra) # 800023ea <bread>
    80002d70:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d72:	05850493          	add	s1,a0,88
    80002d76:	45850913          	add	s2,a0,1112
    80002d7a:	a021                	j	80002d82 <itrunc+0x7a>
    80002d7c:	0491                	add	s1,s1,4
    80002d7e:	01248b63          	beq	s1,s2,80002d94 <itrunc+0x8c>
      if(a[j])
    80002d82:	408c                	lw	a1,0(s1)
    80002d84:	dde5                	beqz	a1,80002d7c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d86:	0009a503          	lw	a0,0(s3)
    80002d8a:	00000097          	auipc	ra,0x0
    80002d8e:	8a4080e7          	jalr	-1884(ra) # 8000262e <bfree>
    80002d92:	b7ed                	j	80002d7c <itrunc+0x74>
    brelse(bp);
    80002d94:	8552                	mv	a0,s4
    80002d96:	fffff097          	auipc	ra,0xfffff
    80002d9a:	784080e7          	jalr	1924(ra) # 8000251a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d9e:	0809a583          	lw	a1,128(s3)
    80002da2:	0009a503          	lw	a0,0(s3)
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	888080e7          	jalr	-1912(ra) # 8000262e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dae:	0809a023          	sw	zero,128(s3)
    80002db2:	bf51                	j	80002d46 <itrunc+0x3e>

0000000080002db4 <iput>:
{
    80002db4:	1101                	add	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	e426                	sd	s1,8(sp)
    80002dbc:	e04a                	sd	s2,0(sp)
    80002dbe:	1000                	add	s0,sp,32
    80002dc0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc2:	00014517          	auipc	a0,0x14
    80002dc6:	3f650513          	add	a0,a0,1014 # 800171b8 <itable>
    80002dca:	00003097          	auipc	ra,0x3
    80002dce:	3c4080e7          	jalr	964(ra) # 8000618e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd2:	4498                	lw	a4,8(s1)
    80002dd4:	4785                	li	a5,1
    80002dd6:	02f70363          	beq	a4,a5,80002dfc <iput+0x48>
  ip->ref--;
    80002dda:	449c                	lw	a5,8(s1)
    80002ddc:	37fd                	addw	a5,a5,-1
    80002dde:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de0:	00014517          	auipc	a0,0x14
    80002de4:	3d850513          	add	a0,a0,984 # 800171b8 <itable>
    80002de8:	00003097          	auipc	ra,0x3
    80002dec:	45a080e7          	jalr	1114(ra) # 80006242 <release>
}
    80002df0:	60e2                	ld	ra,24(sp)
    80002df2:	6442                	ld	s0,16(sp)
    80002df4:	64a2                	ld	s1,8(sp)
    80002df6:	6902                	ld	s2,0(sp)
    80002df8:	6105                	add	sp,sp,32
    80002dfa:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfc:	40bc                	lw	a5,64(s1)
    80002dfe:	dff1                	beqz	a5,80002dda <iput+0x26>
    80002e00:	04a49783          	lh	a5,74(s1)
    80002e04:	fbf9                	bnez	a5,80002dda <iput+0x26>
    acquiresleep(&ip->lock);
    80002e06:	01048913          	add	s2,s1,16
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	00001097          	auipc	ra,0x1
    80002e10:	a84080e7          	jalr	-1404(ra) # 80003890 <acquiresleep>
    release(&itable.lock);
    80002e14:	00014517          	auipc	a0,0x14
    80002e18:	3a450513          	add	a0,a0,932 # 800171b8 <itable>
    80002e1c:	00003097          	auipc	ra,0x3
    80002e20:	426080e7          	jalr	1062(ra) # 80006242 <release>
    itrunc(ip);
    80002e24:	8526                	mv	a0,s1
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	ee2080e7          	jalr	-286(ra) # 80002d08 <itrunc>
    ip->type = 0;
    80002e2e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e32:	8526                	mv	a0,s1
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	cfa080e7          	jalr	-774(ra) # 80002b2e <iupdate>
    ip->valid = 0;
    80002e3c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e40:	854a                	mv	a0,s2
    80002e42:	00001097          	auipc	ra,0x1
    80002e46:	aa4080e7          	jalr	-1372(ra) # 800038e6 <releasesleep>
    acquire(&itable.lock);
    80002e4a:	00014517          	auipc	a0,0x14
    80002e4e:	36e50513          	add	a0,a0,878 # 800171b8 <itable>
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	33c080e7          	jalr	828(ra) # 8000618e <acquire>
    80002e5a:	b741                	j	80002dda <iput+0x26>

0000000080002e5c <iunlockput>:
{
    80002e5c:	1101                	add	sp,sp,-32
    80002e5e:	ec06                	sd	ra,24(sp)
    80002e60:	e822                	sd	s0,16(sp)
    80002e62:	e426                	sd	s1,8(sp)
    80002e64:	1000                	add	s0,sp,32
    80002e66:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e68:	00000097          	auipc	ra,0x0
    80002e6c:	e54080e7          	jalr	-428(ra) # 80002cbc <iunlock>
  iput(ip);
    80002e70:	8526                	mv	a0,s1
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	f42080e7          	jalr	-190(ra) # 80002db4 <iput>
}
    80002e7a:	60e2                	ld	ra,24(sp)
    80002e7c:	6442                	ld	s0,16(sp)
    80002e7e:	64a2                	ld	s1,8(sp)
    80002e80:	6105                	add	sp,sp,32
    80002e82:	8082                	ret

0000000080002e84 <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80002e84:	1141                	add	sp,sp,-16
    80002e86:	e422                	sd	s0,8(sp)
    80002e88:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002e8a:	411c                	lw	a5,0(a0)
    80002e8c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e8e:	415c                	lw	a5,4(a0)
    80002e90:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e92:	04451783          	lh	a5,68(a0)
    80002e96:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e9a:	04a51783          	lh	a5,74(a0)
    80002e9e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ea2:	04c56783          	lwu	a5,76(a0)
    80002ea6:	e99c                	sd	a5,16(a1)
}
    80002ea8:	6422                	ld	s0,8(sp)
    80002eaa:	0141                	add	sp,sp,16
    80002eac:	8082                	ret

0000000080002eae <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eae:	457c                	lw	a5,76(a0)
    80002eb0:	0ed7e963          	bltu	a5,a3,80002fa2 <readi+0xf4>
{
    80002eb4:	7159                	add	sp,sp,-112
    80002eb6:	f486                	sd	ra,104(sp)
    80002eb8:	f0a2                	sd	s0,96(sp)
    80002eba:	eca6                	sd	s1,88(sp)
    80002ebc:	e8ca                	sd	s2,80(sp)
    80002ebe:	e4ce                	sd	s3,72(sp)
    80002ec0:	e0d2                	sd	s4,64(sp)
    80002ec2:	fc56                	sd	s5,56(sp)
    80002ec4:	f85a                	sd	s6,48(sp)
    80002ec6:	f45e                	sd	s7,40(sp)
    80002ec8:	f062                	sd	s8,32(sp)
    80002eca:	ec66                	sd	s9,24(sp)
    80002ecc:	e86a                	sd	s10,16(sp)
    80002ece:	e46e                	sd	s11,8(sp)
    80002ed0:	1880                	add	s0,sp,112
    80002ed2:	8b2a                	mv	s6,a0
    80002ed4:	8bae                	mv	s7,a1
    80002ed6:	8a32                	mv	s4,a2
    80002ed8:	84b6                	mv	s1,a3
    80002eda:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002edc:	9f35                	addw	a4,a4,a3
    return 0;
    80002ede:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ee0:	0ad76063          	bltu	a4,a3,80002f80 <readi+0xd2>
  if(off + n > ip->size)
    80002ee4:	00e7f463          	bgeu	a5,a4,80002eec <readi+0x3e>
    n = ip->size - off;
    80002ee8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eec:	0a0a8963          	beqz	s5,80002f9e <readi+0xf0>
    80002ef0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef6:	5c7d                	li	s8,-1
    80002ef8:	a82d                	j	80002f32 <readi+0x84>
    80002efa:	020d1d93          	sll	s11,s10,0x20
    80002efe:	020ddd93          	srl	s11,s11,0x20
    80002f02:	05890613          	add	a2,s2,88
    80002f06:	86ee                	mv	a3,s11
    80002f08:	963a                	add	a2,a2,a4
    80002f0a:	85d2                	mv	a1,s4
    80002f0c:	855e                	mv	a0,s7
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	a58080e7          	jalr	-1448(ra) # 80001966 <either_copyout>
    80002f16:	05850d63          	beq	a0,s8,80002f70 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	5fe080e7          	jalr	1534(ra) # 8000251a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f24:	013d09bb          	addw	s3,s10,s3
    80002f28:	009d04bb          	addw	s1,s10,s1
    80002f2c:	9a6e                	add	s4,s4,s11
    80002f2e:	0559f763          	bgeu	s3,s5,80002f7c <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f32:	00a4d59b          	srlw	a1,s1,0xa
    80002f36:	855a                	mv	a0,s6
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	8a4080e7          	jalr	-1884(ra) # 800027dc <bmap>
    80002f40:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f44:	cd85                	beqz	a1,80002f7c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f46:	000b2503          	lw	a0,0(s6)
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	4a0080e7          	jalr	1184(ra) # 800023ea <bread>
    80002f52:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f54:	3ff4f713          	and	a4,s1,1023
    80002f58:	40ec87bb          	subw	a5,s9,a4
    80002f5c:	413a86bb          	subw	a3,s5,s3
    80002f60:	8d3e                	mv	s10,a5
    80002f62:	2781                	sext.w	a5,a5
    80002f64:	0006861b          	sext.w	a2,a3
    80002f68:	f8f679e3          	bgeu	a2,a5,80002efa <readi+0x4c>
    80002f6c:	8d36                	mv	s10,a3
    80002f6e:	b771                	j	80002efa <readi+0x4c>
      brelse(bp);
    80002f70:	854a                	mv	a0,s2
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	5a8080e7          	jalr	1448(ra) # 8000251a <brelse>
      tot = -1;
    80002f7a:	59fd                	li	s3,-1
  }
  return tot;
    80002f7c:	0009851b          	sext.w	a0,s3
}
    80002f80:	70a6                	ld	ra,104(sp)
    80002f82:	7406                	ld	s0,96(sp)
    80002f84:	64e6                	ld	s1,88(sp)
    80002f86:	6946                	ld	s2,80(sp)
    80002f88:	69a6                	ld	s3,72(sp)
    80002f8a:	6a06                	ld	s4,64(sp)
    80002f8c:	7ae2                	ld	s5,56(sp)
    80002f8e:	7b42                	ld	s6,48(sp)
    80002f90:	7ba2                	ld	s7,40(sp)
    80002f92:	7c02                	ld	s8,32(sp)
    80002f94:	6ce2                	ld	s9,24(sp)
    80002f96:	6d42                	ld	s10,16(sp)
    80002f98:	6da2                	ld	s11,8(sp)
    80002f9a:	6165                	add	sp,sp,112
    80002f9c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f9e:	89d6                	mv	s3,s5
    80002fa0:	bff1                	j	80002f7c <readi+0xce>
    return 0;
    80002fa2:	4501                	li	a0,0
}
    80002fa4:	8082                	ret

0000000080002fa6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa6:	457c                	lw	a5,76(a0)
    80002fa8:	10d7e863          	bltu	a5,a3,800030b8 <writei+0x112>
{
    80002fac:	7159                	add	sp,sp,-112
    80002fae:	f486                	sd	ra,104(sp)
    80002fb0:	f0a2                	sd	s0,96(sp)
    80002fb2:	eca6                	sd	s1,88(sp)
    80002fb4:	e8ca                	sd	s2,80(sp)
    80002fb6:	e4ce                	sd	s3,72(sp)
    80002fb8:	e0d2                	sd	s4,64(sp)
    80002fba:	fc56                	sd	s5,56(sp)
    80002fbc:	f85a                	sd	s6,48(sp)
    80002fbe:	f45e                	sd	s7,40(sp)
    80002fc0:	f062                	sd	s8,32(sp)
    80002fc2:	ec66                	sd	s9,24(sp)
    80002fc4:	e86a                	sd	s10,16(sp)
    80002fc6:	e46e                	sd	s11,8(sp)
    80002fc8:	1880                	add	s0,sp,112
    80002fca:	8aaa                	mv	s5,a0
    80002fcc:	8bae                	mv	s7,a1
    80002fce:	8a32                	mv	s4,a2
    80002fd0:	8936                	mv	s2,a3
    80002fd2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fd4:	00e687bb          	addw	a5,a3,a4
    80002fd8:	0ed7e263          	bltu	a5,a3,800030bc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fdc:	00043737          	lui	a4,0x43
    80002fe0:	0ef76063          	bltu	a4,a5,800030c0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe4:	0c0b0863          	beqz	s6,800030b4 <writei+0x10e>
    80002fe8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fea:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fee:	5c7d                	li	s8,-1
    80002ff0:	a091                	j	80003034 <writei+0x8e>
    80002ff2:	020d1d93          	sll	s11,s10,0x20
    80002ff6:	020ddd93          	srl	s11,s11,0x20
    80002ffa:	05848513          	add	a0,s1,88
    80002ffe:	86ee                	mv	a3,s11
    80003000:	8652                	mv	a2,s4
    80003002:	85de                	mv	a1,s7
    80003004:	953a                	add	a0,a0,a4
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	9b6080e7          	jalr	-1610(ra) # 800019bc <either_copyin>
    8000300e:	07850263          	beq	a0,s8,80003072 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003012:	8526                	mv	a0,s1
    80003014:	00000097          	auipc	ra,0x0
    80003018:	75e080e7          	jalr	1886(ra) # 80003772 <log_write>
    brelse(bp);
    8000301c:	8526                	mv	a0,s1
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	4fc080e7          	jalr	1276(ra) # 8000251a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003026:	013d09bb          	addw	s3,s10,s3
    8000302a:	012d093b          	addw	s2,s10,s2
    8000302e:	9a6e                	add	s4,s4,s11
    80003030:	0569f663          	bgeu	s3,s6,8000307c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003034:	00a9559b          	srlw	a1,s2,0xa
    80003038:	8556                	mv	a0,s5
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	7a2080e7          	jalr	1954(ra) # 800027dc <bmap>
    80003042:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003046:	c99d                	beqz	a1,8000307c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003048:	000aa503          	lw	a0,0(s5)
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	39e080e7          	jalr	926(ra) # 800023ea <bread>
    80003054:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003056:	3ff97713          	and	a4,s2,1023
    8000305a:	40ec87bb          	subw	a5,s9,a4
    8000305e:	413b06bb          	subw	a3,s6,s3
    80003062:	8d3e                	mv	s10,a5
    80003064:	2781                	sext.w	a5,a5
    80003066:	0006861b          	sext.w	a2,a3
    8000306a:	f8f674e3          	bgeu	a2,a5,80002ff2 <writei+0x4c>
    8000306e:	8d36                	mv	s10,a3
    80003070:	b749                	j	80002ff2 <writei+0x4c>
      brelse(bp);
    80003072:	8526                	mv	a0,s1
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	4a6080e7          	jalr	1190(ra) # 8000251a <brelse>
  }

  if(off > ip->size)
    8000307c:	04caa783          	lw	a5,76(s5)
    80003080:	0127f463          	bgeu	a5,s2,80003088 <writei+0xe2>
    ip->size = off;
    80003084:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80003088:	8556                	mv	a0,s5
    8000308a:	00000097          	auipc	ra,0x0
    8000308e:	aa4080e7          	jalr	-1372(ra) # 80002b2e <iupdate>

  return tot;
    80003092:	0009851b          	sext.w	a0,s3
}
    80003096:	70a6                	ld	ra,104(sp)
    80003098:	7406                	ld	s0,96(sp)
    8000309a:	64e6                	ld	s1,88(sp)
    8000309c:	6946                	ld	s2,80(sp)
    8000309e:	69a6                	ld	s3,72(sp)
    800030a0:	6a06                	ld	s4,64(sp)
    800030a2:	7ae2                	ld	s5,56(sp)
    800030a4:	7b42                	ld	s6,48(sp)
    800030a6:	7ba2                	ld	s7,40(sp)
    800030a8:	7c02                	ld	s8,32(sp)
    800030aa:	6ce2                	ld	s9,24(sp)
    800030ac:	6d42                	ld	s10,16(sp)
    800030ae:	6da2                	ld	s11,8(sp)
    800030b0:	6165                	add	sp,sp,112
    800030b2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b4:	89da                	mv	s3,s6
    800030b6:	bfc9                	j	80003088 <writei+0xe2>
    return -1;
    800030b8:	557d                	li	a0,-1
}
    800030ba:	8082                	ret
    return -1;
    800030bc:	557d                	li	a0,-1
    800030be:	bfe1                	j	80003096 <writei+0xf0>
    return -1;
    800030c0:	557d                	li	a0,-1
    800030c2:	bfd1                	j	80003096 <writei+0xf0>

00000000800030c4 <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    800030c4:	1141                	add	sp,sp,-16
    800030c6:	e406                	sd	ra,8(sp)
    800030c8:	e022                	sd	s0,0(sp)
    800030ca:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030cc:	4639                	li	a2,14
    800030ce:	ffffd097          	auipc	ra,0xffffd
    800030d2:	17c080e7          	jalr	380(ra) # 8000024a <strncmp>
}
    800030d6:	60a2                	ld	ra,8(sp)
    800030d8:	6402                	ld	s0,0(sp)
    800030da:	0141                	add	sp,sp,16
    800030dc:	8082                	ret

00000000800030de <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030de:	7139                	add	sp,sp,-64
    800030e0:	fc06                	sd	ra,56(sp)
    800030e2:	f822                	sd	s0,48(sp)
    800030e4:	f426                	sd	s1,40(sp)
    800030e6:	f04a                	sd	s2,32(sp)
    800030e8:	ec4e                	sd	s3,24(sp)
    800030ea:	e852                	sd	s4,16(sp)
    800030ec:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ee:	04451703          	lh	a4,68(a0)
    800030f2:	4785                	li	a5,1
    800030f4:	00f71a63          	bne	a4,a5,80003108 <dirlookup+0x2a>
    800030f8:	892a                	mv	s2,a0
    800030fa:	89ae                	mv	s3,a1
    800030fc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fe:	457c                	lw	a5,76(a0)
    80003100:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003102:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003104:	e79d                	bnez	a5,80003132 <dirlookup+0x54>
    80003106:	a8a5                	j	8000317e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003108:	00005517          	auipc	a0,0x5
    8000310c:	57050513          	add	a0,a0,1392 # 80008678 <syscalls+0x1a8>
    80003110:	00003097          	auipc	ra,0x3
    80003114:	b46080e7          	jalr	-1210(ra) # 80005c56 <panic>
      panic("dirlookup read");
    80003118:	00005517          	auipc	a0,0x5
    8000311c:	57850513          	add	a0,a0,1400 # 80008690 <syscalls+0x1c0>
    80003120:	00003097          	auipc	ra,0x3
    80003124:	b36080e7          	jalr	-1226(ra) # 80005c56 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003128:	24c1                	addw	s1,s1,16
    8000312a:	04c92783          	lw	a5,76(s2)
    8000312e:	04f4f763          	bgeu	s1,a5,8000317c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003132:	4741                	li	a4,16
    80003134:	86a6                	mv	a3,s1
    80003136:	fc040613          	add	a2,s0,-64
    8000313a:	4581                	li	a1,0
    8000313c:	854a                	mv	a0,s2
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	d70080e7          	jalr	-656(ra) # 80002eae <readi>
    80003146:	47c1                	li	a5,16
    80003148:	fcf518e3          	bne	a0,a5,80003118 <dirlookup+0x3a>
    if(de.inum == 0)
    8000314c:	fc045783          	lhu	a5,-64(s0)
    80003150:	dfe1                	beqz	a5,80003128 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003152:	fc240593          	add	a1,s0,-62
    80003156:	854e                	mv	a0,s3
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	f6c080e7          	jalr	-148(ra) # 800030c4 <namecmp>
    80003160:	f561                	bnez	a0,80003128 <dirlookup+0x4a>
      if(poff)
    80003162:	000a0463          	beqz	s4,8000316a <dirlookup+0x8c>
        *poff = off;
    80003166:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000316a:	fc045583          	lhu	a1,-64(s0)
    8000316e:	00092503          	lw	a0,0(s2)
    80003172:	fffff097          	auipc	ra,0xfffff
    80003176:	754080e7          	jalr	1876(ra) # 800028c6 <iget>
    8000317a:	a011                	j	8000317e <dirlookup+0xa0>
  return 0;
    8000317c:	4501                	li	a0,0
}
    8000317e:	70e2                	ld	ra,56(sp)
    80003180:	7442                	ld	s0,48(sp)
    80003182:	74a2                	ld	s1,40(sp)
    80003184:	7902                	ld	s2,32(sp)
    80003186:	69e2                	ld	s3,24(sp)
    80003188:	6a42                	ld	s4,16(sp)
    8000318a:	6121                	add	sp,sp,64
    8000318c:	8082                	ret

000000008000318e <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000318e:	711d                	add	sp,sp,-96
    80003190:	ec86                	sd	ra,88(sp)
    80003192:	e8a2                	sd	s0,80(sp)
    80003194:	e4a6                	sd	s1,72(sp)
    80003196:	e0ca                	sd	s2,64(sp)
    80003198:	fc4e                	sd	s3,56(sp)
    8000319a:	f852                	sd	s4,48(sp)
    8000319c:	f456                	sd	s5,40(sp)
    8000319e:	f05a                	sd	s6,32(sp)
    800031a0:	ec5e                	sd	s7,24(sp)
    800031a2:	e862                	sd	s8,16(sp)
    800031a4:	e466                	sd	s9,8(sp)
    800031a6:	1080                	add	s0,sp,96
    800031a8:	84aa                	mv	s1,a0
    800031aa:	8b2e                	mv	s6,a1
    800031ac:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ae:	00054703          	lbu	a4,0(a0)
    800031b2:	02f00793          	li	a5,47
    800031b6:	02f70263          	beq	a4,a5,800031da <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031ba:	ffffe097          	auipc	ra,0xffffe
    800031be:	cf0080e7          	jalr	-784(ra) # 80000eaa <myproc>
    800031c2:	15053503          	ld	a0,336(a0)
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	9f6080e7          	jalr	-1546(ra) # 80002bbc <idup>
    800031ce:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031d0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031d4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031d6:	4b85                	li	s7,1
    800031d8:	a875                	j	80003294 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031da:	4585                	li	a1,1
    800031dc:	4505                	li	a0,1
    800031de:	fffff097          	auipc	ra,0xfffff
    800031e2:	6e8080e7          	jalr	1768(ra) # 800028c6 <iget>
    800031e6:	8a2a                	mv	s4,a0
    800031e8:	b7e5                	j	800031d0 <namex+0x42>
      iunlockput(ip);
    800031ea:	8552                	mv	a0,s4
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	c70080e7          	jalr	-912(ra) # 80002e5c <iunlockput>
      return 0;
    800031f4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031f6:	8552                	mv	a0,s4
    800031f8:	60e6                	ld	ra,88(sp)
    800031fa:	6446                	ld	s0,80(sp)
    800031fc:	64a6                	ld	s1,72(sp)
    800031fe:	6906                	ld	s2,64(sp)
    80003200:	79e2                	ld	s3,56(sp)
    80003202:	7a42                	ld	s4,48(sp)
    80003204:	7aa2                	ld	s5,40(sp)
    80003206:	7b02                	ld	s6,32(sp)
    80003208:	6be2                	ld	s7,24(sp)
    8000320a:	6c42                	ld	s8,16(sp)
    8000320c:	6ca2                	ld	s9,8(sp)
    8000320e:	6125                	add	sp,sp,96
    80003210:	8082                	ret
      iunlock(ip);
    80003212:	8552                	mv	a0,s4
    80003214:	00000097          	auipc	ra,0x0
    80003218:	aa8080e7          	jalr	-1368(ra) # 80002cbc <iunlock>
      return ip;
    8000321c:	bfe9                	j	800031f6 <namex+0x68>
      iunlockput(ip);
    8000321e:	8552                	mv	a0,s4
    80003220:	00000097          	auipc	ra,0x0
    80003224:	c3c080e7          	jalr	-964(ra) # 80002e5c <iunlockput>
      return 0;
    80003228:	8a4e                	mv	s4,s3
    8000322a:	b7f1                	j	800031f6 <namex+0x68>
  len = path - s;
    8000322c:	40998633          	sub	a2,s3,s1
    80003230:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003234:	099c5863          	bge	s8,s9,800032c4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003238:	4639                	li	a2,14
    8000323a:	85a6                	mv	a1,s1
    8000323c:	8556                	mv	a0,s5
    8000323e:	ffffd097          	auipc	ra,0xffffd
    80003242:	f98080e7          	jalr	-104(ra) # 800001d6 <memmove>
    80003246:	84ce                	mv	s1,s3
  while(*path == '/')
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	01279763          	bne	a5,s2,8000325a <namex+0xcc>
    path++;
    80003250:	0485                	add	s1,s1,1
  while(*path == '/')
    80003252:	0004c783          	lbu	a5,0(s1)
    80003256:	ff278de3          	beq	a5,s2,80003250 <namex+0xc2>
    ilock(ip);
    8000325a:	8552                	mv	a0,s4
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	99e080e7          	jalr	-1634(ra) # 80002bfa <ilock>
    if(ip->type != T_DIR){
    80003264:	044a1783          	lh	a5,68(s4)
    80003268:	f97791e3          	bne	a5,s7,800031ea <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000326c:	000b0563          	beqz	s6,80003276 <namex+0xe8>
    80003270:	0004c783          	lbu	a5,0(s1)
    80003274:	dfd9                	beqz	a5,80003212 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003276:	4601                	li	a2,0
    80003278:	85d6                	mv	a1,s5
    8000327a:	8552                	mv	a0,s4
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	e62080e7          	jalr	-414(ra) # 800030de <dirlookup>
    80003284:	89aa                	mv	s3,a0
    80003286:	dd41                	beqz	a0,8000321e <namex+0x90>
    iunlockput(ip);
    80003288:	8552                	mv	a0,s4
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	bd2080e7          	jalr	-1070(ra) # 80002e5c <iunlockput>
    ip = next;
    80003292:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	01279763          	bne	a5,s2,800032a6 <namex+0x118>
    path++;
    8000329c:	0485                	add	s1,s1,1
  while(*path == '/')
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	ff278de3          	beq	a5,s2,8000329c <namex+0x10e>
  if(*path == 0)
    800032a6:	cb9d                	beqz	a5,800032dc <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032a8:	0004c783          	lbu	a5,0(s1)
    800032ac:	89a6                	mv	s3,s1
  len = path - s;
    800032ae:	4c81                	li	s9,0
    800032b0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032b2:	01278963          	beq	a5,s2,800032c4 <namex+0x136>
    800032b6:	dbbd                	beqz	a5,8000322c <namex+0x9e>
    path++;
    800032b8:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800032ba:	0009c783          	lbu	a5,0(s3)
    800032be:	ff279ce3          	bne	a5,s2,800032b6 <namex+0x128>
    800032c2:	b7ad                	j	8000322c <namex+0x9e>
    memmove(name, s, len);
    800032c4:	2601                	sext.w	a2,a2
    800032c6:	85a6                	mv	a1,s1
    800032c8:	8556                	mv	a0,s5
    800032ca:	ffffd097          	auipc	ra,0xffffd
    800032ce:	f0c080e7          	jalr	-244(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032d2:	9cd6                	add	s9,s9,s5
    800032d4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032d8:	84ce                	mv	s1,s3
    800032da:	b7bd                	j	80003248 <namex+0xba>
  if(nameiparent){
    800032dc:	f00b0de3          	beqz	s6,800031f6 <namex+0x68>
    iput(ip);
    800032e0:	8552                	mv	a0,s4
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	ad2080e7          	jalr	-1326(ra) # 80002db4 <iput>
    return 0;
    800032ea:	4a01                	li	s4,0
    800032ec:	b729                	j	800031f6 <namex+0x68>

00000000800032ee <dirlink>:
{
    800032ee:	7139                	add	sp,sp,-64
    800032f0:	fc06                	sd	ra,56(sp)
    800032f2:	f822                	sd	s0,48(sp)
    800032f4:	f426                	sd	s1,40(sp)
    800032f6:	f04a                	sd	s2,32(sp)
    800032f8:	ec4e                	sd	s3,24(sp)
    800032fa:	e852                	sd	s4,16(sp)
    800032fc:	0080                	add	s0,sp,64
    800032fe:	892a                	mv	s2,a0
    80003300:	8a2e                	mv	s4,a1
    80003302:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003304:	4601                	li	a2,0
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	dd8080e7          	jalr	-552(ra) # 800030de <dirlookup>
    8000330e:	e93d                	bnez	a0,80003384 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003310:	04c92483          	lw	s1,76(s2)
    80003314:	c49d                	beqz	s1,80003342 <dirlink+0x54>
    80003316:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003318:	4741                	li	a4,16
    8000331a:	86a6                	mv	a3,s1
    8000331c:	fc040613          	add	a2,s0,-64
    80003320:	4581                	li	a1,0
    80003322:	854a                	mv	a0,s2
    80003324:	00000097          	auipc	ra,0x0
    80003328:	b8a080e7          	jalr	-1142(ra) # 80002eae <readi>
    8000332c:	47c1                	li	a5,16
    8000332e:	06f51163          	bne	a0,a5,80003390 <dirlink+0xa2>
    if(de.inum == 0)
    80003332:	fc045783          	lhu	a5,-64(s0)
    80003336:	c791                	beqz	a5,80003342 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003338:	24c1                	addw	s1,s1,16
    8000333a:	04c92783          	lw	a5,76(s2)
    8000333e:	fcf4ede3          	bltu	s1,a5,80003318 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003342:	4639                	li	a2,14
    80003344:	85d2                	mv	a1,s4
    80003346:	fc240513          	add	a0,s0,-62
    8000334a:	ffffd097          	auipc	ra,0xffffd
    8000334e:	f3c080e7          	jalr	-196(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003352:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003356:	4741                	li	a4,16
    80003358:	86a6                	mv	a3,s1
    8000335a:	fc040613          	add	a2,s0,-64
    8000335e:	4581                	li	a1,0
    80003360:	854a                	mv	a0,s2
    80003362:	00000097          	auipc	ra,0x0
    80003366:	c44080e7          	jalr	-956(ra) # 80002fa6 <writei>
    8000336a:	1541                	add	a0,a0,-16
    8000336c:	00a03533          	snez	a0,a0
    80003370:	40a00533          	neg	a0,a0
}
    80003374:	70e2                	ld	ra,56(sp)
    80003376:	7442                	ld	s0,48(sp)
    80003378:	74a2                	ld	s1,40(sp)
    8000337a:	7902                	ld	s2,32(sp)
    8000337c:	69e2                	ld	s3,24(sp)
    8000337e:	6a42                	ld	s4,16(sp)
    80003380:	6121                	add	sp,sp,64
    80003382:	8082                	ret
    iput(ip);
    80003384:	00000097          	auipc	ra,0x0
    80003388:	a30080e7          	jalr	-1488(ra) # 80002db4 <iput>
    return -1;
    8000338c:	557d                	li	a0,-1
    8000338e:	b7dd                	j	80003374 <dirlink+0x86>
      panic("dirlink read");
    80003390:	00005517          	auipc	a0,0x5
    80003394:	31050513          	add	a0,a0,784 # 800086a0 <syscalls+0x1d0>
    80003398:	00003097          	auipc	ra,0x3
    8000339c:	8be080e7          	jalr	-1858(ra) # 80005c56 <panic>

00000000800033a0 <namei>:

struct inode*
namei(char *path)
{
    800033a0:	1101                	add	sp,sp,-32
    800033a2:	ec06                	sd	ra,24(sp)
    800033a4:	e822                	sd	s0,16(sp)
    800033a6:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a8:	fe040613          	add	a2,s0,-32
    800033ac:	4581                	li	a1,0
    800033ae:	00000097          	auipc	ra,0x0
    800033b2:	de0080e7          	jalr	-544(ra) # 8000318e <namex>
}
    800033b6:	60e2                	ld	ra,24(sp)
    800033b8:	6442                	ld	s0,16(sp)
    800033ba:	6105                	add	sp,sp,32
    800033bc:	8082                	ret

00000000800033be <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033be:	1141                	add	sp,sp,-16
    800033c0:	e406                	sd	ra,8(sp)
    800033c2:	e022                	sd	s0,0(sp)
    800033c4:	0800                	add	s0,sp,16
    800033c6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c8:	4585                	li	a1,1
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	dc4080e7          	jalr	-572(ra) # 8000318e <namex>
}
    800033d2:	60a2                	ld	ra,8(sp)
    800033d4:	6402                	ld	s0,0(sp)
    800033d6:	0141                	add	sp,sp,16
    800033d8:	8082                	ret

00000000800033da <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    800033da:	1101                	add	sp,sp,-32
    800033dc:	ec06                	sd	ra,24(sp)
    800033de:	e822                	sd	s0,16(sp)
    800033e0:	e426                	sd	s1,8(sp)
    800033e2:	e04a                	sd	s2,0(sp)
    800033e4:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e6:	00016917          	auipc	s2,0x16
    800033ea:	87a90913          	add	s2,s2,-1926 # 80018c60 <log>
    800033ee:	01892583          	lw	a1,24(s2)
    800033f2:	02892503          	lw	a0,40(s2)
    800033f6:	fffff097          	auipc	ra,0xfffff
    800033fa:	ff4080e7          	jalr	-12(ra) # 800023ea <bread>
    800033fe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003400:	02c92603          	lw	a2,44(s2)
    80003404:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003406:	00c05f63          	blez	a2,80003424 <write_head+0x4a>
    8000340a:	00016717          	auipc	a4,0x16
    8000340e:	88670713          	add	a4,a4,-1914 # 80018c90 <log+0x30>
    80003412:	87aa                	mv	a5,a0
    80003414:	060a                	sll	a2,a2,0x2
    80003416:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003418:	4314                	lw	a3,0(a4)
    8000341a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000341c:	0711                	add	a4,a4,4
    8000341e:	0791                	add	a5,a5,4
    80003420:	fec79ce3          	bne	a5,a2,80003418 <write_head+0x3e>
  }
  bwrite(buf);
    80003424:	8526                	mv	a0,s1
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	0b6080e7          	jalr	182(ra) # 800024dc <bwrite>
  brelse(buf);
    8000342e:	8526                	mv	a0,s1
    80003430:	fffff097          	auipc	ra,0xfffff
    80003434:	0ea080e7          	jalr	234(ra) # 8000251a <brelse>
}
    80003438:	60e2                	ld	ra,24(sp)
    8000343a:	6442                	ld	s0,16(sp)
    8000343c:	64a2                	ld	s1,8(sp)
    8000343e:	6902                	ld	s2,0(sp)
    80003440:	6105                	add	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003444:	00016797          	auipc	a5,0x16
    80003448:	8487a783          	lw	a5,-1976(a5) # 80018c8c <log+0x2c>
    8000344c:	0af05d63          	blez	a5,80003506 <install_trans+0xc2>
{
    80003450:	7139                	add	sp,sp,-64
    80003452:	fc06                	sd	ra,56(sp)
    80003454:	f822                	sd	s0,48(sp)
    80003456:	f426                	sd	s1,40(sp)
    80003458:	f04a                	sd	s2,32(sp)
    8000345a:	ec4e                	sd	s3,24(sp)
    8000345c:	e852                	sd	s4,16(sp)
    8000345e:	e456                	sd	s5,8(sp)
    80003460:	e05a                	sd	s6,0(sp)
    80003462:	0080                	add	s0,sp,64
    80003464:	8b2a                	mv	s6,a0
    80003466:	00016a97          	auipc	s5,0x16
    8000346a:	82aa8a93          	add	s5,s5,-2006 # 80018c90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80003470:	00015997          	auipc	s3,0x15
    80003474:	7f098993          	add	s3,s3,2032 # 80018c60 <log>
    80003478:	a00d                	j	8000349a <install_trans+0x56>
    brelse(lbuf);
    8000347a:	854a                	mv	a0,s2
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	09e080e7          	jalr	158(ra) # 8000251a <brelse>
    brelse(dbuf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	094080e7          	jalr	148(ra) # 8000251a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000348e:	2a05                	addw	s4,s4,1
    80003490:	0a91                	add	s5,s5,4
    80003492:	02c9a783          	lw	a5,44(s3)
    80003496:	04fa5e63          	bge	s4,a5,800034f2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000349a:	0189a583          	lw	a1,24(s3)
    8000349e:	014585bb          	addw	a1,a1,s4
    800034a2:	2585                	addw	a1,a1,1
    800034a4:	0289a503          	lw	a0,40(s3)
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	f42080e7          	jalr	-190(ra) # 800023ea <bread>
    800034b0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    800034b2:	000aa583          	lw	a1,0(s5)
    800034b6:	0289a503          	lw	a0,40(s3)
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	f30080e7          	jalr	-208(ra) # 800023ea <bread>
    800034c2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    800034c4:	40000613          	li	a2,1024
    800034c8:	05890593          	add	a1,s2,88
    800034cc:	05850513          	add	a0,a0,88
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	d06080e7          	jalr	-762(ra) # 800001d6 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    800034d8:	8526                	mv	a0,s1
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	002080e7          	jalr	2(ra) # 800024dc <bwrite>
    if(recovering == 0)
    800034e2:	f80b1ce3          	bnez	s6,8000347a <install_trans+0x36>
      bunpin(dbuf);
    800034e6:	8526                	mv	a0,s1
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	10a080e7          	jalr	266(ra) # 800025f2 <bunpin>
    800034f0:	b769                	j	8000347a <install_trans+0x36>
}
    800034f2:	70e2                	ld	ra,56(sp)
    800034f4:	7442                	ld	s0,48(sp)
    800034f6:	74a2                	ld	s1,40(sp)
    800034f8:	7902                	ld	s2,32(sp)
    800034fa:	69e2                	ld	s3,24(sp)
    800034fc:	6a42                	ld	s4,16(sp)
    800034fe:	6aa2                	ld	s5,8(sp)
    80003500:	6b02                	ld	s6,0(sp)
    80003502:	6121                	add	sp,sp,64
    80003504:	8082                	ret
    80003506:	8082                	ret

0000000080003508 <initlog>:
{
    80003508:	7179                	add	sp,sp,-48
    8000350a:	f406                	sd	ra,40(sp)
    8000350c:	f022                	sd	s0,32(sp)
    8000350e:	ec26                	sd	s1,24(sp)
    80003510:	e84a                	sd	s2,16(sp)
    80003512:	e44e                	sd	s3,8(sp)
    80003514:	1800                	add	s0,sp,48
    80003516:	892a                	mv	s2,a0
    80003518:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000351a:	00015497          	auipc	s1,0x15
    8000351e:	74648493          	add	s1,s1,1862 # 80018c60 <log>
    80003522:	00005597          	auipc	a1,0x5
    80003526:	18e58593          	add	a1,a1,398 # 800086b0 <syscalls+0x1e0>
    8000352a:	8526                	mv	a0,s1
    8000352c:	00003097          	auipc	ra,0x3
    80003530:	bd2080e7          	jalr	-1070(ra) # 800060fe <initlock>
  log.start = sb->logstart;
    80003534:	0149a583          	lw	a1,20(s3)
    80003538:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000353a:	0109a783          	lw	a5,16(s3)
    8000353e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003540:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003544:	854a                	mv	a0,s2
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	ea4080e7          	jalr	-348(ra) # 800023ea <bread>
  log.lh.n = lh->n;
    8000354e:	4d30                	lw	a2,88(a0)
    80003550:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003552:	00c05f63          	blez	a2,80003570 <initlog+0x68>
    80003556:	87aa                	mv	a5,a0
    80003558:	00015717          	auipc	a4,0x15
    8000355c:	73870713          	add	a4,a4,1848 # 80018c90 <log+0x30>
    80003560:	060a                	sll	a2,a2,0x2
    80003562:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003564:	4ff4                	lw	a3,92(a5)
    80003566:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003568:	0791                	add	a5,a5,4
    8000356a:	0711                	add	a4,a4,4
    8000356c:	fec79ce3          	bne	a5,a2,80003564 <initlog+0x5c>
  brelse(buf);
    80003570:	fffff097          	auipc	ra,0xfffff
    80003574:	faa080e7          	jalr	-86(ra) # 8000251a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    80003578:	4505                	li	a0,1
    8000357a:	00000097          	auipc	ra,0x0
    8000357e:	eca080e7          	jalr	-310(ra) # 80003444 <install_trans>
  log.lh.n = 0;
    80003582:	00015797          	auipc	a5,0x15
    80003586:	7007a523          	sw	zero,1802(a5) # 80018c8c <log+0x2c>
  write_head(); /* clear the log */
    8000358a:	00000097          	auipc	ra,0x0
    8000358e:	e50080e7          	jalr	-432(ra) # 800033da <write_head>
}
    80003592:	70a2                	ld	ra,40(sp)
    80003594:	7402                	ld	s0,32(sp)
    80003596:	64e2                	ld	s1,24(sp)
    80003598:	6942                	ld	s2,16(sp)
    8000359a:	69a2                	ld	s3,8(sp)
    8000359c:	6145                	add	sp,sp,48
    8000359e:	8082                	ret

00000000800035a0 <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    800035a0:	1101                	add	sp,sp,-32
    800035a2:	ec06                	sd	ra,24(sp)
    800035a4:	e822                	sd	s0,16(sp)
    800035a6:	e426                	sd	s1,8(sp)
    800035a8:	e04a                	sd	s2,0(sp)
    800035aa:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800035ac:	00015517          	auipc	a0,0x15
    800035b0:	6b450513          	add	a0,a0,1716 # 80018c60 <log>
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	bda080e7          	jalr	-1062(ra) # 8000618e <acquire>
  while(1){
    if(log.committing){
    800035bc:	00015497          	auipc	s1,0x15
    800035c0:	6a448493          	add	s1,s1,1700 # 80018c60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c4:	4979                	li	s2,30
    800035c6:	a039                	j	800035d4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c8:	85a6                	mv	a1,s1
    800035ca:	8526                	mv	a0,s1
    800035cc:	ffffe097          	auipc	ra,0xffffe
    800035d0:	f92080e7          	jalr	-110(ra) # 8000155e <sleep>
    if(log.committing){
    800035d4:	50dc                	lw	a5,36(s1)
    800035d6:	fbed                	bnez	a5,800035c8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d8:	5098                	lw	a4,32(s1)
    800035da:	2705                	addw	a4,a4,1
    800035dc:	0027179b          	sllw	a5,a4,0x2
    800035e0:	9fb9                	addw	a5,a5,a4
    800035e2:	0017979b          	sllw	a5,a5,0x1
    800035e6:	54d4                	lw	a3,44(s1)
    800035e8:	9fb5                	addw	a5,a5,a3
    800035ea:	00f95963          	bge	s2,a5,800035fc <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    800035ee:	85a6                	mv	a1,s1
    800035f0:	8526                	mv	a0,s1
    800035f2:	ffffe097          	auipc	ra,0xffffe
    800035f6:	f6c080e7          	jalr	-148(ra) # 8000155e <sleep>
    800035fa:	bfe9                	j	800035d4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035fc:	00015517          	auipc	a0,0x15
    80003600:	66450513          	add	a0,a0,1636 # 80018c60 <log>
    80003604:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003606:	00003097          	auipc	ra,0x3
    8000360a:	c3c080e7          	jalr	-964(ra) # 80006242 <release>
      break;
    }
  }
}
    8000360e:	60e2                	ld	ra,24(sp)
    80003610:	6442                	ld	s0,16(sp)
    80003612:	64a2                	ld	s1,8(sp)
    80003614:	6902                	ld	s2,0(sp)
    80003616:	6105                	add	sp,sp,32
    80003618:	8082                	ret

000000008000361a <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    8000361a:	7139                	add	sp,sp,-64
    8000361c:	fc06                	sd	ra,56(sp)
    8000361e:	f822                	sd	s0,48(sp)
    80003620:	f426                	sd	s1,40(sp)
    80003622:	f04a                	sd	s2,32(sp)
    80003624:	ec4e                	sd	s3,24(sp)
    80003626:	e852                	sd	s4,16(sp)
    80003628:	e456                	sd	s5,8(sp)
    8000362a:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000362c:	00015497          	auipc	s1,0x15
    80003630:	63448493          	add	s1,s1,1588 # 80018c60 <log>
    80003634:	8526                	mv	a0,s1
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	b58080e7          	jalr	-1192(ra) # 8000618e <acquire>
  log.outstanding -= 1;
    8000363e:	509c                	lw	a5,32(s1)
    80003640:	37fd                	addw	a5,a5,-1
    80003642:	0007891b          	sext.w	s2,a5
    80003646:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003648:	50dc                	lw	a5,36(s1)
    8000364a:	e7b9                	bnez	a5,80003698 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000364c:	04091e63          	bnez	s2,800036a8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003650:	00015497          	auipc	s1,0x15
    80003654:	61048493          	add	s1,s1,1552 # 80018c60 <log>
    80003658:	4785                	li	a5,1
    8000365a:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    8000365c:	8526                	mv	a0,s1
    8000365e:	00003097          	auipc	ra,0x3
    80003662:	be4080e7          	jalr	-1052(ra) # 80006242 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003666:	54dc                	lw	a5,44(s1)
    80003668:	06f04763          	bgtz	a5,800036d6 <end_op+0xbc>
    acquire(&log.lock);
    8000366c:	00015497          	auipc	s1,0x15
    80003670:	5f448493          	add	s1,s1,1524 # 80018c60 <log>
    80003674:	8526                	mv	a0,s1
    80003676:	00003097          	auipc	ra,0x3
    8000367a:	b18080e7          	jalr	-1256(ra) # 8000618e <acquire>
    log.committing = 0;
    8000367e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003682:	8526                	mv	a0,s1
    80003684:	ffffe097          	auipc	ra,0xffffe
    80003688:	f3e080e7          	jalr	-194(ra) # 800015c2 <wakeup>
    release(&log.lock);
    8000368c:	8526                	mv	a0,s1
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	bb4080e7          	jalr	-1100(ra) # 80006242 <release>
}
    80003696:	a03d                	j	800036c4 <end_op+0xaa>
    panic("log.committing");
    80003698:	00005517          	auipc	a0,0x5
    8000369c:	02050513          	add	a0,a0,32 # 800086b8 <syscalls+0x1e8>
    800036a0:	00002097          	auipc	ra,0x2
    800036a4:	5b6080e7          	jalr	1462(ra) # 80005c56 <panic>
    wakeup(&log);
    800036a8:	00015497          	auipc	s1,0x15
    800036ac:	5b848493          	add	s1,s1,1464 # 80018c60 <log>
    800036b0:	8526                	mv	a0,s1
    800036b2:	ffffe097          	auipc	ra,0xffffe
    800036b6:	f10080e7          	jalr	-240(ra) # 800015c2 <wakeup>
  release(&log.lock);
    800036ba:	8526                	mv	a0,s1
    800036bc:	00003097          	auipc	ra,0x3
    800036c0:	b86080e7          	jalr	-1146(ra) # 80006242 <release>
}
    800036c4:	70e2                	ld	ra,56(sp)
    800036c6:	7442                	ld	s0,48(sp)
    800036c8:	74a2                	ld	s1,40(sp)
    800036ca:	7902                	ld	s2,32(sp)
    800036cc:	69e2                	ld	s3,24(sp)
    800036ce:	6a42                	ld	s4,16(sp)
    800036d0:	6aa2                	ld	s5,8(sp)
    800036d2:	6121                	add	sp,sp,64
    800036d4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d6:	00015a97          	auipc	s5,0x15
    800036da:	5baa8a93          	add	s5,s5,1466 # 80018c90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    800036de:	00015a17          	auipc	s4,0x15
    800036e2:	582a0a13          	add	s4,s4,1410 # 80018c60 <log>
    800036e6:	018a2583          	lw	a1,24(s4)
    800036ea:	012585bb          	addw	a1,a1,s2
    800036ee:	2585                	addw	a1,a1,1
    800036f0:	028a2503          	lw	a0,40(s4)
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	cf6080e7          	jalr	-778(ra) # 800023ea <bread>
    800036fc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    800036fe:	000aa583          	lw	a1,0(s5)
    80003702:	028a2503          	lw	a0,40(s4)
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	ce4080e7          	jalr	-796(ra) # 800023ea <bread>
    8000370e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003710:	40000613          	li	a2,1024
    80003714:	05850593          	add	a1,a0,88
    80003718:	05848513          	add	a0,s1,88
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	aba080e7          	jalr	-1350(ra) # 800001d6 <memmove>
    bwrite(to);  /* write the log */
    80003724:	8526                	mv	a0,s1
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	db6080e7          	jalr	-586(ra) # 800024dc <bwrite>
    brelse(from);
    8000372e:	854e                	mv	a0,s3
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	dea080e7          	jalr	-534(ra) # 8000251a <brelse>
    brelse(to);
    80003738:	8526                	mv	a0,s1
    8000373a:	fffff097          	auipc	ra,0xfffff
    8000373e:	de0080e7          	jalr	-544(ra) # 8000251a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003742:	2905                	addw	s2,s2,1
    80003744:	0a91                	add	s5,s5,4
    80003746:	02ca2783          	lw	a5,44(s4)
    8000374a:	f8f94ee3          	blt	s2,a5,800036e6 <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    8000374e:	00000097          	auipc	ra,0x0
    80003752:	c8c080e7          	jalr	-884(ra) # 800033da <write_head>
    install_trans(0); /* Now install writes to home locations */
    80003756:	4501                	li	a0,0
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	cec080e7          	jalr	-788(ra) # 80003444 <install_trans>
    log.lh.n = 0;
    80003760:	00015797          	auipc	a5,0x15
    80003764:	5207a623          	sw	zero,1324(a5) # 80018c8c <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	c72080e7          	jalr	-910(ra) # 800033da <write_head>
    80003770:	bdf5                	j	8000366c <end_op+0x52>

0000000080003772 <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    80003772:	1101                	add	sp,sp,-32
    80003774:	ec06                	sd	ra,24(sp)
    80003776:	e822                	sd	s0,16(sp)
    80003778:	e426                	sd	s1,8(sp)
    8000377a:	e04a                	sd	s2,0(sp)
    8000377c:	1000                	add	s0,sp,32
    8000377e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003780:	00015917          	auipc	s2,0x15
    80003784:	4e090913          	add	s2,s2,1248 # 80018c60 <log>
    80003788:	854a                	mv	a0,s2
    8000378a:	00003097          	auipc	ra,0x3
    8000378e:	a04080e7          	jalr	-1532(ra) # 8000618e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003792:	02c92603          	lw	a2,44(s2)
    80003796:	47f5                	li	a5,29
    80003798:	06c7c563          	blt	a5,a2,80003802 <log_write+0x90>
    8000379c:	00015797          	auipc	a5,0x15
    800037a0:	4e07a783          	lw	a5,1248(a5) # 80018c7c <log+0x1c>
    800037a4:	37fd                	addw	a5,a5,-1
    800037a6:	04f65e63          	bge	a2,a5,80003802 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037aa:	00015797          	auipc	a5,0x15
    800037ae:	4d67a783          	lw	a5,1238(a5) # 80018c80 <log+0x20>
    800037b2:	06f05063          	blez	a5,80003812 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b6:	4781                	li	a5,0
    800037b8:	06c05563          	blez	a2,80003822 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    800037bc:	44cc                	lw	a1,12(s1)
    800037be:	00015717          	auipc	a4,0x15
    800037c2:	4d270713          	add	a4,a4,1234 # 80018c90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    800037c8:	4314                	lw	a3,0(a4)
    800037ca:	04b68c63          	beq	a3,a1,80003822 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ce:	2785                	addw	a5,a5,1
    800037d0:	0711                	add	a4,a4,4
    800037d2:	fef61be3          	bne	a2,a5,800037c8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d6:	0621                	add	a2,a2,8
    800037d8:	060a                	sll	a2,a2,0x2
    800037da:	00015797          	auipc	a5,0x15
    800037de:	48678793          	add	a5,a5,1158 # 80018c60 <log>
    800037e2:	97b2                	add	a5,a5,a2
    800037e4:	44d8                	lw	a4,12(s1)
    800037e6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    800037e8:	8526                	mv	a0,s1
    800037ea:	fffff097          	auipc	ra,0xfffff
    800037ee:	dcc080e7          	jalr	-564(ra) # 800025b6 <bpin>
    log.lh.n++;
    800037f2:	00015717          	auipc	a4,0x15
    800037f6:	46e70713          	add	a4,a4,1134 # 80018c60 <log>
    800037fa:	575c                	lw	a5,44(a4)
    800037fc:	2785                	addw	a5,a5,1
    800037fe:	d75c                	sw	a5,44(a4)
    80003800:	a82d                	j	8000383a <log_write+0xc8>
    panic("too big a transaction");
    80003802:	00005517          	auipc	a0,0x5
    80003806:	ec650513          	add	a0,a0,-314 # 800086c8 <syscalls+0x1f8>
    8000380a:	00002097          	auipc	ra,0x2
    8000380e:	44c080e7          	jalr	1100(ra) # 80005c56 <panic>
    panic("log_write outside of trans");
    80003812:	00005517          	auipc	a0,0x5
    80003816:	ece50513          	add	a0,a0,-306 # 800086e0 <syscalls+0x210>
    8000381a:	00002097          	auipc	ra,0x2
    8000381e:	43c080e7          	jalr	1084(ra) # 80005c56 <panic>
  log.lh.block[i] = b->blockno;
    80003822:	00878693          	add	a3,a5,8
    80003826:	068a                	sll	a3,a3,0x2
    80003828:	00015717          	auipc	a4,0x15
    8000382c:	43870713          	add	a4,a4,1080 # 80018c60 <log>
    80003830:	9736                	add	a4,a4,a3
    80003832:	44d4                	lw	a3,12(s1)
    80003834:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    80003836:	faf609e3          	beq	a2,a5,800037e8 <log_write+0x76>
  }
  release(&log.lock);
    8000383a:	00015517          	auipc	a0,0x15
    8000383e:	42650513          	add	a0,a0,1062 # 80018c60 <log>
    80003842:	00003097          	auipc	ra,0x3
    80003846:	a00080e7          	jalr	-1536(ra) # 80006242 <release>
}
    8000384a:	60e2                	ld	ra,24(sp)
    8000384c:	6442                	ld	s0,16(sp)
    8000384e:	64a2                	ld	s1,8(sp)
    80003850:	6902                	ld	s2,0(sp)
    80003852:	6105                	add	sp,sp,32
    80003854:	8082                	ret

0000000080003856 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003856:	1101                	add	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	e426                	sd	s1,8(sp)
    8000385e:	e04a                	sd	s2,0(sp)
    80003860:	1000                	add	s0,sp,32
    80003862:	84aa                	mv	s1,a0
    80003864:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003866:	00005597          	auipc	a1,0x5
    8000386a:	e9a58593          	add	a1,a1,-358 # 80008700 <syscalls+0x230>
    8000386e:	0521                	add	a0,a0,8
    80003870:	00003097          	auipc	ra,0x3
    80003874:	88e080e7          	jalr	-1906(ra) # 800060fe <initlock>
  lk->name = name;
    80003878:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000387c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003880:	0204a423          	sw	zero,40(s1)
}
    80003884:	60e2                	ld	ra,24(sp)
    80003886:	6442                	ld	s0,16(sp)
    80003888:	64a2                	ld	s1,8(sp)
    8000388a:	6902                	ld	s2,0(sp)
    8000388c:	6105                	add	sp,sp,32
    8000388e:	8082                	ret

0000000080003890 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003890:	1101                	add	sp,sp,-32
    80003892:	ec06                	sd	ra,24(sp)
    80003894:	e822                	sd	s0,16(sp)
    80003896:	e426                	sd	s1,8(sp)
    80003898:	e04a                	sd	s2,0(sp)
    8000389a:	1000                	add	s0,sp,32
    8000389c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389e:	00850913          	add	s2,a0,8
    800038a2:	854a                	mv	a0,s2
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	8ea080e7          	jalr	-1814(ra) # 8000618e <acquire>
  while (lk->locked) {
    800038ac:	409c                	lw	a5,0(s1)
    800038ae:	cb89                	beqz	a5,800038c0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038b0:	85ca                	mv	a1,s2
    800038b2:	8526                	mv	a0,s1
    800038b4:	ffffe097          	auipc	ra,0xffffe
    800038b8:	caa080e7          	jalr	-854(ra) # 8000155e <sleep>
  while (lk->locked) {
    800038bc:	409c                	lw	a5,0(s1)
    800038be:	fbed                	bnez	a5,800038b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038c0:	4785                	li	a5,1
    800038c2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c4:	ffffd097          	auipc	ra,0xffffd
    800038c8:	5e6080e7          	jalr	1510(ra) # 80000eaa <myproc>
    800038cc:	591c                	lw	a5,48(a0)
    800038ce:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038d0:	854a                	mv	a0,s2
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	970080e7          	jalr	-1680(ra) # 80006242 <release>
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6902                	ld	s2,0(sp)
    800038e2:	6105                	add	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e6:	1101                	add	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	e04a                	sd	s2,0(sp)
    800038f0:	1000                	add	s0,sp,32
    800038f2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f4:	00850913          	add	s2,a0,8
    800038f8:	854a                	mv	a0,s2
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	894080e7          	jalr	-1900(ra) # 8000618e <acquire>
  lk->locked = 0;
    80003902:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003906:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000390a:	8526                	mv	a0,s1
    8000390c:	ffffe097          	auipc	ra,0xffffe
    80003910:	cb6080e7          	jalr	-842(ra) # 800015c2 <wakeup>
  release(&lk->lk);
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	92c080e7          	jalr	-1748(ra) # 80006242 <release>
}
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	64a2                	ld	s1,8(sp)
    80003924:	6902                	ld	s2,0(sp)
    80003926:	6105                	add	sp,sp,32
    80003928:	8082                	ret

000000008000392a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000392a:	7179                	add	sp,sp,-48
    8000392c:	f406                	sd	ra,40(sp)
    8000392e:	f022                	sd	s0,32(sp)
    80003930:	ec26                	sd	s1,24(sp)
    80003932:	e84a                	sd	s2,16(sp)
    80003934:	e44e                	sd	s3,8(sp)
    80003936:	1800                	add	s0,sp,48
    80003938:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000393a:	00850913          	add	s2,a0,8
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	84e080e7          	jalr	-1970(ra) # 8000618e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003948:	409c                	lw	a5,0(s1)
    8000394a:	ef99                	bnez	a5,80003968 <holdingsleep+0x3e>
    8000394c:	4481                	li	s1,0
  release(&lk->lk);
    8000394e:	854a                	mv	a0,s2
    80003950:	00003097          	auipc	ra,0x3
    80003954:	8f2080e7          	jalr	-1806(ra) # 80006242 <release>
  return r;
}
    80003958:	8526                	mv	a0,s1
    8000395a:	70a2                	ld	ra,40(sp)
    8000395c:	7402                	ld	s0,32(sp)
    8000395e:	64e2                	ld	s1,24(sp)
    80003960:	6942                	ld	s2,16(sp)
    80003962:	69a2                	ld	s3,8(sp)
    80003964:	6145                	add	sp,sp,48
    80003966:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003968:	0284a983          	lw	s3,40(s1)
    8000396c:	ffffd097          	auipc	ra,0xffffd
    80003970:	53e080e7          	jalr	1342(ra) # 80000eaa <myproc>
    80003974:	5904                	lw	s1,48(a0)
    80003976:	413484b3          	sub	s1,s1,s3
    8000397a:	0014b493          	seqz	s1,s1
    8000397e:	bfc1                	j	8000394e <holdingsleep+0x24>

0000000080003980 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003980:	1141                	add	sp,sp,-16
    80003982:	e406                	sd	ra,8(sp)
    80003984:	e022                	sd	s0,0(sp)
    80003986:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003988:	00005597          	auipc	a1,0x5
    8000398c:	d8858593          	add	a1,a1,-632 # 80008710 <syscalls+0x240>
    80003990:	00015517          	auipc	a0,0x15
    80003994:	41850513          	add	a0,a0,1048 # 80018da8 <ftable>
    80003998:	00002097          	auipc	ra,0x2
    8000399c:	766080e7          	jalr	1894(ra) # 800060fe <initlock>
}
    800039a0:	60a2                	ld	ra,8(sp)
    800039a2:	6402                	ld	s0,0(sp)
    800039a4:	0141                	add	sp,sp,16
    800039a6:	8082                	ret

00000000800039a8 <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    800039a8:	1101                	add	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039b2:	00015517          	auipc	a0,0x15
    800039b6:	3f650513          	add	a0,a0,1014 # 80018da8 <ftable>
    800039ba:	00002097          	auipc	ra,0x2
    800039be:	7d4080e7          	jalr	2004(ra) # 8000618e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c2:	00015497          	auipc	s1,0x15
    800039c6:	3fe48493          	add	s1,s1,1022 # 80018dc0 <ftable+0x18>
    800039ca:	00016717          	auipc	a4,0x16
    800039ce:	39670713          	add	a4,a4,918 # 80019d60 <disk>
    if(f->ref == 0){
    800039d2:	40dc                	lw	a5,4(s1)
    800039d4:	cf99                	beqz	a5,800039f2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d6:	02848493          	add	s1,s1,40
    800039da:	fee49ce3          	bne	s1,a4,800039d2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039de:	00015517          	auipc	a0,0x15
    800039e2:	3ca50513          	add	a0,a0,970 # 80018da8 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	85c080e7          	jalr	-1956(ra) # 80006242 <release>
  return 0;
    800039ee:	4481                	li	s1,0
    800039f0:	a819                	j	80003a06 <filealloc+0x5e>
      f->ref = 1;
    800039f2:	4785                	li	a5,1
    800039f4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039f6:	00015517          	auipc	a0,0x15
    800039fa:	3b250513          	add	a0,a0,946 # 80018da8 <ftable>
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	844080e7          	jalr	-1980(ra) # 80006242 <release>
}
    80003a06:	8526                	mv	a0,s1
    80003a08:	60e2                	ld	ra,24(sp)
    80003a0a:	6442                	ld	s0,16(sp)
    80003a0c:	64a2                	ld	s1,8(sp)
    80003a0e:	6105                	add	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    80003a12:	1101                	add	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	1000                	add	s0,sp,32
    80003a1c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a1e:	00015517          	auipc	a0,0x15
    80003a22:	38a50513          	add	a0,a0,906 # 80018da8 <ftable>
    80003a26:	00002097          	auipc	ra,0x2
    80003a2a:	768080e7          	jalr	1896(ra) # 8000618e <acquire>
  if(f->ref < 1)
    80003a2e:	40dc                	lw	a5,4(s1)
    80003a30:	02f05263          	blez	a5,80003a54 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a34:	2785                	addw	a5,a5,1
    80003a36:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a38:	00015517          	auipc	a0,0x15
    80003a3c:	37050513          	add	a0,a0,880 # 80018da8 <ftable>
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	802080e7          	jalr	-2046(ra) # 80006242 <release>
  return f;
}
    80003a48:	8526                	mv	a0,s1
    80003a4a:	60e2                	ld	ra,24(sp)
    80003a4c:	6442                	ld	s0,16(sp)
    80003a4e:	64a2                	ld	s1,8(sp)
    80003a50:	6105                	add	sp,sp,32
    80003a52:	8082                	ret
    panic("filedup");
    80003a54:	00005517          	auipc	a0,0x5
    80003a58:	cc450513          	add	a0,a0,-828 # 80008718 <syscalls+0x248>
    80003a5c:	00002097          	auipc	ra,0x2
    80003a60:	1fa080e7          	jalr	506(ra) # 80005c56 <panic>

0000000080003a64 <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80003a64:	7139                	add	sp,sp,-64
    80003a66:	fc06                	sd	ra,56(sp)
    80003a68:	f822                	sd	s0,48(sp)
    80003a6a:	f426                	sd	s1,40(sp)
    80003a6c:	f04a                	sd	s2,32(sp)
    80003a6e:	ec4e                	sd	s3,24(sp)
    80003a70:	e852                	sd	s4,16(sp)
    80003a72:	e456                	sd	s5,8(sp)
    80003a74:	0080                	add	s0,sp,64
    80003a76:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a78:	00015517          	auipc	a0,0x15
    80003a7c:	33050513          	add	a0,a0,816 # 80018da8 <ftable>
    80003a80:	00002097          	auipc	ra,0x2
    80003a84:	70e080e7          	jalr	1806(ra) # 8000618e <acquire>
  if(f->ref < 1)
    80003a88:	40dc                	lw	a5,4(s1)
    80003a8a:	06f05163          	blez	a5,80003aec <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a8e:	37fd                	addw	a5,a5,-1
    80003a90:	0007871b          	sext.w	a4,a5
    80003a94:	c0dc                	sw	a5,4(s1)
    80003a96:	06e04363          	bgtz	a4,80003afc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a9a:	0004a903          	lw	s2,0(s1)
    80003a9e:	0094ca83          	lbu	s5,9(s1)
    80003aa2:	0104ba03          	ld	s4,16(s1)
    80003aa6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aaa:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aae:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ab2:	00015517          	auipc	a0,0x15
    80003ab6:	2f650513          	add	a0,a0,758 # 80018da8 <ftable>
    80003aba:	00002097          	auipc	ra,0x2
    80003abe:	788080e7          	jalr	1928(ra) # 80006242 <release>

  if(ff.type == FD_PIPE){
    80003ac2:	4785                	li	a5,1
    80003ac4:	04f90d63          	beq	s2,a5,80003b1e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ac8:	3979                	addw	s2,s2,-2
    80003aca:	4785                	li	a5,1
    80003acc:	0527e063          	bltu	a5,s2,80003b0c <fileclose+0xa8>
    begin_op();
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	ad0080e7          	jalr	-1328(ra) # 800035a0 <begin_op>
    iput(ff.ip);
    80003ad8:	854e                	mv	a0,s3
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	2da080e7          	jalr	730(ra) # 80002db4 <iput>
    end_op();
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	b38080e7          	jalr	-1224(ra) # 8000361a <end_op>
    80003aea:	a00d                	j	80003b0c <fileclose+0xa8>
    panic("fileclose");
    80003aec:	00005517          	auipc	a0,0x5
    80003af0:	c3450513          	add	a0,a0,-972 # 80008720 <syscalls+0x250>
    80003af4:	00002097          	auipc	ra,0x2
    80003af8:	162080e7          	jalr	354(ra) # 80005c56 <panic>
    release(&ftable.lock);
    80003afc:	00015517          	auipc	a0,0x15
    80003b00:	2ac50513          	add	a0,a0,684 # 80018da8 <ftable>
    80003b04:	00002097          	auipc	ra,0x2
    80003b08:	73e080e7          	jalr	1854(ra) # 80006242 <release>
  }
}
    80003b0c:	70e2                	ld	ra,56(sp)
    80003b0e:	7442                	ld	s0,48(sp)
    80003b10:	74a2                	ld	s1,40(sp)
    80003b12:	7902                	ld	s2,32(sp)
    80003b14:	69e2                	ld	s3,24(sp)
    80003b16:	6a42                	ld	s4,16(sp)
    80003b18:	6aa2                	ld	s5,8(sp)
    80003b1a:	6121                	add	sp,sp,64
    80003b1c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b1e:	85d6                	mv	a1,s5
    80003b20:	8552                	mv	a0,s4
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	348080e7          	jalr	840(ra) # 80003e6a <pipeclose>
    80003b2a:	b7cd                	j	80003b0c <fileclose+0xa8>

0000000080003b2c <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80003b2c:	715d                	add	sp,sp,-80
    80003b2e:	e486                	sd	ra,72(sp)
    80003b30:	e0a2                	sd	s0,64(sp)
    80003b32:	fc26                	sd	s1,56(sp)
    80003b34:	f84a                	sd	s2,48(sp)
    80003b36:	f44e                	sd	s3,40(sp)
    80003b38:	0880                	add	s0,sp,80
    80003b3a:	84aa                	mv	s1,a0
    80003b3c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b3e:	ffffd097          	auipc	ra,0xffffd
    80003b42:	36c080e7          	jalr	876(ra) # 80000eaa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b46:	409c                	lw	a5,0(s1)
    80003b48:	37f9                	addw	a5,a5,-2
    80003b4a:	4705                	li	a4,1
    80003b4c:	04f76763          	bltu	a4,a5,80003b9a <filestat+0x6e>
    80003b50:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b52:	6c88                	ld	a0,24(s1)
    80003b54:	fffff097          	auipc	ra,0xfffff
    80003b58:	0a6080e7          	jalr	166(ra) # 80002bfa <ilock>
    stati(f->ip, &st);
    80003b5c:	fb840593          	add	a1,s0,-72
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	322080e7          	jalr	802(ra) # 80002e84 <stati>
    iunlock(f->ip);
    80003b6a:	6c88                	ld	a0,24(s1)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	150080e7          	jalr	336(ra) # 80002cbc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b74:	46e1                	li	a3,24
    80003b76:	fb840613          	add	a2,s0,-72
    80003b7a:	85ce                	mv	a1,s3
    80003b7c:	05093503          	ld	a0,80(s2)
    80003b80:	ffffd097          	auipc	ra,0xffffd
    80003b84:	fb6080e7          	jalr	-74(ra) # 80000b36 <copyout>
    80003b88:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b8c:	60a6                	ld	ra,72(sp)
    80003b8e:	6406                	ld	s0,64(sp)
    80003b90:	74e2                	ld	s1,56(sp)
    80003b92:	7942                	ld	s2,48(sp)
    80003b94:	79a2                	ld	s3,40(sp)
    80003b96:	6161                	add	sp,sp,80
    80003b98:	8082                	ret
  return -1;
    80003b9a:	557d                	li	a0,-1
    80003b9c:	bfc5                	j	80003b8c <filestat+0x60>

0000000080003b9e <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b9e:	7179                	add	sp,sp,-48
    80003ba0:	f406                	sd	ra,40(sp)
    80003ba2:	f022                	sd	s0,32(sp)
    80003ba4:	ec26                	sd	s1,24(sp)
    80003ba6:	e84a                	sd	s2,16(sp)
    80003ba8:	e44e                	sd	s3,8(sp)
    80003baa:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bac:	00854783          	lbu	a5,8(a0)
    80003bb0:	c3d5                	beqz	a5,80003c54 <fileread+0xb6>
    80003bb2:	84aa                	mv	s1,a0
    80003bb4:	89ae                	mv	s3,a1
    80003bb6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bb8:	411c                	lw	a5,0(a0)
    80003bba:	4705                	li	a4,1
    80003bbc:	04e78963          	beq	a5,a4,80003c0e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bc0:	470d                	li	a4,3
    80003bc2:	04e78d63          	beq	a5,a4,80003c1c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bc6:	4709                	li	a4,2
    80003bc8:	06e79e63          	bne	a5,a4,80003c44 <fileread+0xa6>
    ilock(f->ip);
    80003bcc:	6d08                	ld	a0,24(a0)
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	02c080e7          	jalr	44(ra) # 80002bfa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bd6:	874a                	mv	a4,s2
    80003bd8:	5094                	lw	a3,32(s1)
    80003bda:	864e                	mv	a2,s3
    80003bdc:	4585                	li	a1,1
    80003bde:	6c88                	ld	a0,24(s1)
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	2ce080e7          	jalr	718(ra) # 80002eae <readi>
    80003be8:	892a                	mv	s2,a0
    80003bea:	00a05563          	blez	a0,80003bf4 <fileread+0x56>
      f->off += r;
    80003bee:	509c                	lw	a5,32(s1)
    80003bf0:	9fa9                	addw	a5,a5,a0
    80003bf2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bf4:	6c88                	ld	a0,24(s1)
    80003bf6:	fffff097          	auipc	ra,0xfffff
    80003bfa:	0c6080e7          	jalr	198(ra) # 80002cbc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bfe:	854a                	mv	a0,s2
    80003c00:	70a2                	ld	ra,40(sp)
    80003c02:	7402                	ld	s0,32(sp)
    80003c04:	64e2                	ld	s1,24(sp)
    80003c06:	6942                	ld	s2,16(sp)
    80003c08:	69a2                	ld	s3,8(sp)
    80003c0a:	6145                	add	sp,sp,48
    80003c0c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c0e:	6908                	ld	a0,16(a0)
    80003c10:	00000097          	auipc	ra,0x0
    80003c14:	3c2080e7          	jalr	962(ra) # 80003fd2 <piperead>
    80003c18:	892a                	mv	s2,a0
    80003c1a:	b7d5                	j	80003bfe <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c1c:	02451783          	lh	a5,36(a0)
    80003c20:	03079693          	sll	a3,a5,0x30
    80003c24:	92c1                	srl	a3,a3,0x30
    80003c26:	4725                	li	a4,9
    80003c28:	02d76863          	bltu	a4,a3,80003c58 <fileread+0xba>
    80003c2c:	0792                	sll	a5,a5,0x4
    80003c2e:	00015717          	auipc	a4,0x15
    80003c32:	0da70713          	add	a4,a4,218 # 80018d08 <devsw>
    80003c36:	97ba                	add	a5,a5,a4
    80003c38:	639c                	ld	a5,0(a5)
    80003c3a:	c38d                	beqz	a5,80003c5c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c3c:	4505                	li	a0,1
    80003c3e:	9782                	jalr	a5
    80003c40:	892a                	mv	s2,a0
    80003c42:	bf75                	j	80003bfe <fileread+0x60>
    panic("fileread");
    80003c44:	00005517          	auipc	a0,0x5
    80003c48:	aec50513          	add	a0,a0,-1300 # 80008730 <syscalls+0x260>
    80003c4c:	00002097          	auipc	ra,0x2
    80003c50:	00a080e7          	jalr	10(ra) # 80005c56 <panic>
    return -1;
    80003c54:	597d                	li	s2,-1
    80003c56:	b765                	j	80003bfe <fileread+0x60>
      return -1;
    80003c58:	597d                	li	s2,-1
    80003c5a:	b755                	j	80003bfe <fileread+0x60>
    80003c5c:	597d                	li	s2,-1
    80003c5e:	b745                	j	80003bfe <fileread+0x60>

0000000080003c60 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c60:	00954783          	lbu	a5,9(a0)
    80003c64:	10078e63          	beqz	a5,80003d80 <filewrite+0x120>
{
    80003c68:	715d                	add	sp,sp,-80
    80003c6a:	e486                	sd	ra,72(sp)
    80003c6c:	e0a2                	sd	s0,64(sp)
    80003c6e:	fc26                	sd	s1,56(sp)
    80003c70:	f84a                	sd	s2,48(sp)
    80003c72:	f44e                	sd	s3,40(sp)
    80003c74:	f052                	sd	s4,32(sp)
    80003c76:	ec56                	sd	s5,24(sp)
    80003c78:	e85a                	sd	s6,16(sp)
    80003c7a:	e45e                	sd	s7,8(sp)
    80003c7c:	e062                	sd	s8,0(sp)
    80003c7e:	0880                	add	s0,sp,80
    80003c80:	892a                	mv	s2,a0
    80003c82:	8b2e                	mv	s6,a1
    80003c84:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c86:	411c                	lw	a5,0(a0)
    80003c88:	4705                	li	a4,1
    80003c8a:	02e78263          	beq	a5,a4,80003cae <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c8e:	470d                	li	a4,3
    80003c90:	02e78563          	beq	a5,a4,80003cba <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c94:	4709                	li	a4,2
    80003c96:	0ce79d63          	bne	a5,a4,80003d70 <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c9a:	0ac05b63          	blez	a2,80003d50 <filewrite+0xf0>
    int i = 0;
    80003c9e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003ca0:	6b85                	lui	s7,0x1
    80003ca2:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ca6:	6c05                	lui	s8,0x1
    80003ca8:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cac:	a851                	j	80003d40 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003cae:	6908                	ld	a0,16(a0)
    80003cb0:	00000097          	auipc	ra,0x0
    80003cb4:	22a080e7          	jalr	554(ra) # 80003eda <pipewrite>
    80003cb8:	a045                	j	80003d58 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cba:	02451783          	lh	a5,36(a0)
    80003cbe:	03079693          	sll	a3,a5,0x30
    80003cc2:	92c1                	srl	a3,a3,0x30
    80003cc4:	4725                	li	a4,9
    80003cc6:	0ad76f63          	bltu	a4,a3,80003d84 <filewrite+0x124>
    80003cca:	0792                	sll	a5,a5,0x4
    80003ccc:	00015717          	auipc	a4,0x15
    80003cd0:	03c70713          	add	a4,a4,60 # 80018d08 <devsw>
    80003cd4:	97ba                	add	a5,a5,a4
    80003cd6:	679c                	ld	a5,8(a5)
    80003cd8:	cbc5                	beqz	a5,80003d88 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003cda:	4505                	li	a0,1
    80003cdc:	9782                	jalr	a5
    80003cde:	a8ad                	j	80003d58 <filewrite+0xf8>
      if(n1 > max)
    80003ce0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	8bc080e7          	jalr	-1860(ra) # 800035a0 <begin_op>
      ilock(f->ip);
    80003cec:	01893503          	ld	a0,24(s2)
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	f0a080e7          	jalr	-246(ra) # 80002bfa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf8:	8756                	mv	a4,s5
    80003cfa:	02092683          	lw	a3,32(s2)
    80003cfe:	01698633          	add	a2,s3,s6
    80003d02:	4585                	li	a1,1
    80003d04:	01893503          	ld	a0,24(s2)
    80003d08:	fffff097          	auipc	ra,0xfffff
    80003d0c:	29e080e7          	jalr	670(ra) # 80002fa6 <writei>
    80003d10:	84aa                	mv	s1,a0
    80003d12:	00a05763          	blez	a0,80003d20 <filewrite+0xc0>
        f->off += r;
    80003d16:	02092783          	lw	a5,32(s2)
    80003d1a:	9fa9                	addw	a5,a5,a0
    80003d1c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d20:	01893503          	ld	a0,24(s2)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	f98080e7          	jalr	-104(ra) # 80002cbc <iunlock>
      end_op();
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	8ee080e7          	jalr	-1810(ra) # 8000361a <end_op>

      if(r != n1){
    80003d34:	009a9f63          	bne	s5,s1,80003d52 <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    80003d38:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d3c:	0149db63          	bge	s3,s4,80003d52 <filewrite+0xf2>
      int n1 = n - i;
    80003d40:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d44:	0004879b          	sext.w	a5,s1
    80003d48:	f8fbdce3          	bge	s7,a5,80003ce0 <filewrite+0x80>
    80003d4c:	84e2                	mv	s1,s8
    80003d4e:	bf49                	j	80003ce0 <filewrite+0x80>
    int i = 0;
    80003d50:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d52:	033a1d63          	bne	s4,s3,80003d8c <filewrite+0x12c>
    80003d56:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d58:	60a6                	ld	ra,72(sp)
    80003d5a:	6406                	ld	s0,64(sp)
    80003d5c:	74e2                	ld	s1,56(sp)
    80003d5e:	7942                	ld	s2,48(sp)
    80003d60:	79a2                	ld	s3,40(sp)
    80003d62:	7a02                	ld	s4,32(sp)
    80003d64:	6ae2                	ld	s5,24(sp)
    80003d66:	6b42                	ld	s6,16(sp)
    80003d68:	6ba2                	ld	s7,8(sp)
    80003d6a:	6c02                	ld	s8,0(sp)
    80003d6c:	6161                	add	sp,sp,80
    80003d6e:	8082                	ret
    panic("filewrite");
    80003d70:	00005517          	auipc	a0,0x5
    80003d74:	9d050513          	add	a0,a0,-1584 # 80008740 <syscalls+0x270>
    80003d78:	00002097          	auipc	ra,0x2
    80003d7c:	ede080e7          	jalr	-290(ra) # 80005c56 <panic>
    return -1;
    80003d80:	557d                	li	a0,-1
}
    80003d82:	8082                	ret
      return -1;
    80003d84:	557d                	li	a0,-1
    80003d86:	bfc9                	j	80003d58 <filewrite+0xf8>
    80003d88:	557d                	li	a0,-1
    80003d8a:	b7f9                	j	80003d58 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003d8c:	557d                	li	a0,-1
    80003d8e:	b7e9                	j	80003d58 <filewrite+0xf8>

0000000080003d90 <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d90:	7179                	add	sp,sp,-48
    80003d92:	f406                	sd	ra,40(sp)
    80003d94:	f022                	sd	s0,32(sp)
    80003d96:	ec26                	sd	s1,24(sp)
    80003d98:	e84a                	sd	s2,16(sp)
    80003d9a:	e44e                	sd	s3,8(sp)
    80003d9c:	e052                	sd	s4,0(sp)
    80003d9e:	1800                	add	s0,sp,48
    80003da0:	84aa                	mv	s1,a0
    80003da2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003da4:	0005b023          	sd	zero,0(a1)
    80003da8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	bfc080e7          	jalr	-1028(ra) # 800039a8 <filealloc>
    80003db4:	e088                	sd	a0,0(s1)
    80003db6:	c551                	beqz	a0,80003e42 <pipealloc+0xb2>
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	bf0080e7          	jalr	-1040(ra) # 800039a8 <filealloc>
    80003dc0:	00aa3023          	sd	a0,0(s4)
    80003dc4:	c92d                	beqz	a0,80003e36 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dc6:	ffffc097          	auipc	ra,0xffffc
    80003dca:	354080e7          	jalr	852(ra) # 8000011a <kalloc>
    80003dce:	892a                	mv	s2,a0
    80003dd0:	c125                	beqz	a0,80003e30 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dd2:	4985                	li	s3,1
    80003dd4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dd8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ddc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003de0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003de4:	00004597          	auipc	a1,0x4
    80003de8:	64458593          	add	a1,a1,1604 # 80008428 <states.0+0x1a0>
    80003dec:	00002097          	auipc	ra,0x2
    80003df0:	312080e7          	jalr	786(ra) # 800060fe <initlock>
  (*f0)->type = FD_PIPE;
    80003df4:	609c                	ld	a5,0(s1)
    80003df6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e0c:	000a3783          	ld	a5,0(s4)
    80003e10:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e14:	000a3783          	ld	a5,0(s4)
    80003e18:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e1c:	000a3783          	ld	a5,0(s4)
    80003e20:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e24:	000a3783          	ld	a5,0(s4)
    80003e28:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e2c:	4501                	li	a0,0
    80003e2e:	a025                	j	80003e56 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e30:	6088                	ld	a0,0(s1)
    80003e32:	e501                	bnez	a0,80003e3a <pipealloc+0xaa>
    80003e34:	a039                	j	80003e42 <pipealloc+0xb2>
    80003e36:	6088                	ld	a0,0(s1)
    80003e38:	c51d                	beqz	a0,80003e66 <pipealloc+0xd6>
    fileclose(*f0);
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	c2a080e7          	jalr	-982(ra) # 80003a64 <fileclose>
  if(*f1)
    80003e42:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e46:	557d                	li	a0,-1
  if(*f1)
    80003e48:	c799                	beqz	a5,80003e56 <pipealloc+0xc6>
    fileclose(*f1);
    80003e4a:	853e                	mv	a0,a5
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c18080e7          	jalr	-1000(ra) # 80003a64 <fileclose>
  return -1;
    80003e54:	557d                	li	a0,-1
}
    80003e56:	70a2                	ld	ra,40(sp)
    80003e58:	7402                	ld	s0,32(sp)
    80003e5a:	64e2                	ld	s1,24(sp)
    80003e5c:	6942                	ld	s2,16(sp)
    80003e5e:	69a2                	ld	s3,8(sp)
    80003e60:	6a02                	ld	s4,0(sp)
    80003e62:	6145                	add	sp,sp,48
    80003e64:	8082                	ret
  return -1;
    80003e66:	557d                	li	a0,-1
    80003e68:	b7fd                	j	80003e56 <pipealloc+0xc6>

0000000080003e6a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e6a:	1101                	add	sp,sp,-32
    80003e6c:	ec06                	sd	ra,24(sp)
    80003e6e:	e822                	sd	s0,16(sp)
    80003e70:	e426                	sd	s1,8(sp)
    80003e72:	e04a                	sd	s2,0(sp)
    80003e74:	1000                	add	s0,sp,32
    80003e76:	84aa                	mv	s1,a0
    80003e78:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e7a:	00002097          	auipc	ra,0x2
    80003e7e:	314080e7          	jalr	788(ra) # 8000618e <acquire>
  if(writable){
    80003e82:	02090d63          	beqz	s2,80003ebc <pipeclose+0x52>
    pi->writeopen = 0;
    80003e86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e8a:	21848513          	add	a0,s1,536
    80003e8e:	ffffd097          	auipc	ra,0xffffd
    80003e92:	734080e7          	jalr	1844(ra) # 800015c2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e96:	2204b783          	ld	a5,544(s1)
    80003e9a:	eb95                	bnez	a5,80003ece <pipeclose+0x64>
    release(&pi->lock);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	00002097          	auipc	ra,0x2
    80003ea2:	3a4080e7          	jalr	932(ra) # 80006242 <release>
    kfree((char*)pi);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	ffffc097          	auipc	ra,0xffffc
    80003eac:	174080e7          	jalr	372(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb0:	60e2                	ld	ra,24(sp)
    80003eb2:	6442                	ld	s0,16(sp)
    80003eb4:	64a2                	ld	s1,8(sp)
    80003eb6:	6902                	ld	s2,0(sp)
    80003eb8:	6105                	add	sp,sp,32
    80003eba:	8082                	ret
    pi->readopen = 0;
    80003ebc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec0:	21c48513          	add	a0,s1,540
    80003ec4:	ffffd097          	auipc	ra,0xffffd
    80003ec8:	6fe080e7          	jalr	1790(ra) # 800015c2 <wakeup>
    80003ecc:	b7e9                	j	80003e96 <pipeclose+0x2c>
    release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	372080e7          	jalr	882(ra) # 80006242 <release>
}
    80003ed8:	bfe1                	j	80003eb0 <pipeclose+0x46>

0000000080003eda <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eda:	711d                	add	sp,sp,-96
    80003edc:	ec86                	sd	ra,88(sp)
    80003ede:	e8a2                	sd	s0,80(sp)
    80003ee0:	e4a6                	sd	s1,72(sp)
    80003ee2:	e0ca                	sd	s2,64(sp)
    80003ee4:	fc4e                	sd	s3,56(sp)
    80003ee6:	f852                	sd	s4,48(sp)
    80003ee8:	f456                	sd	s5,40(sp)
    80003eea:	f05a                	sd	s6,32(sp)
    80003eec:	ec5e                	sd	s7,24(sp)
    80003eee:	e862                	sd	s8,16(sp)
    80003ef0:	1080                	add	s0,sp,96
    80003ef2:	84aa                	mv	s1,a0
    80003ef4:	8aae                	mv	s5,a1
    80003ef6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	fb2080e7          	jalr	-78(ra) # 80000eaa <myproc>
    80003f00:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f02:	8526                	mv	a0,s1
    80003f04:	00002097          	auipc	ra,0x2
    80003f08:	28a080e7          	jalr	650(ra) # 8000618e <acquire>
  while(i < n){
    80003f0c:	0b405663          	blez	s4,80003fb8 <pipewrite+0xde>
  int i = 0;
    80003f10:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f12:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f14:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f18:	21c48b93          	add	s7,s1,540
    80003f1c:	a089                	j	80003f5e <pipewrite+0x84>
      release(&pi->lock);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	00002097          	auipc	ra,0x2
    80003f24:	322080e7          	jalr	802(ra) # 80006242 <release>
      return -1;
    80003f28:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f2a:	854a                	mv	a0,s2
    80003f2c:	60e6                	ld	ra,88(sp)
    80003f2e:	6446                	ld	s0,80(sp)
    80003f30:	64a6                	ld	s1,72(sp)
    80003f32:	6906                	ld	s2,64(sp)
    80003f34:	79e2                	ld	s3,56(sp)
    80003f36:	7a42                	ld	s4,48(sp)
    80003f38:	7aa2                	ld	s5,40(sp)
    80003f3a:	7b02                	ld	s6,32(sp)
    80003f3c:	6be2                	ld	s7,24(sp)
    80003f3e:	6c42                	ld	s8,16(sp)
    80003f40:	6125                	add	sp,sp,96
    80003f42:	8082                	ret
      wakeup(&pi->nread);
    80003f44:	8562                	mv	a0,s8
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	67c080e7          	jalr	1660(ra) # 800015c2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f4e:	85a6                	mv	a1,s1
    80003f50:	855e                	mv	a0,s7
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	60c080e7          	jalr	1548(ra) # 8000155e <sleep>
  while(i < n){
    80003f5a:	07495063          	bge	s2,s4,80003fba <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f5e:	2204a783          	lw	a5,544(s1)
    80003f62:	dfd5                	beqz	a5,80003f1e <pipewrite+0x44>
    80003f64:	854e                	mv	a0,s3
    80003f66:	ffffe097          	auipc	ra,0xffffe
    80003f6a:	8a0080e7          	jalr	-1888(ra) # 80001806 <killed>
    80003f6e:	f945                	bnez	a0,80003f1e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80003f70:	2184a783          	lw	a5,536(s1)
    80003f74:	21c4a703          	lw	a4,540(s1)
    80003f78:	2007879b          	addw	a5,a5,512
    80003f7c:	fcf704e3          	beq	a4,a5,80003f44 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f80:	4685                	li	a3,1
    80003f82:	01590633          	add	a2,s2,s5
    80003f86:	faf40593          	add	a1,s0,-81
    80003f8a:	0509b503          	ld	a0,80(s3)
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	c68080e7          	jalr	-920(ra) # 80000bf6 <copyin>
    80003f96:	03650263          	beq	a0,s6,80003fba <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f9a:	21c4a783          	lw	a5,540(s1)
    80003f9e:	0017871b          	addw	a4,a5,1
    80003fa2:	20e4ae23          	sw	a4,540(s1)
    80003fa6:	1ff7f793          	and	a5,a5,511
    80003faa:	97a6                	add	a5,a5,s1
    80003fac:	faf44703          	lbu	a4,-81(s0)
    80003fb0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fb4:	2905                	addw	s2,s2,1
    80003fb6:	b755                	j	80003f5a <pipewrite+0x80>
  int i = 0;
    80003fb8:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fba:	21848513          	add	a0,s1,536
    80003fbe:	ffffd097          	auipc	ra,0xffffd
    80003fc2:	604080e7          	jalr	1540(ra) # 800015c2 <wakeup>
  release(&pi->lock);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	27a080e7          	jalr	634(ra) # 80006242 <release>
  return i;
    80003fd0:	bfa9                	j	80003f2a <pipewrite+0x50>

0000000080003fd2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fd2:	715d                	add	sp,sp,-80
    80003fd4:	e486                	sd	ra,72(sp)
    80003fd6:	e0a2                	sd	s0,64(sp)
    80003fd8:	fc26                	sd	s1,56(sp)
    80003fda:	f84a                	sd	s2,48(sp)
    80003fdc:	f44e                	sd	s3,40(sp)
    80003fde:	f052                	sd	s4,32(sp)
    80003fe0:	ec56                	sd	s5,24(sp)
    80003fe2:	e85a                	sd	s6,16(sp)
    80003fe4:	0880                	add	s0,sp,80
    80003fe6:	84aa                	mv	s1,a0
    80003fe8:	892e                	mv	s2,a1
    80003fea:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fec:	ffffd097          	auipc	ra,0xffffd
    80003ff0:	ebe080e7          	jalr	-322(ra) # 80000eaa <myproc>
    80003ff4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	00002097          	auipc	ra,0x2
    80003ffc:	196080e7          	jalr	406(ra) # 8000618e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004000:	2184a703          	lw	a4,536(s1)
    80004004:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004008:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    8000400c:	02f71763          	bne	a4,a5,8000403a <piperead+0x68>
    80004010:	2244a783          	lw	a5,548(s1)
    80004014:	c39d                	beqz	a5,8000403a <piperead+0x68>
    if(killed(pr)){
    80004016:	8552                	mv	a0,s4
    80004018:	ffffd097          	auipc	ra,0xffffd
    8000401c:	7ee080e7          	jalr	2030(ra) # 80001806 <killed>
    80004020:	e949                	bnez	a0,800040b2 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004022:	85a6                	mv	a1,s1
    80004024:	854e                	mv	a0,s3
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	538080e7          	jalr	1336(ra) # 8000155e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    8000402e:	2184a703          	lw	a4,536(s1)
    80004032:	21c4a783          	lw	a5,540(s1)
    80004036:	fcf70de3          	beq	a4,a5,80004010 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    8000403a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    8000403e:	05505463          	blez	s5,80004086 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004042:	2184a783          	lw	a5,536(s1)
    80004046:	21c4a703          	lw	a4,540(s1)
    8000404a:	02f70e63          	beq	a4,a5,80004086 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000404e:	0017871b          	addw	a4,a5,1
    80004052:	20e4ac23          	sw	a4,536(s1)
    80004056:	1ff7f793          	and	a5,a5,511
    8000405a:	97a6                	add	a5,a5,s1
    8000405c:	0187c783          	lbu	a5,24(a5)
    80004060:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004064:	4685                	li	a3,1
    80004066:	fbf40613          	add	a2,s0,-65
    8000406a:	85ca                	mv	a1,s2
    8000406c:	050a3503          	ld	a0,80(s4)
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	ac6080e7          	jalr	-1338(ra) # 80000b36 <copyout>
    80004078:	01650763          	beq	a0,s6,80004086 <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    8000407c:	2985                	addw	s3,s3,1
    8000407e:	0905                	add	s2,s2,1
    80004080:	fd3a91e3          	bne	s5,s3,80004042 <piperead+0x70>
    80004084:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    80004086:	21c48513          	add	a0,s1,540
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	538080e7          	jalr	1336(ra) # 800015c2 <wakeup>
  release(&pi->lock);
    80004092:	8526                	mv	a0,s1
    80004094:	00002097          	auipc	ra,0x2
    80004098:	1ae080e7          	jalr	430(ra) # 80006242 <release>
  return i;
}
    8000409c:	854e                	mv	a0,s3
    8000409e:	60a6                	ld	ra,72(sp)
    800040a0:	6406                	ld	s0,64(sp)
    800040a2:	74e2                	ld	s1,56(sp)
    800040a4:	7942                	ld	s2,48(sp)
    800040a6:	79a2                	ld	s3,40(sp)
    800040a8:	7a02                	ld	s4,32(sp)
    800040aa:	6ae2                	ld	s5,24(sp)
    800040ac:	6b42                	ld	s6,16(sp)
    800040ae:	6161                	add	sp,sp,80
    800040b0:	8082                	ret
      release(&pi->lock);
    800040b2:	8526                	mv	a0,s1
    800040b4:	00002097          	auipc	ra,0x2
    800040b8:	18e080e7          	jalr	398(ra) # 80006242 <release>
      return -1;
    800040bc:	59fd                	li	s3,-1
    800040be:	bff9                	j	8000409c <piperead+0xca>

00000000800040c0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040c0:	1141                	add	sp,sp,-16
    800040c2:	e422                	sd	s0,8(sp)
    800040c4:	0800                	add	s0,sp,16
    800040c6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040c8:	8905                	and	a0,a0,1
    800040ca:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800040cc:	8b89                	and	a5,a5,2
    800040ce:	c399                	beqz	a5,800040d4 <flags2perm+0x14>
      perm |= PTE_W;
    800040d0:	00456513          	or	a0,a0,4
    return perm;
}
    800040d4:	6422                	ld	s0,8(sp)
    800040d6:	0141                	add	sp,sp,16
    800040d8:	8082                	ret

00000000800040da <exec>:

int
exec(char *path, char **argv)
{
    800040da:	df010113          	add	sp,sp,-528
    800040de:	20113423          	sd	ra,520(sp)
    800040e2:	20813023          	sd	s0,512(sp)
    800040e6:	ffa6                	sd	s1,504(sp)
    800040e8:	fbca                	sd	s2,496(sp)
    800040ea:	f7ce                	sd	s3,488(sp)
    800040ec:	f3d2                	sd	s4,480(sp)
    800040ee:	efd6                	sd	s5,472(sp)
    800040f0:	ebda                	sd	s6,464(sp)
    800040f2:	e7de                	sd	s7,456(sp)
    800040f4:	e3e2                	sd	s8,448(sp)
    800040f6:	ff66                	sd	s9,440(sp)
    800040f8:	fb6a                	sd	s10,432(sp)
    800040fa:	f76e                	sd	s11,424(sp)
    800040fc:	0c00                	add	s0,sp,528
    800040fe:	892a                	mv	s2,a0
    80004100:	dea43c23          	sd	a0,-520(s0)
    80004104:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	da2080e7          	jalr	-606(ra) # 80000eaa <myproc>
    80004110:	84aa                	mv	s1,a0

  begin_op();
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	48e080e7          	jalr	1166(ra) # 800035a0 <begin_op>

  if((ip = namei(path)) == 0){
    8000411a:	854a                	mv	a0,s2
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	284080e7          	jalr	644(ra) # 800033a0 <namei>
    80004124:	c92d                	beqz	a0,80004196 <exec+0xbc>
    80004126:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	ad2080e7          	jalr	-1326(ra) # 80002bfa <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004130:	04000713          	li	a4,64
    80004134:	4681                	li	a3,0
    80004136:	e5040613          	add	a2,s0,-432
    8000413a:	4581                	li	a1,0
    8000413c:	8552                	mv	a0,s4
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	d70080e7          	jalr	-656(ra) # 80002eae <readi>
    80004146:	04000793          	li	a5,64
    8000414a:	00f51a63          	bne	a0,a5,8000415e <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000414e:	e5042703          	lw	a4,-432(s0)
    80004152:	464c47b7          	lui	a5,0x464c4
    80004156:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000415a:	04f70463          	beq	a4,a5,800041a2 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000415e:	8552                	mv	a0,s4
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	cfc080e7          	jalr	-772(ra) # 80002e5c <iunlockput>
    end_op();
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	4b2080e7          	jalr	1202(ra) # 8000361a <end_op>
  }
  return -1;
    80004170:	557d                	li	a0,-1
}
    80004172:	20813083          	ld	ra,520(sp)
    80004176:	20013403          	ld	s0,512(sp)
    8000417a:	74fe                	ld	s1,504(sp)
    8000417c:	795e                	ld	s2,496(sp)
    8000417e:	79be                	ld	s3,488(sp)
    80004180:	7a1e                	ld	s4,480(sp)
    80004182:	6afe                	ld	s5,472(sp)
    80004184:	6b5e                	ld	s6,464(sp)
    80004186:	6bbe                	ld	s7,456(sp)
    80004188:	6c1e                	ld	s8,448(sp)
    8000418a:	7cfa                	ld	s9,440(sp)
    8000418c:	7d5a                	ld	s10,432(sp)
    8000418e:	7dba                	ld	s11,424(sp)
    80004190:	21010113          	add	sp,sp,528
    80004194:	8082                	ret
    end_op();
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	484080e7          	jalr	1156(ra) # 8000361a <end_op>
    return -1;
    8000419e:	557d                	li	a0,-1
    800041a0:	bfc9                	j	80004172 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041a2:	8526                	mv	a0,s1
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	dce080e7          	jalr	-562(ra) # 80000f72 <proc_pagetable>
    800041ac:	8b2a                	mv	s6,a0
    800041ae:	d945                	beqz	a0,8000415e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b0:	e7042d03          	lw	s10,-400(s0)
    800041b4:	e8845783          	lhu	a5,-376(s0)
    800041b8:	10078463          	beqz	a5,800042c0 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041bc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041be:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800041c0:	6c85                	lui	s9,0x1
    800041c2:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041c6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041ca:	6a85                	lui	s5,0x1
    800041cc:	a0b5                	j	80004238 <exec+0x15e>
      panic("loadseg: address should exist");
    800041ce:	00004517          	auipc	a0,0x4
    800041d2:	58250513          	add	a0,a0,1410 # 80008750 <syscalls+0x280>
    800041d6:	00002097          	auipc	ra,0x2
    800041da:	a80080e7          	jalr	-1408(ra) # 80005c56 <panic>
    if(sz - i < PGSIZE)
    800041de:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041e0:	8726                	mv	a4,s1
    800041e2:	012c06bb          	addw	a3,s8,s2
    800041e6:	4581                	li	a1,0
    800041e8:	8552                	mv	a0,s4
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	cc4080e7          	jalr	-828(ra) # 80002eae <readi>
    800041f2:	2501                	sext.w	a0,a0
    800041f4:	24a49863          	bne	s1,a0,80004444 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800041f8:	012a893b          	addw	s2,s5,s2
    800041fc:	03397563          	bgeu	s2,s3,80004226 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004200:	02091593          	sll	a1,s2,0x20
    80004204:	9181                	srl	a1,a1,0x20
    80004206:	95de                	add	a1,a1,s7
    80004208:	855a                	mv	a0,s6
    8000420a:	ffffc097          	auipc	ra,0xffffc
    8000420e:	2f8080e7          	jalr	760(ra) # 80000502 <walkaddr>
    80004212:	862a                	mv	a2,a0
    if(pa == 0)
    80004214:	dd4d                	beqz	a0,800041ce <exec+0xf4>
    if(sz - i < PGSIZE)
    80004216:	412984bb          	subw	s1,s3,s2
    8000421a:	0004879b          	sext.w	a5,s1
    8000421e:	fcfcf0e3          	bgeu	s9,a5,800041de <exec+0x104>
    80004222:	84d6                	mv	s1,s5
    80004224:	bf6d                	j	800041de <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004226:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000422a:	2d85                	addw	s11,s11,1
    8000422c:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004230:	e8845783          	lhu	a5,-376(s0)
    80004234:	08fdd763          	bge	s11,a5,800042c2 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004238:	2d01                	sext.w	s10,s10
    8000423a:	03800713          	li	a4,56
    8000423e:	86ea                	mv	a3,s10
    80004240:	e1840613          	add	a2,s0,-488
    80004244:	4581                	li	a1,0
    80004246:	8552                	mv	a0,s4
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	c66080e7          	jalr	-922(ra) # 80002eae <readi>
    80004250:	03800793          	li	a5,56
    80004254:	1ef51663          	bne	a0,a5,80004440 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004258:	e1842783          	lw	a5,-488(s0)
    8000425c:	4705                	li	a4,1
    8000425e:	fce796e3          	bne	a5,a4,8000422a <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004262:	e4043483          	ld	s1,-448(s0)
    80004266:	e3843783          	ld	a5,-456(s0)
    8000426a:	1ef4e863          	bltu	s1,a5,8000445a <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000426e:	e2843783          	ld	a5,-472(s0)
    80004272:	94be                	add	s1,s1,a5
    80004274:	1ef4e663          	bltu	s1,a5,80004460 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004278:	df043703          	ld	a4,-528(s0)
    8000427c:	8ff9                	and	a5,a5,a4
    8000427e:	1e079463          	bnez	a5,80004466 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004282:	e1c42503          	lw	a0,-484(s0)
    80004286:	00000097          	auipc	ra,0x0
    8000428a:	e3a080e7          	jalr	-454(ra) # 800040c0 <flags2perm>
    8000428e:	86aa                	mv	a3,a0
    80004290:	8626                	mv	a2,s1
    80004292:	85ca                	mv	a1,s2
    80004294:	855a                	mv	a0,s6
    80004296:	ffffc097          	auipc	ra,0xffffc
    8000429a:	644080e7          	jalr	1604(ra) # 800008da <uvmalloc>
    8000429e:	e0a43423          	sd	a0,-504(s0)
    800042a2:	1c050563          	beqz	a0,8000446c <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042a6:	e2843b83          	ld	s7,-472(s0)
    800042aa:	e2042c03          	lw	s8,-480(s0)
    800042ae:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042b2:	00098463          	beqz	s3,800042ba <exec+0x1e0>
    800042b6:	4901                	li	s2,0
    800042b8:	b7a1                	j	80004200 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042ba:	e0843903          	ld	s2,-504(s0)
    800042be:	b7b5                	j	8000422a <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042c0:	4901                	li	s2,0
  iunlockput(ip);
    800042c2:	8552                	mv	a0,s4
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	b98080e7          	jalr	-1128(ra) # 80002e5c <iunlockput>
  end_op();
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	34e080e7          	jalr	846(ra) # 8000361a <end_op>
  p = myproc();
    800042d4:	ffffd097          	auipc	ra,0xffffd
    800042d8:	bd6080e7          	jalr	-1066(ra) # 80000eaa <myproc>
    800042dc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042de:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800042e2:	6985                	lui	s3,0x1
    800042e4:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042e6:	99ca                	add	s3,s3,s2
    800042e8:	77fd                	lui	a5,0xfffff
    800042ea:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042ee:	4691                	li	a3,4
    800042f0:	6609                	lui	a2,0x2
    800042f2:	964e                	add	a2,a2,s3
    800042f4:	85ce                	mv	a1,s3
    800042f6:	855a                	mv	a0,s6
    800042f8:	ffffc097          	auipc	ra,0xffffc
    800042fc:	5e2080e7          	jalr	1506(ra) # 800008da <uvmalloc>
    80004300:	892a                	mv	s2,a0
    80004302:	e0a43423          	sd	a0,-504(s0)
    80004306:	e509                	bnez	a0,80004310 <exec+0x236>
  if(pagetable)
    80004308:	e1343423          	sd	s3,-504(s0)
    8000430c:	4a01                	li	s4,0
    8000430e:	aa1d                	j	80004444 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004310:	75f9                	lui	a1,0xffffe
    80004312:	95aa                	add	a1,a1,a0
    80004314:	855a                	mv	a0,s6
    80004316:	ffffc097          	auipc	ra,0xffffc
    8000431a:	7ee080e7          	jalr	2030(ra) # 80000b04 <uvmclear>
  stackbase = sp - PGSIZE;
    8000431e:	7bfd                	lui	s7,0xfffff
    80004320:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004322:	e0043783          	ld	a5,-512(s0)
    80004326:	6388                	ld	a0,0(a5)
    80004328:	c52d                	beqz	a0,80004392 <exec+0x2b8>
    8000432a:	e9040993          	add	s3,s0,-368
    8000432e:	f9040c13          	add	s8,s0,-112
    80004332:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	fc0080e7          	jalr	-64(ra) # 800002f4 <strlen>
    8000433c:	0015079b          	addw	a5,a0,1
    80004340:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004344:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004348:	13796563          	bltu	s2,s7,80004472 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000434c:	e0043d03          	ld	s10,-512(s0)
    80004350:	000d3a03          	ld	s4,0(s10)
    80004354:	8552                	mv	a0,s4
    80004356:	ffffc097          	auipc	ra,0xffffc
    8000435a:	f9e080e7          	jalr	-98(ra) # 800002f4 <strlen>
    8000435e:	0015069b          	addw	a3,a0,1
    80004362:	8652                	mv	a2,s4
    80004364:	85ca                	mv	a1,s2
    80004366:	855a                	mv	a0,s6
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	7ce080e7          	jalr	1998(ra) # 80000b36 <copyout>
    80004370:	10054363          	bltz	a0,80004476 <exec+0x39c>
    ustack[argc] = sp;
    80004374:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004378:	0485                	add	s1,s1,1
    8000437a:	008d0793          	add	a5,s10,8
    8000437e:	e0f43023          	sd	a5,-512(s0)
    80004382:	008d3503          	ld	a0,8(s10)
    80004386:	c909                	beqz	a0,80004398 <exec+0x2be>
    if(argc >= MAXARG)
    80004388:	09a1                	add	s3,s3,8
    8000438a:	fb8995e3          	bne	s3,s8,80004334 <exec+0x25a>
  ip = 0;
    8000438e:	4a01                	li	s4,0
    80004390:	a855                	j	80004444 <exec+0x36a>
  sp = sz;
    80004392:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004396:	4481                	li	s1,0
  ustack[argc] = 0;
    80004398:	00349793          	sll	a5,s1,0x3
    8000439c:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdceb0>
    800043a0:	97a2                	add	a5,a5,s0
    800043a2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043a6:	00148693          	add	a3,s1,1
    800043aa:	068e                	sll	a3,a3,0x3
    800043ac:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043b0:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800043b4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800043b8:	f57968e3          	bltu	s2,s7,80004308 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043bc:	e9040613          	add	a2,s0,-368
    800043c0:	85ca                	mv	a1,s2
    800043c2:	855a                	mv	a0,s6
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	772080e7          	jalr	1906(ra) # 80000b36 <copyout>
    800043cc:	0a054763          	bltz	a0,8000447a <exec+0x3a0>
  p->trapframe->a1 = sp;
    800043d0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043d4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043d8:	df843783          	ld	a5,-520(s0)
    800043dc:	0007c703          	lbu	a4,0(a5)
    800043e0:	cf11                	beqz	a4,800043fc <exec+0x322>
    800043e2:	0785                	add	a5,a5,1
    if(*s == '/')
    800043e4:	02f00693          	li	a3,47
    800043e8:	a039                	j	800043f6 <exec+0x31c>
      last = s+1;
    800043ea:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043ee:	0785                	add	a5,a5,1
    800043f0:	fff7c703          	lbu	a4,-1(a5)
    800043f4:	c701                	beqz	a4,800043fc <exec+0x322>
    if(*s == '/')
    800043f6:	fed71ce3          	bne	a4,a3,800043ee <exec+0x314>
    800043fa:	bfc5                	j	800043ea <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800043fc:	4641                	li	a2,16
    800043fe:	df843583          	ld	a1,-520(s0)
    80004402:	158a8513          	add	a0,s5,344
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	ebc080e7          	jalr	-324(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000440e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004412:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004416:	e0843783          	ld	a5,-504(s0)
    8000441a:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    8000441e:	058ab783          	ld	a5,88(s5)
    80004422:	e6843703          	ld	a4,-408(s0)
    80004426:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    80004428:	058ab783          	ld	a5,88(s5)
    8000442c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004430:	85e6                	mv	a1,s9
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	bdc080e7          	jalr	-1060(ra) # 8000100e <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    8000443a:	0004851b          	sext.w	a0,s1
    8000443e:	bb15                	j	80004172 <exec+0x98>
    80004440:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004444:	e0843583          	ld	a1,-504(s0)
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffd097          	auipc	ra,0xffffd
    8000444e:	bc4080e7          	jalr	-1084(ra) # 8000100e <proc_freepagetable>
  return -1;
    80004452:	557d                	li	a0,-1
  if(ip){
    80004454:	d00a0fe3          	beqz	s4,80004172 <exec+0x98>
    80004458:	b319                	j	8000415e <exec+0x84>
    8000445a:	e1243423          	sd	s2,-504(s0)
    8000445e:	b7dd                	j	80004444 <exec+0x36a>
    80004460:	e1243423          	sd	s2,-504(s0)
    80004464:	b7c5                	j	80004444 <exec+0x36a>
    80004466:	e1243423          	sd	s2,-504(s0)
    8000446a:	bfe9                	j	80004444 <exec+0x36a>
    8000446c:	e1243423          	sd	s2,-504(s0)
    80004470:	bfd1                	j	80004444 <exec+0x36a>
  ip = 0;
    80004472:	4a01                	li	s4,0
    80004474:	bfc1                	j	80004444 <exec+0x36a>
    80004476:	4a01                	li	s4,0
  if(pagetable)
    80004478:	b7f1                	j	80004444 <exec+0x36a>
  sz = sz1;
    8000447a:	e0843983          	ld	s3,-504(s0)
    8000447e:	b569                	j	80004308 <exec+0x22e>

0000000080004480 <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004480:	7179                	add	sp,sp,-48
    80004482:	f406                	sd	ra,40(sp)
    80004484:	f022                	sd	s0,32(sp)
    80004486:	ec26                	sd	s1,24(sp)
    80004488:	e84a                	sd	s2,16(sp)
    8000448a:	1800                	add	s0,sp,48
    8000448c:	892e                	mv	s2,a1
    8000448e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004490:	fdc40593          	add	a1,s0,-36
    80004494:	ffffe097          	auipc	ra,0xffffe
    80004498:	b5e080e7          	jalr	-1186(ra) # 80001ff2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000449c:	fdc42703          	lw	a4,-36(s0)
    800044a0:	47bd                	li	a5,15
    800044a2:	02e7eb63          	bltu	a5,a4,800044d8 <argfd+0x58>
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	a04080e7          	jalr	-1532(ra) # 80000eaa <myproc>
    800044ae:	fdc42703          	lw	a4,-36(s0)
    800044b2:	01a70793          	add	a5,a4,26
    800044b6:	078e                	sll	a5,a5,0x3
    800044b8:	953e                	add	a0,a0,a5
    800044ba:	611c                	ld	a5,0(a0)
    800044bc:	c385                	beqz	a5,800044dc <argfd+0x5c>
    return -1;
  if(pfd)
    800044be:	00090463          	beqz	s2,800044c6 <argfd+0x46>
    *pfd = fd;
    800044c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c6:	4501                	li	a0,0
  if(pf)
    800044c8:	c091                	beqz	s1,800044cc <argfd+0x4c>
    *pf = f;
    800044ca:	e09c                	sd	a5,0(s1)
}
    800044cc:	70a2                	ld	ra,40(sp)
    800044ce:	7402                	ld	s0,32(sp)
    800044d0:	64e2                	ld	s1,24(sp)
    800044d2:	6942                	ld	s2,16(sp)
    800044d4:	6145                	add	sp,sp,48
    800044d6:	8082                	ret
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	bfcd                	j	800044cc <argfd+0x4c>
    800044dc:	557d                	li	a0,-1
    800044de:	b7fd                	j	800044cc <argfd+0x4c>

00000000800044e0 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    800044e0:	1101                	add	sp,sp,-32
    800044e2:	ec06                	sd	ra,24(sp)
    800044e4:	e822                	sd	s0,16(sp)
    800044e6:	e426                	sd	s1,8(sp)
    800044e8:	1000                	add	s0,sp,32
    800044ea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ec:	ffffd097          	auipc	ra,0xffffd
    800044f0:	9be080e7          	jalr	-1602(ra) # 80000eaa <myproc>
    800044f4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f6:	0d050793          	add	a5,a0,208
    800044fa:	4501                	li	a0,0
    800044fc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044fe:	6398                	ld	a4,0(a5)
    80004500:	cb19                	beqz	a4,80004516 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004502:	2505                	addw	a0,a0,1
    80004504:	07a1                	add	a5,a5,8
    80004506:	fed51ce3          	bne	a0,a3,800044fe <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000450a:	557d                	li	a0,-1
}
    8000450c:	60e2                	ld	ra,24(sp)
    8000450e:	6442                	ld	s0,16(sp)
    80004510:	64a2                	ld	s1,8(sp)
    80004512:	6105                	add	sp,sp,32
    80004514:	8082                	ret
      p->ofile[fd] = f;
    80004516:	01a50793          	add	a5,a0,26
    8000451a:	078e                	sll	a5,a5,0x3
    8000451c:	963e                	add	a2,a2,a5
    8000451e:	e204                	sd	s1,0(a2)
      return fd;
    80004520:	b7f5                	j	8000450c <fdalloc+0x2c>

0000000080004522 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004522:	715d                	add	sp,sp,-80
    80004524:	e486                	sd	ra,72(sp)
    80004526:	e0a2                	sd	s0,64(sp)
    80004528:	fc26                	sd	s1,56(sp)
    8000452a:	f84a                	sd	s2,48(sp)
    8000452c:	f44e                	sd	s3,40(sp)
    8000452e:	f052                	sd	s4,32(sp)
    80004530:	ec56                	sd	s5,24(sp)
    80004532:	e85a                	sd	s6,16(sp)
    80004534:	0880                	add	s0,sp,80
    80004536:	8b2e                	mv	s6,a1
    80004538:	89b2                	mv	s3,a2
    8000453a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000453c:	fb040593          	add	a1,s0,-80
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	e7e080e7          	jalr	-386(ra) # 800033be <nameiparent>
    80004548:	84aa                	mv	s1,a0
    8000454a:	14050b63          	beqz	a0,800046a0 <create+0x17e>
    return 0;

  ilock(dp);
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	6ac080e7          	jalr	1708(ra) # 80002bfa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004556:	4601                	li	a2,0
    80004558:	fb040593          	add	a1,s0,-80
    8000455c:	8526                	mv	a0,s1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	b80080e7          	jalr	-1152(ra) # 800030de <dirlookup>
    80004566:	8aaa                	mv	s5,a0
    80004568:	c921                	beqz	a0,800045b8 <create+0x96>
    iunlockput(dp);
    8000456a:	8526                	mv	a0,s1
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	8f0080e7          	jalr	-1808(ra) # 80002e5c <iunlockput>
    ilock(ip);
    80004574:	8556                	mv	a0,s5
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	684080e7          	jalr	1668(ra) # 80002bfa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000457e:	4789                	li	a5,2
    80004580:	02fb1563          	bne	s6,a5,800045aa <create+0x88>
    80004584:	044ad783          	lhu	a5,68(s5)
    80004588:	37f9                	addw	a5,a5,-2
    8000458a:	17c2                	sll	a5,a5,0x30
    8000458c:	93c1                	srl	a5,a5,0x30
    8000458e:	4705                	li	a4,1
    80004590:	00f76d63          	bltu	a4,a5,800045aa <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004594:	8556                	mv	a0,s5
    80004596:	60a6                	ld	ra,72(sp)
    80004598:	6406                	ld	s0,64(sp)
    8000459a:	74e2                	ld	s1,56(sp)
    8000459c:	7942                	ld	s2,48(sp)
    8000459e:	79a2                	ld	s3,40(sp)
    800045a0:	7a02                	ld	s4,32(sp)
    800045a2:	6ae2                	ld	s5,24(sp)
    800045a4:	6b42                	ld	s6,16(sp)
    800045a6:	6161                	add	sp,sp,80
    800045a8:	8082                	ret
    iunlockput(ip);
    800045aa:	8556                	mv	a0,s5
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	8b0080e7          	jalr	-1872(ra) # 80002e5c <iunlockput>
    return 0;
    800045b4:	4a81                	li	s5,0
    800045b6:	bff9                	j	80004594 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045b8:	85da                	mv	a1,s6
    800045ba:	4088                	lw	a0,0(s1)
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	4a6080e7          	jalr	1190(ra) # 80002a62 <ialloc>
    800045c4:	8a2a                	mv	s4,a0
    800045c6:	c529                	beqz	a0,80004610 <create+0xee>
  ilock(ip);
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	632080e7          	jalr	1586(ra) # 80002bfa <ilock>
  ip->major = major;
    800045d0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045d4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045d8:	4905                	li	s2,1
    800045da:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800045de:	8552                	mv	a0,s4
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	54e080e7          	jalr	1358(ra) # 80002b2e <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    800045e8:	032b0b63          	beq	s6,s2,8000461e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045ec:	004a2603          	lw	a2,4(s4)
    800045f0:	fb040593          	add	a1,s0,-80
    800045f4:	8526                	mv	a0,s1
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	cf8080e7          	jalr	-776(ra) # 800032ee <dirlink>
    800045fe:	06054f63          	bltz	a0,8000467c <create+0x15a>
  iunlockput(dp);
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	858080e7          	jalr	-1960(ra) # 80002e5c <iunlockput>
  return ip;
    8000460c:	8ad2                	mv	s5,s4
    8000460e:	b759                	j	80004594 <create+0x72>
    iunlockput(dp);
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	84a080e7          	jalr	-1974(ra) # 80002e5c <iunlockput>
    return 0;
    8000461a:	8ad2                	mv	s5,s4
    8000461c:	bfa5                	j	80004594 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000461e:	004a2603          	lw	a2,4(s4)
    80004622:	00004597          	auipc	a1,0x4
    80004626:	14e58593          	add	a1,a1,334 # 80008770 <syscalls+0x2a0>
    8000462a:	8552                	mv	a0,s4
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	cc2080e7          	jalr	-830(ra) # 800032ee <dirlink>
    80004634:	04054463          	bltz	a0,8000467c <create+0x15a>
    80004638:	40d0                	lw	a2,4(s1)
    8000463a:	00004597          	auipc	a1,0x4
    8000463e:	13e58593          	add	a1,a1,318 # 80008778 <syscalls+0x2a8>
    80004642:	8552                	mv	a0,s4
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	caa080e7          	jalr	-854(ra) # 800032ee <dirlink>
    8000464c:	02054863          	bltz	a0,8000467c <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004650:	004a2603          	lw	a2,4(s4)
    80004654:	fb040593          	add	a1,s0,-80
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	c94080e7          	jalr	-876(ra) # 800032ee <dirlink>
    80004662:	00054d63          	bltz	a0,8000467c <create+0x15a>
    dp->nlink++;  /* for ".." */
    80004666:	04a4d783          	lhu	a5,74(s1)
    8000466a:	2785                	addw	a5,a5,1
    8000466c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004670:	8526                	mv	a0,s1
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	4bc080e7          	jalr	1212(ra) # 80002b2e <iupdate>
    8000467a:	b761                	j	80004602 <create+0xe0>
  ip->nlink = 0;
    8000467c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004680:	8552                	mv	a0,s4
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	4ac080e7          	jalr	1196(ra) # 80002b2e <iupdate>
  iunlockput(ip);
    8000468a:	8552                	mv	a0,s4
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	7d0080e7          	jalr	2000(ra) # 80002e5c <iunlockput>
  iunlockput(dp);
    80004694:	8526                	mv	a0,s1
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	7c6080e7          	jalr	1990(ra) # 80002e5c <iunlockput>
  return 0;
    8000469e:	bddd                	j	80004594 <create+0x72>
    return 0;
    800046a0:	8aaa                	mv	s5,a0
    800046a2:	bdcd                	j	80004594 <create+0x72>

00000000800046a4 <sys_dup>:
{
    800046a4:	7179                	add	sp,sp,-48
    800046a6:	f406                	sd	ra,40(sp)
    800046a8:	f022                	sd	s0,32(sp)
    800046aa:	ec26                	sd	s1,24(sp)
    800046ac:	e84a                	sd	s2,16(sp)
    800046ae:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046b0:	fd840613          	add	a2,s0,-40
    800046b4:	4581                	li	a1,0
    800046b6:	4501                	li	a0,0
    800046b8:	00000097          	auipc	ra,0x0
    800046bc:	dc8080e7          	jalr	-568(ra) # 80004480 <argfd>
    return -1;
    800046c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046c2:	02054363          	bltz	a0,800046e8 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046c6:	fd843903          	ld	s2,-40(s0)
    800046ca:	854a                	mv	a0,s2
    800046cc:	00000097          	auipc	ra,0x0
    800046d0:	e14080e7          	jalr	-492(ra) # 800044e0 <fdalloc>
    800046d4:	84aa                	mv	s1,a0
    return -1;
    800046d6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046d8:	00054863          	bltz	a0,800046e8 <sys_dup+0x44>
  filedup(f);
    800046dc:	854a                	mv	a0,s2
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	334080e7          	jalr	820(ra) # 80003a12 <filedup>
  return fd;
    800046e6:	87a6                	mv	a5,s1
}
    800046e8:	853e                	mv	a0,a5
    800046ea:	70a2                	ld	ra,40(sp)
    800046ec:	7402                	ld	s0,32(sp)
    800046ee:	64e2                	ld	s1,24(sp)
    800046f0:	6942                	ld	s2,16(sp)
    800046f2:	6145                	add	sp,sp,48
    800046f4:	8082                	ret

00000000800046f6 <sys_read>:
{
    800046f6:	7179                	add	sp,sp,-48
    800046f8:	f406                	sd	ra,40(sp)
    800046fa:	f022                	sd	s0,32(sp)
    800046fc:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800046fe:	fd840593          	add	a1,s0,-40
    80004702:	4505                	li	a0,1
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	90e080e7          	jalr	-1778(ra) # 80002012 <argaddr>
  argint(2, &n);
    8000470c:	fe440593          	add	a1,s0,-28
    80004710:	4509                	li	a0,2
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	8e0080e7          	jalr	-1824(ra) # 80001ff2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000471a:	fe840613          	add	a2,s0,-24
    8000471e:	4581                	li	a1,0
    80004720:	4501                	li	a0,0
    80004722:	00000097          	auipc	ra,0x0
    80004726:	d5e080e7          	jalr	-674(ra) # 80004480 <argfd>
    8000472a:	87aa                	mv	a5,a0
    return -1;
    8000472c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000472e:	0007cc63          	bltz	a5,80004746 <sys_read+0x50>
  return fileread(f, p, n);
    80004732:	fe442603          	lw	a2,-28(s0)
    80004736:	fd843583          	ld	a1,-40(s0)
    8000473a:	fe843503          	ld	a0,-24(s0)
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	460080e7          	jalr	1120(ra) # 80003b9e <fileread>
}
    80004746:	70a2                	ld	ra,40(sp)
    80004748:	7402                	ld	s0,32(sp)
    8000474a:	6145                	add	sp,sp,48
    8000474c:	8082                	ret

000000008000474e <sys_write>:
{
    8000474e:	7179                	add	sp,sp,-48
    80004750:	f406                	sd	ra,40(sp)
    80004752:	f022                	sd	s0,32(sp)
    80004754:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004756:	fd840593          	add	a1,s0,-40
    8000475a:	4505                	li	a0,1
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	8b6080e7          	jalr	-1866(ra) # 80002012 <argaddr>
  argint(2, &n);
    80004764:	fe440593          	add	a1,s0,-28
    80004768:	4509                	li	a0,2
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	888080e7          	jalr	-1912(ra) # 80001ff2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004772:	fe840613          	add	a2,s0,-24
    80004776:	4581                	li	a1,0
    80004778:	4501                	li	a0,0
    8000477a:	00000097          	auipc	ra,0x0
    8000477e:	d06080e7          	jalr	-762(ra) # 80004480 <argfd>
    80004782:	87aa                	mv	a5,a0
    return -1;
    80004784:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004786:	0007cc63          	bltz	a5,8000479e <sys_write+0x50>
  return filewrite(f, p, n);
    8000478a:	fe442603          	lw	a2,-28(s0)
    8000478e:	fd843583          	ld	a1,-40(s0)
    80004792:	fe843503          	ld	a0,-24(s0)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	4ca080e7          	jalr	1226(ra) # 80003c60 <filewrite>
}
    8000479e:	70a2                	ld	ra,40(sp)
    800047a0:	7402                	ld	s0,32(sp)
    800047a2:	6145                	add	sp,sp,48
    800047a4:	8082                	ret

00000000800047a6 <sys_close>:
{
    800047a6:	1101                	add	sp,sp,-32
    800047a8:	ec06                	sd	ra,24(sp)
    800047aa:	e822                	sd	s0,16(sp)
    800047ac:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ae:	fe040613          	add	a2,s0,-32
    800047b2:	fec40593          	add	a1,s0,-20
    800047b6:	4501                	li	a0,0
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	cc8080e7          	jalr	-824(ra) # 80004480 <argfd>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c2:	02054463          	bltz	a0,800047ea <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047c6:	ffffc097          	auipc	ra,0xffffc
    800047ca:	6e4080e7          	jalr	1764(ra) # 80000eaa <myproc>
    800047ce:	fec42783          	lw	a5,-20(s0)
    800047d2:	07e9                	add	a5,a5,26
    800047d4:	078e                	sll	a5,a5,0x3
    800047d6:	953e                	add	a0,a0,a5
    800047d8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047dc:	fe043503          	ld	a0,-32(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	284080e7          	jalr	644(ra) # 80003a64 <fileclose>
  return 0;
    800047e8:	4781                	li	a5,0
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	60e2                	ld	ra,24(sp)
    800047ee:	6442                	ld	s0,16(sp)
    800047f0:	6105                	add	sp,sp,32
    800047f2:	8082                	ret

00000000800047f4 <sys_fstat>:
{
    800047f4:	1101                	add	sp,sp,-32
    800047f6:	ec06                	sd	ra,24(sp)
    800047f8:	e822                	sd	s0,16(sp)
    800047fa:	1000                	add	s0,sp,32
  argaddr(1, &st);
    800047fc:	fe040593          	add	a1,s0,-32
    80004800:	4505                	li	a0,1
    80004802:	ffffe097          	auipc	ra,0xffffe
    80004806:	810080e7          	jalr	-2032(ra) # 80002012 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000480a:	fe840613          	add	a2,s0,-24
    8000480e:	4581                	li	a1,0
    80004810:	4501                	li	a0,0
    80004812:	00000097          	auipc	ra,0x0
    80004816:	c6e080e7          	jalr	-914(ra) # 80004480 <argfd>
    8000481a:	87aa                	mv	a5,a0
    return -1;
    8000481c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000481e:	0007ca63          	bltz	a5,80004832 <sys_fstat+0x3e>
  return filestat(f, st);
    80004822:	fe043583          	ld	a1,-32(s0)
    80004826:	fe843503          	ld	a0,-24(s0)
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	302080e7          	jalr	770(ra) # 80003b2c <filestat>
}
    80004832:	60e2                	ld	ra,24(sp)
    80004834:	6442                	ld	s0,16(sp)
    80004836:	6105                	add	sp,sp,32
    80004838:	8082                	ret

000000008000483a <sys_link>:
{
    8000483a:	7169                	add	sp,sp,-304
    8000483c:	f606                	sd	ra,296(sp)
    8000483e:	f222                	sd	s0,288(sp)
    80004840:	ee26                	sd	s1,280(sp)
    80004842:	ea4a                	sd	s2,272(sp)
    80004844:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004846:	08000613          	li	a2,128
    8000484a:	ed040593          	add	a1,s0,-304
    8000484e:	4501                	li	a0,0
    80004850:	ffffd097          	auipc	ra,0xffffd
    80004854:	7e2080e7          	jalr	2018(ra) # 80002032 <argstr>
    return -1;
    80004858:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485a:	10054e63          	bltz	a0,80004976 <sys_link+0x13c>
    8000485e:	08000613          	li	a2,128
    80004862:	f5040593          	add	a1,s0,-176
    80004866:	4505                	li	a0,1
    80004868:	ffffd097          	auipc	ra,0xffffd
    8000486c:	7ca080e7          	jalr	1994(ra) # 80002032 <argstr>
    return -1;
    80004870:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004872:	10054263          	bltz	a0,80004976 <sys_link+0x13c>
  begin_op();
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	d2a080e7          	jalr	-726(ra) # 800035a0 <begin_op>
  if((ip = namei(old)) == 0){
    8000487e:	ed040513          	add	a0,s0,-304
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	b1e080e7          	jalr	-1250(ra) # 800033a0 <namei>
    8000488a:	84aa                	mv	s1,a0
    8000488c:	c551                	beqz	a0,80004918 <sys_link+0xde>
  ilock(ip);
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	36c080e7          	jalr	876(ra) # 80002bfa <ilock>
  if(ip->type == T_DIR){
    80004896:	04449703          	lh	a4,68(s1)
    8000489a:	4785                	li	a5,1
    8000489c:	08f70463          	beq	a4,a5,80004924 <sys_link+0xea>
  ip->nlink++;
    800048a0:	04a4d783          	lhu	a5,74(s1)
    800048a4:	2785                	addw	a5,a5,1
    800048a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048aa:	8526                	mv	a0,s1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	282080e7          	jalr	642(ra) # 80002b2e <iupdate>
  iunlock(ip);
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	406080e7          	jalr	1030(ra) # 80002cbc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048be:	fd040593          	add	a1,s0,-48
    800048c2:	f5040513          	add	a0,s0,-176
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	af8080e7          	jalr	-1288(ra) # 800033be <nameiparent>
    800048ce:	892a                	mv	s2,a0
    800048d0:	c935                	beqz	a0,80004944 <sys_link+0x10a>
  ilock(dp);
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	328080e7          	jalr	808(ra) # 80002bfa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048da:	00092703          	lw	a4,0(s2)
    800048de:	409c                	lw	a5,0(s1)
    800048e0:	04f71d63          	bne	a4,a5,8000493a <sys_link+0x100>
    800048e4:	40d0                	lw	a2,4(s1)
    800048e6:	fd040593          	add	a1,s0,-48
    800048ea:	854a                	mv	a0,s2
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	a02080e7          	jalr	-1534(ra) # 800032ee <dirlink>
    800048f4:	04054363          	bltz	a0,8000493a <sys_link+0x100>
  iunlockput(dp);
    800048f8:	854a                	mv	a0,s2
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	562080e7          	jalr	1378(ra) # 80002e5c <iunlockput>
  iput(ip);
    80004902:	8526                	mv	a0,s1
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	4b0080e7          	jalr	1200(ra) # 80002db4 <iput>
  end_op();
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	d0e080e7          	jalr	-754(ra) # 8000361a <end_op>
  return 0;
    80004914:	4781                	li	a5,0
    80004916:	a085                	j	80004976 <sys_link+0x13c>
    end_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	d02080e7          	jalr	-766(ra) # 8000361a <end_op>
    return -1;
    80004920:	57fd                	li	a5,-1
    80004922:	a891                	j	80004976 <sys_link+0x13c>
    iunlockput(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	536080e7          	jalr	1334(ra) # 80002e5c <iunlockput>
    end_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	cec080e7          	jalr	-788(ra) # 8000361a <end_op>
    return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	a83d                	j	80004976 <sys_link+0x13c>
    iunlockput(dp);
    8000493a:	854a                	mv	a0,s2
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	520080e7          	jalr	1312(ra) # 80002e5c <iunlockput>
  ilock(ip);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	2b4080e7          	jalr	692(ra) # 80002bfa <ilock>
  ip->nlink--;
    8000494e:	04a4d783          	lhu	a5,74(s1)
    80004952:	37fd                	addw	a5,a5,-1
    80004954:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	1d4080e7          	jalr	468(ra) # 80002b2e <iupdate>
  iunlockput(ip);
    80004962:	8526                	mv	a0,s1
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	4f8080e7          	jalr	1272(ra) # 80002e5c <iunlockput>
  end_op();
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	cae080e7          	jalr	-850(ra) # 8000361a <end_op>
  return -1;
    80004974:	57fd                	li	a5,-1
}
    80004976:	853e                	mv	a0,a5
    80004978:	70b2                	ld	ra,296(sp)
    8000497a:	7412                	ld	s0,288(sp)
    8000497c:	64f2                	ld	s1,280(sp)
    8000497e:	6952                	ld	s2,272(sp)
    80004980:	6155                	add	sp,sp,304
    80004982:	8082                	ret

0000000080004984 <sys_unlink>:
{
    80004984:	7151                	add	sp,sp,-240
    80004986:	f586                	sd	ra,232(sp)
    80004988:	f1a2                	sd	s0,224(sp)
    8000498a:	eda6                	sd	s1,216(sp)
    8000498c:	e9ca                	sd	s2,208(sp)
    8000498e:	e5ce                	sd	s3,200(sp)
    80004990:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004992:	08000613          	li	a2,128
    80004996:	f3040593          	add	a1,s0,-208
    8000499a:	4501                	li	a0,0
    8000499c:	ffffd097          	auipc	ra,0xffffd
    800049a0:	696080e7          	jalr	1686(ra) # 80002032 <argstr>
    800049a4:	18054163          	bltz	a0,80004b26 <sys_unlink+0x1a2>
  begin_op();
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	bf8080e7          	jalr	-1032(ra) # 800035a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049b0:	fb040593          	add	a1,s0,-80
    800049b4:	f3040513          	add	a0,s0,-208
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	a06080e7          	jalr	-1530(ra) # 800033be <nameiparent>
    800049c0:	84aa                	mv	s1,a0
    800049c2:	c979                	beqz	a0,80004a98 <sys_unlink+0x114>
  ilock(dp);
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	236080e7          	jalr	566(ra) # 80002bfa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049cc:	00004597          	auipc	a1,0x4
    800049d0:	da458593          	add	a1,a1,-604 # 80008770 <syscalls+0x2a0>
    800049d4:	fb040513          	add	a0,s0,-80
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	6ec080e7          	jalr	1772(ra) # 800030c4 <namecmp>
    800049e0:	14050a63          	beqz	a0,80004b34 <sys_unlink+0x1b0>
    800049e4:	00004597          	auipc	a1,0x4
    800049e8:	d9458593          	add	a1,a1,-620 # 80008778 <syscalls+0x2a8>
    800049ec:	fb040513          	add	a0,s0,-80
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	6d4080e7          	jalr	1748(ra) # 800030c4 <namecmp>
    800049f8:	12050e63          	beqz	a0,80004b34 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049fc:	f2c40613          	add	a2,s0,-212
    80004a00:	fb040593          	add	a1,s0,-80
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	6d8080e7          	jalr	1752(ra) # 800030de <dirlookup>
    80004a0e:	892a                	mv	s2,a0
    80004a10:	12050263          	beqz	a0,80004b34 <sys_unlink+0x1b0>
  ilock(ip);
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	1e6080e7          	jalr	486(ra) # 80002bfa <ilock>
  if(ip->nlink < 1)
    80004a1c:	04a91783          	lh	a5,74(s2)
    80004a20:	08f05263          	blez	a5,80004aa4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a24:	04491703          	lh	a4,68(s2)
    80004a28:	4785                	li	a5,1
    80004a2a:	08f70563          	beq	a4,a5,80004ab4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a2e:	4641                	li	a2,16
    80004a30:	4581                	li	a1,0
    80004a32:	fc040513          	add	a0,s0,-64
    80004a36:	ffffb097          	auipc	ra,0xffffb
    80004a3a:	744080e7          	jalr	1860(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a3e:	4741                	li	a4,16
    80004a40:	f2c42683          	lw	a3,-212(s0)
    80004a44:	fc040613          	add	a2,s0,-64
    80004a48:	4581                	li	a1,0
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	55a080e7          	jalr	1370(ra) # 80002fa6 <writei>
    80004a54:	47c1                	li	a5,16
    80004a56:	0af51563          	bne	a0,a5,80004b00 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a5a:	04491703          	lh	a4,68(s2)
    80004a5e:	4785                	li	a5,1
    80004a60:	0af70863          	beq	a4,a5,80004b10 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a64:	8526                	mv	a0,s1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	3f6080e7          	jalr	1014(ra) # 80002e5c <iunlockput>
  ip->nlink--;
    80004a6e:	04a95783          	lhu	a5,74(s2)
    80004a72:	37fd                	addw	a5,a5,-1
    80004a74:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	0b4080e7          	jalr	180(ra) # 80002b2e <iupdate>
  iunlockput(ip);
    80004a82:	854a                	mv	a0,s2
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	3d8080e7          	jalr	984(ra) # 80002e5c <iunlockput>
  end_op();
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	b8e080e7          	jalr	-1138(ra) # 8000361a <end_op>
  return 0;
    80004a94:	4501                	li	a0,0
    80004a96:	a84d                	j	80004b48 <sys_unlink+0x1c4>
    end_op();
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	b82080e7          	jalr	-1150(ra) # 8000361a <end_op>
    return -1;
    80004aa0:	557d                	li	a0,-1
    80004aa2:	a05d                	j	80004b48 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aa4:	00004517          	auipc	a0,0x4
    80004aa8:	cdc50513          	add	a0,a0,-804 # 80008780 <syscalls+0x2b0>
    80004aac:	00001097          	auipc	ra,0x1
    80004ab0:	1aa080e7          	jalr	426(ra) # 80005c56 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab4:	04c92703          	lw	a4,76(s2)
    80004ab8:	02000793          	li	a5,32
    80004abc:	f6e7f9e3          	bgeu	a5,a4,80004a2e <sys_unlink+0xaa>
    80004ac0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac4:	4741                	li	a4,16
    80004ac6:	86ce                	mv	a3,s3
    80004ac8:	f1840613          	add	a2,s0,-232
    80004acc:	4581                	li	a1,0
    80004ace:	854a                	mv	a0,s2
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	3de080e7          	jalr	990(ra) # 80002eae <readi>
    80004ad8:	47c1                	li	a5,16
    80004ada:	00f51b63          	bne	a0,a5,80004af0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ade:	f1845783          	lhu	a5,-232(s0)
    80004ae2:	e7a1                	bnez	a5,80004b2a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae4:	29c1                	addw	s3,s3,16
    80004ae6:	04c92783          	lw	a5,76(s2)
    80004aea:	fcf9ede3          	bltu	s3,a5,80004ac4 <sys_unlink+0x140>
    80004aee:	b781                	j	80004a2e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004af0:	00004517          	auipc	a0,0x4
    80004af4:	ca850513          	add	a0,a0,-856 # 80008798 <syscalls+0x2c8>
    80004af8:	00001097          	auipc	ra,0x1
    80004afc:	15e080e7          	jalr	350(ra) # 80005c56 <panic>
    panic("unlink: writei");
    80004b00:	00004517          	auipc	a0,0x4
    80004b04:	cb050513          	add	a0,a0,-848 # 800087b0 <syscalls+0x2e0>
    80004b08:	00001097          	auipc	ra,0x1
    80004b0c:	14e080e7          	jalr	334(ra) # 80005c56 <panic>
    dp->nlink--;
    80004b10:	04a4d783          	lhu	a5,74(s1)
    80004b14:	37fd                	addw	a5,a5,-1
    80004b16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	012080e7          	jalr	18(ra) # 80002b2e <iupdate>
    80004b24:	b781                	j	80004a64 <sys_unlink+0xe0>
    return -1;
    80004b26:	557d                	li	a0,-1
    80004b28:	a005                	j	80004b48 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b2a:	854a                	mv	a0,s2
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	330080e7          	jalr	816(ra) # 80002e5c <iunlockput>
  iunlockput(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	326080e7          	jalr	806(ra) # 80002e5c <iunlockput>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	adc080e7          	jalr	-1316(ra) # 8000361a <end_op>
  return -1;
    80004b46:	557d                	li	a0,-1
}
    80004b48:	70ae                	ld	ra,232(sp)
    80004b4a:	740e                	ld	s0,224(sp)
    80004b4c:	64ee                	ld	s1,216(sp)
    80004b4e:	694e                	ld	s2,208(sp)
    80004b50:	69ae                	ld	s3,200(sp)
    80004b52:	616d                	add	sp,sp,240
    80004b54:	8082                	ret

0000000080004b56 <sys_open>:

uint64
sys_open(void)
{
    80004b56:	7131                	add	sp,sp,-192
    80004b58:	fd06                	sd	ra,184(sp)
    80004b5a:	f922                	sd	s0,176(sp)
    80004b5c:	f526                	sd	s1,168(sp)
    80004b5e:	f14a                	sd	s2,160(sp)
    80004b60:	ed4e                	sd	s3,152(sp)
    80004b62:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b64:	f4c40593          	add	a1,s0,-180
    80004b68:	4505                	li	a0,1
    80004b6a:	ffffd097          	auipc	ra,0xffffd
    80004b6e:	488080e7          	jalr	1160(ra) # 80001ff2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b72:	08000613          	li	a2,128
    80004b76:	f5040593          	add	a1,s0,-176
    80004b7a:	4501                	li	a0,0
    80004b7c:	ffffd097          	auipc	ra,0xffffd
    80004b80:	4b6080e7          	jalr	1206(ra) # 80002032 <argstr>
    80004b84:	87aa                	mv	a5,a0
    return -1;
    80004b86:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b88:	0a07c863          	bltz	a5,80004c38 <sys_open+0xe2>

  begin_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	a14080e7          	jalr	-1516(ra) # 800035a0 <begin_op>

  if(omode & O_CREATE){
    80004b94:	f4c42783          	lw	a5,-180(s0)
    80004b98:	2007f793          	and	a5,a5,512
    80004b9c:	cbdd                	beqz	a5,80004c52 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004b9e:	4681                	li	a3,0
    80004ba0:	4601                	li	a2,0
    80004ba2:	4589                	li	a1,2
    80004ba4:	f5040513          	add	a0,s0,-176
    80004ba8:	00000097          	auipc	ra,0x0
    80004bac:	97a080e7          	jalr	-1670(ra) # 80004522 <create>
    80004bb0:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bb2:	c951                	beqz	a0,80004c46 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb4:	04449703          	lh	a4,68(s1)
    80004bb8:	478d                	li	a5,3
    80004bba:	00f71763          	bne	a4,a5,80004bc8 <sys_open+0x72>
    80004bbe:	0464d703          	lhu	a4,70(s1)
    80004bc2:	47a5                	li	a5,9
    80004bc4:	0ce7ec63          	bltu	a5,a4,80004c9c <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	de0080e7          	jalr	-544(ra) # 800039a8 <filealloc>
    80004bd0:	892a                	mv	s2,a0
    80004bd2:	c56d                	beqz	a0,80004cbc <sys_open+0x166>
    80004bd4:	00000097          	auipc	ra,0x0
    80004bd8:	90c080e7          	jalr	-1780(ra) # 800044e0 <fdalloc>
    80004bdc:	89aa                	mv	s3,a0
    80004bde:	0c054a63          	bltz	a0,80004cb2 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be2:	04449703          	lh	a4,68(s1)
    80004be6:	478d                	li	a5,3
    80004be8:	0ef70563          	beq	a4,a5,80004cd2 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bec:	4789                	li	a5,2
    80004bee:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004bf2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004bf6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004bfa:	f4c42783          	lw	a5,-180(s0)
    80004bfe:	0017c713          	xor	a4,a5,1
    80004c02:	8b05                	and	a4,a4,1
    80004c04:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c08:	0037f713          	and	a4,a5,3
    80004c0c:	00e03733          	snez	a4,a4
    80004c10:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c14:	4007f793          	and	a5,a5,1024
    80004c18:	c791                	beqz	a5,80004c24 <sys_open+0xce>
    80004c1a:	04449703          	lh	a4,68(s1)
    80004c1e:	4789                	li	a5,2
    80004c20:	0cf70063          	beq	a4,a5,80004ce0 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	096080e7          	jalr	150(ra) # 80002cbc <iunlock>
  end_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	9ec080e7          	jalr	-1556(ra) # 8000361a <end_op>

  return fd;
    80004c36:	854e                	mv	a0,s3
}
    80004c38:	70ea                	ld	ra,184(sp)
    80004c3a:	744a                	ld	s0,176(sp)
    80004c3c:	74aa                	ld	s1,168(sp)
    80004c3e:	790a                	ld	s2,160(sp)
    80004c40:	69ea                	ld	s3,152(sp)
    80004c42:	6129                	add	sp,sp,192
    80004c44:	8082                	ret
      end_op();
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	9d4080e7          	jalr	-1580(ra) # 8000361a <end_op>
      return -1;
    80004c4e:	557d                	li	a0,-1
    80004c50:	b7e5                	j	80004c38 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c52:	f5040513          	add	a0,s0,-176
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	74a080e7          	jalr	1866(ra) # 800033a0 <namei>
    80004c5e:	84aa                	mv	s1,a0
    80004c60:	c905                	beqz	a0,80004c90 <sys_open+0x13a>
    ilock(ip);
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	f98080e7          	jalr	-104(ra) # 80002bfa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c6a:	04449703          	lh	a4,68(s1)
    80004c6e:	4785                	li	a5,1
    80004c70:	f4f712e3          	bne	a4,a5,80004bb4 <sys_open+0x5e>
    80004c74:	f4c42783          	lw	a5,-180(s0)
    80004c78:	dba1                	beqz	a5,80004bc8 <sys_open+0x72>
      iunlockput(ip);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	1e0080e7          	jalr	480(ra) # 80002e5c <iunlockput>
      end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	996080e7          	jalr	-1642(ra) # 8000361a <end_op>
      return -1;
    80004c8c:	557d                	li	a0,-1
    80004c8e:	b76d                	j	80004c38 <sys_open+0xe2>
      end_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	98a080e7          	jalr	-1654(ra) # 8000361a <end_op>
      return -1;
    80004c98:	557d                	li	a0,-1
    80004c9a:	bf79                	j	80004c38 <sys_open+0xe2>
    iunlockput(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	1be080e7          	jalr	446(ra) # 80002e5c <iunlockput>
    end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	974080e7          	jalr	-1676(ra) # 8000361a <end_op>
    return -1;
    80004cae:	557d                	li	a0,-1
    80004cb0:	b761                	j	80004c38 <sys_open+0xe2>
      fileclose(f);
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	db0080e7          	jalr	-592(ra) # 80003a64 <fileclose>
    iunlockput(ip);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	19e080e7          	jalr	414(ra) # 80002e5c <iunlockput>
    end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	954080e7          	jalr	-1708(ra) # 8000361a <end_op>
    return -1;
    80004cce:	557d                	li	a0,-1
    80004cd0:	b7a5                	j	80004c38 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004cd2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004cd6:	04649783          	lh	a5,70(s1)
    80004cda:	02f91223          	sh	a5,36(s2)
    80004cde:	bf21                	j	80004bf6 <sys_open+0xa0>
    itrunc(ip);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	026080e7          	jalr	38(ra) # 80002d08 <itrunc>
    80004cea:	bf2d                	j	80004c24 <sys_open+0xce>

0000000080004cec <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cec:	7175                	add	sp,sp,-144
    80004cee:	e506                	sd	ra,136(sp)
    80004cf0:	e122                	sd	s0,128(sp)
    80004cf2:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	8ac080e7          	jalr	-1876(ra) # 800035a0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cfc:	08000613          	li	a2,128
    80004d00:	f7040593          	add	a1,s0,-144
    80004d04:	4501                	li	a0,0
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	32c080e7          	jalr	812(ra) # 80002032 <argstr>
    80004d0e:	02054963          	bltz	a0,80004d40 <sys_mkdir+0x54>
    80004d12:	4681                	li	a3,0
    80004d14:	4601                	li	a2,0
    80004d16:	4585                	li	a1,1
    80004d18:	f7040513          	add	a0,s0,-144
    80004d1c:	00000097          	auipc	ra,0x0
    80004d20:	806080e7          	jalr	-2042(ra) # 80004522 <create>
    80004d24:	cd11                	beqz	a0,80004d40 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	136080e7          	jalr	310(ra) # 80002e5c <iunlockput>
  end_op();
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	8ec080e7          	jalr	-1812(ra) # 8000361a <end_op>
  return 0;
    80004d36:	4501                	li	a0,0
}
    80004d38:	60aa                	ld	ra,136(sp)
    80004d3a:	640a                	ld	s0,128(sp)
    80004d3c:	6149                	add	sp,sp,144
    80004d3e:	8082                	ret
    end_op();
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	8da080e7          	jalr	-1830(ra) # 8000361a <end_op>
    return -1;
    80004d48:	557d                	li	a0,-1
    80004d4a:	b7fd                	j	80004d38 <sys_mkdir+0x4c>

0000000080004d4c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d4c:	7135                	add	sp,sp,-160
    80004d4e:	ed06                	sd	ra,152(sp)
    80004d50:	e922                	sd	s0,144(sp)
    80004d52:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	84c080e7          	jalr	-1972(ra) # 800035a0 <begin_op>
  argint(1, &major);
    80004d5c:	f6c40593          	add	a1,s0,-148
    80004d60:	4505                	li	a0,1
    80004d62:	ffffd097          	auipc	ra,0xffffd
    80004d66:	290080e7          	jalr	656(ra) # 80001ff2 <argint>
  argint(2, &minor);
    80004d6a:	f6840593          	add	a1,s0,-152
    80004d6e:	4509                	li	a0,2
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	282080e7          	jalr	642(ra) # 80001ff2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d78:	08000613          	li	a2,128
    80004d7c:	f7040593          	add	a1,s0,-144
    80004d80:	4501                	li	a0,0
    80004d82:	ffffd097          	auipc	ra,0xffffd
    80004d86:	2b0080e7          	jalr	688(ra) # 80002032 <argstr>
    80004d8a:	02054b63          	bltz	a0,80004dc0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d8e:	f6841683          	lh	a3,-152(s0)
    80004d92:	f6c41603          	lh	a2,-148(s0)
    80004d96:	458d                	li	a1,3
    80004d98:	f7040513          	add	a0,s0,-144
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	786080e7          	jalr	1926(ra) # 80004522 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004da4:	cd11                	beqz	a0,80004dc0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	0b6080e7          	jalr	182(ra) # 80002e5c <iunlockput>
  end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	86c080e7          	jalr	-1940(ra) # 8000361a <end_op>
  return 0;
    80004db6:	4501                	li	a0,0
}
    80004db8:	60ea                	ld	ra,152(sp)
    80004dba:	644a                	ld	s0,144(sp)
    80004dbc:	610d                	add	sp,sp,160
    80004dbe:	8082                	ret
    end_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	85a080e7          	jalr	-1958(ra) # 8000361a <end_op>
    return -1;
    80004dc8:	557d                	li	a0,-1
    80004dca:	b7fd                	j	80004db8 <sys_mknod+0x6c>

0000000080004dcc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dcc:	7135                	add	sp,sp,-160
    80004dce:	ed06                	sd	ra,152(sp)
    80004dd0:	e922                	sd	s0,144(sp)
    80004dd2:	e526                	sd	s1,136(sp)
    80004dd4:	e14a                	sd	s2,128(sp)
    80004dd6:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dd8:	ffffc097          	auipc	ra,0xffffc
    80004ddc:	0d2080e7          	jalr	210(ra) # 80000eaa <myproc>
    80004de0:	892a                	mv	s2,a0
  
  begin_op();
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	7be080e7          	jalr	1982(ra) # 800035a0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dea:	08000613          	li	a2,128
    80004dee:	f6040593          	add	a1,s0,-160
    80004df2:	4501                	li	a0,0
    80004df4:	ffffd097          	auipc	ra,0xffffd
    80004df8:	23e080e7          	jalr	574(ra) # 80002032 <argstr>
    80004dfc:	04054b63          	bltz	a0,80004e52 <sys_chdir+0x86>
    80004e00:	f6040513          	add	a0,s0,-160
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	59c080e7          	jalr	1436(ra) # 800033a0 <namei>
    80004e0c:	84aa                	mv	s1,a0
    80004e0e:	c131                	beqz	a0,80004e52 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	dea080e7          	jalr	-534(ra) # 80002bfa <ilock>
  if(ip->type != T_DIR){
    80004e18:	04449703          	lh	a4,68(s1)
    80004e1c:	4785                	li	a5,1
    80004e1e:	04f71063          	bne	a4,a5,80004e5e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e22:	8526                	mv	a0,s1
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	e98080e7          	jalr	-360(ra) # 80002cbc <iunlock>
  iput(p->cwd);
    80004e2c:	15093503          	ld	a0,336(s2)
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	f84080e7          	jalr	-124(ra) # 80002db4 <iput>
  end_op();
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	7e2080e7          	jalr	2018(ra) # 8000361a <end_op>
  p->cwd = ip;
    80004e40:	14993823          	sd	s1,336(s2)
  return 0;
    80004e44:	4501                	li	a0,0
}
    80004e46:	60ea                	ld	ra,152(sp)
    80004e48:	644a                	ld	s0,144(sp)
    80004e4a:	64aa                	ld	s1,136(sp)
    80004e4c:	690a                	ld	s2,128(sp)
    80004e4e:	610d                	add	sp,sp,160
    80004e50:	8082                	ret
    end_op();
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	7c8080e7          	jalr	1992(ra) # 8000361a <end_op>
    return -1;
    80004e5a:	557d                	li	a0,-1
    80004e5c:	b7ed                	j	80004e46 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e5e:	8526                	mv	a0,s1
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	ffc080e7          	jalr	-4(ra) # 80002e5c <iunlockput>
    end_op();
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	7b2080e7          	jalr	1970(ra) # 8000361a <end_op>
    return -1;
    80004e70:	557d                	li	a0,-1
    80004e72:	bfd1                	j	80004e46 <sys_chdir+0x7a>

0000000080004e74 <sys_exec>:

uint64
sys_exec(void)
{
    80004e74:	7121                	add	sp,sp,-448
    80004e76:	ff06                	sd	ra,440(sp)
    80004e78:	fb22                	sd	s0,432(sp)
    80004e7a:	f726                	sd	s1,424(sp)
    80004e7c:	f34a                	sd	s2,416(sp)
    80004e7e:	ef4e                	sd	s3,408(sp)
    80004e80:	eb52                	sd	s4,400(sp)
    80004e82:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e84:	e4840593          	add	a1,s0,-440
    80004e88:	4505                	li	a0,1
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	188080e7          	jalr	392(ra) # 80002012 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e92:	08000613          	li	a2,128
    80004e96:	f5040593          	add	a1,s0,-176
    80004e9a:	4501                	li	a0,0
    80004e9c:	ffffd097          	auipc	ra,0xffffd
    80004ea0:	196080e7          	jalr	406(ra) # 80002032 <argstr>
    80004ea4:	87aa                	mv	a5,a0
    return -1;
    80004ea6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ea8:	0c07c263          	bltz	a5,80004f6c <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004eac:	10000613          	li	a2,256
    80004eb0:	4581                	li	a1,0
    80004eb2:	e5040513          	add	a0,s0,-432
    80004eb6:	ffffb097          	auipc	ra,0xffffb
    80004eba:	2c4080e7          	jalr	708(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ebe:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004ec2:	89a6                	mv	s3,s1
    80004ec4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ec6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eca:	00391513          	sll	a0,s2,0x3
    80004ece:	e4040593          	add	a1,s0,-448
    80004ed2:	e4843783          	ld	a5,-440(s0)
    80004ed6:	953e                	add	a0,a0,a5
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	07c080e7          	jalr	124(ra) # 80001f54 <fetchaddr>
    80004ee0:	02054a63          	bltz	a0,80004f14 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004ee4:	e4043783          	ld	a5,-448(s0)
    80004ee8:	c3b9                	beqz	a5,80004f2e <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eea:	ffffb097          	auipc	ra,0xffffb
    80004eee:	230080e7          	jalr	560(ra) # 8000011a <kalloc>
    80004ef2:	85aa                	mv	a1,a0
    80004ef4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef8:	cd11                	beqz	a0,80004f14 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004efa:	6605                	lui	a2,0x1
    80004efc:	e4043503          	ld	a0,-448(s0)
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	0a6080e7          	jalr	166(ra) # 80001fa6 <fetchstr>
    80004f08:	00054663          	bltz	a0,80004f14 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f0c:	0905                	add	s2,s2,1
    80004f0e:	09a1                	add	s3,s3,8
    80004f10:	fb491de3          	bne	s2,s4,80004eca <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f14:	f5040913          	add	s2,s0,-176
    80004f18:	6088                	ld	a0,0(s1)
    80004f1a:	c921                	beqz	a0,80004f6a <sys_exec+0xf6>
    kfree(argv[i]);
    80004f1c:	ffffb097          	auipc	ra,0xffffb
    80004f20:	100080e7          	jalr	256(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f24:	04a1                	add	s1,s1,8
    80004f26:	ff2499e3          	bne	s1,s2,80004f18 <sys_exec+0xa4>
  return -1;
    80004f2a:	557d                	li	a0,-1
    80004f2c:	a081                	j	80004f6c <sys_exec+0xf8>
      argv[i] = 0;
    80004f2e:	0009079b          	sext.w	a5,s2
    80004f32:	078e                	sll	a5,a5,0x3
    80004f34:	fd078793          	add	a5,a5,-48
    80004f38:	97a2                	add	a5,a5,s0
    80004f3a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f3e:	e5040593          	add	a1,s0,-432
    80004f42:	f5040513          	add	a0,s0,-176
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	194080e7          	jalr	404(ra) # 800040da <exec>
    80004f4e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f50:	f5040993          	add	s3,s0,-176
    80004f54:	6088                	ld	a0,0(s1)
    80004f56:	c901                	beqz	a0,80004f66 <sys_exec+0xf2>
    kfree(argv[i]);
    80004f58:	ffffb097          	auipc	ra,0xffffb
    80004f5c:	0c4080e7          	jalr	196(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f60:	04a1                	add	s1,s1,8
    80004f62:	ff3499e3          	bne	s1,s3,80004f54 <sys_exec+0xe0>
  return ret;
    80004f66:	854a                	mv	a0,s2
    80004f68:	a011                	j	80004f6c <sys_exec+0xf8>
  return -1;
    80004f6a:	557d                	li	a0,-1
}
    80004f6c:	70fa                	ld	ra,440(sp)
    80004f6e:	745a                	ld	s0,432(sp)
    80004f70:	74ba                	ld	s1,424(sp)
    80004f72:	791a                	ld	s2,416(sp)
    80004f74:	69fa                	ld	s3,408(sp)
    80004f76:	6a5a                	ld	s4,400(sp)
    80004f78:	6139                	add	sp,sp,448
    80004f7a:	8082                	ret

0000000080004f7c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f7c:	7139                	add	sp,sp,-64
    80004f7e:	fc06                	sd	ra,56(sp)
    80004f80:	f822                	sd	s0,48(sp)
    80004f82:	f426                	sd	s1,40(sp)
    80004f84:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	f24080e7          	jalr	-220(ra) # 80000eaa <myproc>
    80004f8e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f90:	fd840593          	add	a1,s0,-40
    80004f94:	4501                	li	a0,0
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	07c080e7          	jalr	124(ra) # 80002012 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f9e:	fc840593          	add	a1,s0,-56
    80004fa2:	fd040513          	add	a0,s0,-48
    80004fa6:	fffff097          	auipc	ra,0xfffff
    80004faa:	dea080e7          	jalr	-534(ra) # 80003d90 <pipealloc>
    return -1;
    80004fae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fb0:	0c054463          	bltz	a0,80005078 <sys_pipe+0xfc>
  fd0 = -1;
    80004fb4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fb8:	fd043503          	ld	a0,-48(s0)
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	524080e7          	jalr	1316(ra) # 800044e0 <fdalloc>
    80004fc4:	fca42223          	sw	a0,-60(s0)
    80004fc8:	08054b63          	bltz	a0,8000505e <sys_pipe+0xe2>
    80004fcc:	fc843503          	ld	a0,-56(s0)
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	510080e7          	jalr	1296(ra) # 800044e0 <fdalloc>
    80004fd8:	fca42023          	sw	a0,-64(s0)
    80004fdc:	06054863          	bltz	a0,8000504c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe0:	4691                	li	a3,4
    80004fe2:	fc440613          	add	a2,s0,-60
    80004fe6:	fd843583          	ld	a1,-40(s0)
    80004fea:	68a8                	ld	a0,80(s1)
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	b4a080e7          	jalr	-1206(ra) # 80000b36 <copyout>
    80004ff4:	02054063          	bltz	a0,80005014 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ff8:	4691                	li	a3,4
    80004ffa:	fc040613          	add	a2,s0,-64
    80004ffe:	fd843583          	ld	a1,-40(s0)
    80005002:	0591                	add	a1,a1,4
    80005004:	68a8                	ld	a0,80(s1)
    80005006:	ffffc097          	auipc	ra,0xffffc
    8000500a:	b30080e7          	jalr	-1232(ra) # 80000b36 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000500e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005010:	06055463          	bgez	a0,80005078 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005014:	fc442783          	lw	a5,-60(s0)
    80005018:	07e9                	add	a5,a5,26
    8000501a:	078e                	sll	a5,a5,0x3
    8000501c:	97a6                	add	a5,a5,s1
    8000501e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005022:	fc042783          	lw	a5,-64(s0)
    80005026:	07e9                	add	a5,a5,26
    80005028:	078e                	sll	a5,a5,0x3
    8000502a:	94be                	add	s1,s1,a5
    8000502c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005030:	fd043503          	ld	a0,-48(s0)
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	a30080e7          	jalr	-1488(ra) # 80003a64 <fileclose>
    fileclose(wf);
    8000503c:	fc843503          	ld	a0,-56(s0)
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	a24080e7          	jalr	-1500(ra) # 80003a64 <fileclose>
    return -1;
    80005048:	57fd                	li	a5,-1
    8000504a:	a03d                	j	80005078 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000504c:	fc442783          	lw	a5,-60(s0)
    80005050:	0007c763          	bltz	a5,8000505e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005054:	07e9                	add	a5,a5,26
    80005056:	078e                	sll	a5,a5,0x3
    80005058:	97a6                	add	a5,a5,s1
    8000505a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000505e:	fd043503          	ld	a0,-48(s0)
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	a02080e7          	jalr	-1534(ra) # 80003a64 <fileclose>
    fileclose(wf);
    8000506a:	fc843503          	ld	a0,-56(s0)
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	9f6080e7          	jalr	-1546(ra) # 80003a64 <fileclose>
    return -1;
    80005076:	57fd                	li	a5,-1
}
    80005078:	853e                	mv	a0,a5
    8000507a:	70e2                	ld	ra,56(sp)
    8000507c:	7442                	ld	s0,48(sp)
    8000507e:	74a2                	ld	s1,40(sp)
    80005080:	6121                	add	sp,sp,64
    80005082:	8082                	ret
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	add	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	d51fc0ef          	jal	80001e20 <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	add	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    8000514a:	1141                	add	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
}
    8000515a:	6422                	ld	s0,8(sp)
    8000515c:	0141                	add	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plicinithart>:

void
plicinithart(void)
{
    80005160:	1141                	add	sp,sp,-16
    80005162:	e406                	sd	ra,8(sp)
    80005164:	e022                	sd	s0,0(sp)
    80005166:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	d16080e7          	jalr	-746(ra) # 80000e7e <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	sllw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	sllw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	97aa                	add	a5,a5,a0
    8000518c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	add	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005198:	1141                	add	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	add	s0,sp,16
  int hart = cpuid();
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	cde080e7          	jalr	-802(ra) # 80000e7e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a8:	00d5151b          	sllw	a0,a0,0xd
    800051ac:	0c2017b7          	lui	a5,0xc201
    800051b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051b2:	43c8                	lw	a0,4(a5)
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	add	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    800051bc:	1101                	add	sp,sp,-32
    800051be:	ec06                	sd	ra,24(sp)
    800051c0:	e822                	sd	s0,16(sp)
    800051c2:	e426                	sd	s1,8(sp)
    800051c4:	1000                	add	s0,sp,32
    800051c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	cb6080e7          	jalr	-842(ra) # 80000e7e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d0:	00d5151b          	sllw	a0,a0,0xd
    800051d4:	0c2017b7          	lui	a5,0xc201
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	c3c4                	sw	s1,4(a5)
}
    800051dc:	60e2                	ld	ra,24(sp)
    800051de:	6442                	ld	s0,16(sp)
    800051e0:	64a2                	ld	s1,8(sp)
    800051e2:	6105                	add	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    800051e6:	1141                	add	sp,sp,-16
    800051e8:	e406                	sd	ra,8(sp)
    800051ea:	e022                	sd	s0,0(sp)
    800051ec:	0800                	add	s0,sp,16
  if(i >= NUM)
    800051ee:	479d                	li	a5,7
    800051f0:	04a7cc63          	blt	a5,a0,80005248 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051f4:	00015797          	auipc	a5,0x15
    800051f8:	b6c78793          	add	a5,a5,-1172 # 80019d60 <disk>
    800051fc:	97aa                	add	a5,a5,a0
    800051fe:	0187c783          	lbu	a5,24(a5)
    80005202:	ebb9                	bnez	a5,80005258 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005204:	00451693          	sll	a3,a0,0x4
    80005208:	00015797          	auipc	a5,0x15
    8000520c:	b5878793          	add	a5,a5,-1192 # 80019d60 <disk>
    80005210:	6398                	ld	a4,0(a5)
    80005212:	9736                	add	a4,a4,a3
    80005214:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005218:	6398                	ld	a4,0(a5)
    8000521a:	9736                	add	a4,a4,a3
    8000521c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005220:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005224:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005228:	97aa                	add	a5,a5,a0
    8000522a:	4705                	li	a4,1
    8000522c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005230:	00015517          	auipc	a0,0x15
    80005234:	b4850513          	add	a0,a0,-1208 # 80019d78 <disk+0x18>
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	38a080e7          	jalr	906(ra) # 800015c2 <wakeup>
}
    80005240:	60a2                	ld	ra,8(sp)
    80005242:	6402                	ld	s0,0(sp)
    80005244:	0141                	add	sp,sp,16
    80005246:	8082                	ret
    panic("free_desc 1");
    80005248:	00003517          	auipc	a0,0x3
    8000524c:	57850513          	add	a0,a0,1400 # 800087c0 <syscalls+0x2f0>
    80005250:	00001097          	auipc	ra,0x1
    80005254:	a06080e7          	jalr	-1530(ra) # 80005c56 <panic>
    panic("free_desc 2");
    80005258:	00003517          	auipc	a0,0x3
    8000525c:	57850513          	add	a0,a0,1400 # 800087d0 <syscalls+0x300>
    80005260:	00001097          	auipc	ra,0x1
    80005264:	9f6080e7          	jalr	-1546(ra) # 80005c56 <panic>

0000000080005268 <virtio_disk_init>:
{
    80005268:	1101                	add	sp,sp,-32
    8000526a:	ec06                	sd	ra,24(sp)
    8000526c:	e822                	sd	s0,16(sp)
    8000526e:	e426                	sd	s1,8(sp)
    80005270:	e04a                	sd	s2,0(sp)
    80005272:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005274:	00003597          	auipc	a1,0x3
    80005278:	56c58593          	add	a1,a1,1388 # 800087e0 <syscalls+0x310>
    8000527c:	00015517          	auipc	a0,0x15
    80005280:	c0c50513          	add	a0,a0,-1012 # 80019e88 <disk+0x128>
    80005284:	00001097          	auipc	ra,0x1
    80005288:	e7a080e7          	jalr	-390(ra) # 800060fe <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000528c:	100017b7          	lui	a5,0x10001
    80005290:	4398                	lw	a4,0(a5)
    80005292:	2701                	sext.w	a4,a4
    80005294:	747277b7          	lui	a5,0x74727
    80005298:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000529c:	14f71b63          	bne	a4,a5,800053f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052a0:	100017b7          	lui	a5,0x10001
    800052a4:	43dc                	lw	a5,4(a5)
    800052a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a8:	4709                	li	a4,2
    800052aa:	14e79463          	bne	a5,a4,800053f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ae:	100017b7          	lui	a5,0x10001
    800052b2:	479c                	lw	a5,8(a5)
    800052b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052b6:	12e79e63          	bne	a5,a4,800053f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ba:	100017b7          	lui	a5,0x10001
    800052be:	47d8                	lw	a4,12(a5)
    800052c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c2:	554d47b7          	lui	a5,0x554d4
    800052c6:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052ca:	12f71463          	bne	a4,a5,800053f2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ce:	100017b7          	lui	a5,0x10001
    800052d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d6:	4705                	li	a4,1
    800052d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052da:	470d                	li	a4,3
    800052dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052de:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800052e4:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc67f>
    800052e8:	8f75                	and	a4,a4,a3
    800052ea:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ec:	472d                	li	a4,11
    800052ee:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052f0:	5bbc                	lw	a5,112(a5)
    800052f2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052f6:	8ba1                	and	a5,a5,8
    800052f8:	10078563          	beqz	a5,80005402 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052fc:	100017b7          	lui	a5,0x10001
    80005300:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005304:	43fc                	lw	a5,68(a5)
    80005306:	2781                	sext.w	a5,a5
    80005308:	10079563          	bnez	a5,80005412 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000530c:	100017b7          	lui	a5,0x10001
    80005310:	5bdc                	lw	a5,52(a5)
    80005312:	2781                	sext.w	a5,a5
  if(max == 0)
    80005314:	10078763          	beqz	a5,80005422 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005318:	471d                	li	a4,7
    8000531a:	10f77c63          	bgeu	a4,a5,80005432 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000531e:	ffffb097          	auipc	ra,0xffffb
    80005322:	dfc080e7          	jalr	-516(ra) # 8000011a <kalloc>
    80005326:	00015497          	auipc	s1,0x15
    8000532a:	a3a48493          	add	s1,s1,-1478 # 80019d60 <disk>
    8000532e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005330:	ffffb097          	auipc	ra,0xffffb
    80005334:	dea080e7          	jalr	-534(ra) # 8000011a <kalloc>
    80005338:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000533a:	ffffb097          	auipc	ra,0xffffb
    8000533e:	de0080e7          	jalr	-544(ra) # 8000011a <kalloc>
    80005342:	87aa                	mv	a5,a0
    80005344:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005346:	6088                	ld	a0,0(s1)
    80005348:	cd6d                	beqz	a0,80005442 <virtio_disk_init+0x1da>
    8000534a:	00015717          	auipc	a4,0x15
    8000534e:	a1e73703          	ld	a4,-1506(a4) # 80019d68 <disk+0x8>
    80005352:	cb65                	beqz	a4,80005442 <virtio_disk_init+0x1da>
    80005354:	c7fd                	beqz	a5,80005442 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005356:	6605                	lui	a2,0x1
    80005358:	4581                	li	a1,0
    8000535a:	ffffb097          	auipc	ra,0xffffb
    8000535e:	e20080e7          	jalr	-480(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005362:	00015497          	auipc	s1,0x15
    80005366:	9fe48493          	add	s1,s1,-1538 # 80019d60 <disk>
    8000536a:	6605                	lui	a2,0x1
    8000536c:	4581                	li	a1,0
    8000536e:	6488                	ld	a0,8(s1)
    80005370:	ffffb097          	auipc	ra,0xffffb
    80005374:	e0a080e7          	jalr	-502(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005378:	6605                	lui	a2,0x1
    8000537a:	4581                	li	a1,0
    8000537c:	6888                	ld	a0,16(s1)
    8000537e:	ffffb097          	auipc	ra,0xffffb
    80005382:	dfc080e7          	jalr	-516(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005386:	100017b7          	lui	a5,0x10001
    8000538a:	4721                	li	a4,8
    8000538c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000538e:	4098                	lw	a4,0(s1)
    80005390:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005394:	40d8                	lw	a4,4(s1)
    80005396:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000539a:	6498                	ld	a4,8(s1)
    8000539c:	0007069b          	sext.w	a3,a4
    800053a0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053a4:	9701                	sra	a4,a4,0x20
    800053a6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053aa:	6898                	ld	a4,16(s1)
    800053ac:	0007069b          	sext.w	a3,a4
    800053b0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053b4:	9701                	sra	a4,a4,0x20
    800053b6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ba:	4705                	li	a4,1
    800053bc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053be:	00e48c23          	sb	a4,24(s1)
    800053c2:	00e48ca3          	sb	a4,25(s1)
    800053c6:	00e48d23          	sb	a4,26(s1)
    800053ca:	00e48da3          	sb	a4,27(s1)
    800053ce:	00e48e23          	sb	a4,28(s1)
    800053d2:	00e48ea3          	sb	a4,29(s1)
    800053d6:	00e48f23          	sb	a4,30(s1)
    800053da:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053de:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e2:	0727a823          	sw	s2,112(a5)
}
    800053e6:	60e2                	ld	ra,24(sp)
    800053e8:	6442                	ld	s0,16(sp)
    800053ea:	64a2                	ld	s1,8(sp)
    800053ec:	6902                	ld	s2,0(sp)
    800053ee:	6105                	add	sp,sp,32
    800053f0:	8082                	ret
    panic("could not find virtio disk");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	3fe50513          	add	a0,a0,1022 # 800087f0 <syscalls+0x320>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	85c080e7          	jalr	-1956(ra) # 80005c56 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	40e50513          	add	a0,a0,1038 # 80008810 <syscalls+0x340>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	84c080e7          	jalr	-1972(ra) # 80005c56 <panic>
    panic("virtio disk should not be ready");
    80005412:	00003517          	auipc	a0,0x3
    80005416:	41e50513          	add	a0,a0,1054 # 80008830 <syscalls+0x360>
    8000541a:	00001097          	auipc	ra,0x1
    8000541e:	83c080e7          	jalr	-1988(ra) # 80005c56 <panic>
    panic("virtio disk has no queue 0");
    80005422:	00003517          	auipc	a0,0x3
    80005426:	42e50513          	add	a0,a0,1070 # 80008850 <syscalls+0x380>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	82c080e7          	jalr	-2004(ra) # 80005c56 <panic>
    panic("virtio disk max queue too short");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	43e50513          	add	a0,a0,1086 # 80008870 <syscalls+0x3a0>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	81c080e7          	jalr	-2020(ra) # 80005c56 <panic>
    panic("virtio disk kalloc");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	44e50513          	add	a0,a0,1102 # 80008890 <syscalls+0x3c0>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	80c080e7          	jalr	-2036(ra) # 80005c56 <panic>

0000000080005452 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005452:	7159                	add	sp,sp,-112
    80005454:	f486                	sd	ra,104(sp)
    80005456:	f0a2                	sd	s0,96(sp)
    80005458:	eca6                	sd	s1,88(sp)
    8000545a:	e8ca                	sd	s2,80(sp)
    8000545c:	e4ce                	sd	s3,72(sp)
    8000545e:	e0d2                	sd	s4,64(sp)
    80005460:	fc56                	sd	s5,56(sp)
    80005462:	f85a                	sd	s6,48(sp)
    80005464:	f45e                	sd	s7,40(sp)
    80005466:	f062                	sd	s8,32(sp)
    80005468:	ec66                	sd	s9,24(sp)
    8000546a:	e86a                	sd	s10,16(sp)
    8000546c:	1880                	add	s0,sp,112
    8000546e:	8a2a                	mv	s4,a0
    80005470:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005472:	00c52c83          	lw	s9,12(a0)
    80005476:	001c9c9b          	sllw	s9,s9,0x1
    8000547a:	1c82                	sll	s9,s9,0x20
    8000547c:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005480:	00015517          	auipc	a0,0x15
    80005484:	a0850513          	add	a0,a0,-1528 # 80019e88 <disk+0x128>
    80005488:	00001097          	auipc	ra,0x1
    8000548c:	d06080e7          	jalr	-762(ra) # 8000618e <acquire>
  for(int i = 0; i < 3; i++){
    80005490:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005492:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005494:	00015b17          	auipc	s6,0x15
    80005498:	8ccb0b13          	add	s6,s6,-1844 # 80019d60 <disk>
  for(int i = 0; i < 3; i++){
    8000549c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000549e:	00015c17          	auipc	s8,0x15
    800054a2:	9eac0c13          	add	s8,s8,-1558 # 80019e88 <disk+0x128>
    800054a6:	a095                	j	8000550a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054a8:	00fb0733          	add	a4,s6,a5
    800054ac:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054b0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054b2:	0207c563          	bltz	a5,800054dc <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800054b6:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054b8:	0591                	add	a1,a1,4
    800054ba:	05560d63          	beq	a2,s5,80005514 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054be:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800054c0:	00015717          	auipc	a4,0x15
    800054c4:	8a070713          	add	a4,a4,-1888 # 80019d60 <disk>
    800054c8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800054ca:	01874683          	lbu	a3,24(a4)
    800054ce:	fee9                	bnez	a3,800054a8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800054d0:	2785                	addw	a5,a5,1
    800054d2:	0705                	add	a4,a4,1
    800054d4:	fe979be3          	bne	a5,s1,800054ca <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800054d8:	57fd                	li	a5,-1
    800054da:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800054dc:	00c05e63          	blez	a2,800054f8 <virtio_disk_rw+0xa6>
    800054e0:	060a                	sll	a2,a2,0x2
    800054e2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800054e6:	0009a503          	lw	a0,0(s3)
    800054ea:	00000097          	auipc	ra,0x0
    800054ee:	cfc080e7          	jalr	-772(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    800054f2:	0991                	add	s3,s3,4
    800054f4:	ffa999e3          	bne	s3,s10,800054e6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054f8:	85e2                	mv	a1,s8
    800054fa:	00015517          	auipc	a0,0x15
    800054fe:	87e50513          	add	a0,a0,-1922 # 80019d78 <disk+0x18>
    80005502:	ffffc097          	auipc	ra,0xffffc
    80005506:	05c080e7          	jalr	92(ra) # 8000155e <sleep>
  for(int i = 0; i < 3; i++){
    8000550a:	f9040993          	add	s3,s0,-112
{
    8000550e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005510:	864a                	mv	a2,s2
    80005512:	b775                	j	800054be <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005514:	f9042503          	lw	a0,-112(s0)
    80005518:	00a50713          	add	a4,a0,10
    8000551c:	0712                	sll	a4,a4,0x4

  if(write)
    8000551e:	00015797          	auipc	a5,0x15
    80005522:	84278793          	add	a5,a5,-1982 # 80019d60 <disk>
    80005526:	00e786b3          	add	a3,a5,a4
    8000552a:	01703633          	snez	a2,s7
    8000552e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    80005530:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005534:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005538:	f6070613          	add	a2,a4,-160
    8000553c:	6394                	ld	a3,0(a5)
    8000553e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005540:	00870593          	add	a1,a4,8
    80005544:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005546:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005548:	0007b803          	ld	a6,0(a5)
    8000554c:	9642                	add	a2,a2,a6
    8000554e:	46c1                	li	a3,16
    80005550:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005552:	4585                	li	a1,1
    80005554:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005558:	f9442683          	lw	a3,-108(s0)
    8000555c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005560:	0692                	sll	a3,a3,0x4
    80005562:	9836                	add	a6,a6,a3
    80005564:	058a0613          	add	a2,s4,88
    80005568:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000556c:	0007b803          	ld	a6,0(a5)
    80005570:	96c2                	add	a3,a3,a6
    80005572:	40000613          	li	a2,1024
    80005576:	c690                	sw	a2,8(a3)
  if(write)
    80005578:	001bb613          	seqz	a2,s7
    8000557c:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005580:	00166613          	or	a2,a2,1
    80005584:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005588:	f9842603          	lw	a2,-104(s0)
    8000558c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    80005590:	00250693          	add	a3,a0,2
    80005594:	0692                	sll	a3,a3,0x4
    80005596:	96be                	add	a3,a3,a5
    80005598:	58fd                	li	a7,-1
    8000559a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000559e:	0612                	sll	a2,a2,0x4
    800055a0:	9832                	add	a6,a6,a2
    800055a2:	f9070713          	add	a4,a4,-112
    800055a6:	973e                	add	a4,a4,a5
    800055a8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055ac:	6398                	ld	a4,0(a5)
    800055ae:	9732                	add	a4,a4,a2
    800055b0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    800055b2:	4609                	li	a2,2
    800055b4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055b8:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    800055bc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800055c0:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055c4:	6794                	ld	a3,8(a5)
    800055c6:	0026d703          	lhu	a4,2(a3)
    800055ca:	8b1d                	and	a4,a4,7
    800055cc:	0706                	sll	a4,a4,0x1
    800055ce:	96ba                	add	a3,a3,a4
    800055d0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055d4:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    800055d8:	6798                	ld	a4,8(a5)
    800055da:	00275783          	lhu	a5,2(a4)
    800055de:	2785                	addw	a5,a5,1
    800055e0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055e4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    800055e8:	100017b7          	lui	a5,0x10001
    800055ec:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    800055f0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800055f4:	00015917          	auipc	s2,0x15
    800055f8:	89490913          	add	s2,s2,-1900 # 80019e88 <disk+0x128>
  while(b->disk == 1) {
    800055fc:	4485                	li	s1,1
    800055fe:	00b79c63          	bne	a5,a1,80005616 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005602:	85ca                	mv	a1,s2
    80005604:	8552                	mv	a0,s4
    80005606:	ffffc097          	auipc	ra,0xffffc
    8000560a:	f58080e7          	jalr	-168(ra) # 8000155e <sleep>
  while(b->disk == 1) {
    8000560e:	004a2783          	lw	a5,4(s4)
    80005612:	fe9788e3          	beq	a5,s1,80005602 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005616:	f9042903          	lw	s2,-112(s0)
    8000561a:	00290713          	add	a4,s2,2
    8000561e:	0712                	sll	a4,a4,0x4
    80005620:	00014797          	auipc	a5,0x14
    80005624:	74078793          	add	a5,a5,1856 # 80019d60 <disk>
    80005628:	97ba                	add	a5,a5,a4
    8000562a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000562e:	00014997          	auipc	s3,0x14
    80005632:	73298993          	add	s3,s3,1842 # 80019d60 <disk>
    80005636:	00491713          	sll	a4,s2,0x4
    8000563a:	0009b783          	ld	a5,0(s3)
    8000563e:	97ba                	add	a5,a5,a4
    80005640:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005644:	854a                	mv	a0,s2
    80005646:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000564a:	00000097          	auipc	ra,0x0
    8000564e:	b9c080e7          	jalr	-1124(ra) # 800051e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005652:	8885                	and	s1,s1,1
    80005654:	f0ed                	bnez	s1,80005636 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005656:	00015517          	auipc	a0,0x15
    8000565a:	83250513          	add	a0,a0,-1998 # 80019e88 <disk+0x128>
    8000565e:	00001097          	auipc	ra,0x1
    80005662:	be4080e7          	jalr	-1052(ra) # 80006242 <release>
}
    80005666:	70a6                	ld	ra,104(sp)
    80005668:	7406                	ld	s0,96(sp)
    8000566a:	64e6                	ld	s1,88(sp)
    8000566c:	6946                	ld	s2,80(sp)
    8000566e:	69a6                	ld	s3,72(sp)
    80005670:	6a06                	ld	s4,64(sp)
    80005672:	7ae2                	ld	s5,56(sp)
    80005674:	7b42                	ld	s6,48(sp)
    80005676:	7ba2                	ld	s7,40(sp)
    80005678:	7c02                	ld	s8,32(sp)
    8000567a:	6ce2                	ld	s9,24(sp)
    8000567c:	6d42                	ld	s10,16(sp)
    8000567e:	6165                	add	sp,sp,112
    80005680:	8082                	ret

0000000080005682 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005682:	1101                	add	sp,sp,-32
    80005684:	ec06                	sd	ra,24(sp)
    80005686:	e822                	sd	s0,16(sp)
    80005688:	e426                	sd	s1,8(sp)
    8000568a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000568c:	00014497          	auipc	s1,0x14
    80005690:	6d448493          	add	s1,s1,1748 # 80019d60 <disk>
    80005694:	00014517          	auipc	a0,0x14
    80005698:	7f450513          	add	a0,a0,2036 # 80019e88 <disk+0x128>
    8000569c:	00001097          	auipc	ra,0x1
    800056a0:	af2080e7          	jalr	-1294(ra) # 8000618e <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056a4:	10001737          	lui	a4,0x10001
    800056a8:	533c                	lw	a5,96(a4)
    800056aa:	8b8d                	and	a5,a5,3
    800056ac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056ae:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    800056b2:	689c                	ld	a5,16(s1)
    800056b4:	0204d703          	lhu	a4,32(s1)
    800056b8:	0027d783          	lhu	a5,2(a5)
    800056bc:	04f70863          	beq	a4,a5,8000570c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056c0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c4:	6898                	ld	a4,16(s1)
    800056c6:	0204d783          	lhu	a5,32(s1)
    800056ca:	8b9d                	and	a5,a5,7
    800056cc:	078e                	sll	a5,a5,0x3
    800056ce:	97ba                	add	a5,a5,a4
    800056d0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d2:	00278713          	add	a4,a5,2
    800056d6:	0712                	sll	a4,a4,0x4
    800056d8:	9726                	add	a4,a4,s1
    800056da:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056de:	e721                	bnez	a4,80005726 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e0:	0789                	add	a5,a5,2
    800056e2:	0792                	sll	a5,a5,0x4
    800056e4:	97a6                	add	a5,a5,s1
    800056e6:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    800056e8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	ed6080e7          	jalr	-298(ra) # 800015c2 <wakeup>

    disk.used_idx += 1;
    800056f4:	0204d783          	lhu	a5,32(s1)
    800056f8:	2785                	addw	a5,a5,1
    800056fa:	17c2                	sll	a5,a5,0x30
    800056fc:	93c1                	srl	a5,a5,0x30
    800056fe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005702:	6898                	ld	a4,16(s1)
    80005704:	00275703          	lhu	a4,2(a4)
    80005708:	faf71ce3          	bne	a4,a5,800056c0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000570c:	00014517          	auipc	a0,0x14
    80005710:	77c50513          	add	a0,a0,1916 # 80019e88 <disk+0x128>
    80005714:	00001097          	auipc	ra,0x1
    80005718:	b2e080e7          	jalr	-1234(ra) # 80006242 <release>
}
    8000571c:	60e2                	ld	ra,24(sp)
    8000571e:	6442                	ld	s0,16(sp)
    80005720:	64a2                	ld	s1,8(sp)
    80005722:	6105                	add	sp,sp,32
    80005724:	8082                	ret
      panic("virtio_disk_intr status");
    80005726:	00003517          	auipc	a0,0x3
    8000572a:	18250513          	add	a0,a0,386 # 800088a8 <syscalls+0x3d8>
    8000572e:	00000097          	auipc	ra,0x0
    80005732:	528080e7          	jalr	1320(ra) # 80005c56 <panic>

0000000080005736 <timerinit>:
/* at timervec in kernelvec.S, */
/* which turns them into software interrupts for */
/* devintr() in trap.c. */
void
timerinit()
{
    80005736:	1141                	add	sp,sp,-16
    80005738:	e422                	sd	s0,8(sp)
    8000573a:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000573c:	f14027f3          	csrr	a5,mhartid
  /* each CPU has a separate source of timer interrupts. */
  int id = r_mhartid();
    80005740:	0007859b          	sext.w	a1,a5

  /* ask the CLINT for a timer interrupt. */
  int interval = 1000000; /* cycles; about 1/10th second in qemu. */
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005744:	0037979b          	sllw	a5,a5,0x3
    80005748:	02004737          	lui	a4,0x2004
    8000574c:	97ba                	add	a5,a5,a4
    8000574e:	0200c737          	lui	a4,0x200c
    80005752:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005756:	000f4637          	lui	a2,0xf4
    8000575a:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000575e:	9732                	add	a4,a4,a2
    80005760:	e398                	sd	a4,0(a5)

  /* prepare information in scratch[] for timervec. */
  /* scratch[0..2] : space for timervec to save registers. */
  /* scratch[3] : address of CLINT MTIMECMP register. */
  /* scratch[4] : desired interval (in cycles) between timer interrupts. */
  uint64 *scratch = &timer_scratch[id][0];
    80005762:	00259693          	sll	a3,a1,0x2
    80005766:	96ae                	add	a3,a3,a1
    80005768:	068e                	sll	a3,a3,0x3
    8000576a:	00014717          	auipc	a4,0x14
    8000576e:	73670713          	add	a4,a4,1846 # 80019ea0 <timer_scratch>
    80005772:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005774:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005776:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005778:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000577c:	00000797          	auipc	a5,0x0
    80005780:	9a478793          	add	a5,a5,-1628 # 80005120 <timervec>
    80005784:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005788:	300027f3          	csrr	a5,mstatus

  /* set the machine-mode trap handler. */
  w_mtvec((uint64)timervec);

  /* enable machine-mode interrupts. */
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000578c:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005790:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005794:	304027f3          	csrr	a5,mie

  /* enable machine-mode timer interrupts. */
  w_mie(r_mie() | MIE_MTIE);
    80005798:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000579c:	30479073          	csrw	mie,a5
}
    800057a0:	6422                	ld	s0,8(sp)
    800057a2:	0141                	add	sp,sp,16
    800057a4:	8082                	ret

00000000800057a6 <start>:
{
    800057a6:	1141                	add	sp,sp,-16
    800057a8:	e406                	sd	ra,8(sp)
    800057aa:	e022                	sd	s0,0(sp)
    800057ac:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ae:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b2:	7779                	lui	a4,0xffffe
    800057b4:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc71f>
    800057b8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ba:	6705                	lui	a4,0x1
    800057bc:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057c6:	ffffb797          	auipc	a5,0xffffb
    800057ca:	b5878793          	add	a5,a5,-1192 # 8000031e <main>
    800057ce:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d2:	4781                	li	a5,0
    800057d4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057d8:	67c1                	lui	a5,0x10
    800057da:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057dc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057e4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057e8:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057ec:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f0:	57fd                	li	a5,-1
    800057f2:	83a9                	srl	a5,a5,0xa
    800057f4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057f8:	47bd                	li	a5,15
    800057fa:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	f38080e7          	jalr	-200(ra) # 80005736 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005806:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000580a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000580c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000580e:	30200073          	mret
}
    80005812:	60a2                	ld	ra,8(sp)
    80005814:	6402                	ld	s0,0(sp)
    80005816:	0141                	add	sp,sp,16
    80005818:	8082                	ret

000000008000581a <consolewrite>:
/* */
/* user write()s to the console go here. */
/* */
int
consolewrite(int user_src, uint64 src, int n)
{
    8000581a:	715d                	add	sp,sp,-80
    8000581c:	e486                	sd	ra,72(sp)
    8000581e:	e0a2                	sd	s0,64(sp)
    80005820:	fc26                	sd	s1,56(sp)
    80005822:	f84a                	sd	s2,48(sp)
    80005824:	f44e                	sd	s3,40(sp)
    80005826:	f052                	sd	s4,32(sp)
    80005828:	ec56                	sd	s5,24(sp)
    8000582a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000582c:	04c05763          	blez	a2,8000587a <consolewrite+0x60>
    80005830:	8a2a                	mv	s4,a0
    80005832:	84ae                	mv	s1,a1
    80005834:	89b2                	mv	s3,a2
    80005836:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005838:	5afd                	li	s5,-1
    8000583a:	4685                	li	a3,1
    8000583c:	8626                	mv	a2,s1
    8000583e:	85d2                	mv	a1,s4
    80005840:	fbf40513          	add	a0,s0,-65
    80005844:	ffffc097          	auipc	ra,0xffffc
    80005848:	178080e7          	jalr	376(ra) # 800019bc <either_copyin>
    8000584c:	01550d63          	beq	a0,s5,80005866 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005850:	fbf44503          	lbu	a0,-65(s0)
    80005854:	00000097          	auipc	ra,0x0
    80005858:	780080e7          	jalr	1920(ra) # 80005fd4 <uartputc>
  for(i = 0; i < n; i++){
    8000585c:	2905                	addw	s2,s2,1
    8000585e:	0485                	add	s1,s1,1
    80005860:	fd299de3          	bne	s3,s2,8000583a <consolewrite+0x20>
    80005864:	894e                	mv	s2,s3
  }

  return i;
}
    80005866:	854a                	mv	a0,s2
    80005868:	60a6                	ld	ra,72(sp)
    8000586a:	6406                	ld	s0,64(sp)
    8000586c:	74e2                	ld	s1,56(sp)
    8000586e:	7942                	ld	s2,48(sp)
    80005870:	79a2                	ld	s3,40(sp)
    80005872:	7a02                	ld	s4,32(sp)
    80005874:	6ae2                	ld	s5,24(sp)
    80005876:	6161                	add	sp,sp,80
    80005878:	8082                	ret
  for(i = 0; i < n; i++){
    8000587a:	4901                	li	s2,0
    8000587c:	b7ed                	j	80005866 <consolewrite+0x4c>

000000008000587e <consoleread>:
/* user_dist indicates whether dst is a user */
/* or kernel address. */
/* */
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000587e:	711d                	add	sp,sp,-96
    80005880:	ec86                	sd	ra,88(sp)
    80005882:	e8a2                	sd	s0,80(sp)
    80005884:	e4a6                	sd	s1,72(sp)
    80005886:	e0ca                	sd	s2,64(sp)
    80005888:	fc4e                	sd	s3,56(sp)
    8000588a:	f852                	sd	s4,48(sp)
    8000588c:	f456                	sd	s5,40(sp)
    8000588e:	f05a                	sd	s6,32(sp)
    80005890:	ec5e                	sd	s7,24(sp)
    80005892:	1080                	add	s0,sp,96
    80005894:	8aaa                	mv	s5,a0
    80005896:	8a2e                	mv	s4,a1
    80005898:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000589a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000589e:	0001c517          	auipc	a0,0x1c
    800058a2:	74250513          	add	a0,a0,1858 # 80021fe0 <cons>
    800058a6:	00001097          	auipc	ra,0x1
    800058aa:	8e8080e7          	jalr	-1816(ra) # 8000618e <acquire>
  while(n > 0){
    /* wait until interrupt handler has put some */
    /* input into cons.buffer. */
    while(cons.r == cons.w){
    800058ae:	0001c497          	auipc	s1,0x1c
    800058b2:	73248493          	add	s1,s1,1842 # 80021fe0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058b6:	0001c917          	auipc	s2,0x1c
    800058ba:	7c290913          	add	s2,s2,1986 # 80022078 <cons+0x98>
  while(n > 0){
    800058be:	09305263          	blez	s3,80005942 <consoleread+0xc4>
    while(cons.r == cons.w){
    800058c2:	0984a783          	lw	a5,152(s1)
    800058c6:	09c4a703          	lw	a4,156(s1)
    800058ca:	02f71763          	bne	a4,a5,800058f8 <consoleread+0x7a>
      if(killed(myproc())){
    800058ce:	ffffb097          	auipc	ra,0xffffb
    800058d2:	5dc080e7          	jalr	1500(ra) # 80000eaa <myproc>
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	f30080e7          	jalr	-208(ra) # 80001806 <killed>
    800058de:	ed2d                	bnez	a0,80005958 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800058e0:	85a6                	mv	a1,s1
    800058e2:	854a                	mv	a0,s2
    800058e4:	ffffc097          	auipc	ra,0xffffc
    800058e8:	c7a080e7          	jalr	-902(ra) # 8000155e <sleep>
    while(cons.r == cons.w){
    800058ec:	0984a783          	lw	a5,152(s1)
    800058f0:	09c4a703          	lw	a4,156(s1)
    800058f4:	fcf70de3          	beq	a4,a5,800058ce <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800058f8:	0001c717          	auipc	a4,0x1c
    800058fc:	6e870713          	add	a4,a4,1768 # 80021fe0 <cons>
    80005900:	0017869b          	addw	a3,a5,1
    80005904:	08d72c23          	sw	a3,152(a4)
    80005908:	07f7f693          	and	a3,a5,127
    8000590c:	9736                	add	a4,a4,a3
    8000590e:	01874703          	lbu	a4,24(a4)
    80005912:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  /* end-of-file */
    80005916:	4691                	li	a3,4
    80005918:	06db8463          	beq	s7,a3,80005980 <consoleread+0x102>
      }
      break;
    }

    /* copy the input byte to the user-space buffer. */
    cbuf = c;
    8000591c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005920:	4685                	li	a3,1
    80005922:	faf40613          	add	a2,s0,-81
    80005926:	85d2                	mv	a1,s4
    80005928:	8556                	mv	a0,s5
    8000592a:	ffffc097          	auipc	ra,0xffffc
    8000592e:	03c080e7          	jalr	60(ra) # 80001966 <either_copyout>
    80005932:	57fd                	li	a5,-1
    80005934:	00f50763          	beq	a0,a5,80005942 <consoleread+0xc4>
      break;

    dst++;
    80005938:	0a05                	add	s4,s4,1
    --n;
    8000593a:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000593c:	47a9                	li	a5,10
    8000593e:	f8fb90e3          	bne	s7,a5,800058be <consoleread+0x40>
      /* a whole line has arrived, return to */
      /* the user-level read(). */
      break;
    }
  }
  release(&cons.lock);
    80005942:	0001c517          	auipc	a0,0x1c
    80005946:	69e50513          	add	a0,a0,1694 # 80021fe0 <cons>
    8000594a:	00001097          	auipc	ra,0x1
    8000594e:	8f8080e7          	jalr	-1800(ra) # 80006242 <release>

  return target - n;
    80005952:	413b053b          	subw	a0,s6,s3
    80005956:	a811                	j	8000596a <consoleread+0xec>
        release(&cons.lock);
    80005958:	0001c517          	auipc	a0,0x1c
    8000595c:	68850513          	add	a0,a0,1672 # 80021fe0 <cons>
    80005960:	00001097          	auipc	ra,0x1
    80005964:	8e2080e7          	jalr	-1822(ra) # 80006242 <release>
        return -1;
    80005968:	557d                	li	a0,-1
}
    8000596a:	60e6                	ld	ra,88(sp)
    8000596c:	6446                	ld	s0,80(sp)
    8000596e:	64a6                	ld	s1,72(sp)
    80005970:	6906                	ld	s2,64(sp)
    80005972:	79e2                	ld	s3,56(sp)
    80005974:	7a42                	ld	s4,48(sp)
    80005976:	7aa2                	ld	s5,40(sp)
    80005978:	7b02                	ld	s6,32(sp)
    8000597a:	6be2                	ld	s7,24(sp)
    8000597c:	6125                	add	sp,sp,96
    8000597e:	8082                	ret
      if(n < target){
    80005980:	0009871b          	sext.w	a4,s3
    80005984:	fb677fe3          	bgeu	a4,s6,80005942 <consoleread+0xc4>
        cons.r--;
    80005988:	0001c717          	auipc	a4,0x1c
    8000598c:	6ef72823          	sw	a5,1776(a4) # 80022078 <cons+0x98>
    80005990:	bf4d                	j	80005942 <consoleread+0xc4>

0000000080005992 <consputc>:
{
    80005992:	1141                	add	sp,sp,-16
    80005994:	e406                	sd	ra,8(sp)
    80005996:	e022                	sd	s0,0(sp)
    80005998:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000599a:	10000793          	li	a5,256
    8000599e:	00f50a63          	beq	a0,a5,800059b2 <consputc+0x20>
    uartputc_sync(c);
    800059a2:	00000097          	auipc	ra,0x0
    800059a6:	560080e7          	jalr	1376(ra) # 80005f02 <uartputc_sync>
}
    800059aa:	60a2                	ld	ra,8(sp)
    800059ac:	6402                	ld	s0,0(sp)
    800059ae:	0141                	add	sp,sp,16
    800059b0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059b2:	4521                	li	a0,8
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	54e080e7          	jalr	1358(ra) # 80005f02 <uartputc_sync>
    800059bc:	02000513          	li	a0,32
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	542080e7          	jalr	1346(ra) # 80005f02 <uartputc_sync>
    800059c8:	4521                	li	a0,8
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	538080e7          	jalr	1336(ra) # 80005f02 <uartputc_sync>
    800059d2:	bfe1                	j	800059aa <consputc+0x18>

00000000800059d4 <consoleintr>:
/* do erase/kill processing, append to cons.buf, */
/* wake up consoleread() if a whole line has arrived. */
/* */
void
consoleintr(int c)
{
    800059d4:	1101                	add	sp,sp,-32
    800059d6:	ec06                	sd	ra,24(sp)
    800059d8:	e822                	sd	s0,16(sp)
    800059da:	e426                	sd	s1,8(sp)
    800059dc:	e04a                	sd	s2,0(sp)
    800059de:	1000                	add	s0,sp,32
    800059e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059e2:	0001c517          	auipc	a0,0x1c
    800059e6:	5fe50513          	add	a0,a0,1534 # 80021fe0 <cons>
    800059ea:	00000097          	auipc	ra,0x0
    800059ee:	7a4080e7          	jalr	1956(ra) # 8000618e <acquire>

  switch(c){
    800059f2:	47d5                	li	a5,21
    800059f4:	0af48663          	beq	s1,a5,80005aa0 <consoleintr+0xcc>
    800059f8:	0297ca63          	blt	a5,s1,80005a2c <consoleintr+0x58>
    800059fc:	47a1                	li	a5,8
    800059fe:	0ef48763          	beq	s1,a5,80005aec <consoleintr+0x118>
    80005a02:	47c1                	li	a5,16
    80005a04:	10f49a63          	bne	s1,a5,80005b18 <consoleintr+0x144>
  case C('P'):  /* Print process list. */
    procdump();
    80005a08:	ffffc097          	auipc	ra,0xffffc
    80005a0c:	00a080e7          	jalr	10(ra) # 80001a12 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a10:	0001c517          	auipc	a0,0x1c
    80005a14:	5d050513          	add	a0,a0,1488 # 80021fe0 <cons>
    80005a18:	00001097          	auipc	ra,0x1
    80005a1c:	82a080e7          	jalr	-2006(ra) # 80006242 <release>
}
    80005a20:	60e2                	ld	ra,24(sp)
    80005a22:	6442                	ld	s0,16(sp)
    80005a24:	64a2                	ld	s1,8(sp)
    80005a26:	6902                	ld	s2,0(sp)
    80005a28:	6105                	add	sp,sp,32
    80005a2a:	8082                	ret
  switch(c){
    80005a2c:	07f00793          	li	a5,127
    80005a30:	0af48e63          	beq	s1,a5,80005aec <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a34:	0001c717          	auipc	a4,0x1c
    80005a38:	5ac70713          	add	a4,a4,1452 # 80021fe0 <cons>
    80005a3c:	0a072783          	lw	a5,160(a4)
    80005a40:	09872703          	lw	a4,152(a4)
    80005a44:	9f99                	subw	a5,a5,a4
    80005a46:	07f00713          	li	a4,127
    80005a4a:	fcf763e3          	bltu	a4,a5,80005a10 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a4e:	47b5                	li	a5,13
    80005a50:	0cf48763          	beq	s1,a5,80005b1e <consoleintr+0x14a>
      consputc(c);
    80005a54:	8526                	mv	a0,s1
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	f3c080e7          	jalr	-196(ra) # 80005992 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a5e:	0001c797          	auipc	a5,0x1c
    80005a62:	58278793          	add	a5,a5,1410 # 80021fe0 <cons>
    80005a66:	0a07a683          	lw	a3,160(a5)
    80005a6a:	0016871b          	addw	a4,a3,1
    80005a6e:	0007061b          	sext.w	a2,a4
    80005a72:	0ae7a023          	sw	a4,160(a5)
    80005a76:	07f6f693          	and	a3,a3,127
    80005a7a:	97b6                	add	a5,a5,a3
    80005a7c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a80:	47a9                	li	a5,10
    80005a82:	0cf48563          	beq	s1,a5,80005b4c <consoleintr+0x178>
    80005a86:	4791                	li	a5,4
    80005a88:	0cf48263          	beq	s1,a5,80005b4c <consoleintr+0x178>
    80005a8c:	0001c797          	auipc	a5,0x1c
    80005a90:	5ec7a783          	lw	a5,1516(a5) # 80022078 <cons+0x98>
    80005a94:	9f1d                	subw	a4,a4,a5
    80005a96:	08000793          	li	a5,128
    80005a9a:	f6f71be3          	bne	a4,a5,80005a10 <consoleintr+0x3c>
    80005a9e:	a07d                	j	80005b4c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aa0:	0001c717          	auipc	a4,0x1c
    80005aa4:	54070713          	add	a4,a4,1344 # 80021fe0 <cons>
    80005aa8:	0a072783          	lw	a5,160(a4)
    80005aac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ab0:	0001c497          	auipc	s1,0x1c
    80005ab4:	53048493          	add	s1,s1,1328 # 80021fe0 <cons>
    while(cons.e != cons.w &&
    80005ab8:	4929                	li	s2,10
    80005aba:	f4f70be3          	beq	a4,a5,80005a10 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005abe:	37fd                	addw	a5,a5,-1
    80005ac0:	07f7f713          	and	a4,a5,127
    80005ac4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ac6:	01874703          	lbu	a4,24(a4)
    80005aca:	f52703e3          	beq	a4,s2,80005a10 <consoleintr+0x3c>
      cons.e--;
    80005ace:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ad2:	10000513          	li	a0,256
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	ebc080e7          	jalr	-324(ra) # 80005992 <consputc>
    while(cons.e != cons.w &&
    80005ade:	0a04a783          	lw	a5,160(s1)
    80005ae2:	09c4a703          	lw	a4,156(s1)
    80005ae6:	fcf71ce3          	bne	a4,a5,80005abe <consoleintr+0xea>
    80005aea:	b71d                	j	80005a10 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005aec:	0001c717          	auipc	a4,0x1c
    80005af0:	4f470713          	add	a4,a4,1268 # 80021fe0 <cons>
    80005af4:	0a072783          	lw	a5,160(a4)
    80005af8:	09c72703          	lw	a4,156(a4)
    80005afc:	f0f70ae3          	beq	a4,a5,80005a10 <consoleintr+0x3c>
      cons.e--;
    80005b00:	37fd                	addw	a5,a5,-1
    80005b02:	0001c717          	auipc	a4,0x1c
    80005b06:	56f72f23          	sw	a5,1406(a4) # 80022080 <cons+0xa0>
      consputc(BACKSPACE);
    80005b0a:	10000513          	li	a0,256
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	e84080e7          	jalr	-380(ra) # 80005992 <consputc>
    80005b16:	bded                	j	80005a10 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b18:	ee048ce3          	beqz	s1,80005a10 <consoleintr+0x3c>
    80005b1c:	bf21                	j	80005a34 <consoleintr+0x60>
      consputc(c);
    80005b1e:	4529                	li	a0,10
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	e72080e7          	jalr	-398(ra) # 80005992 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b28:	0001c797          	auipc	a5,0x1c
    80005b2c:	4b878793          	add	a5,a5,1208 # 80021fe0 <cons>
    80005b30:	0a07a703          	lw	a4,160(a5)
    80005b34:	0017069b          	addw	a3,a4,1
    80005b38:	0006861b          	sext.w	a2,a3
    80005b3c:	0ad7a023          	sw	a3,160(a5)
    80005b40:	07f77713          	and	a4,a4,127
    80005b44:	97ba                	add	a5,a5,a4
    80005b46:	4729                	li	a4,10
    80005b48:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b4c:	0001c797          	auipc	a5,0x1c
    80005b50:	52c7a823          	sw	a2,1328(a5) # 8002207c <cons+0x9c>
        wakeup(&cons.r);
    80005b54:	0001c517          	auipc	a0,0x1c
    80005b58:	52450513          	add	a0,a0,1316 # 80022078 <cons+0x98>
    80005b5c:	ffffc097          	auipc	ra,0xffffc
    80005b60:	a66080e7          	jalr	-1434(ra) # 800015c2 <wakeup>
    80005b64:	b575                	j	80005a10 <consoleintr+0x3c>

0000000080005b66 <consoleinit>:

void
consoleinit(void)
{
    80005b66:	1141                	add	sp,sp,-16
    80005b68:	e406                	sd	ra,8(sp)
    80005b6a:	e022                	sd	s0,0(sp)
    80005b6c:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b6e:	00003597          	auipc	a1,0x3
    80005b72:	d5258593          	add	a1,a1,-686 # 800088c0 <syscalls+0x3f0>
    80005b76:	0001c517          	auipc	a0,0x1c
    80005b7a:	46a50513          	add	a0,a0,1130 # 80021fe0 <cons>
    80005b7e:	00000097          	auipc	ra,0x0
    80005b82:	580080e7          	jalr	1408(ra) # 800060fe <initlock>

  uartinit();
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	32c080e7          	jalr	812(ra) # 80005eb2 <uartinit>

  /* connect read and write system calls */
  /* to consoleread and consolewrite. */
  devsw[CONSOLE].read = consoleread;
    80005b8e:	00013797          	auipc	a5,0x13
    80005b92:	17a78793          	add	a5,a5,378 # 80018d08 <devsw>
    80005b96:	00000717          	auipc	a4,0x0
    80005b9a:	ce870713          	add	a4,a4,-792 # 8000587e <consoleread>
    80005b9e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ba0:	00000717          	auipc	a4,0x0
    80005ba4:	c7a70713          	add	a4,a4,-902 # 8000581a <consolewrite>
    80005ba8:	ef98                	sd	a4,24(a5)
}
    80005baa:	60a2                	ld	ra,8(sp)
    80005bac:	6402                	ld	s0,0(sp)
    80005bae:	0141                	add	sp,sp,16
    80005bb0:	8082                	ret

0000000080005bb2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bb2:	7179                	add	sp,sp,-48
    80005bb4:	f406                	sd	ra,40(sp)
    80005bb6:	f022                	sd	s0,32(sp)
    80005bb8:	ec26                	sd	s1,24(sp)
    80005bba:	e84a                	sd	s2,16(sp)
    80005bbc:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bbe:	c219                	beqz	a2,80005bc4 <printint+0x12>
    80005bc0:	08054763          	bltz	a0,80005c4e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bc4:	2501                	sext.w	a0,a0
    80005bc6:	4881                	li	a7,0
    80005bc8:	fd040693          	add	a3,s0,-48

  i = 0;
    80005bcc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bce:	2581                	sext.w	a1,a1
    80005bd0:	00003617          	auipc	a2,0x3
    80005bd4:	d2060613          	add	a2,a2,-736 # 800088f0 <digits>
    80005bd8:	883a                	mv	a6,a4
    80005bda:	2705                	addw	a4,a4,1
    80005bdc:	02b577bb          	remuw	a5,a0,a1
    80005be0:	1782                	sll	a5,a5,0x20
    80005be2:	9381                	srl	a5,a5,0x20
    80005be4:	97b2                	add	a5,a5,a2
    80005be6:	0007c783          	lbu	a5,0(a5)
    80005bea:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bee:	0005079b          	sext.w	a5,a0
    80005bf2:	02b5553b          	divuw	a0,a0,a1
    80005bf6:	0685                	add	a3,a3,1
    80005bf8:	feb7f0e3          	bgeu	a5,a1,80005bd8 <printint+0x26>

  if(sign)
    80005bfc:	00088c63          	beqz	a7,80005c14 <printint+0x62>
    buf[i++] = '-';
    80005c00:	fe070793          	add	a5,a4,-32
    80005c04:	00878733          	add	a4,a5,s0
    80005c08:	02d00793          	li	a5,45
    80005c0c:	fef70823          	sb	a5,-16(a4)
    80005c10:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005c14:	02e05763          	blez	a4,80005c42 <printint+0x90>
    80005c18:	fd040793          	add	a5,s0,-48
    80005c1c:	00e784b3          	add	s1,a5,a4
    80005c20:	fff78913          	add	s2,a5,-1
    80005c24:	993a                	add	s2,s2,a4
    80005c26:	377d                	addw	a4,a4,-1
    80005c28:	1702                	sll	a4,a4,0x20
    80005c2a:	9301                	srl	a4,a4,0x20
    80005c2c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c30:	fff4c503          	lbu	a0,-1(s1)
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	d5e080e7          	jalr	-674(ra) # 80005992 <consputc>
  while(--i >= 0)
    80005c3c:	14fd                	add	s1,s1,-1
    80005c3e:	ff2499e3          	bne	s1,s2,80005c30 <printint+0x7e>
}
    80005c42:	70a2                	ld	ra,40(sp)
    80005c44:	7402                	ld	s0,32(sp)
    80005c46:	64e2                	ld	s1,24(sp)
    80005c48:	6942                	ld	s2,16(sp)
    80005c4a:	6145                	add	sp,sp,48
    80005c4c:	8082                	ret
    x = -xx;
    80005c4e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c52:	4885                	li	a7,1
    x = -xx;
    80005c54:	bf95                	j	80005bc8 <printint+0x16>

0000000080005c56 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c56:	1101                	add	sp,sp,-32
    80005c58:	ec06                	sd	ra,24(sp)
    80005c5a:	e822                	sd	s0,16(sp)
    80005c5c:	e426                	sd	s1,8(sp)
    80005c5e:	1000                	add	s0,sp,32
    80005c60:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c62:	0001c797          	auipc	a5,0x1c
    80005c66:	4207af23          	sw	zero,1086(a5) # 800220a0 <pr+0x18>
  printf("panic: ");
    80005c6a:	00003517          	auipc	a0,0x3
    80005c6e:	c5e50513          	add	a0,a0,-930 # 800088c8 <syscalls+0x3f8>
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	02e080e7          	jalr	46(ra) # 80005ca0 <printf>
  printf(s);
    80005c7a:	8526                	mv	a0,s1
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	024080e7          	jalr	36(ra) # 80005ca0 <printf>
  printf("\n");
    80005c84:	00002517          	auipc	a0,0x2
    80005c88:	3c450513          	add	a0,a0,964 # 80008048 <etext+0x48>
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	014080e7          	jalr	20(ra) # 80005ca0 <printf>
  panicked = 1; /* freeze uart output from other CPUs */
    80005c94:	4785                	li	a5,1
    80005c96:	00003717          	auipc	a4,0x3
    80005c9a:	dcf72323          	sw	a5,-570(a4) # 80008a5c <panicked>
  for(;;)
    80005c9e:	a001                	j	80005c9e <panic+0x48>

0000000080005ca0 <printf>:
{
    80005ca0:	7131                	add	sp,sp,-192
    80005ca2:	fc86                	sd	ra,120(sp)
    80005ca4:	f8a2                	sd	s0,112(sp)
    80005ca6:	f4a6                	sd	s1,104(sp)
    80005ca8:	f0ca                	sd	s2,96(sp)
    80005caa:	ecce                	sd	s3,88(sp)
    80005cac:	e8d2                	sd	s4,80(sp)
    80005cae:	e4d6                	sd	s5,72(sp)
    80005cb0:	e0da                	sd	s6,64(sp)
    80005cb2:	fc5e                	sd	s7,56(sp)
    80005cb4:	f862                	sd	s8,48(sp)
    80005cb6:	f466                	sd	s9,40(sp)
    80005cb8:	f06a                	sd	s10,32(sp)
    80005cba:	ec6e                	sd	s11,24(sp)
    80005cbc:	0100                	add	s0,sp,128
    80005cbe:	8a2a                	mv	s4,a0
    80005cc0:	e40c                	sd	a1,8(s0)
    80005cc2:	e810                	sd	a2,16(s0)
    80005cc4:	ec14                	sd	a3,24(s0)
    80005cc6:	f018                	sd	a4,32(s0)
    80005cc8:	f41c                	sd	a5,40(s0)
    80005cca:	03043823          	sd	a6,48(s0)
    80005cce:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cd2:	0001cd97          	auipc	s11,0x1c
    80005cd6:	3cedad83          	lw	s11,974(s11) # 800220a0 <pr+0x18>
  if(locking)
    80005cda:	020d9b63          	bnez	s11,80005d10 <printf+0x70>
  if (fmt == 0)
    80005cde:	040a0263          	beqz	s4,80005d22 <printf+0x82>
  va_start(ap, fmt);
    80005ce2:	00840793          	add	a5,s0,8
    80005ce6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cea:	000a4503          	lbu	a0,0(s4)
    80005cee:	14050f63          	beqz	a0,80005e4c <printf+0x1ac>
    80005cf2:	4981                	li	s3,0
    if(c != '%'){
    80005cf4:	02500a93          	li	s5,37
    switch(c){
    80005cf8:	07000b93          	li	s7,112
  consputc('x');
    80005cfc:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cfe:	00003b17          	auipc	s6,0x3
    80005d02:	bf2b0b13          	add	s6,s6,-1038 # 800088f0 <digits>
    switch(c){
    80005d06:	07300c93          	li	s9,115
    80005d0a:	06400c13          	li	s8,100
    80005d0e:	a82d                	j	80005d48 <printf+0xa8>
    acquire(&pr.lock);
    80005d10:	0001c517          	auipc	a0,0x1c
    80005d14:	37850513          	add	a0,a0,888 # 80022088 <pr>
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	476080e7          	jalr	1142(ra) # 8000618e <acquire>
    80005d20:	bf7d                	j	80005cde <printf+0x3e>
    panic("null fmt");
    80005d22:	00003517          	auipc	a0,0x3
    80005d26:	bb650513          	add	a0,a0,-1098 # 800088d8 <syscalls+0x408>
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	f2c080e7          	jalr	-212(ra) # 80005c56 <panic>
      consputc(c);
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	c60080e7          	jalr	-928(ra) # 80005992 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3a:	2985                	addw	s3,s3,1
    80005d3c:	013a07b3          	add	a5,s4,s3
    80005d40:	0007c503          	lbu	a0,0(a5)
    80005d44:	10050463          	beqz	a0,80005e4c <printf+0x1ac>
    if(c != '%'){
    80005d48:	ff5515e3          	bne	a0,s5,80005d32 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d4c:	2985                	addw	s3,s3,1
    80005d4e:	013a07b3          	add	a5,s4,s3
    80005d52:	0007c783          	lbu	a5,0(a5)
    80005d56:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d5a:	cbed                	beqz	a5,80005e4c <printf+0x1ac>
    switch(c){
    80005d5c:	05778a63          	beq	a5,s7,80005db0 <printf+0x110>
    80005d60:	02fbf663          	bgeu	s7,a5,80005d8c <printf+0xec>
    80005d64:	09978863          	beq	a5,s9,80005df4 <printf+0x154>
    80005d68:	07800713          	li	a4,120
    80005d6c:	0ce79563          	bne	a5,a4,80005e36 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d70:	f8843783          	ld	a5,-120(s0)
    80005d74:	00878713          	add	a4,a5,8
    80005d78:	f8e43423          	sd	a4,-120(s0)
    80005d7c:	4605                	li	a2,1
    80005d7e:	85ea                	mv	a1,s10
    80005d80:	4388                	lw	a0,0(a5)
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	e30080e7          	jalr	-464(ra) # 80005bb2 <printint>
      break;
    80005d8a:	bf45                	j	80005d3a <printf+0x9a>
    switch(c){
    80005d8c:	09578f63          	beq	a5,s5,80005e2a <printf+0x18a>
    80005d90:	0b879363          	bne	a5,s8,80005e36 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d94:	f8843783          	ld	a5,-120(s0)
    80005d98:	00878713          	add	a4,a5,8
    80005d9c:	f8e43423          	sd	a4,-120(s0)
    80005da0:	4605                	li	a2,1
    80005da2:	45a9                	li	a1,10
    80005da4:	4388                	lw	a0,0(a5)
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	e0c080e7          	jalr	-500(ra) # 80005bb2 <printint>
      break;
    80005dae:	b771                	j	80005d3a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005db0:	f8843783          	ld	a5,-120(s0)
    80005db4:	00878713          	add	a4,a5,8
    80005db8:	f8e43423          	sd	a4,-120(s0)
    80005dbc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dc0:	03000513          	li	a0,48
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	bce080e7          	jalr	-1074(ra) # 80005992 <consputc>
  consputc('x');
    80005dcc:	07800513          	li	a0,120
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	bc2080e7          	jalr	-1086(ra) # 80005992 <consputc>
    80005dd8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dda:	03c95793          	srl	a5,s2,0x3c
    80005dde:	97da                	add	a5,a5,s6
    80005de0:	0007c503          	lbu	a0,0(a5)
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	bae080e7          	jalr	-1106(ra) # 80005992 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dec:	0912                	sll	s2,s2,0x4
    80005dee:	34fd                	addw	s1,s1,-1
    80005df0:	f4ed                	bnez	s1,80005dda <printf+0x13a>
    80005df2:	b7a1                	j	80005d3a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005df4:	f8843783          	ld	a5,-120(s0)
    80005df8:	00878713          	add	a4,a5,8
    80005dfc:	f8e43423          	sd	a4,-120(s0)
    80005e00:	6384                	ld	s1,0(a5)
    80005e02:	cc89                	beqz	s1,80005e1c <printf+0x17c>
      for(; *s; s++)
    80005e04:	0004c503          	lbu	a0,0(s1)
    80005e08:	d90d                	beqz	a0,80005d3a <printf+0x9a>
        consputc(*s);
    80005e0a:	00000097          	auipc	ra,0x0
    80005e0e:	b88080e7          	jalr	-1144(ra) # 80005992 <consputc>
      for(; *s; s++)
    80005e12:	0485                	add	s1,s1,1
    80005e14:	0004c503          	lbu	a0,0(s1)
    80005e18:	f96d                	bnez	a0,80005e0a <printf+0x16a>
    80005e1a:	b705                	j	80005d3a <printf+0x9a>
        s = "(null)";
    80005e1c:	00003497          	auipc	s1,0x3
    80005e20:	ab448493          	add	s1,s1,-1356 # 800088d0 <syscalls+0x400>
      for(; *s; s++)
    80005e24:	02800513          	li	a0,40
    80005e28:	b7cd                	j	80005e0a <printf+0x16a>
      consputc('%');
    80005e2a:	8556                	mv	a0,s5
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	b66080e7          	jalr	-1178(ra) # 80005992 <consputc>
      break;
    80005e34:	b719                	j	80005d3a <printf+0x9a>
      consputc('%');
    80005e36:	8556                	mv	a0,s5
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	b5a080e7          	jalr	-1190(ra) # 80005992 <consputc>
      consputc(c);
    80005e40:	8526                	mv	a0,s1
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	b50080e7          	jalr	-1200(ra) # 80005992 <consputc>
      break;
    80005e4a:	bdc5                	j	80005d3a <printf+0x9a>
  if(locking)
    80005e4c:	020d9163          	bnez	s11,80005e6e <printf+0x1ce>
}
    80005e50:	70e6                	ld	ra,120(sp)
    80005e52:	7446                	ld	s0,112(sp)
    80005e54:	74a6                	ld	s1,104(sp)
    80005e56:	7906                	ld	s2,96(sp)
    80005e58:	69e6                	ld	s3,88(sp)
    80005e5a:	6a46                	ld	s4,80(sp)
    80005e5c:	6aa6                	ld	s5,72(sp)
    80005e5e:	6b06                	ld	s6,64(sp)
    80005e60:	7be2                	ld	s7,56(sp)
    80005e62:	7c42                	ld	s8,48(sp)
    80005e64:	7ca2                	ld	s9,40(sp)
    80005e66:	7d02                	ld	s10,32(sp)
    80005e68:	6de2                	ld	s11,24(sp)
    80005e6a:	6129                	add	sp,sp,192
    80005e6c:	8082                	ret
    release(&pr.lock);
    80005e6e:	0001c517          	auipc	a0,0x1c
    80005e72:	21a50513          	add	a0,a0,538 # 80022088 <pr>
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	3cc080e7          	jalr	972(ra) # 80006242 <release>
}
    80005e7e:	bfc9                	j	80005e50 <printf+0x1b0>

0000000080005e80 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e80:	1101                	add	sp,sp,-32
    80005e82:	ec06                	sd	ra,24(sp)
    80005e84:	e822                	sd	s0,16(sp)
    80005e86:	e426                	sd	s1,8(sp)
    80005e88:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e8a:	0001c497          	auipc	s1,0x1c
    80005e8e:	1fe48493          	add	s1,s1,510 # 80022088 <pr>
    80005e92:	00003597          	auipc	a1,0x3
    80005e96:	a5658593          	add	a1,a1,-1450 # 800088e8 <syscalls+0x418>
    80005e9a:	8526                	mv	a0,s1
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	262080e7          	jalr	610(ra) # 800060fe <initlock>
  pr.locking = 1;
    80005ea4:	4785                	li	a5,1
    80005ea6:	cc9c                	sw	a5,24(s1)
}
    80005ea8:	60e2                	ld	ra,24(sp)
    80005eaa:	6442                	ld	s0,16(sp)
    80005eac:	64a2                	ld	s1,8(sp)
    80005eae:	6105                	add	sp,sp,32
    80005eb0:	8082                	ret

0000000080005eb2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eb2:	1141                	add	sp,sp,-16
    80005eb4:	e406                	sd	ra,8(sp)
    80005eb6:	e022                	sd	s0,0(sp)
    80005eb8:	0800                	add	s0,sp,16
  /* disable interrupts. */
  WriteReg(IER, 0x00);
    80005eba:	100007b7          	lui	a5,0x10000
    80005ebe:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  /* special mode to set baud rate. */
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ec2:	f8000713          	li	a4,-128
    80005ec6:	00e781a3          	sb	a4,3(a5)

  /* LSB for baud rate of 38.4K. */
  WriteReg(0, 0x03);
    80005eca:	470d                	li	a4,3
    80005ecc:	00e78023          	sb	a4,0(a5)

  /* MSB for baud rate of 38.4K. */
  WriteReg(1, 0x00);
    80005ed0:	000780a3          	sb	zero,1(a5)

  /* leave set-baud mode, */
  /* and set word length to 8 bits, no parity. */
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ed4:	00e781a3          	sb	a4,3(a5)

  /* reset and enable FIFOs. */
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ed8:	469d                	li	a3,7
    80005eda:	00d78123          	sb	a3,2(a5)

  /* enable transmit and receive interrupts. */
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ede:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ee2:	00003597          	auipc	a1,0x3
    80005ee6:	a2658593          	add	a1,a1,-1498 # 80008908 <digits+0x18>
    80005eea:	0001c517          	auipc	a0,0x1c
    80005eee:	1be50513          	add	a0,a0,446 # 800220a8 <uart_tx_lock>
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	20c080e7          	jalr	524(ra) # 800060fe <initlock>
}
    80005efa:	60a2                	ld	ra,8(sp)
    80005efc:	6402                	ld	s0,0(sp)
    80005efe:	0141                	add	sp,sp,16
    80005f00:	8082                	ret

0000000080005f02 <uartputc_sync>:
/* use interrupts, for use by kernel printf() and */
/* to echo characters. it spins waiting for the uart's */
/* output register to be empty. */
void
uartputc_sync(int c)
{
    80005f02:	1101                	add	sp,sp,-32
    80005f04:	ec06                	sd	ra,24(sp)
    80005f06:	e822                	sd	s0,16(sp)
    80005f08:	e426                	sd	s1,8(sp)
    80005f0a:	1000                	add	s0,sp,32
    80005f0c:	84aa                	mv	s1,a0
  push_off();
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	234080e7          	jalr	564(ra) # 80006142 <push_off>

  if(panicked){
    80005f16:	00003797          	auipc	a5,0x3
    80005f1a:	b467a783          	lw	a5,-1210(a5) # 80008a5c <panicked>
    for(;;)
      ;
  }

  /* wait for Transmit Holding Empty to be set in LSR. */
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f1e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f22:	c391                	beqz	a5,80005f26 <uartputc_sync+0x24>
    for(;;)
    80005f24:	a001                	j	80005f24 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f26:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f2a:	0207f793          	and	a5,a5,32
    80005f2e:	dfe5                	beqz	a5,80005f26 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f30:	0ff4f513          	zext.b	a0,s1
    80005f34:	100007b7          	lui	a5,0x10000
    80005f38:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	2a6080e7          	jalr	678(ra) # 800061e2 <pop_off>
}
    80005f44:	60e2                	ld	ra,24(sp)
    80005f46:	6442                	ld	s0,16(sp)
    80005f48:	64a2                	ld	s1,8(sp)
    80005f4a:	6105                	add	sp,sp,32
    80005f4c:	8082                	ret

0000000080005f4e <uartstart>:
/* called from both the top- and bottom-half. */
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f4e:	00003797          	auipc	a5,0x3
    80005f52:	b127b783          	ld	a5,-1262(a5) # 80008a60 <uart_tx_r>
    80005f56:	00003717          	auipc	a4,0x3
    80005f5a:	b1273703          	ld	a4,-1262(a4) # 80008a68 <uart_tx_w>
    80005f5e:	06f70a63          	beq	a4,a5,80005fd2 <uartstart+0x84>
{
    80005f62:	7139                	add	sp,sp,-64
    80005f64:	fc06                	sd	ra,56(sp)
    80005f66:	f822                	sd	s0,48(sp)
    80005f68:	f426                	sd	s1,40(sp)
    80005f6a:	f04a                	sd	s2,32(sp)
    80005f6c:	ec4e                	sd	s3,24(sp)
    80005f6e:	e852                	sd	s4,16(sp)
    80005f70:	e456                	sd	s5,8(sp)
    80005f72:	0080                	add	s0,sp,64
      /* transmit buffer is empty. */
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f74:	10000937          	lui	s2,0x10000
      /* so we cannot give it another byte. */
      /* it will interrupt when it's ready for a new byte. */
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f78:	0001ca17          	auipc	s4,0x1c
    80005f7c:	130a0a13          	add	s4,s4,304 # 800220a8 <uart_tx_lock>
    uart_tx_r += 1;
    80005f80:	00003497          	auipc	s1,0x3
    80005f84:	ae048493          	add	s1,s1,-1312 # 80008a60 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f88:	00003997          	auipc	s3,0x3
    80005f8c:	ae098993          	add	s3,s3,-1312 # 80008a68 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f90:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f94:	02077713          	and	a4,a4,32
    80005f98:	c705                	beqz	a4,80005fc0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f9a:	01f7f713          	and	a4,a5,31
    80005f9e:	9752                	add	a4,a4,s4
    80005fa0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fa4:	0785                	add	a5,a5,1
    80005fa6:	e09c                	sd	a5,0(s1)
    
    /* maybe uartputc() is waiting for space in the buffer. */
    wakeup(&uart_tx_r);
    80005fa8:	8526                	mv	a0,s1
    80005faa:	ffffb097          	auipc	ra,0xffffb
    80005fae:	618080e7          	jalr	1560(ra) # 800015c2 <wakeup>
    
    WriteReg(THR, c);
    80005fb2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fb6:	609c                	ld	a5,0(s1)
    80005fb8:	0009b703          	ld	a4,0(s3)
    80005fbc:	fcf71ae3          	bne	a4,a5,80005f90 <uartstart+0x42>
  }
}
    80005fc0:	70e2                	ld	ra,56(sp)
    80005fc2:	7442                	ld	s0,48(sp)
    80005fc4:	74a2                	ld	s1,40(sp)
    80005fc6:	7902                	ld	s2,32(sp)
    80005fc8:	69e2                	ld	s3,24(sp)
    80005fca:	6a42                	ld	s4,16(sp)
    80005fcc:	6aa2                	ld	s5,8(sp)
    80005fce:	6121                	add	sp,sp,64
    80005fd0:	8082                	ret
    80005fd2:	8082                	ret

0000000080005fd4 <uartputc>:
{
    80005fd4:	7179                	add	sp,sp,-48
    80005fd6:	f406                	sd	ra,40(sp)
    80005fd8:	f022                	sd	s0,32(sp)
    80005fda:	ec26                	sd	s1,24(sp)
    80005fdc:	e84a                	sd	s2,16(sp)
    80005fde:	e44e                	sd	s3,8(sp)
    80005fe0:	e052                	sd	s4,0(sp)
    80005fe2:	1800                	add	s0,sp,48
    80005fe4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fe6:	0001c517          	auipc	a0,0x1c
    80005fea:	0c250513          	add	a0,a0,194 # 800220a8 <uart_tx_lock>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	1a0080e7          	jalr	416(ra) # 8000618e <acquire>
  if(panicked){
    80005ff6:	00003797          	auipc	a5,0x3
    80005ffa:	a667a783          	lw	a5,-1434(a5) # 80008a5c <panicked>
    80005ffe:	e7c9                	bnez	a5,80006088 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006000:	00003717          	auipc	a4,0x3
    80006004:	a6873703          	ld	a4,-1432(a4) # 80008a68 <uart_tx_w>
    80006008:	00003797          	auipc	a5,0x3
    8000600c:	a587b783          	ld	a5,-1448(a5) # 80008a60 <uart_tx_r>
    80006010:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006014:	0001c997          	auipc	s3,0x1c
    80006018:	09498993          	add	s3,s3,148 # 800220a8 <uart_tx_lock>
    8000601c:	00003497          	auipc	s1,0x3
    80006020:	a4448493          	add	s1,s1,-1468 # 80008a60 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006024:	00003917          	auipc	s2,0x3
    80006028:	a4490913          	add	s2,s2,-1468 # 80008a68 <uart_tx_w>
    8000602c:	00e79f63          	bne	a5,a4,8000604a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006030:	85ce                	mv	a1,s3
    80006032:	8526                	mv	a0,s1
    80006034:	ffffb097          	auipc	ra,0xffffb
    80006038:	52a080e7          	jalr	1322(ra) # 8000155e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603c:	00093703          	ld	a4,0(s2)
    80006040:	609c                	ld	a5,0(s1)
    80006042:	02078793          	add	a5,a5,32
    80006046:	fee785e3          	beq	a5,a4,80006030 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000604a:	0001c497          	auipc	s1,0x1c
    8000604e:	05e48493          	add	s1,s1,94 # 800220a8 <uart_tx_lock>
    80006052:	01f77793          	and	a5,a4,31
    80006056:	97a6                	add	a5,a5,s1
    80006058:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000605c:	0705                	add	a4,a4,1
    8000605e:	00003797          	auipc	a5,0x3
    80006062:	a0e7b523          	sd	a4,-1526(a5) # 80008a68 <uart_tx_w>
  uartstart();
    80006066:	00000097          	auipc	ra,0x0
    8000606a:	ee8080e7          	jalr	-280(ra) # 80005f4e <uartstart>
  release(&uart_tx_lock);
    8000606e:	8526                	mv	a0,s1
    80006070:	00000097          	auipc	ra,0x0
    80006074:	1d2080e7          	jalr	466(ra) # 80006242 <release>
}
    80006078:	70a2                	ld	ra,40(sp)
    8000607a:	7402                	ld	s0,32(sp)
    8000607c:	64e2                	ld	s1,24(sp)
    8000607e:	6942                	ld	s2,16(sp)
    80006080:	69a2                	ld	s3,8(sp)
    80006082:	6a02                	ld	s4,0(sp)
    80006084:	6145                	add	sp,sp,48
    80006086:	8082                	ret
    for(;;)
    80006088:	a001                	j	80006088 <uartputc+0xb4>

000000008000608a <uartgetc>:

/* read one input character from the UART. */
/* return -1 if none is waiting. */
int
uartgetc(void)
{
    8000608a:	1141                	add	sp,sp,-16
    8000608c:	e422                	sd	s0,8(sp)
    8000608e:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006090:	100007b7          	lui	a5,0x10000
    80006094:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006098:	8b85                	and	a5,a5,1
    8000609a:	cb81                	beqz	a5,800060aa <uartgetc+0x20>
    /* input data is ready. */
    return ReadReg(RHR);
    8000609c:	100007b7          	lui	a5,0x10000
    800060a0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060a4:	6422                	ld	s0,8(sp)
    800060a6:	0141                	add	sp,sp,16
    800060a8:	8082                	ret
    return -1;
    800060aa:	557d                	li	a0,-1
    800060ac:	bfe5                	j	800060a4 <uartgetc+0x1a>

00000000800060ae <uartintr>:
/* handle a uart interrupt, raised because input has */
/* arrived, or the uart is ready for more output, or */
/* both. called from devintr(). */
void
uartintr(void)
{
    800060ae:	1101                	add	sp,sp,-32
    800060b0:	ec06                	sd	ra,24(sp)
    800060b2:	e822                	sd	s0,16(sp)
    800060b4:	e426                	sd	s1,8(sp)
    800060b6:	1000                	add	s0,sp,32
  /* read and process incoming characters. */
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060b8:	54fd                	li	s1,-1
    800060ba:	a029                	j	800060c4 <uartintr+0x16>
      break;
    consoleintr(c);
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	918080e7          	jalr	-1768(ra) # 800059d4 <consoleintr>
    int c = uartgetc();
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	fc6080e7          	jalr	-58(ra) # 8000608a <uartgetc>
    if(c == -1)
    800060cc:	fe9518e3          	bne	a0,s1,800060bc <uartintr+0xe>
  }

  /* send buffered characters. */
  acquire(&uart_tx_lock);
    800060d0:	0001c497          	auipc	s1,0x1c
    800060d4:	fd848493          	add	s1,s1,-40 # 800220a8 <uart_tx_lock>
    800060d8:	8526                	mv	a0,s1
    800060da:	00000097          	auipc	ra,0x0
    800060de:	0b4080e7          	jalr	180(ra) # 8000618e <acquire>
  uartstart();
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	e6c080e7          	jalr	-404(ra) # 80005f4e <uartstart>
  release(&uart_tx_lock);
    800060ea:	8526                	mv	a0,s1
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	156080e7          	jalr	342(ra) # 80006242 <release>
}
    800060f4:	60e2                	ld	ra,24(sp)
    800060f6:	6442                	ld	s0,16(sp)
    800060f8:	64a2                	ld	s1,8(sp)
    800060fa:	6105                	add	sp,sp,32
    800060fc:	8082                	ret

00000000800060fe <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060fe:	1141                	add	sp,sp,-16
    80006100:	e422                	sd	s0,8(sp)
    80006102:	0800                	add	s0,sp,16
  lk->name = name;
    80006104:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006106:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000610a:	00053823          	sd	zero,16(a0)
}
    8000610e:	6422                	ld	s0,8(sp)
    80006110:	0141                	add	sp,sp,16
    80006112:	8082                	ret

0000000080006114 <holding>:
/* Interrupts must be off. */
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006114:	411c                	lw	a5,0(a0)
    80006116:	e399                	bnez	a5,8000611c <holding+0x8>
    80006118:	4501                	li	a0,0
  return r;
}
    8000611a:	8082                	ret
{
    8000611c:	1101                	add	sp,sp,-32
    8000611e:	ec06                	sd	ra,24(sp)
    80006120:	e822                	sd	s0,16(sp)
    80006122:	e426                	sd	s1,8(sp)
    80006124:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006126:	6904                	ld	s1,16(a0)
    80006128:	ffffb097          	auipc	ra,0xffffb
    8000612c:	d66080e7          	jalr	-666(ra) # 80000e8e <mycpu>
    80006130:	40a48533          	sub	a0,s1,a0
    80006134:	00153513          	seqz	a0,a0
}
    80006138:	60e2                	ld	ra,24(sp)
    8000613a:	6442                	ld	s0,16(sp)
    8000613c:	64a2                	ld	s1,8(sp)
    8000613e:	6105                	add	sp,sp,32
    80006140:	8082                	ret

0000000080006142 <push_off>:
/* it takes two pop_off()s to undo two push_off()s.  Also, if interrupts */
/* are initially off, then push_off, pop_off leaves them off. */

void
push_off(void)
{
    80006142:	1101                	add	sp,sp,-32
    80006144:	ec06                	sd	ra,24(sp)
    80006146:	e822                	sd	s0,16(sp)
    80006148:	e426                	sd	s1,8(sp)
    8000614a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000614c:	100024f3          	csrr	s1,sstatus
    80006150:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006154:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006156:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000615a:	ffffb097          	auipc	ra,0xffffb
    8000615e:	d34080e7          	jalr	-716(ra) # 80000e8e <mycpu>
    80006162:	5d3c                	lw	a5,120(a0)
    80006164:	cf89                	beqz	a5,8000617e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006166:	ffffb097          	auipc	ra,0xffffb
    8000616a:	d28080e7          	jalr	-728(ra) # 80000e8e <mycpu>
    8000616e:	5d3c                	lw	a5,120(a0)
    80006170:	2785                	addw	a5,a5,1
    80006172:	dd3c                	sw	a5,120(a0)
}
    80006174:	60e2                	ld	ra,24(sp)
    80006176:	6442                	ld	s0,16(sp)
    80006178:	64a2                	ld	s1,8(sp)
    8000617a:	6105                	add	sp,sp,32
    8000617c:	8082                	ret
    mycpu()->intena = old;
    8000617e:	ffffb097          	auipc	ra,0xffffb
    80006182:	d10080e7          	jalr	-752(ra) # 80000e8e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006186:	8085                	srl	s1,s1,0x1
    80006188:	8885                	and	s1,s1,1
    8000618a:	dd64                	sw	s1,124(a0)
    8000618c:	bfe9                	j	80006166 <push_off+0x24>

000000008000618e <acquire>:
{
    8000618e:	1101                	add	sp,sp,-32
    80006190:	ec06                	sd	ra,24(sp)
    80006192:	e822                	sd	s0,16(sp)
    80006194:	e426                	sd	s1,8(sp)
    80006196:	1000                	add	s0,sp,32
    80006198:	84aa                	mv	s1,a0
  push_off(); /* disable interrupts to avoid deadlock. */
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	fa8080e7          	jalr	-88(ra) # 80006142 <push_off>
  if(holding(lk))
    800061a2:	8526                	mv	a0,s1
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	f70080e7          	jalr	-144(ra) # 80006114 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ac:	4705                	li	a4,1
  if(holding(lk))
    800061ae:	e115                	bnez	a0,800061d2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061b0:	87ba                	mv	a5,a4
    800061b2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061b6:	2781                	sext.w	a5,a5
    800061b8:	ffe5                	bnez	a5,800061b0 <acquire+0x22>
  __sync_synchronize();
    800061ba:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	cd0080e7          	jalr	-816(ra) # 80000e8e <mycpu>
    800061c6:	e888                	sd	a0,16(s1)
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	add	sp,sp,32
    800061d0:	8082                	ret
    panic("acquire");
    800061d2:	00002517          	auipc	a0,0x2
    800061d6:	73e50513          	add	a0,a0,1854 # 80008910 <digits+0x20>
    800061da:	00000097          	auipc	ra,0x0
    800061de:	a7c080e7          	jalr	-1412(ra) # 80005c56 <panic>

00000000800061e2 <pop_off>:

void
pop_off(void)
{
    800061e2:	1141                	add	sp,sp,-16
    800061e4:	e406                	sd	ra,8(sp)
    800061e6:	e022                	sd	s0,0(sp)
    800061e8:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    800061ea:	ffffb097          	auipc	ra,0xffffb
    800061ee:	ca4080e7          	jalr	-860(ra) # 80000e8e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061f2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061f6:	8b89                	and	a5,a5,2
  if(intr_get())
    800061f8:	e78d                	bnez	a5,80006222 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061fa:	5d3c                	lw	a5,120(a0)
    800061fc:	02f05b63          	blez	a5,80006232 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006200:	37fd                	addw	a5,a5,-1
    80006202:	0007871b          	sext.w	a4,a5
    80006206:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006208:	eb09                	bnez	a4,8000621a <pop_off+0x38>
    8000620a:	5d7c                	lw	a5,124(a0)
    8000620c:	c799                	beqz	a5,8000621a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000620e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006212:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006216:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000621a:	60a2                	ld	ra,8(sp)
    8000621c:	6402                	ld	s0,0(sp)
    8000621e:	0141                	add	sp,sp,16
    80006220:	8082                	ret
    panic("pop_off - interruptible");
    80006222:	00002517          	auipc	a0,0x2
    80006226:	6f650513          	add	a0,a0,1782 # 80008918 <digits+0x28>
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	a2c080e7          	jalr	-1492(ra) # 80005c56 <panic>
    panic("pop_off");
    80006232:	00002517          	auipc	a0,0x2
    80006236:	6fe50513          	add	a0,a0,1790 # 80008930 <digits+0x40>
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	a1c080e7          	jalr	-1508(ra) # 80005c56 <panic>

0000000080006242 <release>:
{
    80006242:	1101                	add	sp,sp,-32
    80006244:	ec06                	sd	ra,24(sp)
    80006246:	e822                	sd	s0,16(sp)
    80006248:	e426                	sd	s1,8(sp)
    8000624a:	1000                	add	s0,sp,32
    8000624c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	ec6080e7          	jalr	-314(ra) # 80006114 <holding>
    80006256:	c115                	beqz	a0,8000627a <release+0x38>
  lk->cpu = 0;
    80006258:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000625c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006260:	0f50000f          	fence	iorw,ow
    80006264:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	f7a080e7          	jalr	-134(ra) # 800061e2 <pop_off>
}
    80006270:	60e2                	ld	ra,24(sp)
    80006272:	6442                	ld	s0,16(sp)
    80006274:	64a2                	ld	s1,8(sp)
    80006276:	6105                	add	sp,sp,32
    80006278:	8082                	ret
    panic("release");
    8000627a:	00002517          	auipc	a0,0x2
    8000627e:	6be50513          	add	a0,a0,1726 # 80008938 <digits+0x48>
    80006282:	00000097          	auipc	ra,0x0
    80006286:	9d4080e7          	jalr	-1580(ra) # 80005c56 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
