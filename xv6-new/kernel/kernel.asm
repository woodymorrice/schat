
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0003a117          	auipc	sp,0x3a
    80000004:	02010113          	add	sp,sp,32 # 8003a020 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	201050ef          	jal	80005a16 <start>

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
  /* Begin CMPT 332 group14 change Fall 2023 */
  int index;

  index = RCIND((uint64)pa);
    80000028:	800007b7          	lui	a5,0x80000
    8000002c:	97aa                	add	a5,a5,a0
    8000002e:	83b1                	srl	a5,a5,0xc
    80000030:	0007849b          	sext.w	s1,a5
  /* End CMPT 332 group14 change Fall 2023 */

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000034:	03451793          	sll	a5,a0,0x34
    80000038:	e3ad                	bnez	a5,8000009a <kfree+0x7e>
    8000003a:	892a                	mv	s2,a0
    8000003c:	00042797          	auipc	a5,0x42
    80000040:	0e478793          	add	a5,a5,228 # 80042120 <end>
    80000044:	04f56b63          	bltu	a0,a5,8000009a <kfree+0x7e>
    80000048:	47c5                	li	a5,17
    8000004a:	07ee                	sll	a5,a5,0x1b
    8000004c:	04f57763          	bgeu	a0,a5,8000009a <kfree+0x7e>
    panic("kfree");

  acquire(&kmem.lock);
    80000050:	00009517          	auipc	a0,0x9
    80000054:	a5050513          	add	a0,a0,-1456 # 80008aa0 <kmem>
    80000058:	00006097          	auipc	ra,0x6
    8000005c:	3a6080e7          	jalr	934(ra) # 800063fe <acquire>
  kmem.refcount[index]--;
    80000060:	00848793          	add	a5,s1,8
    80000064:	078a                	sll	a5,a5,0x2
    80000066:	00009717          	auipc	a4,0x9
    8000006a:	a3a70713          	add	a4,a4,-1478 # 80008aa0 <kmem>
    8000006e:	97ba                	add	a5,a5,a4
    80000070:	4398                	lw	a4,0(a5)
    80000072:	377d                	addw	a4,a4,-1
    80000074:	0007069b          	sext.w	a3,a4
    80000078:	c398                	sw	a4,0(a5)
  /* Begin CMPT 332 group14 change Fall 2023 */
  if ((kmem.refcount[index] < 1)) {
    8000007a:	02d05863          	blez	a3,800000aa <kfree+0x8e>
    kmem.freelist = r; 

    kmem.freecount++;
  }
  /* End CMPT 332 group14 change Fall 2023 */
  release(&kmem.lock);
    8000007e:	00009517          	auipc	a0,0x9
    80000082:	a2250513          	add	a0,a0,-1502 # 80008aa0 <kmem>
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	42c080e7          	jalr	1068(ra) # 800064b2 <release>
}
    8000008e:	60e2                	ld	ra,24(sp)
    80000090:	6442                	ld	s0,16(sp)
    80000092:	64a2                	ld	s1,8(sp)
    80000094:	6902                	ld	s2,0(sp)
    80000096:	6105                	add	sp,sp,32
    80000098:	8082                	ret
    panic("kfree");
    8000009a:	00008517          	auipc	a0,0x8
    8000009e:	f7650513          	add	a0,a0,-138 # 80008010 <etext+0x10>
    800000a2:	00006097          	auipc	ra,0x6
    800000a6:	e24080e7          	jalr	-476(ra) # 80005ec6 <panic>
    memset(pa, 1, PGSIZE);
    800000aa:	6605                	lui	a2,0x1
    800000ac:	4585                	li	a1,1
    800000ae:	854a                	mv	a0,s2
    800000b0:	00000097          	auipc	ra,0x0
    800000b4:	258080e7          	jalr	600(ra) # 80000308 <memset>
    r->next = kmem.freelist;
    800000b8:	00009797          	auipc	a5,0x9
    800000bc:	9e878793          	add	a5,a5,-1560 # 80008aa0 <kmem>
    800000c0:	6f98                	ld	a4,24(a5)
    800000c2:	00e93023          	sd	a4,0(s2)
    kmem.freelist = r; 
    800000c6:	0127bc23          	sd	s2,24(a5)
    kmem.freecount++;
    800000ca:	00029717          	auipc	a4,0x29
    800000ce:	9d670713          	add	a4,a4,-1578 # 80028aa0 <kmem+0x20000>
    800000d2:	531c                	lw	a5,32(a4)
    800000d4:	2785                	addw	a5,a5,1
    800000d6:	d31c                	sw	a5,32(a4)
    800000d8:	b75d                	j	8000007e <kfree+0x62>

00000000800000da <freerange>:
{
    800000da:	7139                	add	sp,sp,-64
    800000dc:	fc06                	sd	ra,56(sp)
    800000de:	f822                	sd	s0,48(sp)
    800000e0:	f426                	sd	s1,40(sp)
    800000e2:	f04a                	sd	s2,32(sp)
    800000e4:	ec4e                	sd	s3,24(sp)
    800000e6:	e852                	sd	s4,16(sp)
    800000e8:	e456                	sd	s5,8(sp)
    800000ea:	e05a                	sd	s6,0(sp)
    800000ec:	0080                	add	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ee:	6785                	lui	a5,0x1
    800000f0:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000f4:	00e504b3          	add	s1,a0,a4
    800000f8:	777d                	lui	a4,0xfffff
    800000fa:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    800000fc:	94be                	add	s1,s1,a5
    800000fe:	0295ef63          	bltu	a1,s1,8000013c <freerange+0x62>
    80000102:	89ae                	mv	s3,a1
    kmem.refcount[index] = 0;
    80000104:	00009b17          	auipc	s6,0x9
    80000108:	99cb0b13          	add	s6,s6,-1636 # 80008aa0 <kmem>
    index = RCIND((uint64)p);
    8000010c:	fff80937          	lui	s2,0xfff80
    80000110:	197d                	add	s2,s2,-1 # fffffffffff7ffff <end+0xffffffff7ff3dedf>
    80000112:	0932                	sll	s2,s2,0xc
    kfree(p);
    80000114:	7afd                	lui	s5,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000116:	6a05                	lui	s4,0x1
    index = RCIND((uint64)p);
    80000118:	012487b3          	add	a5,s1,s2
    8000011c:	83b1                	srl	a5,a5,0xc
    kmem.refcount[index] = 0;
    8000011e:	2781                	sext.w	a5,a5
    80000120:	07a1                	add	a5,a5,8
    80000122:	078a                	sll	a5,a5,0x2
    80000124:	97da                	add	a5,a5,s6
    80000126:	0007a023          	sw	zero,0(a5)
    kfree(p);
    8000012a:	01548533          	add	a0,s1,s5
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	eee080e7          	jalr	-274(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000136:	94d2                	add	s1,s1,s4
    80000138:	fe99f0e3          	bgeu	s3,s1,80000118 <freerange+0x3e>
}
    8000013c:	70e2                	ld	ra,56(sp)
    8000013e:	7442                	ld	s0,48(sp)
    80000140:	74a2                	ld	s1,40(sp)
    80000142:	7902                	ld	s2,32(sp)
    80000144:	69e2                	ld	s3,24(sp)
    80000146:	6a42                	ld	s4,16(sp)
    80000148:	6aa2                	ld	s5,8(sp)
    8000014a:	6b02                	ld	s6,0(sp)
    8000014c:	6121                	add	sp,sp,64
    8000014e:	8082                	ret

0000000080000150 <kinit>:
{
    80000150:	1141                	add	sp,sp,-16
    80000152:	e406                	sd	ra,8(sp)
    80000154:	e022                	sd	s0,0(sp)
    80000156:	0800                	add	s0,sp,16
  kmem.freecount = 0; /* don't need lock here */
    80000158:	00029797          	auipc	a5,0x29
    8000015c:	9607a423          	sw	zero,-1688(a5) # 80028ac0 <kmem+0x20020>
  initlock(&kmem.lock, "kmem");
    80000160:	00008597          	auipc	a1,0x8
    80000164:	eb858593          	add	a1,a1,-328 # 80008018 <etext+0x18>
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	93850513          	add	a0,a0,-1736 # 80008aa0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1fe080e7          	jalr	510(ra) # 8000636e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000178:	45c5                	li	a1,17
    8000017a:	05ee                	sll	a1,a1,0x1b
    8000017c:	00042517          	auipc	a0,0x42
    80000180:	fa450513          	add	a0,a0,-92 # 80042120 <end>
    80000184:	00000097          	auipc	ra,0x0
    80000188:	f56080e7          	jalr	-170(ra) # 800000da <freerange>
}
    8000018c:	60a2                	ld	ra,8(sp)
    8000018e:	6402                	ld	s0,0(sp)
    80000190:	0141                	add	sp,sp,16
    80000192:	8082                	ret

0000000080000194 <kalloc>:
/* Allocate one 4096-byte page of physical memory. */
/* Returns a pointer that the kernel can use. */
/* Returns 0 if the memory cannot be allocated. */
void *
kalloc(void)
{
    80000194:	1101                	add	sp,sp,-32
    80000196:	ec06                	sd	ra,24(sp)
    80000198:	e822                	sd	s0,16(sp)
    8000019a:	e426                	sd	s1,8(sp)
    8000019c:	1000                	add	s0,sp,32
  struct run *r;
  /* Begin CMPT 332 group14 change Fall 2023 */
  int index;
  /* End CMPT 332 group14 change Fall 2023 */

  acquire(&kmem.lock);
    8000019e:	00009517          	auipc	a0,0x9
    800001a2:	90250513          	add	a0,a0,-1790 # 80008aa0 <kmem>
    800001a6:	00006097          	auipc	ra,0x6
    800001aa:	258080e7          	jalr	600(ra) # 800063fe <acquire>
  r = kmem.freelist;
    800001ae:	00009497          	auipc	s1,0x9
    800001b2:	90a4b483          	ld	s1,-1782(s1) # 80008ab8 <kmem+0x18>
  /* Begin CMPT 332 group14 change Fall 2023 */
  index = RCIND((uint64)r);
    800001b6:	800007b7          	lui	a5,0x80000
    800001ba:	97a6                	add	a5,a5,s1
    800001bc:	83b1                	srl	a5,a5,0xc
    800001be:	2781                	sext.w	a5,a5
  if(r)
    800001c0:	c4a1                	beqz	s1,80000208 <kalloc+0x74>
    kmem.freelist = r->next;
    800001c2:	6098                	ld	a4,0(s1)
    800001c4:	00009517          	auipc	a0,0x9
    800001c8:	8dc50513          	add	a0,a0,-1828 # 80008aa0 <kmem>
    800001cc:	ed18                	sd	a4,24(a0)
  kmem.refcount[index] = 1;
    800001ce:	07a1                	add	a5,a5,8 # ffffffff80000008 <end+0xfffffffefffbdee8>
    800001d0:	078a                	sll	a5,a5,0x2
    800001d2:	97aa                	add	a5,a5,a0
    800001d4:	4705                	li	a4,1
    800001d6:	c398                	sw	a4,0(a5)

  kmem.freecount--;
    800001d8:	00029717          	auipc	a4,0x29
    800001dc:	8c870713          	add	a4,a4,-1848 # 80028aa0 <kmem+0x20000>
    800001e0:	531c                	lw	a5,32(a4)
    800001e2:	37fd                	addw	a5,a5,-1
    800001e4:	d31c                	sw	a5,32(a4)
  /* End CMPT 332 group14 change Fall 2023 */
  release(&kmem.lock);
    800001e6:	00006097          	auipc	ra,0x6
    800001ea:	2cc080e7          	jalr	716(ra) # 800064b2 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); /* fill with junk */
    800001ee:	6605                	lui	a2,0x1
    800001f0:	4595                	li	a1,5
    800001f2:	8526                	mv	a0,s1
    800001f4:	00000097          	auipc	ra,0x0
    800001f8:	114080e7          	jalr	276(ra) # 80000308 <memset>
  return (void*)r;
}
    800001fc:	8526                	mv	a0,s1
    800001fe:	60e2                	ld	ra,24(sp)
    80000200:	6442                	ld	s0,16(sp)
    80000202:	64a2                	ld	s1,8(sp)
    80000204:	6105                	add	sp,sp,32
    80000206:	8082                	ret
  kmem.refcount[index] = 1;
    80000208:	00009517          	auipc	a0,0x9
    8000020c:	89850513          	add	a0,a0,-1896 # 80008aa0 <kmem>
    80000210:	07a1                	add	a5,a5,8
    80000212:	078a                	sll	a5,a5,0x2
    80000214:	97aa                	add	a5,a5,a0
    80000216:	4705                	li	a4,1
    80000218:	c398                	sw	a4,0(a5)
  kmem.freecount--;
    8000021a:	00029717          	auipc	a4,0x29
    8000021e:	88670713          	add	a4,a4,-1914 # 80028aa0 <kmem+0x20000>
    80000222:	531c                	lw	a5,32(a4)
    80000224:	37fd                	addw	a5,a5,-1
    80000226:	d31c                	sw	a5,32(a4)
  release(&kmem.lock);
    80000228:	00006097          	auipc	ra,0x6
    8000022c:	28a080e7          	jalr	650(ra) # 800064b2 <release>
  if(r)
    80000230:	b7f1                	j	800001fc <kalloc+0x68>

0000000080000232 <nfree>:

/* Begin CMPT 332 group14 change Fall 2023 */
int
nfree(void)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e422                	sd	s0,8(sp)
    80000236:	0800                	add	s0,sp,16
  return kmem.freecount;
}
    80000238:	00029517          	auipc	a0,0x29
    8000023c:	88852503          	lw	a0,-1912(a0) # 80028ac0 <kmem+0x20020>
    80000240:	6422                	ld	s0,8(sp)
    80000242:	0141                	add	sp,sp,16
    80000244:	8082                	ret

0000000080000246 <ref_inc>:

void
ref_inc(void *p)
{
    80000246:	1101                	add	sp,sp,-32
    80000248:	ec06                	sd	ra,24(sp)
    8000024a:	e822                	sd	s0,16(sp)
    8000024c:	e426                	sd	s1,8(sp)
    8000024e:	1000                	add	s0,sp,32
  int index;
  index = RCIND((uint64)p);
    80000250:	800007b7          	lui	a5,0x80000
    80000254:	00f504b3          	add	s1,a0,a5
    80000258:	80b1                	srl	s1,s1,0xc
    8000025a:	2481                	sext.w	s1,s1
  acquire(&kmem.lock);
    8000025c:	00009517          	auipc	a0,0x9
    80000260:	84450513          	add	a0,a0,-1980 # 80008aa0 <kmem>
    80000264:	00006097          	auipc	ra,0x6
    80000268:	19a080e7          	jalr	410(ra) # 800063fe <acquire>
  kmem.refcount[index]++;
    8000026c:	00009517          	auipc	a0,0x9
    80000270:	83450513          	add	a0,a0,-1996 # 80008aa0 <kmem>
    80000274:	00848793          	add	a5,s1,8
    80000278:	078a                	sll	a5,a5,0x2
    8000027a:	97aa                	add	a5,a5,a0
    8000027c:	4398                	lw	a4,0(a5)
    8000027e:	2705                	addw	a4,a4,1
    80000280:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000282:	00006097          	auipc	ra,0x6
    80000286:	230080e7          	jalr	560(ra) # 800064b2 <release>
}
    8000028a:	60e2                	ld	ra,24(sp)
    8000028c:	6442                	ld	s0,16(sp)
    8000028e:	64a2                	ld	s1,8(sp)
    80000290:	6105                	add	sp,sp,32
    80000292:	8082                	ret

0000000080000294 <ref_dec>:

void
ref_dec(void *p)
{
    80000294:	1101                	add	sp,sp,-32
    80000296:	ec06                	sd	ra,24(sp)
    80000298:	e822                	sd	s0,16(sp)
    8000029a:	e426                	sd	s1,8(sp)
    8000029c:	1000                	add	s0,sp,32
  int index;
  index = RCIND((uint64)p);
    8000029e:	800007b7          	lui	a5,0x80000
    800002a2:	00f504b3          	add	s1,a0,a5
    800002a6:	80b1                	srl	s1,s1,0xc
    800002a8:	2481                	sext.w	s1,s1
  acquire(&kmem.lock);
    800002aa:	00008517          	auipc	a0,0x8
    800002ae:	7f650513          	add	a0,a0,2038 # 80008aa0 <kmem>
    800002b2:	00006097          	auipc	ra,0x6
    800002b6:	14c080e7          	jalr	332(ra) # 800063fe <acquire>
  kmem.refcount[index]--;
    800002ba:	00008517          	auipc	a0,0x8
    800002be:	7e650513          	add	a0,a0,2022 # 80008aa0 <kmem>
    800002c2:	00848793          	add	a5,s1,8
    800002c6:	078a                	sll	a5,a5,0x2
    800002c8:	97aa                	add	a5,a5,a0
    800002ca:	4398                	lw	a4,0(a5)
    800002cc:	377d                	addw	a4,a4,-1
    800002ce:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    800002d0:	00006097          	auipc	ra,0x6
    800002d4:	1e2080e7          	jalr	482(ra) # 800064b2 <release>
}
    800002d8:	60e2                	ld	ra,24(sp)
    800002da:	6442                	ld	s0,16(sp)
    800002dc:	64a2                	ld	s1,8(sp)
    800002de:	6105                	add	sp,sp,32
    800002e0:	8082                	ret

00000000800002e2 <ref_cnt>:

int
ref_cnt(void *p)
{
    800002e2:	1141                	add	sp,sp,-16
    800002e4:	e422                	sd	s0,8(sp)
    800002e6:	0800                	add	s0,sp,16
  int index;
  index = RCIND((uint64)p);
    800002e8:	800007b7          	lui	a5,0x80000
    800002ec:	97aa                	add	a5,a5,a0
    800002ee:	83b1                	srl	a5,a5,0xc
  return kmem.refcount[index];
    800002f0:	2781                	sext.w	a5,a5
    800002f2:	07a1                	add	a5,a5,8 # ffffffff80000008 <end+0xfffffffefffbdee8>
    800002f4:	078a                	sll	a5,a5,0x2
    800002f6:	00008717          	auipc	a4,0x8
    800002fa:	7aa70713          	add	a4,a4,1962 # 80008aa0 <kmem>
    800002fe:	97ba                	add	a5,a5,a4
}
    80000300:	4388                	lw	a0,0(a5)
    80000302:	6422                	ld	s0,8(sp)
    80000304:	0141                	add	sp,sp,16
    80000306:	8082                	ret

0000000080000308 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000308:	1141                	add	sp,sp,-16
    8000030a:	e422                	sd	s0,8(sp)
    8000030c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000030e:	ca19                	beqz	a2,80000324 <memset+0x1c>
    80000310:	87aa                	mv	a5,a0
    80000312:	1602                	sll	a2,a2,0x20
    80000314:	9201                	srl	a2,a2,0x20
    80000316:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000031a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000031e:	0785                	add	a5,a5,1
    80000320:	fee79de3          	bne	a5,a4,8000031a <memset+0x12>
  }
  return dst;
}
    80000324:	6422                	ld	s0,8(sp)
    80000326:	0141                	add	sp,sp,16
    80000328:	8082                	ret

000000008000032a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000032a:	1141                	add	sp,sp,-16
    8000032c:	e422                	sd	s0,8(sp)
    8000032e:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000330:	ca05                	beqz	a2,80000360 <memcmp+0x36>
    80000332:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000336:	1682                	sll	a3,a3,0x20
    80000338:	9281                	srl	a3,a3,0x20
    8000033a:	0685                	add	a3,a3,1
    8000033c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	0005c703          	lbu	a4,0(a1)
    80000346:	00e79863          	bne	a5,a4,80000356 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000034a:	0505                	add	a0,a0,1
    8000034c:	0585                	add	a1,a1,1
  while(n-- > 0){
    8000034e:	fed518e3          	bne	a0,a3,8000033e <memcmp+0x14>
  }

  return 0;
    80000352:	4501                	li	a0,0
    80000354:	a019                	j	8000035a <memcmp+0x30>
      return *s1 - *s2;
    80000356:	40e7853b          	subw	a0,a5,a4
}
    8000035a:	6422                	ld	s0,8(sp)
    8000035c:	0141                	add	sp,sp,16
    8000035e:	8082                	ret
  return 0;
    80000360:	4501                	li	a0,0
    80000362:	bfe5                	j	8000035a <memcmp+0x30>

0000000080000364 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000364:	1141                	add	sp,sp,-16
    80000366:	e422                	sd	s0,8(sp)
    80000368:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000036a:	c205                	beqz	a2,8000038a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000036c:	02a5e263          	bltu	a1,a0,80000390 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000370:	1602                	sll	a2,a2,0x20
    80000372:	9201                	srl	a2,a2,0x20
    80000374:	00c587b3          	add	a5,a1,a2
{
    80000378:	872a                	mv	a4,a0
      *d++ = *s++;
    8000037a:	0585                	add	a1,a1,1
    8000037c:	0705                	add	a4,a4,1
    8000037e:	fff5c683          	lbu	a3,-1(a1)
    80000382:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000386:	fef59ae3          	bne	a1,a5,8000037a <memmove+0x16>

  return dst;
}
    8000038a:	6422                	ld	s0,8(sp)
    8000038c:	0141                	add	sp,sp,16
    8000038e:	8082                	ret
  if(s < d && s + n > d){
    80000390:	02061693          	sll	a3,a2,0x20
    80000394:	9281                	srl	a3,a3,0x20
    80000396:	00d58733          	add	a4,a1,a3
    8000039a:	fce57be3          	bgeu	a0,a4,80000370 <memmove+0xc>
    d += n;
    8000039e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800003a0:	fff6079b          	addw	a5,a2,-1
    800003a4:	1782                	sll	a5,a5,0x20
    800003a6:	9381                	srl	a5,a5,0x20
    800003a8:	fff7c793          	not	a5,a5
    800003ac:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800003ae:	177d                	add	a4,a4,-1
    800003b0:	16fd                	add	a3,a3,-1
    800003b2:	00074603          	lbu	a2,0(a4)
    800003b6:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003ba:	fee79ae3          	bne	a5,a4,800003ae <memmove+0x4a>
    800003be:	b7f1                	j	8000038a <memmove+0x26>

00000000800003c0 <memcpy>:

/* memcpy exists to placate GCC.  Use memmove. */
void*
memcpy(void *dst, const void *src, uint n)
{
    800003c0:	1141                	add	sp,sp,-16
    800003c2:	e406                	sd	ra,8(sp)
    800003c4:	e022                	sd	s0,0(sp)
    800003c6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    800003c8:	00000097          	auipc	ra,0x0
    800003cc:	f9c080e7          	jalr	-100(ra) # 80000364 <memmove>
}
    800003d0:	60a2                	ld	ra,8(sp)
    800003d2:	6402                	ld	s0,0(sp)
    800003d4:	0141                	add	sp,sp,16
    800003d6:	8082                	ret

00000000800003d8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003d8:	1141                	add	sp,sp,-16
    800003da:	e422                	sd	s0,8(sp)
    800003dc:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003de:	ce11                	beqz	a2,800003fa <strncmp+0x22>
    800003e0:	00054783          	lbu	a5,0(a0)
    800003e4:	cf89                	beqz	a5,800003fe <strncmp+0x26>
    800003e6:	0005c703          	lbu	a4,0(a1)
    800003ea:	00f71a63          	bne	a4,a5,800003fe <strncmp+0x26>
    n--, p++, q++;
    800003ee:	367d                	addw	a2,a2,-1
    800003f0:	0505                	add	a0,a0,1
    800003f2:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003f4:	f675                	bnez	a2,800003e0 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003f6:	4501                	li	a0,0
    800003f8:	a809                	j	8000040a <strncmp+0x32>
    800003fa:	4501                	li	a0,0
    800003fc:	a039                	j	8000040a <strncmp+0x32>
  if(n == 0)
    800003fe:	ca09                	beqz	a2,80000410 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000400:	00054503          	lbu	a0,0(a0)
    80000404:	0005c783          	lbu	a5,0(a1)
    80000408:	9d1d                	subw	a0,a0,a5
}
    8000040a:	6422                	ld	s0,8(sp)
    8000040c:	0141                	add	sp,sp,16
    8000040e:	8082                	ret
    return 0;
    80000410:	4501                	li	a0,0
    80000412:	bfe5                	j	8000040a <strncmp+0x32>

0000000080000414 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000414:	1141                	add	sp,sp,-16
    80000416:	e422                	sd	s0,8(sp)
    80000418:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000041a:	87aa                	mv	a5,a0
    8000041c:	86b2                	mv	a3,a2
    8000041e:	367d                	addw	a2,a2,-1
    80000420:	00d05963          	blez	a3,80000432 <strncpy+0x1e>
    80000424:	0785                	add	a5,a5,1
    80000426:	0005c703          	lbu	a4,0(a1)
    8000042a:	fee78fa3          	sb	a4,-1(a5)
    8000042e:	0585                	add	a1,a1,1
    80000430:	f775                	bnez	a4,8000041c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000432:	873e                	mv	a4,a5
    80000434:	9fb5                	addw	a5,a5,a3
    80000436:	37fd                	addw	a5,a5,-1
    80000438:	00c05963          	blez	a2,8000044a <strncpy+0x36>
    *s++ = 0;
    8000043c:	0705                	add	a4,a4,1
    8000043e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000442:	40e786bb          	subw	a3,a5,a4
    80000446:	fed04be3          	bgtz	a3,8000043c <strncpy+0x28>
  return os;
}
    8000044a:	6422                	ld	s0,8(sp)
    8000044c:	0141                	add	sp,sp,16
    8000044e:	8082                	ret

0000000080000450 <safestrcpy>:

/* Like strncpy but guaranteed to NUL-terminate. */
char*
safestrcpy(char *s, const char *t, int n)
{
    80000450:	1141                	add	sp,sp,-16
    80000452:	e422                	sd	s0,8(sp)
    80000454:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000456:	02c05363          	blez	a2,8000047c <safestrcpy+0x2c>
    8000045a:	fff6069b          	addw	a3,a2,-1
    8000045e:	1682                	sll	a3,a3,0x20
    80000460:	9281                	srl	a3,a3,0x20
    80000462:	96ae                	add	a3,a3,a1
    80000464:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000466:	00d58963          	beq	a1,a3,80000478 <safestrcpy+0x28>
    8000046a:	0585                	add	a1,a1,1
    8000046c:	0785                	add	a5,a5,1
    8000046e:	fff5c703          	lbu	a4,-1(a1)
    80000472:	fee78fa3          	sb	a4,-1(a5)
    80000476:	fb65                	bnez	a4,80000466 <safestrcpy+0x16>
    ;
  *s = 0;
    80000478:	00078023          	sb	zero,0(a5)
  return os;
}
    8000047c:	6422                	ld	s0,8(sp)
    8000047e:	0141                	add	sp,sp,16
    80000480:	8082                	ret

0000000080000482 <strlen>:

int
strlen(const char *s)
{
    80000482:	1141                	add	sp,sp,-16
    80000484:	e422                	sd	s0,8(sp)
    80000486:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000488:	00054783          	lbu	a5,0(a0)
    8000048c:	cf91                	beqz	a5,800004a8 <strlen+0x26>
    8000048e:	0505                	add	a0,a0,1
    80000490:	87aa                	mv	a5,a0
    80000492:	86be                	mv	a3,a5
    80000494:	0785                	add	a5,a5,1
    80000496:	fff7c703          	lbu	a4,-1(a5)
    8000049a:	ff65                	bnez	a4,80000492 <strlen+0x10>
    8000049c:	40a6853b          	subw	a0,a3,a0
    800004a0:	2505                	addw	a0,a0,1
    ;
  return n;
}
    800004a2:	6422                	ld	s0,8(sp)
    800004a4:	0141                	add	sp,sp,16
    800004a6:	8082                	ret
  for(n = 0; s[n]; n++)
    800004a8:	4501                	li	a0,0
    800004aa:	bfe5                	j	800004a2 <strlen+0x20>

00000000800004ac <main>:
volatile static int started = 0;

/* start() jumps here in supervisor mode on all CPUs. */
void
main()
{
    800004ac:	1141                	add	sp,sp,-16
    800004ae:	e406                	sd	ra,8(sp)
    800004b0:	e022                	sd	s0,0(sp)
    800004b2:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    800004b4:	00001097          	auipc	ra,0x1
    800004b8:	b4c080e7          	jalr	-1204(ra) # 80001000 <cpuid>
    virtio_disk_init(); /* emulated hard disk */
    userinit();      /* first user process */
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800004bc:	00008717          	auipc	a4,0x8
    800004c0:	5b470713          	add	a4,a4,1460 # 80008a70 <started>
  if(cpuid() == 0){
    800004c4:	c139                	beqz	a0,8000050a <main+0x5e>
    while(started == 0)
    800004c6:	431c                	lw	a5,0(a4)
    800004c8:	2781                	sext.w	a5,a5
    800004ca:	dff5                	beqz	a5,800004c6 <main+0x1a>
      ;
    __sync_synchronize();
    800004cc:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004d0:	00001097          	auipc	ra,0x1
    800004d4:	b30080e7          	jalr	-1232(ra) # 80001000 <cpuid>
    800004d8:	85aa                	mv	a1,a0
    800004da:	00008517          	auipc	a0,0x8
    800004de:	b5e50513          	add	a0,a0,-1186 # 80008038 <etext+0x38>
    800004e2:	00006097          	auipc	ra,0x6
    800004e6:	a2e080e7          	jalr	-1490(ra) # 80005f10 <printf>
    kvminithart();    /* turn on paging */
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	0d8080e7          	jalr	216(ra) # 800005c2 <kvminithart>
    trapinithart();   /* install kernel trap vector */
    800004f2:	00002097          	auipc	ra,0x2
    800004f6:	806080e7          	jalr	-2042(ra) # 80001cf8 <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    800004fa:	00005097          	auipc	ra,0x5
    800004fe:	ed6080e7          	jalr	-298(ra) # 800053d0 <plicinithart>
  }

  scheduler();        
    80000502:	00001097          	auipc	ra,0x1
    80000506:	02c080e7          	jalr	44(ra) # 8000152e <scheduler>
    consoleinit();
    8000050a:	00006097          	auipc	ra,0x6
    8000050e:	8cc080e7          	jalr	-1844(ra) # 80005dd6 <consoleinit>
    printfinit();
    80000512:	00006097          	auipc	ra,0x6
    80000516:	bde080e7          	jalr	-1058(ra) # 800060f0 <printfinit>
    printf("\n");
    8000051a:	00008517          	auipc	a0,0x8
    8000051e:	b2e50513          	add	a0,a0,-1234 # 80008048 <etext+0x48>
    80000522:	00006097          	auipc	ra,0x6
    80000526:	9ee080e7          	jalr	-1554(ra) # 80005f10 <printf>
    printf("xv6 kernel is booting\n");
    8000052a:	00008517          	auipc	a0,0x8
    8000052e:	af650513          	add	a0,a0,-1290 # 80008020 <etext+0x20>
    80000532:	00006097          	auipc	ra,0x6
    80000536:	9de080e7          	jalr	-1570(ra) # 80005f10 <printf>
    printf("\n");
    8000053a:	00008517          	auipc	a0,0x8
    8000053e:	b0e50513          	add	a0,a0,-1266 # 80008048 <etext+0x48>
    80000542:	00006097          	auipc	ra,0x6
    80000546:	9ce080e7          	jalr	-1586(ra) # 80005f10 <printf>
    kinit();         /* physical page allocator */
    8000054a:	00000097          	auipc	ra,0x0
    8000054e:	c06080e7          	jalr	-1018(ra) # 80000150 <kinit>
    kvminit();       /* create kernel page table */
    80000552:	00000097          	auipc	ra,0x0
    80000556:	34a080e7          	jalr	842(ra) # 8000089c <kvminit>
    kvminithart();   /* turn on paging */
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	068080e7          	jalr	104(ra) # 800005c2 <kvminithart>
    procinit();      /* process table */
    80000562:	00001097          	auipc	ra,0x1
    80000566:	9ea080e7          	jalr	-1558(ra) # 80000f4c <procinit>
    trapinit();      /* trap vectors */
    8000056a:	00001097          	auipc	ra,0x1
    8000056e:	766080e7          	jalr	1894(ra) # 80001cd0 <trapinit>
    trapinithart();  /* install kernel trap vector */
    80000572:	00001097          	auipc	ra,0x1
    80000576:	786080e7          	jalr	1926(ra) # 80001cf8 <trapinithart>
    plicinit();      /* set up interrupt controller */
    8000057a:	00005097          	auipc	ra,0x5
    8000057e:	e40080e7          	jalr	-448(ra) # 800053ba <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80000582:	00005097          	auipc	ra,0x5
    80000586:	e4e080e7          	jalr	-434(ra) # 800053d0 <plicinithart>
    binit();         /* buffer cache */
    8000058a:	00002097          	auipc	ra,0x2
    8000058e:	044080e7          	jalr	68(ra) # 800025ce <binit>
    iinit();         /* inode table */
    80000592:	00002097          	auipc	ra,0x2
    80000596:	6e2080e7          	jalr	1762(ra) # 80002c74 <iinit>
    fileinit();      /* file table */
    8000059a:	00003097          	auipc	ra,0x3
    8000059e:	658080e7          	jalr	1624(ra) # 80003bf2 <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    800005a2:	00005097          	auipc	ra,0x5
    800005a6:	f36080e7          	jalr	-202(ra) # 800054d8 <virtio_disk_init>
    userinit();      /* first user process */
    800005aa:	00001097          	auipc	ra,0x1
    800005ae:	d5e080e7          	jalr	-674(ra) # 80001308 <userinit>
    __sync_synchronize();
    800005b2:	0ff0000f          	fence
    started = 1;
    800005b6:	4785                	li	a5,1
    800005b8:	00008717          	auipc	a4,0x8
    800005bc:	4af72c23          	sw	a5,1208(a4) # 80008a70 <started>
    800005c0:	b789                	j	80000502 <main+0x56>

00000000800005c2 <kvminithart>:

/* Switch h/w page table register to the kernel's page table, */
/* and enable paging. */
void
kvminithart()
{
    800005c2:	1141                	add	sp,sp,-16
    800005c4:	e422                	sd	s0,8(sp)
    800005c6:	0800                	add	s0,sp,16
/* flush the TLB. */
static inline void
sfence_vma()
{
  /* the zero, zero means flush all TLB entries. */
  asm volatile("sfence.vma zero, zero");
    800005c8:	12000073          	sfence.vma
  /* wait for any previous writes to the page table memory to finish. */
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800005cc:	00008797          	auipc	a5,0x8
    800005d0:	4ac7b783          	ld	a5,1196(a5) # 80008a78 <kernel_pagetable>
    800005d4:	83b1                	srl	a5,a5,0xc
    800005d6:	577d                	li	a4,-1
    800005d8:	177e                	sll	a4,a4,0x3f
    800005da:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800005dc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800005e0:	12000073          	sfence.vma

  /* flush stale entries from the TLB. */
  sfence_vma();
}
    800005e4:	6422                	ld	s0,8(sp)
    800005e6:	0141                	add	sp,sp,16
    800005e8:	8082                	ret

00000000800005ea <walk>:
/*   21..29 -- 9 bits of level-1 index. */
/*   12..20 -- 9 bits of level-0 index. */
/*    0..11 -- 12 bits of byte offset within the page. */
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005ea:	7139                	add	sp,sp,-64
    800005ec:	fc06                	sd	ra,56(sp)
    800005ee:	f822                	sd	s0,48(sp)
    800005f0:	f426                	sd	s1,40(sp)
    800005f2:	f04a                	sd	s2,32(sp)
    800005f4:	ec4e                	sd	s3,24(sp)
    800005f6:	e852                	sd	s4,16(sp)
    800005f8:	e456                	sd	s5,8(sp)
    800005fa:	e05a                	sd	s6,0(sp)
    800005fc:	0080                	add	s0,sp,64
    800005fe:	84aa                	mv	s1,a0
    80000600:	89ae                	mv	s3,a1
    80000602:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000604:	57fd                	li	a5,-1
    80000606:	83e9                	srl	a5,a5,0x1a
    80000608:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000060a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000060c:	04b7f263          	bgeu	a5,a1,80000650 <walk+0x66>
    panic("walk");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a4050513          	add	a0,a0,-1472 # 80008050 <etext+0x50>
    80000618:	00006097          	auipc	ra,0x6
    8000061c:	8ae080e7          	jalr	-1874(ra) # 80005ec6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000620:	060a8663          	beqz	s5,8000068c <walk+0xa2>
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b70080e7          	jalr	-1168(ra) # 80000194 <kalloc>
    8000062c:	84aa                	mv	s1,a0
    8000062e:	c529                	beqz	a0,80000678 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000630:	6605                	lui	a2,0x1
    80000632:	4581                	li	a1,0
    80000634:	00000097          	auipc	ra,0x0
    80000638:	cd4080e7          	jalr	-812(ra) # 80000308 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000063c:	00c4d793          	srl	a5,s1,0xc
    80000640:	07aa                	sll	a5,a5,0xa
    80000642:	0017e793          	or	a5,a5,1
    80000646:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000064a:	3a5d                	addw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    8000064c:	036a0063          	beq	s4,s6,8000066c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000650:	0149d933          	srl	s2,s3,s4
    80000654:	1ff97913          	and	s2,s2,511
    80000658:	090e                	sll	s2,s2,0x3
    8000065a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000065c:	00093483          	ld	s1,0(s2)
    80000660:	0014f793          	and	a5,s1,1
    80000664:	dfd5                	beqz	a5,80000620 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000666:	80a9                	srl	s1,s1,0xa
    80000668:	04b2                	sll	s1,s1,0xc
    8000066a:	b7c5                	j	8000064a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000066c:	00c9d513          	srl	a0,s3,0xc
    80000670:	1ff57513          	and	a0,a0,511
    80000674:	050e                	sll	a0,a0,0x3
    80000676:	9526                	add	a0,a0,s1
}
    80000678:	70e2                	ld	ra,56(sp)
    8000067a:	7442                	ld	s0,48(sp)
    8000067c:	74a2                	ld	s1,40(sp)
    8000067e:	7902                	ld	s2,32(sp)
    80000680:	69e2                	ld	s3,24(sp)
    80000682:	6a42                	ld	s4,16(sp)
    80000684:	6aa2                	ld	s5,8(sp)
    80000686:	6b02                	ld	s6,0(sp)
    80000688:	6121                	add	sp,sp,64
    8000068a:	8082                	ret
        return 0;
    8000068c:	4501                	li	a0,0
    8000068e:	b7ed                	j	80000678 <walk+0x8e>

0000000080000690 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000690:	57fd                	li	a5,-1
    80000692:	83e9                	srl	a5,a5,0x1a
    80000694:	00b7f463          	bgeu	a5,a1,8000069c <walkaddr+0xc>
    return 0;
    80000698:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000069a:	8082                	ret
{
    8000069c:	1141                	add	sp,sp,-16
    8000069e:	e406                	sd	ra,8(sp)
    800006a0:	e022                	sd	s0,0(sp)
    800006a2:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    800006a4:	4601                	li	a2,0
    800006a6:	00000097          	auipc	ra,0x0
    800006aa:	f44080e7          	jalr	-188(ra) # 800005ea <walk>
  if(pte == 0)
    800006ae:	c105                	beqz	a0,800006ce <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800006b0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800006b2:	0117f693          	and	a3,a5,17
    800006b6:	4745                	li	a4,17
    return 0;
    800006b8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800006ba:	00e68663          	beq	a3,a4,800006c6 <walkaddr+0x36>
}
    800006be:	60a2                	ld	ra,8(sp)
    800006c0:	6402                	ld	s0,0(sp)
    800006c2:	0141                	add	sp,sp,16
    800006c4:	8082                	ret
  pa = PTE2PA(*pte);
    800006c6:	83a9                	srl	a5,a5,0xa
    800006c8:	00c79513          	sll	a0,a5,0xc
  return pa;
    800006cc:	bfcd                	j	800006be <walkaddr+0x2e>
    return 0;
    800006ce:	4501                	li	a0,0
    800006d0:	b7fd                	j	800006be <walkaddr+0x2e>

00000000800006d2 <mappages>:
/* va and size MUST be page-aligned. */
/* Returns 0 on success, -1 if walk() couldn't */
/* allocate a needed page-table page. */
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006d2:	715d                	add	sp,sp,-80
    800006d4:	e486                	sd	ra,72(sp)
    800006d6:	e0a2                	sd	s0,64(sp)
    800006d8:	fc26                	sd	s1,56(sp)
    800006da:	f84a                	sd	s2,48(sp)
    800006dc:	f44e                	sd	s3,40(sp)
    800006de:	f052                	sd	s4,32(sp)
    800006e0:	ec56                	sd	s5,24(sp)
    800006e2:	e85a                	sd	s6,16(sp)
    800006e4:	e45e                	sd	s7,8(sp)
    800006e6:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800006e8:	03459793          	sll	a5,a1,0x34
    800006ec:	e7b9                	bnez	a5,8000073a <mappages+0x68>
    800006ee:	8aaa                	mv	s5,a0
    800006f0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800006f2:	03461793          	sll	a5,a2,0x34
    800006f6:	ebb1                	bnez	a5,8000074a <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    800006f8:	c22d                	beqz	a2,8000075a <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800006fa:	77fd                	lui	a5,0xfffff
    800006fc:	963e                	add	a2,a2,a5
    800006fe:	00b609b3          	add	s3,a2,a1
  a = va;
    80000702:	892e                	mv	s2,a1
    80000704:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000708:	6b85                	lui	s7,0x1
    8000070a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000070e:	4605                	li	a2,1
    80000710:	85ca                	mv	a1,s2
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	ed6080e7          	jalr	-298(ra) # 800005ea <walk>
    8000071c:	cd39                	beqz	a0,8000077a <mappages+0xa8>
    if(*pte & PTE_V)
    8000071e:	611c                	ld	a5,0(a0)
    80000720:	8b85                	and	a5,a5,1
    80000722:	e7a1                	bnez	a5,8000076a <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000724:	80b1                	srl	s1,s1,0xc
    80000726:	04aa                	sll	s1,s1,0xa
    80000728:	0164e4b3          	or	s1,s1,s6
    8000072c:	0014e493          	or	s1,s1,1
    80000730:	e104                	sd	s1,0(a0)
    if(a == last)
    80000732:	07390063          	beq	s2,s3,80000792 <mappages+0xc0>
    a += PGSIZE;
    80000736:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000738:	bfc9                	j	8000070a <mappages+0x38>
    panic("mappages: va not aligned");
    8000073a:	00008517          	auipc	a0,0x8
    8000073e:	91e50513          	add	a0,a0,-1762 # 80008058 <etext+0x58>
    80000742:	00005097          	auipc	ra,0x5
    80000746:	784080e7          	jalr	1924(ra) # 80005ec6 <panic>
    panic("mappages: size not aligned");
    8000074a:	00008517          	auipc	a0,0x8
    8000074e:	92e50513          	add	a0,a0,-1746 # 80008078 <etext+0x78>
    80000752:	00005097          	auipc	ra,0x5
    80000756:	774080e7          	jalr	1908(ra) # 80005ec6 <panic>
    panic("mappages: size");
    8000075a:	00008517          	auipc	a0,0x8
    8000075e:	93e50513          	add	a0,a0,-1730 # 80008098 <etext+0x98>
    80000762:	00005097          	auipc	ra,0x5
    80000766:	764080e7          	jalr	1892(ra) # 80005ec6 <panic>
      panic("mappages: remap");
    8000076a:	00008517          	auipc	a0,0x8
    8000076e:	93e50513          	add	a0,a0,-1730 # 800080a8 <etext+0xa8>
    80000772:	00005097          	auipc	ra,0x5
    80000776:	754080e7          	jalr	1876(ra) # 80005ec6 <panic>
      return -1;
    8000077a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000077c:	60a6                	ld	ra,72(sp)
    8000077e:	6406                	ld	s0,64(sp)
    80000780:	74e2                	ld	s1,56(sp)
    80000782:	7942                	ld	s2,48(sp)
    80000784:	79a2                	ld	s3,40(sp)
    80000786:	7a02                	ld	s4,32(sp)
    80000788:	6ae2                	ld	s5,24(sp)
    8000078a:	6b42                	ld	s6,16(sp)
    8000078c:	6ba2                	ld	s7,8(sp)
    8000078e:	6161                	add	sp,sp,80
    80000790:	8082                	ret
  return 0;
    80000792:	4501                	li	a0,0
    80000794:	b7e5                	j	8000077c <mappages+0xaa>

0000000080000796 <kvmmap>:
{
    80000796:	1141                	add	sp,sp,-16
    80000798:	e406                	sd	ra,8(sp)
    8000079a:	e022                	sd	s0,0(sp)
    8000079c:	0800                	add	s0,sp,16
    8000079e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800007a0:	86b2                	mv	a3,a2
    800007a2:	863e                	mv	a2,a5
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	f2e080e7          	jalr	-210(ra) # 800006d2 <mappages>
    800007ac:	e509                	bnez	a0,800007b6 <kvmmap+0x20>
}
    800007ae:	60a2                	ld	ra,8(sp)
    800007b0:	6402                	ld	s0,0(sp)
    800007b2:	0141                	add	sp,sp,16
    800007b4:	8082                	ret
    panic("kvmmap");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	90250513          	add	a0,a0,-1790 # 800080b8 <etext+0xb8>
    800007be:	00005097          	auipc	ra,0x5
    800007c2:	708080e7          	jalr	1800(ra) # 80005ec6 <panic>

00000000800007c6 <kvmmake>:
{
    800007c6:	1101                	add	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	e04a                	sd	s2,0(sp)
    800007d0:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800007d2:	00000097          	auipc	ra,0x0
    800007d6:	9c2080e7          	jalr	-1598(ra) # 80000194 <kalloc>
    800007da:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800007dc:	6605                	lui	a2,0x1
    800007de:	4581                	li	a1,0
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	b28080e7          	jalr	-1240(ra) # 80000308 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007e8:	4719                	li	a4,6
    800007ea:	6685                	lui	a3,0x1
    800007ec:	10000637          	lui	a2,0x10000
    800007f0:	100005b7          	lui	a1,0x10000
    800007f4:	8526                	mv	a0,s1
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	fa0080e7          	jalr	-96(ra) # 80000796 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007fe:	4719                	li	a4,6
    80000800:	6685                	lui	a3,0x1
    80000802:	10001637          	lui	a2,0x10001
    80000806:	100015b7          	lui	a1,0x10001
    8000080a:	8526                	mv	a0,s1
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	f8a080e7          	jalr	-118(ra) # 80000796 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000814:	4719                	li	a4,6
    80000816:	004006b7          	lui	a3,0x400
    8000081a:	0c000637          	lui	a2,0xc000
    8000081e:	0c0005b7          	lui	a1,0xc000
    80000822:	8526                	mv	a0,s1
    80000824:	00000097          	auipc	ra,0x0
    80000828:	f72080e7          	jalr	-142(ra) # 80000796 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000082c:	00007917          	auipc	s2,0x7
    80000830:	7d490913          	add	s2,s2,2004 # 80008000 <etext>
    80000834:	4729                	li	a4,10
    80000836:	80007697          	auipc	a3,0x80007
    8000083a:	7ca68693          	add	a3,a3,1994 # 8000 <_entry-0x7fff8000>
    8000083e:	4605                	li	a2,1
    80000840:	067e                	sll	a2,a2,0x1f
    80000842:	85b2                	mv	a1,a2
    80000844:	8526                	mv	a0,s1
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	f50080e7          	jalr	-176(ra) # 80000796 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000084e:	4719                	li	a4,6
    80000850:	46c5                	li	a3,17
    80000852:	06ee                	sll	a3,a3,0x1b
    80000854:	412686b3          	sub	a3,a3,s2
    80000858:	864a                	mv	a2,s2
    8000085a:	85ca                	mv	a1,s2
    8000085c:	8526                	mv	a0,s1
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	f38080e7          	jalr	-200(ra) # 80000796 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000866:	4729                	li	a4,10
    80000868:	6685                	lui	a3,0x1
    8000086a:	00006617          	auipc	a2,0x6
    8000086e:	79660613          	add	a2,a2,1942 # 80007000 <_trampoline>
    80000872:	040005b7          	lui	a1,0x4000
    80000876:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000878:	05b2                	sll	a1,a1,0xc
    8000087a:	8526                	mv	a0,s1
    8000087c:	00000097          	auipc	ra,0x0
    80000880:	f1a080e7          	jalr	-230(ra) # 80000796 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000884:	8526                	mv	a0,s1
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	630080e7          	jalr	1584(ra) # 80000eb6 <proc_mapstacks>
}
    8000088e:	8526                	mv	a0,s1
    80000890:	60e2                	ld	ra,24(sp)
    80000892:	6442                	ld	s0,16(sp)
    80000894:	64a2                	ld	s1,8(sp)
    80000896:	6902                	ld	s2,0(sp)
    80000898:	6105                	add	sp,sp,32
    8000089a:	8082                	ret

000000008000089c <kvminit>:
{
    8000089c:	1141                	add	sp,sp,-16
    8000089e:	e406                	sd	ra,8(sp)
    800008a0:	e022                	sd	s0,0(sp)
    800008a2:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	f22080e7          	jalr	-222(ra) # 800007c6 <kvmmake>
    800008ac:	00008797          	auipc	a5,0x8
    800008b0:	1ca7b623          	sd	a0,460(a5) # 80008a78 <kernel_pagetable>
}
    800008b4:	60a2                	ld	ra,8(sp)
    800008b6:	6402                	ld	s0,0(sp)
    800008b8:	0141                	add	sp,sp,16
    800008ba:	8082                	ret

00000000800008bc <uvmunmap>:
/* Remove npages of mappings starting from va. va must be */
/* page-aligned. The mappings must exist. */
/* Optionally free the physical memory. */
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800008bc:	715d                	add	sp,sp,-80
    800008be:	e486                	sd	ra,72(sp)
    800008c0:	e0a2                	sd	s0,64(sp)
    800008c2:	fc26                	sd	s1,56(sp)
    800008c4:	f84a                	sd	s2,48(sp)
    800008c6:	f44e                	sd	s3,40(sp)
    800008c8:	f052                	sd	s4,32(sp)
    800008ca:	ec56                	sd	s5,24(sp)
    800008cc:	e85a                	sd	s6,16(sp)
    800008ce:	e45e                	sd	s7,8(sp)
    800008d0:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800008d2:	03459793          	sll	a5,a1,0x34
    800008d6:	e795                	bnez	a5,80000902 <uvmunmap+0x46>
    800008d8:	8a2a                	mv	s4,a0
    800008da:	892e                	mv	s2,a1
    800008dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008de:	0632                	sll	a2,a2,0xc
    800008e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008e6:	6b05                	lui	s6,0x1
    800008e8:	0735e263          	bltu	a1,s3,8000094c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008ec:	60a6                	ld	ra,72(sp)
    800008ee:	6406                	ld	s0,64(sp)
    800008f0:	74e2                	ld	s1,56(sp)
    800008f2:	7942                	ld	s2,48(sp)
    800008f4:	79a2                	ld	s3,40(sp)
    800008f6:	7a02                	ld	s4,32(sp)
    800008f8:	6ae2                	ld	s5,24(sp)
    800008fa:	6b42                	ld	s6,16(sp)
    800008fc:	6ba2                	ld	s7,8(sp)
    800008fe:	6161                	add	sp,sp,80
    80000900:	8082                	ret
    panic("uvmunmap: not aligned");
    80000902:	00007517          	auipc	a0,0x7
    80000906:	7be50513          	add	a0,a0,1982 # 800080c0 <etext+0xc0>
    8000090a:	00005097          	auipc	ra,0x5
    8000090e:	5bc080e7          	jalr	1468(ra) # 80005ec6 <panic>
      panic("uvmunmap: walk");
    80000912:	00007517          	auipc	a0,0x7
    80000916:	7c650513          	add	a0,a0,1990 # 800080d8 <etext+0xd8>
    8000091a:	00005097          	auipc	ra,0x5
    8000091e:	5ac080e7          	jalr	1452(ra) # 80005ec6 <panic>
      panic("uvmunmap: not mapped");
    80000922:	00007517          	auipc	a0,0x7
    80000926:	7c650513          	add	a0,a0,1990 # 800080e8 <etext+0xe8>
    8000092a:	00005097          	auipc	ra,0x5
    8000092e:	59c080e7          	jalr	1436(ra) # 80005ec6 <panic>
      panic("uvmunmap: not a leaf");
    80000932:	00007517          	auipc	a0,0x7
    80000936:	7ce50513          	add	a0,a0,1998 # 80008100 <etext+0x100>
    8000093a:	00005097          	auipc	ra,0x5
    8000093e:	58c080e7          	jalr	1420(ra) # 80005ec6 <panic>
    *pte = 0;
    80000942:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000946:	995a                	add	s2,s2,s6
    80000948:	fb3972e3          	bgeu	s2,s3,800008ec <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000094c:	4601                	li	a2,0
    8000094e:	85ca                	mv	a1,s2
    80000950:	8552                	mv	a0,s4
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c98080e7          	jalr	-872(ra) # 800005ea <walk>
    8000095a:	84aa                	mv	s1,a0
    8000095c:	d95d                	beqz	a0,80000912 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000095e:	6108                	ld	a0,0(a0)
    80000960:	00157793          	and	a5,a0,1
    80000964:	dfdd                	beqz	a5,80000922 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000966:	3ff57793          	and	a5,a0,1023
    8000096a:	fd7784e3          	beq	a5,s7,80000932 <uvmunmap+0x76>
    if(do_free){
    8000096e:	fc0a8ae3          	beqz	s5,80000942 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000972:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80000974:	0532                	sll	a0,a0,0xc
    80000976:	fffff097          	auipc	ra,0xfffff
    8000097a:	6a6080e7          	jalr	1702(ra) # 8000001c <kfree>
    8000097e:	b7d1                	j	80000942 <uvmunmap+0x86>

0000000080000980 <uvmcreate>:

/* create an empty user page table. */
/* returns 0 if out of memory. */
pagetable_t
uvmcreate()
{
    80000980:	1101                	add	sp,sp,-32
    80000982:	ec06                	sd	ra,24(sp)
    80000984:	e822                	sd	s0,16(sp)
    80000986:	e426                	sd	s1,8(sp)
    80000988:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	80a080e7          	jalr	-2038(ra) # 80000194 <kalloc>
    80000992:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000994:	c519                	beqz	a0,800009a2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000996:	6605                	lui	a2,0x1
    80000998:	4581                	li	a1,0
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	96e080e7          	jalr	-1682(ra) # 80000308 <memset>
  return pagetable;
}
    800009a2:	8526                	mv	a0,s1
    800009a4:	60e2                	ld	ra,24(sp)
    800009a6:	6442                	ld	s0,16(sp)
    800009a8:	64a2                	ld	s1,8(sp)
    800009aa:	6105                	add	sp,sp,32
    800009ac:	8082                	ret

00000000800009ae <uvmfirst>:
/* Load the user initcode into address 0 of pagetable, */
/* for the very first process. */
/* sz must be less than a page. */
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800009ae:	7179                	add	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800009be:	6785                	lui	a5,0x1
    800009c0:	04f67863          	bgeu	a2,a5,80000a10 <uvmfirst+0x62>
    800009c4:	8a2a                	mv	s4,a0
    800009c6:	89ae                	mv	s3,a1
    800009c8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800009ca:	fffff097          	auipc	ra,0xfffff
    800009ce:	7ca080e7          	jalr	1994(ra) # 80000194 <kalloc>
    800009d2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800009d4:	6605                	lui	a2,0x1
    800009d6:	4581                	li	a1,0
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	930080e7          	jalr	-1744(ra) # 80000308 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009e0:	4779                	li	a4,30
    800009e2:	86ca                	mv	a3,s2
    800009e4:	6605                	lui	a2,0x1
    800009e6:	4581                	li	a1,0
    800009e8:	8552                	mv	a0,s4
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	ce8080e7          	jalr	-792(ra) # 800006d2 <mappages>
  memmove(mem, src, sz);
    800009f2:	8626                	mv	a2,s1
    800009f4:	85ce                	mv	a1,s3
    800009f6:	854a                	mv	a0,s2
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	96c080e7          	jalr	-1684(ra) # 80000364 <memmove>
}
    80000a00:	70a2                	ld	ra,40(sp)
    80000a02:	7402                	ld	s0,32(sp)
    80000a04:	64e2                	ld	s1,24(sp)
    80000a06:	6942                	ld	s2,16(sp)
    80000a08:	69a2                	ld	s3,8(sp)
    80000a0a:	6a02                	ld	s4,0(sp)
    80000a0c:	6145                	add	sp,sp,48
    80000a0e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000a10:	00007517          	auipc	a0,0x7
    80000a14:	70850513          	add	a0,a0,1800 # 80008118 <etext+0x118>
    80000a18:	00005097          	auipc	ra,0x5
    80000a1c:	4ae080e7          	jalr	1198(ra) # 80005ec6 <panic>

0000000080000a20 <uvmdealloc>:
/* newsz.  oldsz and newsz need not be page-aligned, nor does newsz */
/* need to be less than oldsz.  oldsz can be larger than the actual */
/* process size.  Returns the new process size. */
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a20:	1101                	add	sp,sp,-32
    80000a22:	ec06                	sd	ra,24(sp)
    80000a24:	e822                	sd	s0,16(sp)
    80000a26:	e426                	sd	s1,8(sp)
    80000a28:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a2a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a2c:	00b67d63          	bgeu	a2,a1,80000a46 <uvmdealloc+0x26>
    80000a30:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a32:	6785                	lui	a5,0x1
    80000a34:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a36:	00f60733          	add	a4,a2,a5
    80000a3a:	76fd                	lui	a3,0xfffff
    80000a3c:	8f75                	and	a4,a4,a3
    80000a3e:	97ae                	add	a5,a5,a1
    80000a40:	8ff5                	and	a5,a5,a3
    80000a42:	00f76863          	bltu	a4,a5,80000a52 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a46:	8526                	mv	a0,s1
    80000a48:	60e2                	ld	ra,24(sp)
    80000a4a:	6442                	ld	s0,16(sp)
    80000a4c:	64a2                	ld	s1,8(sp)
    80000a4e:	6105                	add	sp,sp,32
    80000a50:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a52:	8f99                	sub	a5,a5,a4
    80000a54:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a56:	4685                	li	a3,1
    80000a58:	0007861b          	sext.w	a2,a5
    80000a5c:	85ba                	mv	a1,a4
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	e5e080e7          	jalr	-418(ra) # 800008bc <uvmunmap>
    80000a66:	b7c5                	j	80000a46 <uvmdealloc+0x26>

0000000080000a68 <uvmalloc>:
  if(newsz < oldsz)
    80000a68:	0ab66563          	bltu	a2,a1,80000b12 <uvmalloc+0xaa>
{
    80000a6c:	7139                	add	sp,sp,-64
    80000a6e:	fc06                	sd	ra,56(sp)
    80000a70:	f822                	sd	s0,48(sp)
    80000a72:	f426                	sd	s1,40(sp)
    80000a74:	f04a                	sd	s2,32(sp)
    80000a76:	ec4e                	sd	s3,24(sp)
    80000a78:	e852                	sd	s4,16(sp)
    80000a7a:	e456                	sd	s5,8(sp)
    80000a7c:	e05a                	sd	s6,0(sp)
    80000a7e:	0080                	add	s0,sp,64
    80000a80:	8aaa                	mv	s5,a0
    80000a82:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a84:	6785                	lui	a5,0x1
    80000a86:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a88:	95be                	add	a1,a1,a5
    80000a8a:	77fd                	lui	a5,0xfffff
    80000a8c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a90:	08c9f363          	bgeu	s3,a2,80000b16 <uvmalloc+0xae>
    80000a94:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a96:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	6fa080e7          	jalr	1786(ra) # 80000194 <kalloc>
    80000aa2:	84aa                	mv	s1,a0
    if(mem == 0){
    80000aa4:	c51d                	beqz	a0,80000ad2 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000aa6:	6605                	lui	a2,0x1
    80000aa8:	4581                	li	a1,0
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	85e080e7          	jalr	-1954(ra) # 80000308 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000ab2:	875a                	mv	a4,s6
    80000ab4:	86a6                	mv	a3,s1
    80000ab6:	6605                	lui	a2,0x1
    80000ab8:	85ca                	mv	a1,s2
    80000aba:	8556                	mv	a0,s5
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	c16080e7          	jalr	-1002(ra) # 800006d2 <mappages>
    80000ac4:	e90d                	bnez	a0,80000af6 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000ac6:	6785                	lui	a5,0x1
    80000ac8:	993e                	add	s2,s2,a5
    80000aca:	fd4968e3          	bltu	s2,s4,80000a9a <uvmalloc+0x32>
  return newsz;
    80000ace:	8552                	mv	a0,s4
    80000ad0:	a809                	j	80000ae2 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000ad2:	864e                	mv	a2,s3
    80000ad4:	85ca                	mv	a1,s2
    80000ad6:	8556                	mv	a0,s5
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	f48080e7          	jalr	-184(ra) # 80000a20 <uvmdealloc>
      return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	70e2                	ld	ra,56(sp)
    80000ae4:	7442                	ld	s0,48(sp)
    80000ae6:	74a2                	ld	s1,40(sp)
    80000ae8:	7902                	ld	s2,32(sp)
    80000aea:	69e2                	ld	s3,24(sp)
    80000aec:	6a42                	ld	s4,16(sp)
    80000aee:	6aa2                	ld	s5,8(sp)
    80000af0:	6b02                	ld	s6,0(sp)
    80000af2:	6121                	add	sp,sp,64
    80000af4:	8082                	ret
      kfree(mem);
    80000af6:	8526                	mv	a0,s1
    80000af8:	fffff097          	auipc	ra,0xfffff
    80000afc:	524080e7          	jalr	1316(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b00:	864e                	mv	a2,s3
    80000b02:	85ca                	mv	a1,s2
    80000b04:	8556                	mv	a0,s5
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	f1a080e7          	jalr	-230(ra) # 80000a20 <uvmdealloc>
      return 0;
    80000b0e:	4501                	li	a0,0
    80000b10:	bfc9                	j	80000ae2 <uvmalloc+0x7a>
    return oldsz;
    80000b12:	852e                	mv	a0,a1
}
    80000b14:	8082                	ret
  return newsz;
    80000b16:	8532                	mv	a0,a2
    80000b18:	b7e9                	j	80000ae2 <uvmalloc+0x7a>

0000000080000b1a <freewalk>:

/* Recursively free page-table pages. */
/* All leaf mappings must already have been removed. */
void
freewalk(pagetable_t pagetable)
{
    80000b1a:	7179                	add	sp,sp,-48
    80000b1c:	f406                	sd	ra,40(sp)
    80000b1e:	f022                	sd	s0,32(sp)
    80000b20:	ec26                	sd	s1,24(sp)
    80000b22:	e84a                	sd	s2,16(sp)
    80000b24:	e44e                	sd	s3,8(sp)
    80000b26:	e052                	sd	s4,0(sp)
    80000b28:	1800                	add	s0,sp,48
    80000b2a:	8a2a                	mv	s4,a0
  /* there are 2^9 = 512 PTEs in a page table. */
  for(int i = 0; i < 512; i++){
    80000b2c:	84aa                	mv	s1,a0
    80000b2e:	6905                	lui	s2,0x1
    80000b30:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b32:	4985                	li	s3,1
    80000b34:	a829                	j	80000b4e <freewalk+0x34>
      /* this PTE points to a lower-level page table. */
      uint64 child = PTE2PA(pte);
    80000b36:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000b38:	00c79513          	sll	a0,a5,0xc
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	fde080e7          	jalr	-34(ra) # 80000b1a <freewalk>
      pagetable[i] = 0;
    80000b44:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b48:	04a1                	add	s1,s1,8
    80000b4a:	03248163          	beq	s1,s2,80000b6c <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b4e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b50:	00f7f713          	and	a4,a5,15
    80000b54:	ff3701e3          	beq	a4,s3,80000b36 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b58:	8b85                	and	a5,a5,1
    80000b5a:	d7fd                	beqz	a5,80000b48 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000b5c:	00007517          	auipc	a0,0x7
    80000b60:	5dc50513          	add	a0,a0,1500 # 80008138 <etext+0x138>
    80000b64:	00005097          	auipc	ra,0x5
    80000b68:	362080e7          	jalr	866(ra) # 80005ec6 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b6c:	8552                	mv	a0,s4
    80000b6e:	fffff097          	auipc	ra,0xfffff
    80000b72:	4ae080e7          	jalr	1198(ra) # 8000001c <kfree>
}
    80000b76:	70a2                	ld	ra,40(sp)
    80000b78:	7402                	ld	s0,32(sp)
    80000b7a:	64e2                	ld	s1,24(sp)
    80000b7c:	6942                	ld	s2,16(sp)
    80000b7e:	69a2                	ld	s3,8(sp)
    80000b80:	6a02                	ld	s4,0(sp)
    80000b82:	6145                	add	sp,sp,48
    80000b84:	8082                	ret

0000000080000b86 <uvmfree>:

/* Free user memory pages, */
/* then free page-table pages. */
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b86:	1101                	add	sp,sp,-32
    80000b88:	ec06                	sd	ra,24(sp)
    80000b8a:	e822                	sd	s0,16(sp)
    80000b8c:	e426                	sd	s1,8(sp)
    80000b8e:	1000                	add	s0,sp,32
    80000b90:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b92:	e999                	bnez	a1,80000ba8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b94:	8526                	mv	a0,s1
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	f84080e7          	jalr	-124(ra) # 80000b1a <freewalk>
}
    80000b9e:	60e2                	ld	ra,24(sp)
    80000ba0:	6442                	ld	s0,16(sp)
    80000ba2:	64a2                	ld	s1,8(sp)
    80000ba4:	6105                	add	sp,sp,32
    80000ba6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ba8:	6785                	lui	a5,0x1
    80000baa:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000bac:	95be                	add	a1,a1,a5
    80000bae:	4685                	li	a3,1
    80000bb0:	00c5d613          	srl	a2,a1,0xc
    80000bb4:	4581                	li	a1,0
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	d06080e7          	jalr	-762(ra) # 800008bc <uvmunmap>
    80000bbe:	bfd9                	j	80000b94 <uvmfree+0xe>

0000000080000bc0 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000bc0:	c269                	beqz	a2,80000c82 <uvmcopy+0xc2>
{
    80000bc2:	7139                	add	sp,sp,-64
    80000bc4:	fc06                	sd	ra,56(sp)
    80000bc6:	f822                	sd	s0,48(sp)
    80000bc8:	f426                	sd	s1,40(sp)
    80000bca:	f04a                	sd	s2,32(sp)
    80000bcc:	ec4e                	sd	s3,24(sp)
    80000bce:	e852                	sd	s4,16(sp)
    80000bd0:	e456                	sd	s5,8(sp)
    80000bd2:	e05a                	sd	s6,0(sp)
    80000bd4:	0080                	add	s0,sp,64
    80000bd6:	8b2a                	mv	s6,a0
    80000bd8:	8aae                	mv	s5,a1
    80000bda:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000bdc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000bde:	4601                	li	a2,0
    80000be0:	85ce                	mv	a1,s3
    80000be2:	855a                	mv	a0,s6
    80000be4:	00000097          	auipc	ra,0x0
    80000be8:	a06080e7          	jalr	-1530(ra) # 800005ea <walk>
    80000bec:	892a                	mv	s2,a0
    80000bee:	c531                	beqz	a0,80000c3a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000bf0:	6114                	ld	a3,0(a0)
    80000bf2:	0016f793          	and	a5,a3,1
    80000bf6:	cbb1                	beqz	a5,80000c4a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000bf8:	82a9                	srl	a3,a3,0xa
    80000bfa:	00c69493          	sll	s1,a3,0xc
    /* Start CMPT 332 group14 change Fall 2023 */
    /* increment page references */
    ref_inc((void*)pa);
    80000bfe:	8526                	mv	a0,s1
    80000c00:	fffff097          	auipc	ra,0xfffff
    80000c04:	646080e7          	jalr	1606(ra) # 80000246 <ref_inc>
    /* can flips the bits of the parent page directly instead of
     * having to reinstall it -- thanks Delaney! */
    *pte &= ~PTE_W; *pte |= PTE_COW;
    80000c08:	00093703          	ld	a4,0(s2) # 1000 <_entry-0x7ffff000>
    80000c0c:	9b6d                	and	a4,a4,-5
    80000c0e:	10076713          	or	a4,a4,256
    80000c12:	00e93023          	sd	a4,0(s2)
    flags = (PTE_FLAGS(*pte));

    /* map the page into the childs page table */
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000c16:	3fb77713          	and	a4,a4,1019
    80000c1a:	86a6                	mv	a3,s1
    80000c1c:	6605                	lui	a2,0x1
    80000c1e:	85ce                	mv	a1,s3
    80000c20:	8556                	mv	a0,s5
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	ab0080e7          	jalr	-1360(ra) # 800006d2 <mappages>
    80000c2a:	e905                	bnez	a0,80000c5a <uvmcopy+0x9a>
    80000c2c:	12000073          	sfence.vma
  for(i = 0; i < sz; i += PGSIZE){
    80000c30:	6785                	lui	a5,0x1
    80000c32:	99be                	add	s3,s3,a5
    80000c34:	fb49e5e3          	bltu	s3,s4,80000bde <uvmcopy+0x1e>
    80000c38:	a81d                	j	80000c6e <uvmcopy+0xae>
      panic("uvmcopy: pte should exist");
    80000c3a:	00007517          	auipc	a0,0x7
    80000c3e:	50e50513          	add	a0,a0,1294 # 80008148 <etext+0x148>
    80000c42:	00005097          	auipc	ra,0x5
    80000c46:	284080e7          	jalr	644(ra) # 80005ec6 <panic>
      panic("uvmcopy: page not present");
    80000c4a:	00007517          	auipc	a0,0x7
    80000c4e:	51e50513          	add	a0,a0,1310 # 80008168 <etext+0x168>
    80000c52:	00005097          	auipc	ra,0x5
    80000c56:	274080e7          	jalr	628(ra) # 80005ec6 <panic>
    /* End CMPT 332 group14 change Fall 2023 */
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c5a:	4685                	li	a3,1
    80000c5c:	00c9d613          	srl	a2,s3,0xc
    80000c60:	4581                	li	a1,0
    80000c62:	8556                	mv	a0,s5
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	c58080e7          	jalr	-936(ra) # 800008bc <uvmunmap>
  return -1;
    80000c6c:	557d                	li	a0,-1
}
    80000c6e:	70e2                	ld	ra,56(sp)
    80000c70:	7442                	ld	s0,48(sp)
    80000c72:	74a2                	ld	s1,40(sp)
    80000c74:	7902                	ld	s2,32(sp)
    80000c76:	69e2                	ld	s3,24(sp)
    80000c78:	6a42                	ld	s4,16(sp)
    80000c7a:	6aa2                	ld	s5,8(sp)
    80000c7c:	6b02                	ld	s6,0(sp)
    80000c7e:	6121                	add	sp,sp,64
    80000c80:	8082                	ret
  return 0;
    80000c82:	4501                	li	a0,0
}
    80000c84:	8082                	ret

0000000080000c86 <uvmclear>:

/* mark a PTE invalid for user access. */
/* used by exec for the user stack guard page. */
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c86:	1141                	add	sp,sp,-16
    80000c88:	e406                	sd	ra,8(sp)
    80000c8a:	e022                	sd	s0,0(sp)
    80000c8c:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c8e:	4601                	li	a2,0
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	95a080e7          	jalr	-1702(ra) # 800005ea <walk>
  if(pte == 0)
    80000c98:	c901                	beqz	a0,80000ca8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c9a:	611c                	ld	a5,0(a0)
    80000c9c:	9bbd                	and	a5,a5,-17
    80000c9e:	e11c                	sd	a5,0(a0)
}
    80000ca0:	60a2                	ld	ra,8(sp)
    80000ca2:	6402                	ld	s0,0(sp)
    80000ca4:	0141                	add	sp,sp,16
    80000ca6:	8082                	ret
    panic("uvmclear");
    80000ca8:	00007517          	auipc	a0,0x7
    80000cac:	4e050513          	add	a0,a0,1248 # 80008188 <etext+0x188>
    80000cb0:	00005097          	auipc	ra,0x5
    80000cb4:	216080e7          	jalr	534(ra) # 80005ec6 <panic>

0000000080000cb8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000cb8:	cac9                	beqz	a3,80000d4a <copyout+0x92>
{
    80000cba:	711d                	add	sp,sp,-96
    80000cbc:	ec86                	sd	ra,88(sp)
    80000cbe:	e8a2                	sd	s0,80(sp)
    80000cc0:	e4a6                	sd	s1,72(sp)
    80000cc2:	e0ca                	sd	s2,64(sp)
    80000cc4:	fc4e                	sd	s3,56(sp)
    80000cc6:	f852                	sd	s4,48(sp)
    80000cc8:	f456                	sd	s5,40(sp)
    80000cca:	f05a                	sd	s6,32(sp)
    80000ccc:	ec5e                	sd	s7,24(sp)
    80000cce:	e862                	sd	s8,16(sp)
    80000cd0:	e466                	sd	s9,8(sp)
    80000cd2:	e06a                	sd	s10,0(sp)
    80000cd4:	1080                	add	s0,sp,96
    80000cd6:	8baa                	mv	s7,a0
    80000cd8:	8aae                	mv	s5,a1
    80000cda:	8b32                	mv	s6,a2
    80000cdc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000cde:	74fd                	lui	s1,0xfffff
    80000ce0:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000ce2:	57fd                	li	a5,-1
    80000ce4:	83e9                	srl	a5,a5,0x1a
    80000ce6:	0697e463          	bltu	a5,s1,80000d4e <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000cea:	4cd5                	li	s9,21
    80000cec:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000cee:	8c3e                	mv	s8,a5
    80000cf0:	a035                	j	80000d1c <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000cf2:	83a9                	srl	a5,a5,0xa
    80000cf4:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cf6:	409a8533          	sub	a0,s5,s1
    80000cfa:	0009061b          	sext.w	a2,s2
    80000cfe:	85da                	mv	a1,s6
    80000d00:	953e                	add	a0,a0,a5
    80000d02:	fffff097          	auipc	ra,0xfffff
    80000d06:	662080e7          	jalr	1634(ra) # 80000364 <memmove>

    len -= n;
    80000d0a:	412989b3          	sub	s3,s3,s2
    src += n;
    80000d0e:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000d10:	02098b63          	beqz	s3,80000d46 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000d14:	034c6f63          	bltu	s8,s4,80000d52 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000d18:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000d1a:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000d1c:	4601                	li	a2,0
    80000d1e:	85a6                	mv	a1,s1
    80000d20:	855e                	mv	a0,s7
    80000d22:	00000097          	auipc	ra,0x0
    80000d26:	8c8080e7          	jalr	-1848(ra) # 800005ea <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000d2a:	c515                	beqz	a0,80000d56 <copyout+0x9e>
    80000d2c:	611c                	ld	a5,0(a0)
    80000d2e:	0157f713          	and	a4,a5,21
    80000d32:	05971163          	bne	a4,s9,80000d74 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000d36:	01a48a33          	add	s4,s1,s10
    80000d3a:	415a0933          	sub	s2,s4,s5
    80000d3e:	fb29fae3          	bgeu	s3,s2,80000cf2 <copyout+0x3a>
    80000d42:	894e                	mv	s2,s3
    80000d44:	b77d                	j	80000cf2 <copyout+0x3a>
  }
  return 0;
    80000d46:	4501                	li	a0,0
    80000d48:	a801                	j	80000d58 <copyout+0xa0>
    80000d4a:	4501                	li	a0,0
}
    80000d4c:	8082                	ret
      return -1;
    80000d4e:	557d                	li	a0,-1
    80000d50:	a021                	j	80000d58 <copyout+0xa0>
    80000d52:	557d                	li	a0,-1
    80000d54:	a011                	j	80000d58 <copyout+0xa0>
      return -1;
    80000d56:	557d                	li	a0,-1
}
    80000d58:	60e6                	ld	ra,88(sp)
    80000d5a:	6446                	ld	s0,80(sp)
    80000d5c:	64a6                	ld	s1,72(sp)
    80000d5e:	6906                	ld	s2,64(sp)
    80000d60:	79e2                	ld	s3,56(sp)
    80000d62:	7a42                	ld	s4,48(sp)
    80000d64:	7aa2                	ld	s5,40(sp)
    80000d66:	7b02                	ld	s6,32(sp)
    80000d68:	6be2                	ld	s7,24(sp)
    80000d6a:	6c42                	ld	s8,16(sp)
    80000d6c:	6ca2                	ld	s9,8(sp)
    80000d6e:	6d02                	ld	s10,0(sp)
    80000d70:	6125                	add	sp,sp,96
    80000d72:	8082                	ret
      return -1;
    80000d74:	557d                	li	a0,-1
    80000d76:	b7cd                	j	80000d58 <copyout+0xa0>

0000000080000d78 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d78:	caa5                	beqz	a3,80000de8 <copyin+0x70>
{
    80000d7a:	715d                	add	sp,sp,-80
    80000d7c:	e486                	sd	ra,72(sp)
    80000d7e:	e0a2                	sd	s0,64(sp)
    80000d80:	fc26                	sd	s1,56(sp)
    80000d82:	f84a                	sd	s2,48(sp)
    80000d84:	f44e                	sd	s3,40(sp)
    80000d86:	f052                	sd	s4,32(sp)
    80000d88:	ec56                	sd	s5,24(sp)
    80000d8a:	e85a                	sd	s6,16(sp)
    80000d8c:	e45e                	sd	s7,8(sp)
    80000d8e:	e062                	sd	s8,0(sp)
    80000d90:	0880                	add	s0,sp,80
    80000d92:	8b2a                	mv	s6,a0
    80000d94:	8a2e                	mv	s4,a1
    80000d96:	8c32                	mv	s8,a2
    80000d98:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d9a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d9c:	6a85                	lui	s5,0x1
    80000d9e:	a01d                	j	80000dc4 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000da0:	018505b3          	add	a1,a0,s8
    80000da4:	0004861b          	sext.w	a2,s1
    80000da8:	412585b3          	sub	a1,a1,s2
    80000dac:	8552                	mv	a0,s4
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	5b6080e7          	jalr	1462(ra) # 80000364 <memmove>

    len -= n;
    80000db6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000dba:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000dbc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000dc0:	02098263          	beqz	s3,80000de4 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000dc4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000dc8:	85ca                	mv	a1,s2
    80000dca:	855a                	mv	a0,s6
    80000dcc:	00000097          	auipc	ra,0x0
    80000dd0:	8c4080e7          	jalr	-1852(ra) # 80000690 <walkaddr>
    if(pa0 == 0)
    80000dd4:	cd01                	beqz	a0,80000dec <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000dd6:	418904b3          	sub	s1,s2,s8
    80000dda:	94d6                	add	s1,s1,s5
    80000ddc:	fc99f2e3          	bgeu	s3,s1,80000da0 <copyin+0x28>
    80000de0:	84ce                	mv	s1,s3
    80000de2:	bf7d                	j	80000da0 <copyin+0x28>
  }
  return 0;
    80000de4:	4501                	li	a0,0
    80000de6:	a021                	j	80000dee <copyin+0x76>
    80000de8:	4501                	li	a0,0
}
    80000dea:	8082                	ret
      return -1;
    80000dec:	557d                	li	a0,-1
}
    80000dee:	60a6                	ld	ra,72(sp)
    80000df0:	6406                	ld	s0,64(sp)
    80000df2:	74e2                	ld	s1,56(sp)
    80000df4:	7942                	ld	s2,48(sp)
    80000df6:	79a2                	ld	s3,40(sp)
    80000df8:	7a02                	ld	s4,32(sp)
    80000dfa:	6ae2                	ld	s5,24(sp)
    80000dfc:	6b42                	ld	s6,16(sp)
    80000dfe:	6ba2                	ld	s7,8(sp)
    80000e00:	6c02                	ld	s8,0(sp)
    80000e02:	6161                	add	sp,sp,80
    80000e04:	8082                	ret

0000000080000e06 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000e06:	c2dd                	beqz	a3,80000eac <copyinstr+0xa6>
{
    80000e08:	715d                	add	sp,sp,-80
    80000e0a:	e486                	sd	ra,72(sp)
    80000e0c:	e0a2                	sd	s0,64(sp)
    80000e0e:	fc26                	sd	s1,56(sp)
    80000e10:	f84a                	sd	s2,48(sp)
    80000e12:	f44e                	sd	s3,40(sp)
    80000e14:	f052                	sd	s4,32(sp)
    80000e16:	ec56                	sd	s5,24(sp)
    80000e18:	e85a                	sd	s6,16(sp)
    80000e1a:	e45e                	sd	s7,8(sp)
    80000e1c:	0880                	add	s0,sp,80
    80000e1e:	8a2a                	mv	s4,a0
    80000e20:	8b2e                	mv	s6,a1
    80000e22:	8bb2                	mv	s7,a2
    80000e24:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e26:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e28:	6985                	lui	s3,0x1
    80000e2a:	a02d                	j	80000e54 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000e2c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e30:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000e32:	37fd                	addw	a5,a5,-1
    80000e34:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e38:	60a6                	ld	ra,72(sp)
    80000e3a:	6406                	ld	s0,64(sp)
    80000e3c:	74e2                	ld	s1,56(sp)
    80000e3e:	7942                	ld	s2,48(sp)
    80000e40:	79a2                	ld	s3,40(sp)
    80000e42:	7a02                	ld	s4,32(sp)
    80000e44:	6ae2                	ld	s5,24(sp)
    80000e46:	6b42                	ld	s6,16(sp)
    80000e48:	6ba2                	ld	s7,8(sp)
    80000e4a:	6161                	add	sp,sp,80
    80000e4c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e4e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e52:	c8a9                	beqz	s1,80000ea4 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000e54:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e58:	85ca                	mv	a1,s2
    80000e5a:	8552                	mv	a0,s4
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	834080e7          	jalr	-1996(ra) # 80000690 <walkaddr>
    if(pa0 == 0)
    80000e64:	c131                	beqz	a0,80000ea8 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000e66:	417906b3          	sub	a3,s2,s7
    80000e6a:	96ce                	add	a3,a3,s3
    80000e6c:	00d4f363          	bgeu	s1,a3,80000e72 <copyinstr+0x6c>
    80000e70:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e72:	955e                	add	a0,a0,s7
    80000e74:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e78:	daf9                	beqz	a3,80000e4e <copyinstr+0x48>
    80000e7a:	87da                	mv	a5,s6
    80000e7c:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000e7e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000e82:	96da                	add	a3,a3,s6
    80000e84:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000e86:	00f60733          	add	a4,a2,a5
    80000e8a:	00074703          	lbu	a4,0(a4)
    80000e8e:	df59                	beqz	a4,80000e2c <copyinstr+0x26>
        *dst = *p;
    80000e90:	00e78023          	sb	a4,0(a5)
      dst++;
    80000e94:	0785                	add	a5,a5,1
    while(n > 0){
    80000e96:	fed797e3          	bne	a5,a3,80000e84 <copyinstr+0x7e>
    80000e9a:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffbcedf>
    80000e9c:	94c2                	add	s1,s1,a6
      --max;
    80000e9e:	8c8d                	sub	s1,s1,a1
      dst++;
    80000ea0:	8b3e                	mv	s6,a5
    80000ea2:	b775                	j	80000e4e <copyinstr+0x48>
    80000ea4:	4781                	li	a5,0
    80000ea6:	b771                	j	80000e32 <copyinstr+0x2c>
      return -1;
    80000ea8:	557d                	li	a0,-1
    80000eaa:	b779                	j	80000e38 <copyinstr+0x32>
  int got_null = 0;
    80000eac:	4781                	li	a5,0
  if(got_null){
    80000eae:	37fd                	addw	a5,a5,-1
    80000eb0:	0007851b          	sext.w	a0,a5
}
    80000eb4:	8082                	ret

0000000080000eb6 <proc_mapstacks>:
/* Allocate a page for each process's kernel stack. */
/* Map it high in memory, followed by an invalid */
/* guard page. */
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000eb6:	7139                	add	sp,sp,-64
    80000eb8:	fc06                	sd	ra,56(sp)
    80000eba:	f822                	sd	s0,48(sp)
    80000ebc:	f426                	sd	s1,40(sp)
    80000ebe:	f04a                	sd	s2,32(sp)
    80000ec0:	ec4e                	sd	s3,24(sp)
    80000ec2:	e852                	sd	s4,16(sp)
    80000ec4:	e456                	sd	s5,8(sp)
    80000ec6:	e05a                	sd	s6,0(sp)
    80000ec8:	0080                	add	s0,sp,64
    80000eca:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ecc:	00028497          	auipc	s1,0x28
    80000ed0:	02c48493          	add	s1,s1,44 # 80028ef8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ed4:	8b26                	mv	s6,s1
    80000ed6:	00007a97          	auipc	s5,0x7
    80000eda:	12aa8a93          	add	s5,s5,298 # 80008000 <etext>
    80000ede:	04000937          	lui	s2,0x4000
    80000ee2:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ee4:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee6:	0002ea17          	auipc	s4,0x2e
    80000eea:	c12a0a13          	add	s4,s4,-1006 # 8002eaf8 <tickslock>
    char *pa = kalloc();
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	2a6080e7          	jalr	678(ra) # 80000194 <kalloc>
    80000ef6:	862a                	mv	a2,a0
    if(pa == 0)
    80000ef8:	c131                	beqz	a0,80000f3c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000efa:	416485b3          	sub	a1,s1,s6
    80000efe:	8591                	sra	a1,a1,0x4
    80000f00:	000ab783          	ld	a5,0(s5)
    80000f04:	02f585b3          	mul	a1,a1,a5
    80000f08:	2585                	addw	a1,a1,1
    80000f0a:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f0e:	4719                	li	a4,6
    80000f10:	6685                	lui	a3,0x1
    80000f12:	40b905b3          	sub	a1,s2,a1
    80000f16:	854e                	mv	a0,s3
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	87e080e7          	jalr	-1922(ra) # 80000796 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f20:	17048493          	add	s1,s1,368
    80000f24:	fd4495e3          	bne	s1,s4,80000eee <proc_mapstacks+0x38>
  }
}
    80000f28:	70e2                	ld	ra,56(sp)
    80000f2a:	7442                	ld	s0,48(sp)
    80000f2c:	74a2                	ld	s1,40(sp)
    80000f2e:	7902                	ld	s2,32(sp)
    80000f30:	69e2                	ld	s3,24(sp)
    80000f32:	6a42                	ld	s4,16(sp)
    80000f34:	6aa2                	ld	s5,8(sp)
    80000f36:	6b02                	ld	s6,0(sp)
    80000f38:	6121                	add	sp,sp,64
    80000f3a:	8082                	ret
      panic("kalloc");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	25c50513          	add	a0,a0,604 # 80008198 <etext+0x198>
    80000f44:	00005097          	auipc	ra,0x5
    80000f48:	f82080e7          	jalr	-126(ra) # 80005ec6 <panic>

0000000080000f4c <procinit>:

/* initialize the proc table. */
void
procinit(void)
{
    80000f4c:	7139                	add	sp,sp,-64
    80000f4e:	fc06                	sd	ra,56(sp)
    80000f50:	f822                	sd	s0,48(sp)
    80000f52:	f426                	sd	s1,40(sp)
    80000f54:	f04a                	sd	s2,32(sp)
    80000f56:	ec4e                	sd	s3,24(sp)
    80000f58:	e852                	sd	s4,16(sp)
    80000f5a:	e456                	sd	s5,8(sp)
    80000f5c:	e05a                	sd	s6,0(sp)
    80000f5e:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f60:	00007597          	auipc	a1,0x7
    80000f64:	24058593          	add	a1,a1,576 # 800081a0 <etext+0x1a0>
    80000f68:	00028517          	auipc	a0,0x28
    80000f6c:	b6050513          	add	a0,a0,-1184 # 80028ac8 <pid_lock>
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	3fe080e7          	jalr	1022(ra) # 8000636e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f78:	00007597          	auipc	a1,0x7
    80000f7c:	23058593          	add	a1,a1,560 # 800081a8 <etext+0x1a8>
    80000f80:	00028517          	auipc	a0,0x28
    80000f84:	b6050513          	add	a0,a0,-1184 # 80028ae0 <wait_lock>
    80000f88:	00005097          	auipc	ra,0x5
    80000f8c:	3e6080e7          	jalr	998(ra) # 8000636e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f90:	00028497          	auipc	s1,0x28
    80000f94:	f6848493          	add	s1,s1,-152 # 80028ef8 <proc>
      initlock(&p->lock, "proc");
    80000f98:	00007b17          	auipc	s6,0x7
    80000f9c:	220b0b13          	add	s6,s6,544 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000fa0:	8aa6                	mv	s5,s1
    80000fa2:	00007a17          	auipc	s4,0x7
    80000fa6:	05ea0a13          	add	s4,s4,94 # 80008000 <etext>
    80000faa:	04000937          	lui	s2,0x4000
    80000fae:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000fb0:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb2:	0002e997          	auipc	s3,0x2e
    80000fb6:	b4698993          	add	s3,s3,-1210 # 8002eaf8 <tickslock>
      initlock(&p->lock, "proc");
    80000fba:	85da                	mv	a1,s6
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	3b0080e7          	jalr	944(ra) # 8000636e <initlock>
      p->state = UNUSED;
    80000fc6:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000fca:	415487b3          	sub	a5,s1,s5
    80000fce:	8791                	sra	a5,a5,0x4
    80000fd0:	000a3703          	ld	a4,0(s4)
    80000fd4:	02e787b3          	mul	a5,a5,a4
    80000fd8:	2785                	addw	a5,a5,1
    80000fda:	00d7979b          	sllw	a5,a5,0xd
    80000fde:	40f907b3          	sub	a5,s2,a5
    80000fe2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe4:	17048493          	add	s1,s1,368
    80000fe8:	fd3499e3          	bne	s1,s3,80000fba <procinit+0x6e>
  }
}
    80000fec:	70e2                	ld	ra,56(sp)
    80000fee:	7442                	ld	s0,48(sp)
    80000ff0:	74a2                	ld	s1,40(sp)
    80000ff2:	7902                	ld	s2,32(sp)
    80000ff4:	69e2                	ld	s3,24(sp)
    80000ff6:	6a42                	ld	s4,16(sp)
    80000ff8:	6aa2                	ld	s5,8(sp)
    80000ffa:	6b02                	ld	s6,0(sp)
    80000ffc:	6121                	add	sp,sp,64
    80000ffe:	8082                	ret

0000000080001000 <cpuid>:
/* Must be called with interrupts disabled, */
/* to prevent race with process being moved */
/* to a different CPU. */
int
cpuid()
{
    80001000:	1141                	add	sp,sp,-16
    80001002:	e422                	sd	s0,8(sp)
    80001004:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001006:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001008:	2501                	sext.w	a0,a0
    8000100a:	6422                	ld	s0,8(sp)
    8000100c:	0141                	add	sp,sp,16
    8000100e:	8082                	ret

0000000080001010 <mycpu>:

/* Return this CPU's cpu struct. */
/* Interrupts must be disabled. */
struct cpu*
mycpu(void)
{
    80001010:	1141                	add	sp,sp,-16
    80001012:	e422                	sd	s0,8(sp)
    80001014:	0800                	add	s0,sp,16
    80001016:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001018:	2781                	sext.w	a5,a5
    8000101a:	079e                	sll	a5,a5,0x7
  return c;
}
    8000101c:	00028517          	auipc	a0,0x28
    80001020:	adc50513          	add	a0,a0,-1316 # 80028af8 <cpus>
    80001024:	953e                	add	a0,a0,a5
    80001026:	6422                	ld	s0,8(sp)
    80001028:	0141                	add	sp,sp,16
    8000102a:	8082                	ret

000000008000102c <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    8000102c:	1101                	add	sp,sp,-32
    8000102e:	ec06                	sd	ra,24(sp)
    80001030:	e822                	sd	s0,16(sp)
    80001032:	e426                	sd	s1,8(sp)
    80001034:	1000                	add	s0,sp,32
  push_off();
    80001036:	00005097          	auipc	ra,0x5
    8000103a:	37c080e7          	jalr	892(ra) # 800063b2 <push_off>
    8000103e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001040:	2781                	sext.w	a5,a5
    80001042:	079e                	sll	a5,a5,0x7
    80001044:	00028717          	auipc	a4,0x28
    80001048:	a8470713          	add	a4,a4,-1404 # 80028ac8 <pid_lock>
    8000104c:	97ba                	add	a5,a5,a4
    8000104e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001050:	00005097          	auipc	ra,0x5
    80001054:	402080e7          	jalr	1026(ra) # 80006452 <pop_off>
  return p;
}
    80001058:	8526                	mv	a0,s1
    8000105a:	60e2                	ld	ra,24(sp)
    8000105c:	6442                	ld	s0,16(sp)
    8000105e:	64a2                	ld	s1,8(sp)
    80001060:	6105                	add	sp,sp,32
    80001062:	8082                	ret

0000000080001064 <forkret>:

/* A fork child's very first scheduling by scheduler() */
/* will swtch to forkret. */
void
forkret(void)
{
    80001064:	1141                	add	sp,sp,-16
    80001066:	e406                	sd	ra,8(sp)
    80001068:	e022                	sd	s0,0(sp)
    8000106a:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    8000106c:	00000097          	auipc	ra,0x0
    80001070:	fc0080e7          	jalr	-64(ra) # 8000102c <myproc>
    80001074:	00005097          	auipc	ra,0x5
    80001078:	43e080e7          	jalr	1086(ra) # 800064b2 <release>

  if (first) {
    8000107c:	00008797          	auipc	a5,0x8
    80001080:	8f47a783          	lw	a5,-1804(a5) # 80008970 <first.1>
    80001084:	eb89                	bnez	a5,80001096 <forkret+0x32>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    80001086:	00001097          	auipc	ra,0x1
    8000108a:	c8a080e7          	jalr	-886(ra) # 80001d10 <usertrapret>
}
    8000108e:	60a2                	ld	ra,8(sp)
    80001090:	6402                	ld	s0,0(sp)
    80001092:	0141                	add	sp,sp,16
    80001094:	8082                	ret
    fsinit(ROOTDEV);
    80001096:	4505                	li	a0,1
    80001098:	00002097          	auipc	ra,0x2
    8000109c:	b5c080e7          	jalr	-1188(ra) # 80002bf4 <fsinit>
    first = 0;
    800010a0:	00008797          	auipc	a5,0x8
    800010a4:	8c07a823          	sw	zero,-1840(a5) # 80008970 <first.1>
    __sync_synchronize();
    800010a8:	0ff0000f          	fence
    800010ac:	bfe9                	j	80001086 <forkret+0x22>

00000000800010ae <allocpid>:
{
    800010ae:	1101                	add	sp,sp,-32
    800010b0:	ec06                	sd	ra,24(sp)
    800010b2:	e822                	sd	s0,16(sp)
    800010b4:	e426                	sd	s1,8(sp)
    800010b6:	e04a                	sd	s2,0(sp)
    800010b8:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    800010ba:	00028917          	auipc	s2,0x28
    800010be:	a0e90913          	add	s2,s2,-1522 # 80028ac8 <pid_lock>
    800010c2:	854a                	mv	a0,s2
    800010c4:	00005097          	auipc	ra,0x5
    800010c8:	33a080e7          	jalr	826(ra) # 800063fe <acquire>
  pid = nextpid;
    800010cc:	00008797          	auipc	a5,0x8
    800010d0:	8a878793          	add	a5,a5,-1880 # 80008974 <nextpid>
    800010d4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010d6:	0014871b          	addw	a4,s1,1
    800010da:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010dc:	854a                	mv	a0,s2
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	3d4080e7          	jalr	980(ra) # 800064b2 <release>
}
    800010e6:	8526                	mv	a0,s1
    800010e8:	60e2                	ld	ra,24(sp)
    800010ea:	6442                	ld	s0,16(sp)
    800010ec:	64a2                	ld	s1,8(sp)
    800010ee:	6902                	ld	s2,0(sp)
    800010f0:	6105                	add	sp,sp,32
    800010f2:	8082                	ret

00000000800010f4 <proc_pagetable>:
{
    800010f4:	1101                	add	sp,sp,-32
    800010f6:	ec06                	sd	ra,24(sp)
    800010f8:	e822                	sd	s0,16(sp)
    800010fa:	e426                	sd	s1,8(sp)
    800010fc:	e04a                	sd	s2,0(sp)
    800010fe:	1000                	add	s0,sp,32
    80001100:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001102:	00000097          	auipc	ra,0x0
    80001106:	87e080e7          	jalr	-1922(ra) # 80000980 <uvmcreate>
    8000110a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000110c:	c121                	beqz	a0,8000114c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000110e:	4729                	li	a4,10
    80001110:	00006697          	auipc	a3,0x6
    80001114:	ef068693          	add	a3,a3,-272 # 80007000 <_trampoline>
    80001118:	6605                	lui	a2,0x1
    8000111a:	040005b7          	lui	a1,0x4000
    8000111e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001120:	05b2                	sll	a1,a1,0xc
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	5b0080e7          	jalr	1456(ra) # 800006d2 <mappages>
    8000112a:	02054863          	bltz	a0,8000115a <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000112e:	4719                	li	a4,6
    80001130:	05893683          	ld	a3,88(s2)
    80001134:	6605                	lui	a2,0x1
    80001136:	020005b7          	lui	a1,0x2000
    8000113a:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000113c:	05b6                	sll	a1,a1,0xd
    8000113e:	8526                	mv	a0,s1
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	592080e7          	jalr	1426(ra) # 800006d2 <mappages>
    80001148:	02054163          	bltz	a0,8000116a <proc_pagetable+0x76>
}
    8000114c:	8526                	mv	a0,s1
    8000114e:	60e2                	ld	ra,24(sp)
    80001150:	6442                	ld	s0,16(sp)
    80001152:	64a2                	ld	s1,8(sp)
    80001154:	6902                	ld	s2,0(sp)
    80001156:	6105                	add	sp,sp,32
    80001158:	8082                	ret
    uvmfree(pagetable, 0);
    8000115a:	4581                	li	a1,0
    8000115c:	8526                	mv	a0,s1
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	a28080e7          	jalr	-1496(ra) # 80000b86 <uvmfree>
    return 0;
    80001166:	4481                	li	s1,0
    80001168:	b7d5                	j	8000114c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000116a:	4681                	li	a3,0
    8000116c:	4605                	li	a2,1
    8000116e:	040005b7          	lui	a1,0x4000
    80001172:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001174:	05b2                	sll	a1,a1,0xc
    80001176:	8526                	mv	a0,s1
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	744080e7          	jalr	1860(ra) # 800008bc <uvmunmap>
    uvmfree(pagetable, 0);
    80001180:	4581                	li	a1,0
    80001182:	8526                	mv	a0,s1
    80001184:	00000097          	auipc	ra,0x0
    80001188:	a02080e7          	jalr	-1534(ra) # 80000b86 <uvmfree>
    return 0;
    8000118c:	4481                	li	s1,0
    8000118e:	bf7d                	j	8000114c <proc_pagetable+0x58>

0000000080001190 <proc_freepagetable>:
{
    80001190:	1101                	add	sp,sp,-32
    80001192:	ec06                	sd	ra,24(sp)
    80001194:	e822                	sd	s0,16(sp)
    80001196:	e426                	sd	s1,8(sp)
    80001198:	e04a                	sd	s2,0(sp)
    8000119a:	1000                	add	s0,sp,32
    8000119c:	84aa                	mv	s1,a0
    8000119e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011a0:	4681                	li	a3,0
    800011a2:	4605                	li	a2,1
    800011a4:	040005b7          	lui	a1,0x4000
    800011a8:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011aa:	05b2                	sll	a1,a1,0xc
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	710080e7          	jalr	1808(ra) # 800008bc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011b4:	4681                	li	a3,0
    800011b6:	4605                	li	a2,1
    800011b8:	020005b7          	lui	a1,0x2000
    800011bc:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011be:	05b6                	sll	a1,a1,0xd
    800011c0:	8526                	mv	a0,s1
    800011c2:	fffff097          	auipc	ra,0xfffff
    800011c6:	6fa080e7          	jalr	1786(ra) # 800008bc <uvmunmap>
  uvmfree(pagetable, sz);
    800011ca:	85ca                	mv	a1,s2
    800011cc:	8526                	mv	a0,s1
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	9b8080e7          	jalr	-1608(ra) # 80000b86 <uvmfree>
}
    800011d6:	60e2                	ld	ra,24(sp)
    800011d8:	6442                	ld	s0,16(sp)
    800011da:	64a2                	ld	s1,8(sp)
    800011dc:	6902                	ld	s2,0(sp)
    800011de:	6105                	add	sp,sp,32
    800011e0:	8082                	ret

00000000800011e2 <freeproc>:
{
    800011e2:	1101                	add	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	1000                	add	s0,sp,32
    800011ec:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011ee:	6d28                	ld	a0,88(a0)
    800011f0:	c509                	beqz	a0,800011fa <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	e2a080e7          	jalr	-470(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011fa:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011fe:	68a8                	ld	a0,80(s1)
    80001200:	c511                	beqz	a0,8000120c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001202:	64ac                	ld	a1,72(s1)
    80001204:	00000097          	auipc	ra,0x0
    80001208:	f8c080e7          	jalr	-116(ra) # 80001190 <proc_freepagetable>
  p->pagetable = 0;
    8000120c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001210:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001214:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001218:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000121c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001220:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001224:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001228:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000122c:	0004ac23          	sw	zero,24(s1)
}
    80001230:	60e2                	ld	ra,24(sp)
    80001232:	6442                	ld	s0,16(sp)
    80001234:	64a2                	ld	s1,8(sp)
    80001236:	6105                	add	sp,sp,32
    80001238:	8082                	ret

000000008000123a <allocproc>:
{
    8000123a:	1101                	add	sp,sp,-32
    8000123c:	ec06                	sd	ra,24(sp)
    8000123e:	e822                	sd	s0,16(sp)
    80001240:	e426                	sd	s1,8(sp)
    80001242:	e04a                	sd	s2,0(sp)
    80001244:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001246:	00028497          	auipc	s1,0x28
    8000124a:	cb248493          	add	s1,s1,-846 # 80028ef8 <proc>
    8000124e:	0002e917          	auipc	s2,0x2e
    80001252:	8aa90913          	add	s2,s2,-1878 # 8002eaf8 <tickslock>
    acquire(&p->lock);
    80001256:	8526                	mv	a0,s1
    80001258:	00005097          	auipc	ra,0x5
    8000125c:	1a6080e7          	jalr	422(ra) # 800063fe <acquire>
    if(p->state == UNUSED) {
    80001260:	4c9c                	lw	a5,24(s1)
    80001262:	cf81                	beqz	a5,8000127a <allocproc+0x40>
      release(&p->lock);
    80001264:	8526                	mv	a0,s1
    80001266:	00005097          	auipc	ra,0x5
    8000126a:	24c080e7          	jalr	588(ra) # 800064b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000126e:	17048493          	add	s1,s1,368
    80001272:	ff2492e3          	bne	s1,s2,80001256 <allocproc+0x1c>
  return 0;
    80001276:	4481                	li	s1,0
    80001278:	a889                	j	800012ca <allocproc+0x90>
  p->pid = allocpid();
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e34080e7          	jalr	-460(ra) # 800010ae <allocpid>
    80001282:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001284:	4785                	li	a5,1
    80001286:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001288:	fffff097          	auipc	ra,0xfffff
    8000128c:	f0c080e7          	jalr	-244(ra) # 80000194 <kalloc>
    80001290:	892a                	mv	s2,a0
    80001292:	eca8                	sd	a0,88(s1)
    80001294:	c131                	beqz	a0,800012d8 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001296:	8526                	mv	a0,s1
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	e5c080e7          	jalr	-420(ra) # 800010f4 <proc_pagetable>
    800012a0:	892a                	mv	s2,a0
    800012a2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012a4:	c531                	beqz	a0,800012f0 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012a6:	07000613          	li	a2,112
    800012aa:	4581                	li	a1,0
    800012ac:	06048513          	add	a0,s1,96
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	058080e7          	jalr	88(ra) # 80000308 <memset>
  p->context.ra = (uint64)forkret;
    800012b8:	00000797          	auipc	a5,0x0
    800012bc:	dac78793          	add	a5,a5,-596 # 80001064 <forkret>
    800012c0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012c2:	60bc                	ld	a5,64(s1)
    800012c4:	6705                	lui	a4,0x1
    800012c6:	97ba                	add	a5,a5,a4
    800012c8:	f4bc                	sd	a5,104(s1)
}
    800012ca:	8526                	mv	a0,s1
    800012cc:	60e2                	ld	ra,24(sp)
    800012ce:	6442                	ld	s0,16(sp)
    800012d0:	64a2                	ld	s1,8(sp)
    800012d2:	6902                	ld	s2,0(sp)
    800012d4:	6105                	add	sp,sp,32
    800012d6:	8082                	ret
    freeproc(p);
    800012d8:	8526                	mv	a0,s1
    800012da:	00000097          	auipc	ra,0x0
    800012de:	f08080e7          	jalr	-248(ra) # 800011e2 <freeproc>
    release(&p->lock);
    800012e2:	8526                	mv	a0,s1
    800012e4:	00005097          	auipc	ra,0x5
    800012e8:	1ce080e7          	jalr	462(ra) # 800064b2 <release>
    return 0;
    800012ec:	84ca                	mv	s1,s2
    800012ee:	bff1                	j	800012ca <allocproc+0x90>
    freeproc(p);
    800012f0:	8526                	mv	a0,s1
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	ef0080e7          	jalr	-272(ra) # 800011e2 <freeproc>
    release(&p->lock);
    800012fa:	8526                	mv	a0,s1
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	1b6080e7          	jalr	438(ra) # 800064b2 <release>
    return 0;
    80001304:	84ca                	mv	s1,s2
    80001306:	b7d1                	j	800012ca <allocproc+0x90>

0000000080001308 <userinit>:
{
    80001308:	1101                	add	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	1000                	add	s0,sp,32
  p = allocproc();
    80001312:	00000097          	auipc	ra,0x0
    80001316:	f28080e7          	jalr	-216(ra) # 8000123a <allocproc>
    8000131a:	84aa                	mv	s1,a0
  initproc = p;
    8000131c:	00007797          	auipc	a5,0x7
    80001320:	76a7b223          	sd	a0,1892(a5) # 80008a80 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001324:	03400613          	li	a2,52
    80001328:	00007597          	auipc	a1,0x7
    8000132c:	65858593          	add	a1,a1,1624 # 80008980 <initcode>
    80001330:	6928                	ld	a0,80(a0)
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	67c080e7          	jalr	1660(ra) # 800009ae <uvmfirst>
  p->sz = PGSIZE;
    8000133a:	6785                	lui	a5,0x1
    8000133c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      /* user program counter */
    8000133e:	6cb8                	ld	a4,88(s1)
    80001340:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80001344:	6cb8                	ld	a4,88(s1)
    80001346:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001348:	4641                	li	a2,16
    8000134a:	00007597          	auipc	a1,0x7
    8000134e:	e7658593          	add	a1,a1,-394 # 800081c0 <etext+0x1c0>
    80001352:	15848513          	add	a0,s1,344
    80001356:	fffff097          	auipc	ra,0xfffff
    8000135a:	0fa080e7          	jalr	250(ra) # 80000450 <safestrcpy>
  p->cwd = namei("/");
    8000135e:	00007517          	auipc	a0,0x7
    80001362:	e7250513          	add	a0,a0,-398 # 800081d0 <etext+0x1d0>
    80001366:	00002097          	auipc	ra,0x2
    8000136a:	2ac080e7          	jalr	684(ra) # 80003612 <namei>
    8000136e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001372:	478d                	li	a5,3
    80001374:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001376:	8526                	mv	a0,s1
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	13a080e7          	jalr	314(ra) # 800064b2 <release>
}
    80001380:	60e2                	ld	ra,24(sp)
    80001382:	6442                	ld	s0,16(sp)
    80001384:	64a2                	ld	s1,8(sp)
    80001386:	6105                	add	sp,sp,32
    80001388:	8082                	ret

000000008000138a <growproc>:
{
    8000138a:	1101                	add	sp,sp,-32
    8000138c:	ec06                	sd	ra,24(sp)
    8000138e:	e822                	sd	s0,16(sp)
    80001390:	e426                	sd	s1,8(sp)
    80001392:	e04a                	sd	s2,0(sp)
    80001394:	1000                	add	s0,sp,32
    80001396:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	c94080e7          	jalr	-876(ra) # 8000102c <myproc>
    800013a0:	84aa                	mv	s1,a0
  sz = p->sz;
    800013a2:	652c                	ld	a1,72(a0)
  if(n > 0){
    800013a4:	01204c63          	bgtz	s2,800013bc <growproc+0x32>
  } else if(n < 0){
    800013a8:	02094663          	bltz	s2,800013d4 <growproc+0x4a>
  p->sz = sz;
    800013ac:	e4ac                	sd	a1,72(s1)
  return 0;
    800013ae:	4501                	li	a0,0
}
    800013b0:	60e2                	ld	ra,24(sp)
    800013b2:	6442                	ld	s0,16(sp)
    800013b4:	64a2                	ld	s1,8(sp)
    800013b6:	6902                	ld	s2,0(sp)
    800013b8:	6105                	add	sp,sp,32
    800013ba:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800013bc:	4691                	li	a3,4
    800013be:	00b90633          	add	a2,s2,a1
    800013c2:	6928                	ld	a0,80(a0)
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	6a4080e7          	jalr	1700(ra) # 80000a68 <uvmalloc>
    800013cc:	85aa                	mv	a1,a0
    800013ce:	fd79                	bnez	a0,800013ac <growproc+0x22>
      return -1;
    800013d0:	557d                	li	a0,-1
    800013d2:	bff9                	j	800013b0 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013d4:	00b90633          	add	a2,s2,a1
    800013d8:	6928                	ld	a0,80(a0)
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	646080e7          	jalr	1606(ra) # 80000a20 <uvmdealloc>
    800013e2:	85aa                	mv	a1,a0
    800013e4:	b7e1                	j	800013ac <growproc+0x22>

00000000800013e6 <fork>:
{
    800013e6:	7139                	add	sp,sp,-64
    800013e8:	fc06                	sd	ra,56(sp)
    800013ea:	f822                	sd	s0,48(sp)
    800013ec:	f426                	sd	s1,40(sp)
    800013ee:	f04a                	sd	s2,32(sp)
    800013f0:	ec4e                	sd	s3,24(sp)
    800013f2:	e852                	sd	s4,16(sp)
    800013f4:	e456                	sd	s5,8(sp)
    800013f6:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	c34080e7          	jalr	-972(ra) # 8000102c <myproc>
    80001400:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001402:	00000097          	auipc	ra,0x0
    80001406:	e38080e7          	jalr	-456(ra) # 8000123a <allocproc>
    8000140a:	12050063          	beqz	a0,8000152a <fork+0x144>
    8000140e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001410:	048ab603          	ld	a2,72(s5)
    80001414:	692c                	ld	a1,80(a0)
    80001416:	050ab503          	ld	a0,80(s5)
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	7a6080e7          	jalr	1958(ra) # 80000bc0 <uvmcopy>
    80001422:	04054863          	bltz	a0,80001472 <fork+0x8c>
  np->sz = p->sz;
    80001426:	048ab783          	ld	a5,72(s5)
    8000142a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000142e:	058ab683          	ld	a3,88(s5)
    80001432:	87b6                	mv	a5,a3
    80001434:	0589b703          	ld	a4,88(s3)
    80001438:	12068693          	add	a3,a3,288
    8000143c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001440:	6788                	ld	a0,8(a5)
    80001442:	6b8c                	ld	a1,16(a5)
    80001444:	6f90                	ld	a2,24(a5)
    80001446:	01073023          	sd	a6,0(a4)
    8000144a:	e708                	sd	a0,8(a4)
    8000144c:	eb0c                	sd	a1,16(a4)
    8000144e:	ef10                	sd	a2,24(a4)
    80001450:	02078793          	add	a5,a5,32
    80001454:	02070713          	add	a4,a4,32
    80001458:	fed792e3          	bne	a5,a3,8000143c <fork+0x56>
  np->trapframe->a0 = 0;
    8000145c:	0589b783          	ld	a5,88(s3)
    80001460:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001464:	0d0a8493          	add	s1,s5,208
    80001468:	0d098913          	add	s2,s3,208
    8000146c:	150a8a13          	add	s4,s5,336
    80001470:	a00d                	j	80001492 <fork+0xac>
    freeproc(np);
    80001472:	854e                	mv	a0,s3
    80001474:	00000097          	auipc	ra,0x0
    80001478:	d6e080e7          	jalr	-658(ra) # 800011e2 <freeproc>
    release(&np->lock);
    8000147c:	854e                	mv	a0,s3
    8000147e:	00005097          	auipc	ra,0x5
    80001482:	034080e7          	jalr	52(ra) # 800064b2 <release>
    return -1;
    80001486:	597d                	li	s2,-1
    80001488:	a079                	j	80001516 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000148a:	04a1                	add	s1,s1,8
    8000148c:	0921                	add	s2,s2,8
    8000148e:	01448b63          	beq	s1,s4,800014a4 <fork+0xbe>
    if(p->ofile[i])
    80001492:	6088                	ld	a0,0(s1)
    80001494:	d97d                	beqz	a0,8000148a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001496:	00002097          	auipc	ra,0x2
    8000149a:	7ee080e7          	jalr	2030(ra) # 80003c84 <filedup>
    8000149e:	00a93023          	sd	a0,0(s2)
    800014a2:	b7e5                	j	8000148a <fork+0xa4>
  np->cwd = idup(p->cwd);
    800014a4:	150ab503          	ld	a0,336(s5)
    800014a8:	00002097          	auipc	ra,0x2
    800014ac:	986080e7          	jalr	-1658(ra) # 80002e2e <idup>
    800014b0:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014b4:	4641                	li	a2,16
    800014b6:	158a8593          	add	a1,s5,344
    800014ba:	15898513          	add	a0,s3,344
    800014be:	fffff097          	auipc	ra,0xfffff
    800014c2:	f92080e7          	jalr	-110(ra) # 80000450 <safestrcpy>
  pid = np->pid;
    800014c6:	0309a903          	lw	s2,48(s3)
  np->tmask = p->tmask;
    800014ca:	168aa783          	lw	a5,360(s5)
    800014ce:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    800014d2:	854e                	mv	a0,s3
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	fde080e7          	jalr	-34(ra) # 800064b2 <release>
  acquire(&wait_lock);
    800014dc:	00027497          	auipc	s1,0x27
    800014e0:	60448493          	add	s1,s1,1540 # 80028ae0 <wait_lock>
    800014e4:	8526                	mv	a0,s1
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	f18080e7          	jalr	-232(ra) # 800063fe <acquire>
  np->parent = p;
    800014ee:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	fbe080e7          	jalr	-66(ra) # 800064b2 <release>
  acquire(&np->lock);
    800014fc:	854e                	mv	a0,s3
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	f00080e7          	jalr	-256(ra) # 800063fe <acquire>
  np->state = RUNNABLE;
    80001506:	478d                	li	a5,3
    80001508:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000150c:	854e                	mv	a0,s3
    8000150e:	00005097          	auipc	ra,0x5
    80001512:	fa4080e7          	jalr	-92(ra) # 800064b2 <release>
}
    80001516:	854a                	mv	a0,s2
    80001518:	70e2                	ld	ra,56(sp)
    8000151a:	7442                	ld	s0,48(sp)
    8000151c:	74a2                	ld	s1,40(sp)
    8000151e:	7902                	ld	s2,32(sp)
    80001520:	69e2                	ld	s3,24(sp)
    80001522:	6a42                	ld	s4,16(sp)
    80001524:	6aa2                	ld	s5,8(sp)
    80001526:	6121                	add	sp,sp,64
    80001528:	8082                	ret
    return -1;
    8000152a:	597d                	li	s2,-1
    8000152c:	b7ed                	j	80001516 <fork+0x130>

000000008000152e <scheduler>:
{
    8000152e:	7139                	add	sp,sp,-64
    80001530:	fc06                	sd	ra,56(sp)
    80001532:	f822                	sd	s0,48(sp)
    80001534:	f426                	sd	s1,40(sp)
    80001536:	f04a                	sd	s2,32(sp)
    80001538:	ec4e                	sd	s3,24(sp)
    8000153a:	e852                	sd	s4,16(sp)
    8000153c:	e456                	sd	s5,8(sp)
    8000153e:	e05a                	sd	s6,0(sp)
    80001540:	0080                	add	s0,sp,64
    80001542:	8792                	mv	a5,tp
  int id = r_tp();
    80001544:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001546:	00779a93          	sll	s5,a5,0x7
    8000154a:	00027717          	auipc	a4,0x27
    8000154e:	57e70713          	add	a4,a4,1406 # 80028ac8 <pid_lock>
    80001552:	9756                	add	a4,a4,s5
    80001554:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001558:	00027717          	auipc	a4,0x27
    8000155c:	5a870713          	add	a4,a4,1448 # 80028b00 <cpus+0x8>
    80001560:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001562:	498d                	li	s3,3
        p->state = RUNNING;
    80001564:	4b11                	li	s6,4
        c->proc = p;
    80001566:	079e                	sll	a5,a5,0x7
    80001568:	00027a17          	auipc	s4,0x27
    8000156c:	560a0a13          	add	s4,s4,1376 # 80028ac8 <pid_lock>
    80001570:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	0002d917          	auipc	s2,0x2d
    80001576:	58690913          	add	s2,s2,1414 # 8002eaf8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000157a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000157e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001582:	10079073          	csrw	sstatus,a5
    80001586:	00028497          	auipc	s1,0x28
    8000158a:	97248493          	add	s1,s1,-1678 # 80028ef8 <proc>
    8000158e:	a811                	j	800015a2 <scheduler+0x74>
      release(&p->lock);
    80001590:	8526                	mv	a0,s1
    80001592:	00005097          	auipc	ra,0x5
    80001596:	f20080e7          	jalr	-224(ra) # 800064b2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000159a:	17048493          	add	s1,s1,368
    8000159e:	fd248ee3          	beq	s1,s2,8000157a <scheduler+0x4c>
      acquire(&p->lock);
    800015a2:	8526                	mv	a0,s1
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	e5a080e7          	jalr	-422(ra) # 800063fe <acquire>
      if(p->state == RUNNABLE) {
    800015ac:	4c9c                	lw	a5,24(s1)
    800015ae:	ff3791e3          	bne	a5,s3,80001590 <scheduler+0x62>
        p->state = RUNNING;
    800015b2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015b6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015ba:	06048593          	add	a1,s1,96
    800015be:	8556                	mv	a0,s5
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	6a6080e7          	jalr	1702(ra) # 80001c66 <swtch>
        c->proc = 0;
    800015c8:	020a3823          	sd	zero,48(s4)
    800015cc:	b7d1                	j	80001590 <scheduler+0x62>

00000000800015ce <sched>:
{
    800015ce:	7179                	add	sp,sp,-48
    800015d0:	f406                	sd	ra,40(sp)
    800015d2:	f022                	sd	s0,32(sp)
    800015d4:	ec26                	sd	s1,24(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	a50080e7          	jalr	-1456(ra) # 8000102c <myproc>
    800015e4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	d9e080e7          	jalr	-610(ra) # 80006384 <holding>
    800015ee:	c93d                	beqz	a0,80001664 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015f0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015f2:	2781                	sext.w	a5,a5
    800015f4:	079e                	sll	a5,a5,0x7
    800015f6:	00027717          	auipc	a4,0x27
    800015fa:	4d270713          	add	a4,a4,1234 # 80028ac8 <pid_lock>
    800015fe:	97ba                	add	a5,a5,a4
    80001600:	0a87a703          	lw	a4,168(a5)
    80001604:	4785                	li	a5,1
    80001606:	06f71763          	bne	a4,a5,80001674 <sched+0xa6>
  if(p->state == RUNNING)
    8000160a:	4c98                	lw	a4,24(s1)
    8000160c:	4791                	li	a5,4
    8000160e:	06f70b63          	beq	a4,a5,80001684 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001612:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001616:	8b89                	and	a5,a5,2
  if(intr_get())
    80001618:	efb5                	bnez	a5,80001694 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000161a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000161c:	00027917          	auipc	s2,0x27
    80001620:	4ac90913          	add	s2,s2,1196 # 80028ac8 <pid_lock>
    80001624:	2781                	sext.w	a5,a5
    80001626:	079e                	sll	a5,a5,0x7
    80001628:	97ca                	add	a5,a5,s2
    8000162a:	0ac7a983          	lw	s3,172(a5)
    8000162e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001630:	2781                	sext.w	a5,a5
    80001632:	079e                	sll	a5,a5,0x7
    80001634:	00027597          	auipc	a1,0x27
    80001638:	4cc58593          	add	a1,a1,1228 # 80028b00 <cpus+0x8>
    8000163c:	95be                	add	a1,a1,a5
    8000163e:	06048513          	add	a0,s1,96
    80001642:	00000097          	auipc	ra,0x0
    80001646:	624080e7          	jalr	1572(ra) # 80001c66 <swtch>
    8000164a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000164c:	2781                	sext.w	a5,a5
    8000164e:	079e                	sll	a5,a5,0x7
    80001650:	993e                	add	s2,s2,a5
    80001652:	0b392623          	sw	s3,172(s2)
}
    80001656:	70a2                	ld	ra,40(sp)
    80001658:	7402                	ld	s0,32(sp)
    8000165a:	64e2                	ld	s1,24(sp)
    8000165c:	6942                	ld	s2,16(sp)
    8000165e:	69a2                	ld	s3,8(sp)
    80001660:	6145                	add	sp,sp,48
    80001662:	8082                	ret
    panic("sched p->lock");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b7450513          	add	a0,a0,-1164 # 800081d8 <etext+0x1d8>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	85a080e7          	jalr	-1958(ra) # 80005ec6 <panic>
    panic("sched locks");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b7450513          	add	a0,a0,-1164 # 800081e8 <etext+0x1e8>
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	84a080e7          	jalr	-1974(ra) # 80005ec6 <panic>
    panic("sched running");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	b7450513          	add	a0,a0,-1164 # 800081f8 <etext+0x1f8>
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	83a080e7          	jalr	-1990(ra) # 80005ec6 <panic>
    panic("sched interruptible");
    80001694:	00007517          	auipc	a0,0x7
    80001698:	b7450513          	add	a0,a0,-1164 # 80008208 <etext+0x208>
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	82a080e7          	jalr	-2006(ra) # 80005ec6 <panic>

00000000800016a4 <yield>:
{
    800016a4:	1101                	add	sp,sp,-32
    800016a6:	ec06                	sd	ra,24(sp)
    800016a8:	e822                	sd	s0,16(sp)
    800016aa:	e426                	sd	s1,8(sp)
    800016ac:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	97e080e7          	jalr	-1666(ra) # 8000102c <myproc>
    800016b6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	d46080e7          	jalr	-698(ra) # 800063fe <acquire>
  p->state = RUNNABLE;
    800016c0:	478d                	li	a5,3
    800016c2:	cc9c                	sw	a5,24(s1)
  sched();
    800016c4:	00000097          	auipc	ra,0x0
    800016c8:	f0a080e7          	jalr	-246(ra) # 800015ce <sched>
  release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	de4080e7          	jalr	-540(ra) # 800064b2 <release>
}
    800016d6:	60e2                	ld	ra,24(sp)
    800016d8:	6442                	ld	s0,16(sp)
    800016da:	64a2                	ld	s1,8(sp)
    800016dc:	6105                	add	sp,sp,32
    800016de:	8082                	ret

00000000800016e0 <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    800016e0:	7179                	add	sp,sp,-48
    800016e2:	f406                	sd	ra,40(sp)
    800016e4:	f022                	sd	s0,32(sp)
    800016e6:	ec26                	sd	s1,24(sp)
    800016e8:	e84a                	sd	s2,16(sp)
    800016ea:	e44e                	sd	s3,8(sp)
    800016ec:	1800                	add	s0,sp,48
    800016ee:	89aa                	mv	s3,a0
    800016f0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	93a080e7          	jalr	-1734(ra) # 8000102c <myproc>
    800016fa:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	d02080e7          	jalr	-766(ra) # 800063fe <acquire>
  release(lk);
    80001704:	854a                	mv	a0,s2
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	dac080e7          	jalr	-596(ra) # 800064b2 <release>

  /* Go to sleep. */
  p->chan = chan;
    8000170e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001712:	4789                	li	a5,2
    80001714:	cc9c                	sw	a5,24(s1)

  sched();
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	eb8080e7          	jalr	-328(ra) # 800015ce <sched>

  /* Tidy up. */
  p->chan = 0;
    8000171e:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	00005097          	auipc	ra,0x5
    80001728:	d8e080e7          	jalr	-626(ra) # 800064b2 <release>
  acquire(lk);
    8000172c:	854a                	mv	a0,s2
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	cd0080e7          	jalr	-816(ra) # 800063fe <acquire>
}
    80001736:	70a2                	ld	ra,40(sp)
    80001738:	7402                	ld	s0,32(sp)
    8000173a:	64e2                	ld	s1,24(sp)
    8000173c:	6942                	ld	s2,16(sp)
    8000173e:	69a2                	ld	s3,8(sp)
    80001740:	6145                	add	sp,sp,48
    80001742:	8082                	ret

0000000080001744 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    80001744:	7139                	add	sp,sp,-64
    80001746:	fc06                	sd	ra,56(sp)
    80001748:	f822                	sd	s0,48(sp)
    8000174a:	f426                	sd	s1,40(sp)
    8000174c:	f04a                	sd	s2,32(sp)
    8000174e:	ec4e                	sd	s3,24(sp)
    80001750:	e852                	sd	s4,16(sp)
    80001752:	e456                	sd	s5,8(sp)
    80001754:	0080                	add	s0,sp,64
    80001756:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001758:	00027497          	auipc	s1,0x27
    8000175c:	7a048493          	add	s1,s1,1952 # 80028ef8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001760:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001762:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001764:	0002d917          	auipc	s2,0x2d
    80001768:	39490913          	add	s2,s2,916 # 8002eaf8 <tickslock>
    8000176c:	a811                	j	80001780 <wakeup+0x3c>
      }
      release(&p->lock);
    8000176e:	8526                	mv	a0,s1
    80001770:	00005097          	auipc	ra,0x5
    80001774:	d42080e7          	jalr	-702(ra) # 800064b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001778:	17048493          	add	s1,s1,368
    8000177c:	03248663          	beq	s1,s2,800017a8 <wakeup+0x64>
    if(p != myproc()){
    80001780:	00000097          	auipc	ra,0x0
    80001784:	8ac080e7          	jalr	-1876(ra) # 8000102c <myproc>
    80001788:	fea488e3          	beq	s1,a0,80001778 <wakeup+0x34>
      acquire(&p->lock);
    8000178c:	8526                	mv	a0,s1
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	c70080e7          	jalr	-912(ra) # 800063fe <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001796:	4c9c                	lw	a5,24(s1)
    80001798:	fd379be3          	bne	a5,s3,8000176e <wakeup+0x2a>
    8000179c:	709c                	ld	a5,32(s1)
    8000179e:	fd4798e3          	bne	a5,s4,8000176e <wakeup+0x2a>
        p->state = RUNNABLE;
    800017a2:	0154ac23          	sw	s5,24(s1)
    800017a6:	b7e1                	j	8000176e <wakeup+0x2a>
    }
  }
}
    800017a8:	70e2                	ld	ra,56(sp)
    800017aa:	7442                	ld	s0,48(sp)
    800017ac:	74a2                	ld	s1,40(sp)
    800017ae:	7902                	ld	s2,32(sp)
    800017b0:	69e2                	ld	s3,24(sp)
    800017b2:	6a42                	ld	s4,16(sp)
    800017b4:	6aa2                	ld	s5,8(sp)
    800017b6:	6121                	add	sp,sp,64
    800017b8:	8082                	ret

00000000800017ba <reparent>:
{
    800017ba:	7179                	add	sp,sp,-48
    800017bc:	f406                	sd	ra,40(sp)
    800017be:	f022                	sd	s0,32(sp)
    800017c0:	ec26                	sd	s1,24(sp)
    800017c2:	e84a                	sd	s2,16(sp)
    800017c4:	e44e                	sd	s3,8(sp)
    800017c6:	e052                	sd	s4,0(sp)
    800017c8:	1800                	add	s0,sp,48
    800017ca:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017cc:	00027497          	auipc	s1,0x27
    800017d0:	72c48493          	add	s1,s1,1836 # 80028ef8 <proc>
      pp->parent = initproc;
    800017d4:	00007a17          	auipc	s4,0x7
    800017d8:	2aca0a13          	add	s4,s4,684 # 80008a80 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017dc:	0002d997          	auipc	s3,0x2d
    800017e0:	31c98993          	add	s3,s3,796 # 8002eaf8 <tickslock>
    800017e4:	a029                	j	800017ee <reparent+0x34>
    800017e6:	17048493          	add	s1,s1,368
    800017ea:	01348d63          	beq	s1,s3,80001804 <reparent+0x4a>
    if(pp->parent == p){
    800017ee:	7c9c                	ld	a5,56(s1)
    800017f0:	ff279be3          	bne	a5,s2,800017e6 <reparent+0x2c>
      pp->parent = initproc;
    800017f4:	000a3503          	ld	a0,0(s4)
    800017f8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017fa:	00000097          	auipc	ra,0x0
    800017fe:	f4a080e7          	jalr	-182(ra) # 80001744 <wakeup>
    80001802:	b7d5                	j	800017e6 <reparent+0x2c>
}
    80001804:	70a2                	ld	ra,40(sp)
    80001806:	7402                	ld	s0,32(sp)
    80001808:	64e2                	ld	s1,24(sp)
    8000180a:	6942                	ld	s2,16(sp)
    8000180c:	69a2                	ld	s3,8(sp)
    8000180e:	6a02                	ld	s4,0(sp)
    80001810:	6145                	add	sp,sp,48
    80001812:	8082                	ret

0000000080001814 <exit>:
{
    80001814:	7179                	add	sp,sp,-48
    80001816:	f406                	sd	ra,40(sp)
    80001818:	f022                	sd	s0,32(sp)
    8000181a:	ec26                	sd	s1,24(sp)
    8000181c:	e84a                	sd	s2,16(sp)
    8000181e:	e44e                	sd	s3,8(sp)
    80001820:	e052                	sd	s4,0(sp)
    80001822:	1800                	add	s0,sp,48
    80001824:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	806080e7          	jalr	-2042(ra) # 8000102c <myproc>
    8000182e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001830:	00007797          	auipc	a5,0x7
    80001834:	2507b783          	ld	a5,592(a5) # 80008a80 <initproc>
    80001838:	0d050493          	add	s1,a0,208
    8000183c:	15050913          	add	s2,a0,336
    80001840:	02a79363          	bne	a5,a0,80001866 <exit+0x52>
    panic("init exiting");
    80001844:	00007517          	auipc	a0,0x7
    80001848:	9dc50513          	add	a0,a0,-1572 # 80008220 <etext+0x220>
    8000184c:	00004097          	auipc	ra,0x4
    80001850:	67a080e7          	jalr	1658(ra) # 80005ec6 <panic>
      fileclose(f);
    80001854:	00002097          	auipc	ra,0x2
    80001858:	482080e7          	jalr	1154(ra) # 80003cd6 <fileclose>
      p->ofile[fd] = 0;
    8000185c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001860:	04a1                	add	s1,s1,8
    80001862:	01248563          	beq	s1,s2,8000186c <exit+0x58>
    if(p->ofile[fd]){
    80001866:	6088                	ld	a0,0(s1)
    80001868:	f575                	bnez	a0,80001854 <exit+0x40>
    8000186a:	bfdd                	j	80001860 <exit+0x4c>
  begin_op();
    8000186c:	00002097          	auipc	ra,0x2
    80001870:	fa6080e7          	jalr	-90(ra) # 80003812 <begin_op>
  iput(p->cwd);
    80001874:	1509b503          	ld	a0,336(s3)
    80001878:	00001097          	auipc	ra,0x1
    8000187c:	7ae080e7          	jalr	1966(ra) # 80003026 <iput>
  end_op();
    80001880:	00002097          	auipc	ra,0x2
    80001884:	00c080e7          	jalr	12(ra) # 8000388c <end_op>
  p->cwd = 0;
    80001888:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000188c:	00027497          	auipc	s1,0x27
    80001890:	25448493          	add	s1,s1,596 # 80028ae0 <wait_lock>
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	b68080e7          	jalr	-1176(ra) # 800063fe <acquire>
  reparent(p);
    8000189e:	854e                	mv	a0,s3
    800018a0:	00000097          	auipc	ra,0x0
    800018a4:	f1a080e7          	jalr	-230(ra) # 800017ba <reparent>
  wakeup(p->parent);
    800018a8:	0389b503          	ld	a0,56(s3)
    800018ac:	00000097          	auipc	ra,0x0
    800018b0:	e98080e7          	jalr	-360(ra) # 80001744 <wakeup>
  acquire(&p->lock);
    800018b4:	854e                	mv	a0,s3
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	b48080e7          	jalr	-1208(ra) # 800063fe <acquire>
  p->xstate = status;
    800018be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018c2:	4795                	li	a5,5
    800018c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	be8080e7          	jalr	-1048(ra) # 800064b2 <release>
  sched();
    800018d2:	00000097          	auipc	ra,0x0
    800018d6:	cfc080e7          	jalr	-772(ra) # 800015ce <sched>
  panic("zombie exit");
    800018da:	00007517          	auipc	a0,0x7
    800018de:	95650513          	add	a0,a0,-1706 # 80008230 <etext+0x230>
    800018e2:	00004097          	auipc	ra,0x4
    800018e6:	5e4080e7          	jalr	1508(ra) # 80005ec6 <panic>

00000000800018ea <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    800018ea:	7179                	add	sp,sp,-48
    800018ec:	f406                	sd	ra,40(sp)
    800018ee:	f022                	sd	s0,32(sp)
    800018f0:	ec26                	sd	s1,24(sp)
    800018f2:	e84a                	sd	s2,16(sp)
    800018f4:	e44e                	sd	s3,8(sp)
    800018f6:	1800                	add	s0,sp,48
    800018f8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018fa:	00027497          	auipc	s1,0x27
    800018fe:	5fe48493          	add	s1,s1,1534 # 80028ef8 <proc>
    80001902:	0002d997          	auipc	s3,0x2d
    80001906:	1f698993          	add	s3,s3,502 # 8002eaf8 <tickslock>
    acquire(&p->lock);
    8000190a:	8526                	mv	a0,s1
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	af2080e7          	jalr	-1294(ra) # 800063fe <acquire>
    if(p->pid == pid){
    80001914:	589c                	lw	a5,48(s1)
    80001916:	01278d63          	beq	a5,s2,80001930 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000191a:	8526                	mv	a0,s1
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	b96080e7          	jalr	-1130(ra) # 800064b2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001924:	17048493          	add	s1,s1,368
    80001928:	ff3491e3          	bne	s1,s3,8000190a <kill+0x20>
  }
  return -1;
    8000192c:	557d                	li	a0,-1
    8000192e:	a829                	j	80001948 <kill+0x5e>
      p->killed = 1;
    80001930:	4785                	li	a5,1
    80001932:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001934:	4c98                	lw	a4,24(s1)
    80001936:	4789                	li	a5,2
    80001938:	00f70f63          	beq	a4,a5,80001956 <kill+0x6c>
      release(&p->lock);
    8000193c:	8526                	mv	a0,s1
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	b74080e7          	jalr	-1164(ra) # 800064b2 <release>
      return 0;
    80001946:	4501                	li	a0,0
}
    80001948:	70a2                	ld	ra,40(sp)
    8000194a:	7402                	ld	s0,32(sp)
    8000194c:	64e2                	ld	s1,24(sp)
    8000194e:	6942                	ld	s2,16(sp)
    80001950:	69a2                	ld	s3,8(sp)
    80001952:	6145                	add	sp,sp,48
    80001954:	8082                	ret
        p->state = RUNNABLE;
    80001956:	478d                	li	a5,3
    80001958:	cc9c                	sw	a5,24(s1)
    8000195a:	b7cd                	j	8000193c <kill+0x52>

000000008000195c <setkilled>:

void
setkilled(struct proc *p)
{
    8000195c:	1101                	add	sp,sp,-32
    8000195e:	ec06                	sd	ra,24(sp)
    80001960:	e822                	sd	s0,16(sp)
    80001962:	e426                	sd	s1,8(sp)
    80001964:	1000                	add	s0,sp,32
    80001966:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001968:	00005097          	auipc	ra,0x5
    8000196c:	a96080e7          	jalr	-1386(ra) # 800063fe <acquire>
  p->killed = 1;
    80001970:	4785                	li	a5,1
    80001972:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	b3c080e7          	jalr	-1220(ra) # 800064b2 <release>
}
    8000197e:	60e2                	ld	ra,24(sp)
    80001980:	6442                	ld	s0,16(sp)
    80001982:	64a2                	ld	s1,8(sp)
    80001984:	6105                	add	sp,sp,32
    80001986:	8082                	ret

0000000080001988 <killed>:

int
killed(struct proc *p)
{
    80001988:	1101                	add	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	e426                	sd	s1,8(sp)
    80001990:	e04a                	sd	s2,0(sp)
    80001992:	1000                	add	s0,sp,32
    80001994:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001996:	00005097          	auipc	ra,0x5
    8000199a:	a68080e7          	jalr	-1432(ra) # 800063fe <acquire>
  k = p->killed;
    8000199e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019a2:	8526                	mv	a0,s1
    800019a4:	00005097          	auipc	ra,0x5
    800019a8:	b0e080e7          	jalr	-1266(ra) # 800064b2 <release>
  return k;
}
    800019ac:	854a                	mv	a0,s2
    800019ae:	60e2                	ld	ra,24(sp)
    800019b0:	6442                	ld	s0,16(sp)
    800019b2:	64a2                	ld	s1,8(sp)
    800019b4:	6902                	ld	s2,0(sp)
    800019b6:	6105                	add	sp,sp,32
    800019b8:	8082                	ret

00000000800019ba <wait>:
{
    800019ba:	715d                	add	sp,sp,-80
    800019bc:	e486                	sd	ra,72(sp)
    800019be:	e0a2                	sd	s0,64(sp)
    800019c0:	fc26                	sd	s1,56(sp)
    800019c2:	f84a                	sd	s2,48(sp)
    800019c4:	f44e                	sd	s3,40(sp)
    800019c6:	f052                	sd	s4,32(sp)
    800019c8:	ec56                	sd	s5,24(sp)
    800019ca:	e85a                	sd	s6,16(sp)
    800019cc:	e45e                	sd	s7,8(sp)
    800019ce:	e062                	sd	s8,0(sp)
    800019d0:	0880                	add	s0,sp,80
    800019d2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	658080e7          	jalr	1624(ra) # 8000102c <myproc>
    800019dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800019de:	00027517          	auipc	a0,0x27
    800019e2:	10250513          	add	a0,a0,258 # 80028ae0 <wait_lock>
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	a18080e7          	jalr	-1512(ra) # 800063fe <acquire>
    havekids = 0;
    800019ee:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019f0:	4a15                	li	s4,5
        havekids = 1;
    800019f2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019f4:	0002d997          	auipc	s3,0x2d
    800019f8:	10498993          	add	s3,s3,260 # 8002eaf8 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800019fc:	00027c17          	auipc	s8,0x27
    80001a00:	0e4c0c13          	add	s8,s8,228 # 80028ae0 <wait_lock>
    80001a04:	a0d1                	j	80001ac8 <wait+0x10e>
          pid = pp->pid;
    80001a06:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a0a:	000b0e63          	beqz	s6,80001a26 <wait+0x6c>
    80001a0e:	4691                	li	a3,4
    80001a10:	02c48613          	add	a2,s1,44
    80001a14:	85da                	mv	a1,s6
    80001a16:	05093503          	ld	a0,80(s2)
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	29e080e7          	jalr	670(ra) # 80000cb8 <copyout>
    80001a22:	04054163          	bltz	a0,80001a64 <wait+0xaa>
          freeproc(pp);
    80001a26:	8526                	mv	a0,s1
    80001a28:	fffff097          	auipc	ra,0xfffff
    80001a2c:	7ba080e7          	jalr	1978(ra) # 800011e2 <freeproc>
          release(&pp->lock);
    80001a30:	8526                	mv	a0,s1
    80001a32:	00005097          	auipc	ra,0x5
    80001a36:	a80080e7          	jalr	-1408(ra) # 800064b2 <release>
          release(&wait_lock);
    80001a3a:	00027517          	auipc	a0,0x27
    80001a3e:	0a650513          	add	a0,a0,166 # 80028ae0 <wait_lock>
    80001a42:	00005097          	auipc	ra,0x5
    80001a46:	a70080e7          	jalr	-1424(ra) # 800064b2 <release>
}
    80001a4a:	854e                	mv	a0,s3
    80001a4c:	60a6                	ld	ra,72(sp)
    80001a4e:	6406                	ld	s0,64(sp)
    80001a50:	74e2                	ld	s1,56(sp)
    80001a52:	7942                	ld	s2,48(sp)
    80001a54:	79a2                	ld	s3,40(sp)
    80001a56:	7a02                	ld	s4,32(sp)
    80001a58:	6ae2                	ld	s5,24(sp)
    80001a5a:	6b42                	ld	s6,16(sp)
    80001a5c:	6ba2                	ld	s7,8(sp)
    80001a5e:	6c02                	ld	s8,0(sp)
    80001a60:	6161                	add	sp,sp,80
    80001a62:	8082                	ret
            release(&pp->lock);
    80001a64:	8526                	mv	a0,s1
    80001a66:	00005097          	auipc	ra,0x5
    80001a6a:	a4c080e7          	jalr	-1460(ra) # 800064b2 <release>
            release(&wait_lock);
    80001a6e:	00027517          	auipc	a0,0x27
    80001a72:	07250513          	add	a0,a0,114 # 80028ae0 <wait_lock>
    80001a76:	00005097          	auipc	ra,0x5
    80001a7a:	a3c080e7          	jalr	-1476(ra) # 800064b2 <release>
            return -1;
    80001a7e:	59fd                	li	s3,-1
    80001a80:	b7e9                	j	80001a4a <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a82:	17048493          	add	s1,s1,368
    80001a86:	03348463          	beq	s1,s3,80001aae <wait+0xf4>
      if(pp->parent == p){
    80001a8a:	7c9c                	ld	a5,56(s1)
    80001a8c:	ff279be3          	bne	a5,s2,80001a82 <wait+0xc8>
        acquire(&pp->lock);
    80001a90:	8526                	mv	a0,s1
    80001a92:	00005097          	auipc	ra,0x5
    80001a96:	96c080e7          	jalr	-1684(ra) # 800063fe <acquire>
        if(pp->state == ZOMBIE){
    80001a9a:	4c9c                	lw	a5,24(s1)
    80001a9c:	f74785e3          	beq	a5,s4,80001a06 <wait+0x4c>
        release(&pp->lock);
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	00005097          	auipc	ra,0x5
    80001aa6:	a10080e7          	jalr	-1520(ra) # 800064b2 <release>
        havekids = 1;
    80001aaa:	8756                	mv	a4,s5
    80001aac:	bfd9                	j	80001a82 <wait+0xc8>
    if(!havekids || killed(p)){
    80001aae:	c31d                	beqz	a4,80001ad4 <wait+0x11a>
    80001ab0:	854a                	mv	a0,s2
    80001ab2:	00000097          	auipc	ra,0x0
    80001ab6:	ed6080e7          	jalr	-298(ra) # 80001988 <killed>
    80001aba:	ed09                	bnez	a0,80001ad4 <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    80001abc:	85e2                	mv	a1,s8
    80001abe:	854a                	mv	a0,s2
    80001ac0:	00000097          	auipc	ra,0x0
    80001ac4:	c20080e7          	jalr	-992(ra) # 800016e0 <sleep>
    havekids = 0;
    80001ac8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001aca:	00027497          	auipc	s1,0x27
    80001ace:	42e48493          	add	s1,s1,1070 # 80028ef8 <proc>
    80001ad2:	bf65                	j	80001a8a <wait+0xd0>
      release(&wait_lock);
    80001ad4:	00027517          	auipc	a0,0x27
    80001ad8:	00c50513          	add	a0,a0,12 # 80028ae0 <wait_lock>
    80001adc:	00005097          	auipc	ra,0x5
    80001ae0:	9d6080e7          	jalr	-1578(ra) # 800064b2 <release>
      return -1;
    80001ae4:	59fd                	li	s3,-1
    80001ae6:	b795                	j	80001a4a <wait+0x90>

0000000080001ae8 <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ae8:	7179                	add	sp,sp,-48
    80001aea:	f406                	sd	ra,40(sp)
    80001aec:	f022                	sd	s0,32(sp)
    80001aee:	ec26                	sd	s1,24(sp)
    80001af0:	e84a                	sd	s2,16(sp)
    80001af2:	e44e                	sd	s3,8(sp)
    80001af4:	e052                	sd	s4,0(sp)
    80001af6:	1800                	add	s0,sp,48
    80001af8:	84aa                	mv	s1,a0
    80001afa:	892e                	mv	s2,a1
    80001afc:	89b2                	mv	s3,a2
    80001afe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b00:	fffff097          	auipc	ra,0xfffff
    80001b04:	52c080e7          	jalr	1324(ra) # 8000102c <myproc>
  if(user_dst){
    80001b08:	c08d                	beqz	s1,80001b2a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b0a:	86d2                	mv	a3,s4
    80001b0c:	864e                	mv	a2,s3
    80001b0e:	85ca                	mv	a1,s2
    80001b10:	6928                	ld	a0,80(a0)
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	1a6080e7          	jalr	422(ra) # 80000cb8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b1a:	70a2                	ld	ra,40(sp)
    80001b1c:	7402                	ld	s0,32(sp)
    80001b1e:	64e2                	ld	s1,24(sp)
    80001b20:	6942                	ld	s2,16(sp)
    80001b22:	69a2                	ld	s3,8(sp)
    80001b24:	6a02                	ld	s4,0(sp)
    80001b26:	6145                	add	sp,sp,48
    80001b28:	8082                	ret
    memmove((char *)dst, src, len);
    80001b2a:	000a061b          	sext.w	a2,s4
    80001b2e:	85ce                	mv	a1,s3
    80001b30:	854a                	mv	a0,s2
    80001b32:	fffff097          	auipc	ra,0xfffff
    80001b36:	832080e7          	jalr	-1998(ra) # 80000364 <memmove>
    return 0;
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	bff9                	j	80001b1a <either_copyout+0x32>

0000000080001b3e <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b3e:	7179                	add	sp,sp,-48
    80001b40:	f406                	sd	ra,40(sp)
    80001b42:	f022                	sd	s0,32(sp)
    80001b44:	ec26                	sd	s1,24(sp)
    80001b46:	e84a                	sd	s2,16(sp)
    80001b48:	e44e                	sd	s3,8(sp)
    80001b4a:	e052                	sd	s4,0(sp)
    80001b4c:	1800                	add	s0,sp,48
    80001b4e:	892a                	mv	s2,a0
    80001b50:	84ae                	mv	s1,a1
    80001b52:	89b2                	mv	s3,a2
    80001b54:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b56:	fffff097          	auipc	ra,0xfffff
    80001b5a:	4d6080e7          	jalr	1238(ra) # 8000102c <myproc>
  if(user_src){
    80001b5e:	c08d                	beqz	s1,80001b80 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b60:	86d2                	mv	a3,s4
    80001b62:	864e                	mv	a2,s3
    80001b64:	85ca                	mv	a1,s2
    80001b66:	6928                	ld	a0,80(a0)
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	210080e7          	jalr	528(ra) # 80000d78 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b70:	70a2                	ld	ra,40(sp)
    80001b72:	7402                	ld	s0,32(sp)
    80001b74:	64e2                	ld	s1,24(sp)
    80001b76:	6942                	ld	s2,16(sp)
    80001b78:	69a2                	ld	s3,8(sp)
    80001b7a:	6a02                	ld	s4,0(sp)
    80001b7c:	6145                	add	sp,sp,48
    80001b7e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b80:	000a061b          	sext.w	a2,s4
    80001b84:	85ce                	mv	a1,s3
    80001b86:	854a                	mv	a0,s2
    80001b88:	ffffe097          	auipc	ra,0xffffe
    80001b8c:	7dc080e7          	jalr	2012(ra) # 80000364 <memmove>
    return 0;
    80001b90:	8526                	mv	a0,s1
    80001b92:	bff9                	j	80001b70 <either_copyin+0x32>

0000000080001b94 <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    80001b94:	715d                	add	sp,sp,-80
    80001b96:	e486                	sd	ra,72(sp)
    80001b98:	e0a2                	sd	s0,64(sp)
    80001b9a:	fc26                	sd	s1,56(sp)
    80001b9c:	f84a                	sd	s2,48(sp)
    80001b9e:	f44e                	sd	s3,40(sp)
    80001ba0:	f052                	sd	s4,32(sp)
    80001ba2:	ec56                	sd	s5,24(sp)
    80001ba4:	e85a                	sd	s6,16(sp)
    80001ba6:	e45e                	sd	s7,8(sp)
    80001ba8:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001baa:	00006517          	auipc	a0,0x6
    80001bae:	49e50513          	add	a0,a0,1182 # 80008048 <etext+0x48>
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	35e080e7          	jalr	862(ra) # 80005f10 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bba:	00027497          	auipc	s1,0x27
    80001bbe:	49648493          	add	s1,s1,1174 # 80029050 <proc+0x158>
    80001bc2:	0002d917          	auipc	s2,0x2d
    80001bc6:	08e90913          	add	s2,s2,142 # 8002ec50 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bca:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bcc:	00006997          	auipc	s3,0x6
    80001bd0:	67498993          	add	s3,s3,1652 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001bd4:	00006a97          	auipc	s5,0x6
    80001bd8:	674a8a93          	add	s5,s5,1652 # 80008248 <etext+0x248>
    printf("\n");
    80001bdc:	00006a17          	auipc	s4,0x6
    80001be0:	46ca0a13          	add	s4,s4,1132 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001be4:	00006b97          	auipc	s7,0x6
    80001be8:	6a4b8b93          	add	s7,s7,1700 # 80008288 <states.0>
    80001bec:	a00d                	j	80001c0e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bee:	ed86a583          	lw	a1,-296(a3)
    80001bf2:	8556                	mv	a0,s5
    80001bf4:	00004097          	auipc	ra,0x4
    80001bf8:	31c080e7          	jalr	796(ra) # 80005f10 <printf>
    printf("\n");
    80001bfc:	8552                	mv	a0,s4
    80001bfe:	00004097          	auipc	ra,0x4
    80001c02:	312080e7          	jalr	786(ra) # 80005f10 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c06:	17048493          	add	s1,s1,368
    80001c0a:	03248263          	beq	s1,s2,80001c2e <procdump+0x9a>
    if(p->state == UNUSED)
    80001c0e:	86a6                	mv	a3,s1
    80001c10:	ec04a783          	lw	a5,-320(s1)
    80001c14:	dbed                	beqz	a5,80001c06 <procdump+0x72>
      state = "???";
    80001c16:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c18:	fcfb6be3          	bltu	s6,a5,80001bee <procdump+0x5a>
    80001c1c:	02079713          	sll	a4,a5,0x20
    80001c20:	01d75793          	srl	a5,a4,0x1d
    80001c24:	97de                	add	a5,a5,s7
    80001c26:	6390                	ld	a2,0(a5)
    80001c28:	f279                	bnez	a2,80001bee <procdump+0x5a>
      state = "???";
    80001c2a:	864e                	mv	a2,s3
    80001c2c:	b7c9                	j	80001bee <procdump+0x5a>
  }
}
    80001c2e:	60a6                	ld	ra,72(sp)
    80001c30:	6406                	ld	s0,64(sp)
    80001c32:	74e2                	ld	s1,56(sp)
    80001c34:	7942                	ld	s2,48(sp)
    80001c36:	79a2                	ld	s3,40(sp)
    80001c38:	7a02                	ld	s4,32(sp)
    80001c3a:	6ae2                	ld	s5,24(sp)
    80001c3c:	6b42                	ld	s6,16(sp)
    80001c3e:	6ba2                	ld	s7,8(sp)
    80001c40:	6161                	add	sp,sp,80
    80001c42:	8082                	ret

0000000080001c44 <trace>:
/* Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

void
trace(int mask)
{
    80001c44:	1101                	add	sp,sp,-32
    80001c46:	ec06                	sd	ra,24(sp)
    80001c48:	e822                	sd	s0,16(sp)
    80001c4a:	e426                	sd	s1,8(sp)
    80001c4c:	1000                	add	s0,sp,32
    80001c4e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	3dc080e7          	jalr	988(ra) # 8000102c <myproc>
  p->tmask = mask;
    80001c58:	16952423          	sw	s1,360(a0)
}
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6105                	add	sp,sp,32
    80001c64:	8082                	ret

0000000080001c66 <swtch>:
    80001c66:	00153023          	sd	ra,0(a0)
    80001c6a:	00253423          	sd	sp,8(a0)
    80001c6e:	e900                	sd	s0,16(a0)
    80001c70:	ed04                	sd	s1,24(a0)
    80001c72:	03253023          	sd	s2,32(a0)
    80001c76:	03353423          	sd	s3,40(a0)
    80001c7a:	03453823          	sd	s4,48(a0)
    80001c7e:	03553c23          	sd	s5,56(a0)
    80001c82:	05653023          	sd	s6,64(a0)
    80001c86:	05753423          	sd	s7,72(a0)
    80001c8a:	05853823          	sd	s8,80(a0)
    80001c8e:	05953c23          	sd	s9,88(a0)
    80001c92:	07a53023          	sd	s10,96(a0)
    80001c96:	07b53423          	sd	s11,104(a0)
    80001c9a:	0005b083          	ld	ra,0(a1)
    80001c9e:	0085b103          	ld	sp,8(a1)
    80001ca2:	6980                	ld	s0,16(a1)
    80001ca4:	6d84                	ld	s1,24(a1)
    80001ca6:	0205b903          	ld	s2,32(a1)
    80001caa:	0285b983          	ld	s3,40(a1)
    80001cae:	0305ba03          	ld	s4,48(a1)
    80001cb2:	0385ba83          	ld	s5,56(a1)
    80001cb6:	0405bb03          	ld	s6,64(a1)
    80001cba:	0485bb83          	ld	s7,72(a1)
    80001cbe:	0505bc03          	ld	s8,80(a1)
    80001cc2:	0585bc83          	ld	s9,88(a1)
    80001cc6:	0605bd03          	ld	s10,96(a1)
    80001cca:	0685bd83          	ld	s11,104(a1)
    80001cce:	8082                	ret

0000000080001cd0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cd0:	1141                	add	sp,sp,-16
    80001cd2:	e406                	sd	ra,8(sp)
    80001cd4:	e022                	sd	s0,0(sp)
    80001cd6:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001cd8:	00006597          	auipc	a1,0x6
    80001cdc:	5e058593          	add	a1,a1,1504 # 800082b8 <states.0+0x30>
    80001ce0:	0002d517          	auipc	a0,0x2d
    80001ce4:	e1850513          	add	a0,a0,-488 # 8002eaf8 <tickslock>
    80001ce8:	00004097          	auipc	ra,0x4
    80001cec:	686080e7          	jalr	1670(ra) # 8000636e <initlock>
}
    80001cf0:	60a2                	ld	ra,8(sp)
    80001cf2:	6402                	ld	s0,0(sp)
    80001cf4:	0141                	add	sp,sp,16
    80001cf6:	8082                	ret

0000000080001cf8 <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    80001cf8:	1141                	add	sp,sp,-16
    80001cfa:	e422                	sd	s0,8(sp)
    80001cfc:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfe:	00003797          	auipc	a5,0x3
    80001d02:	60278793          	add	a5,a5,1538 # 80005300 <kernelvec>
    80001d06:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d0a:	6422                	ld	s0,8(sp)
    80001d0c:	0141                	add	sp,sp,16
    80001d0e:	8082                	ret

0000000080001d10 <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80001d10:	1141                	add	sp,sp,-16
    80001d12:	e406                	sd	ra,8(sp)
    80001d14:	e022                	sd	s0,0(sp)
    80001d16:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	314080e7          	jalr	788(ra) # 8000102c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d20:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d24:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d26:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d2a:	00005697          	auipc	a3,0x5
    80001d2e:	2d668693          	add	a3,a3,726 # 80007000 <_trampoline>
    80001d32:	00005717          	auipc	a4,0x5
    80001d36:	2ce70713          	add	a4,a4,718 # 80007000 <_trampoline>
    80001d3a:	8f15                	sub	a4,a4,a3
    80001d3c:	040007b7          	lui	a5,0x4000
    80001d40:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d42:	07b2                	sll	a5,a5,0xc
    80001d44:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d46:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    80001d4a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d4c:	18002673          	csrr	a2,satp
    80001d50:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80001d52:	6d30                	ld	a2,88(a0)
    80001d54:	6138                	ld	a4,64(a0)
    80001d56:	6585                	lui	a1,0x1
    80001d58:	972e                	add	a4,a4,a1
    80001d5a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d5c:	6d38                	ld	a4,88(a0)
    80001d5e:	00000617          	auipc	a2,0x0
    80001d62:	13460613          	add	a2,a2,308 # 80001e92 <usertrap>
    80001d66:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    80001d68:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d6a:	8612                	mv	a2,tp
    80001d6c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6e:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    80001d72:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    80001d76:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    80001d7e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d80:	6f18                	ld	a4,24(a4)
    80001d82:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d86:	6928                	ld	a0,80(a0)
    80001d88:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d8a:	00005717          	auipc	a4,0x5
    80001d8e:	31270713          	add	a4,a4,786 # 8000709c <userret>
    80001d92:	8f15                	sub	a4,a4,a3
    80001d94:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d96:	577d                	li	a4,-1
    80001d98:	177e                	sll	a4,a4,0x3f
    80001d9a:	8d59                	or	a0,a0,a4
    80001d9c:	9782                	jalr	a5
}
    80001d9e:	60a2                	ld	ra,8(sp)
    80001da0:	6402                	ld	s0,0(sp)
    80001da2:	0141                	add	sp,sp,16
    80001da4:	8082                	ret

0000000080001da6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001da6:	1101                	add	sp,sp,-32
    80001da8:	ec06                	sd	ra,24(sp)
    80001daa:	e822                	sd	s0,16(sp)
    80001dac:	e426                	sd	s1,8(sp)
    80001dae:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001db0:	0002d497          	auipc	s1,0x2d
    80001db4:	d4848493          	add	s1,s1,-696 # 8002eaf8 <tickslock>
    80001db8:	8526                	mv	a0,s1
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	644080e7          	jalr	1604(ra) # 800063fe <acquire>
  ticks++;
    80001dc2:	00007517          	auipc	a0,0x7
    80001dc6:	cc650513          	add	a0,a0,-826 # 80008a88 <ticks>
    80001dca:	411c                	lw	a5,0(a0)
    80001dcc:	2785                	addw	a5,a5,1
    80001dce:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	974080e7          	jalr	-1676(ra) # 80001744 <wakeup>
  release(&tickslock);
    80001dd8:	8526                	mv	a0,s1
    80001dda:	00004097          	auipc	ra,0x4
    80001dde:	6d8080e7          	jalr	1752(ra) # 800064b2 <release>
}
    80001de2:	60e2                	ld	ra,24(sp)
    80001de4:	6442                	ld	s0,16(sp)
    80001de6:	64a2                	ld	s1,8(sp)
    80001de8:	6105                	add	sp,sp,32
    80001dea:	8082                	ret

0000000080001dec <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dec:	142027f3          	csrr	a5,scause
    /* the SSIP bit in sip. */
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001df0:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001df2:	0807df63          	bgez	a5,80001e90 <devintr+0xa4>
{
    80001df6:	1101                	add	sp,sp,-32
    80001df8:	ec06                	sd	ra,24(sp)
    80001dfa:	e822                	sd	s0,16(sp)
    80001dfc:	e426                	sd	s1,8(sp)
    80001dfe:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001e00:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e04:	46a5                	li	a3,9
    80001e06:	00d70d63          	beq	a4,a3,80001e20 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001e0a:	577d                	li	a4,-1
    80001e0c:	177e                	sll	a4,a4,0x3f
    80001e0e:	0705                	add	a4,a4,1
    return 0;
    80001e10:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e12:	04e78e63          	beq	a5,a4,80001e6e <devintr+0x82>
  }
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	64a2                	ld	s1,8(sp)
    80001e1c:	6105                	add	sp,sp,32
    80001e1e:	8082                	ret
    int irq = plic_claim();
    80001e20:	00003097          	auipc	ra,0x3
    80001e24:	5e8080e7          	jalr	1512(ra) # 80005408 <plic_claim>
    80001e28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e2a:	47a9                	li	a5,10
    80001e2c:	02f50763          	beq	a0,a5,80001e5a <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001e30:	4785                	li	a5,1
    80001e32:	02f50963          	beq	a0,a5,80001e64 <devintr+0x78>
    return 1;
    80001e36:	4505                	li	a0,1
    } else if(irq){
    80001e38:	dcf9                	beqz	s1,80001e16 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e3a:	85a6                	mv	a1,s1
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	48450513          	add	a0,a0,1156 # 800082c0 <states.0+0x38>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	0cc080e7          	jalr	204(ra) # 80005f10 <printf>
      plic_complete(irq);
    80001e4c:	8526                	mv	a0,s1
    80001e4e:	00003097          	auipc	ra,0x3
    80001e52:	5de080e7          	jalr	1502(ra) # 8000542c <plic_complete>
    return 1;
    80001e56:	4505                	li	a0,1
    80001e58:	bf7d                	j	80001e16 <devintr+0x2a>
      uartintr();
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	4c4080e7          	jalr	1220(ra) # 8000631e <uartintr>
    if(irq)
    80001e62:	b7ed                	j	80001e4c <devintr+0x60>
      virtio_disk_intr();
    80001e64:	00004097          	auipc	ra,0x4
    80001e68:	a8e080e7          	jalr	-1394(ra) # 800058f2 <virtio_disk_intr>
    if(irq)
    80001e6c:	b7c5                	j	80001e4c <devintr+0x60>
    if(cpuid() == 0){
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	192080e7          	jalr	402(ra) # 80001000 <cpuid>
    80001e76:	c901                	beqz	a0,80001e86 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e78:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e7c:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e7e:	14479073          	csrw	sip,a5
    return 2;
    80001e82:	4509                	li	a0,2
    80001e84:	bf49                	j	80001e16 <devintr+0x2a>
      clockintr();
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	f20080e7          	jalr	-224(ra) # 80001da6 <clockintr>
    80001e8e:	b7ed                	j	80001e78 <devintr+0x8c>
}
    80001e90:	8082                	ret

0000000080001e92 <usertrap>:
{
    80001e92:	7139                	add	sp,sp,-64
    80001e94:	fc06                	sd	ra,56(sp)
    80001e96:	f822                	sd	s0,48(sp)
    80001e98:	f426                	sd	s1,40(sp)
    80001e9a:	f04a                	sd	s2,32(sp)
    80001e9c:	ec4e                	sd	s3,24(sp)
    80001e9e:	e852                	sd	s4,16(sp)
    80001ea0:	e456                	sd	s5,8(sp)
    80001ea2:	0080                	add	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ea8:	1007f793          	and	a5,a5,256
    80001eac:	eba9                	bnez	a5,80001efe <usertrap+0x6c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001eae:	00003797          	auipc	a5,0x3
    80001eb2:	45278793          	add	a5,a5,1106 # 80005300 <kernelvec>
    80001eb6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	172080e7          	jalr	370(ra) # 8000102c <myproc>
    80001ec2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ec4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec6:	14102773          	csrr	a4,sepc
    80001eca:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ecc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ed0:	47a1                	li	a5,8
    80001ed2:	02f70e63          	beq	a4,a5,80001f0e <usertrap+0x7c>
    80001ed6:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15) {
    80001eda:	47bd                	li	a5,15
    80001edc:	08f70663          	beq	a4,a5,80001f68 <usertrap+0xd6>
  } else if((which_dev = devintr()) != 0){
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	f0c080e7          	jalr	-244(ra) # 80001dec <devintr>
    80001ee8:	892a                	mv	s2,a0
    80001eea:	12050d63          	beqz	a0,80002024 <usertrap+0x192>
  if(killed(p))
    80001eee:	8526                	mv	a0,s1
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	a98080e7          	jalr	-1384(ra) # 80001988 <killed>
    80001ef8:	16050963          	beqz	a0,8000206a <usertrap+0x1d8>
    80001efc:	a295                	j	80002060 <usertrap+0x1ce>
    panic("usertrap: not from user mode");
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	3e250513          	add	a0,a0,994 # 800082e0 <states.0+0x58>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	fc0080e7          	jalr	-64(ra) # 80005ec6 <panic>
    if(killed(p))
    80001f0e:	00000097          	auipc	ra,0x0
    80001f12:	a7a080e7          	jalr	-1414(ra) # 80001988 <killed>
    80001f16:	e139                	bnez	a0,80001f5c <usertrap+0xca>
    p->trapframe->epc += 4;
    80001f18:	6cb8                	ld	a4,88(s1)
    80001f1a:	6f1c                	ld	a5,24(a4)
    80001f1c:	0791                	add	a5,a5,4
    80001f1e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f20:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f24:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f28:	10079073          	csrw	sstatus,a5
    syscall();
    80001f2c:	00000097          	auipc	ra,0x0
    80001f30:	398080e7          	jalr	920(ra) # 800022c4 <syscall>
  if(killed(p))
    80001f34:	8526                	mv	a0,s1
    80001f36:	00000097          	auipc	ra,0x0
    80001f3a:	a52080e7          	jalr	-1454(ra) # 80001988 <killed>
    80001f3e:	12051063          	bnez	a0,8000205e <usertrap+0x1cc>
  usertrapret();
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	dce080e7          	jalr	-562(ra) # 80001d10 <usertrapret>
}
    80001f4a:	70e2                	ld	ra,56(sp)
    80001f4c:	7442                	ld	s0,48(sp)
    80001f4e:	74a2                	ld	s1,40(sp)
    80001f50:	7902                	ld	s2,32(sp)
    80001f52:	69e2                	ld	s3,24(sp)
    80001f54:	6a42                	ld	s4,16(sp)
    80001f56:	6aa2                	ld	s5,8(sp)
    80001f58:	6121                	add	sp,sp,64
    80001f5a:	8082                	ret
      exit(-1);
    80001f5c:	557d                	li	a0,-1
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	8b6080e7          	jalr	-1866(ra) # 80001814 <exit>
    80001f66:	bf4d                	j	80001f18 <usertrap+0x86>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f68:	14302a73          	csrr	s4,stval
    va = PGROUNDDOWN(r_stval());
    80001f6c:	77fd                	lui	a5,0xfffff
    80001f6e:	00fa7a33          	and	s4,s4,a5
    pte = walk(p->pagetable, va, 0);
    80001f72:	4601                	li	a2,0
    80001f74:	85d2                	mv	a1,s4
    80001f76:	6928                	ld	a0,80(a0)
    80001f78:	ffffe097          	auipc	ra,0xffffe
    80001f7c:	672080e7          	jalr	1650(ra) # 800005ea <walk>
    80001f80:	892a                	mv	s2,a0
    if ((*pte & PTE_V) && (*pte & PTE_COW)) {
    80001f82:	611c                	ld	a5,0(a0)
    80001f84:	1017f693          	and	a3,a5,257
    80001f88:	10100713          	li	a4,257
    80001f8c:	02e68063          	beq	a3,a4,80001fac <usertrap+0x11a>
      printf("usertrap(): invalid address\n");
    80001f90:	00006517          	auipc	a0,0x6
    80001f94:	37050513          	add	a0,a0,880 # 80008300 <states.0+0x78>
    80001f98:	00004097          	auipc	ra,0x4
    80001f9c:	f78080e7          	jalr	-136(ra) # 80005f10 <printf>
      setkilled(p);
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	9ba080e7          	jalr	-1606(ra) # 8000195c <setkilled>
    80001faa:	b769                	j	80001f34 <usertrap+0xa2>
      pa = PTE2PA(*pte);
    80001fac:	83a9                	srl	a5,a5,0xa
    80001fae:	00c79993          	sll	s3,a5,0xc
      if (ref_cnt((void*)pa) == 1) {
    80001fb2:	854e                	mv	a0,s3
    80001fb4:	ffffe097          	auipc	ra,0xffffe
    80001fb8:	32e080e7          	jalr	814(ra) # 800002e2 <ref_cnt>
    80001fbc:	4785                	li	a5,1
    80001fbe:	00f51b63          	bne	a0,a5,80001fd4 <usertrap+0x142>
        *pte &= ~PTE_COW; *pte |= PTE_W; 
    80001fc2:	00093783          	ld	a5,0(s2)
    80001fc6:	eff7f793          	and	a5,a5,-257
    80001fca:	0047e793          	or	a5,a5,4
    80001fce:	00f93023          	sd	a5,0(s2)
    80001fd2:	b78d                	j	80001f34 <usertrap+0xa2>
        flags = ((PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW);
    80001fd4:	00093903          	ld	s2,0(s2)
    80001fd8:	2fb97913          	and	s2,s2,763
    80001fdc:	00496913          	or	s2,s2,4
        mem = kalloc();
    80001fe0:	ffffe097          	auipc	ra,0xffffe
    80001fe4:	1b4080e7          	jalr	436(ra) # 80000194 <kalloc>
    80001fe8:	8aaa                	mv	s5,a0
        memmove(mem, (char*)pa, PGSIZE);
    80001fea:	6605                	lui	a2,0x1
    80001fec:	85ce                	mv	a1,s3
    80001fee:	ffffe097          	auipc	ra,0xffffe
    80001ff2:	376080e7          	jalr	886(ra) # 80000364 <memmove>
        uvmunmap(p->pagetable, va, 1, 0);
    80001ff6:	4681                	li	a3,0
    80001ff8:	4605                	li	a2,1
    80001ffa:	85d2                	mv	a1,s4
    80001ffc:	68a8                	ld	a0,80(s1)
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	8be080e7          	jalr	-1858(ra) # 800008bc <uvmunmap>
        mappages(p->pagetable, va, 4096, (uint64)mem, flags);
    80002006:	874a                	mv	a4,s2
    80002008:	86d6                	mv	a3,s5
    8000200a:	6605                	lui	a2,0x1
    8000200c:	85d2                	mv	a1,s4
    8000200e:	68a8                	ld	a0,80(s1)
    80002010:	ffffe097          	auipc	ra,0xffffe
    80002014:	6c2080e7          	jalr	1730(ra) # 800006d2 <mappages>
        kfree((void*)pa);
    80002018:	854e                	mv	a0,s3
    8000201a:	ffffe097          	auipc	ra,0xffffe
    8000201e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
    80002022:	bf09                	j	80001f34 <usertrap+0xa2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002024:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002028:	5890                	lw	a2,48(s1)
    8000202a:	00006517          	auipc	a0,0x6
    8000202e:	2f650513          	add	a0,a0,758 # 80008320 <states.0+0x98>
    80002032:	00004097          	auipc	ra,0x4
    80002036:	ede080e7          	jalr	-290(ra) # 80005f10 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000203a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000203e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002042:	00006517          	auipc	a0,0x6
    80002046:	30e50513          	add	a0,a0,782 # 80008350 <states.0+0xc8>
    8000204a:	00004097          	auipc	ra,0x4
    8000204e:	ec6080e7          	jalr	-314(ra) # 80005f10 <printf>
    setkilled(p);
    80002052:	8526                	mv	a0,s1
    80002054:	00000097          	auipc	ra,0x0
    80002058:	908080e7          	jalr	-1784(ra) # 8000195c <setkilled>
    8000205c:	bde1                	j	80001f34 <usertrap+0xa2>
  if(killed(p))
    8000205e:	4901                	li	s2,0
    exit(-1);
    80002060:	557d                	li	a0,-1
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	7b2080e7          	jalr	1970(ra) # 80001814 <exit>
  if(which_dev == 2)
    8000206a:	4789                	li	a5,2
    8000206c:	ecf91be3          	bne	s2,a5,80001f42 <usertrap+0xb0>
    yield();
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	634080e7          	jalr	1588(ra) # 800016a4 <yield>
    80002078:	b5e9                	j	80001f42 <usertrap+0xb0>

000000008000207a <kerneltrap>:
{
    8000207a:	7179                	add	sp,sp,-48
    8000207c:	f406                	sd	ra,40(sp)
    8000207e:	f022                	sd	s0,32(sp)
    80002080:	ec26                	sd	s1,24(sp)
    80002082:	e84a                	sd	s2,16(sp)
    80002084:	e44e                	sd	s3,8(sp)
    80002086:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002088:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000208c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002090:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002094:	1004f793          	and	a5,s1,256
    80002098:	cb85                	beqz	a5,800020c8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000209a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000209e:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800020a0:	ef85                	bnez	a5,800020d8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800020a2:	00000097          	auipc	ra,0x0
    800020a6:	d4a080e7          	jalr	-694(ra) # 80001dec <devintr>
    800020aa:	cd1d                	beqz	a0,800020e8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020ac:	4789                	li	a5,2
    800020ae:	06f50a63          	beq	a0,a5,80002122 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800020b2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020b6:	10049073          	csrw	sstatus,s1
}
    800020ba:	70a2                	ld	ra,40(sp)
    800020bc:	7402                	ld	s0,32(sp)
    800020be:	64e2                	ld	s1,24(sp)
    800020c0:	6942                	ld	s2,16(sp)
    800020c2:	69a2                	ld	s3,8(sp)
    800020c4:	6145                	add	sp,sp,48
    800020c6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	2a850513          	add	a0,a0,680 # 80008370 <states.0+0xe8>
    800020d0:	00004097          	auipc	ra,0x4
    800020d4:	df6080e7          	jalr	-522(ra) # 80005ec6 <panic>
    panic("kerneltrap: interrupts enabled");
    800020d8:	00006517          	auipc	a0,0x6
    800020dc:	2c050513          	add	a0,a0,704 # 80008398 <states.0+0x110>
    800020e0:	00004097          	auipc	ra,0x4
    800020e4:	de6080e7          	jalr	-538(ra) # 80005ec6 <panic>
    printf("scause %p\n", scause);
    800020e8:	85ce                	mv	a1,s3
    800020ea:	00006517          	auipc	a0,0x6
    800020ee:	2ce50513          	add	a0,a0,718 # 800083b8 <states.0+0x130>
    800020f2:	00004097          	auipc	ra,0x4
    800020f6:	e1e080e7          	jalr	-482(ra) # 80005f10 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020fa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020fe:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002102:	00006517          	auipc	a0,0x6
    80002106:	2c650513          	add	a0,a0,710 # 800083c8 <states.0+0x140>
    8000210a:	00004097          	auipc	ra,0x4
    8000210e:	e06080e7          	jalr	-506(ra) # 80005f10 <printf>
    panic("kerneltrap");
    80002112:	00006517          	auipc	a0,0x6
    80002116:	2ce50513          	add	a0,a0,718 # 800083e0 <states.0+0x158>
    8000211a:	00004097          	auipc	ra,0x4
    8000211e:	dac080e7          	jalr	-596(ra) # 80005ec6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	f0a080e7          	jalr	-246(ra) # 8000102c <myproc>
    8000212a:	d541                	beqz	a0,800020b2 <kerneltrap+0x38>
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	f00080e7          	jalr	-256(ra) # 8000102c <myproc>
    80002134:	4d18                	lw	a4,24(a0)
    80002136:	4791                	li	a5,4
    80002138:	f6f71de3          	bne	a4,a5,800020b2 <kerneltrap+0x38>
    yield();
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	568080e7          	jalr	1384(ra) # 800016a4 <yield>
    80002144:	b7bd                	j	800020b2 <kerneltrap+0x38>

0000000080002146 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002146:	1101                	add	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	1000                	add	s0,sp,32
    80002150:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	eda080e7          	jalr	-294(ra) # 8000102c <myproc>
  switch (n) {
    8000215a:	4795                	li	a5,5
    8000215c:	0497e163          	bltu	a5,s1,8000219e <argraw+0x58>
    80002160:	048a                	sll	s1,s1,0x2
    80002162:	00006717          	auipc	a4,0x6
    80002166:	37670713          	add	a4,a4,886 # 800084d8 <states.0+0x250>
    8000216a:	94ba                	add	s1,s1,a4
    8000216c:	409c                	lw	a5,0(s1)
    8000216e:	97ba                	add	a5,a5,a4
    80002170:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002172:	6d3c                	ld	a5,88(a0)
    80002174:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002176:	60e2                	ld	ra,24(sp)
    80002178:	6442                	ld	s0,16(sp)
    8000217a:	64a2                	ld	s1,8(sp)
    8000217c:	6105                	add	sp,sp,32
    8000217e:	8082                	ret
    return p->trapframe->a1;
    80002180:	6d3c                	ld	a5,88(a0)
    80002182:	7fa8                	ld	a0,120(a5)
    80002184:	bfcd                	j	80002176 <argraw+0x30>
    return p->trapframe->a2;
    80002186:	6d3c                	ld	a5,88(a0)
    80002188:	63c8                	ld	a0,128(a5)
    8000218a:	b7f5                	j	80002176 <argraw+0x30>
    return p->trapframe->a3;
    8000218c:	6d3c                	ld	a5,88(a0)
    8000218e:	67c8                	ld	a0,136(a5)
    80002190:	b7dd                	j	80002176 <argraw+0x30>
    return p->trapframe->a4;
    80002192:	6d3c                	ld	a5,88(a0)
    80002194:	6bc8                	ld	a0,144(a5)
    80002196:	b7c5                	j	80002176 <argraw+0x30>
    return p->trapframe->a5;
    80002198:	6d3c                	ld	a5,88(a0)
    8000219a:	6fc8                	ld	a0,152(a5)
    8000219c:	bfe9                	j	80002176 <argraw+0x30>
  panic("argraw");
    8000219e:	00006517          	auipc	a0,0x6
    800021a2:	25250513          	add	a0,a0,594 # 800083f0 <states.0+0x168>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	d20080e7          	jalr	-736(ra) # 80005ec6 <panic>

00000000800021ae <fetchaddr>:
{
    800021ae:	1101                	add	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	e426                	sd	s1,8(sp)
    800021b6:	e04a                	sd	s2,0(sp)
    800021b8:	1000                	add	s0,sp,32
    800021ba:	84aa                	mv	s1,a0
    800021bc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	e6e080e7          	jalr	-402(ra) # 8000102c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    800021c6:	653c                	ld	a5,72(a0)
    800021c8:	02f4f863          	bgeu	s1,a5,800021f8 <fetchaddr+0x4a>
    800021cc:	00848713          	add	a4,s1,8
    800021d0:	02e7e663          	bltu	a5,a4,800021fc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021d4:	46a1                	li	a3,8
    800021d6:	8626                	mv	a2,s1
    800021d8:	85ca                	mv	a1,s2
    800021da:	6928                	ld	a0,80(a0)
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	b9c080e7          	jalr	-1124(ra) # 80000d78 <copyin>
    800021e4:	00a03533          	snez	a0,a0
    800021e8:	40a00533          	neg	a0,a0
}
    800021ec:	60e2                	ld	ra,24(sp)
    800021ee:	6442                	ld	s0,16(sp)
    800021f0:	64a2                	ld	s1,8(sp)
    800021f2:	6902                	ld	s2,0(sp)
    800021f4:	6105                	add	sp,sp,32
    800021f6:	8082                	ret
    return -1;
    800021f8:	557d                	li	a0,-1
    800021fa:	bfcd                	j	800021ec <fetchaddr+0x3e>
    800021fc:	557d                	li	a0,-1
    800021fe:	b7fd                	j	800021ec <fetchaddr+0x3e>

0000000080002200 <fetchstr>:
{
    80002200:	7179                	add	sp,sp,-48
    80002202:	f406                	sd	ra,40(sp)
    80002204:	f022                	sd	s0,32(sp)
    80002206:	ec26                	sd	s1,24(sp)
    80002208:	e84a                	sd	s2,16(sp)
    8000220a:	e44e                	sd	s3,8(sp)
    8000220c:	1800                	add	s0,sp,48
    8000220e:	892a                	mv	s2,a0
    80002210:	84ae                	mv	s1,a1
    80002212:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	e18080e7          	jalr	-488(ra) # 8000102c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000221c:	86ce                	mv	a3,s3
    8000221e:	864a                	mv	a2,s2
    80002220:	85a6                	mv	a1,s1
    80002222:	6928                	ld	a0,80(a0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	be2080e7          	jalr	-1054(ra) # 80000e06 <copyinstr>
    8000222c:	00054e63          	bltz	a0,80002248 <fetchstr+0x48>
  return strlen(buf);
    80002230:	8526                	mv	a0,s1
    80002232:	ffffe097          	auipc	ra,0xffffe
    80002236:	250080e7          	jalr	592(ra) # 80000482 <strlen>
}
    8000223a:	70a2                	ld	ra,40(sp)
    8000223c:	7402                	ld	s0,32(sp)
    8000223e:	64e2                	ld	s1,24(sp)
    80002240:	6942                	ld	s2,16(sp)
    80002242:	69a2                	ld	s3,8(sp)
    80002244:	6145                	add	sp,sp,48
    80002246:	8082                	ret
    return -1;
    80002248:	557d                	li	a0,-1
    8000224a:	bfc5                	j	8000223a <fetchstr+0x3a>

000000008000224c <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    8000224c:	1101                	add	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	e426                	sd	s1,8(sp)
    80002254:	1000                	add	s0,sp,32
    80002256:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	eee080e7          	jalr	-274(ra) # 80002146 <argraw>
    80002260:	c088                	sw	a0,0(s1)
}
    80002262:	60e2                	ld	ra,24(sp)
    80002264:	6442                	ld	s0,16(sp)
    80002266:	64a2                	ld	s1,8(sp)
    80002268:	6105                	add	sp,sp,32
    8000226a:	8082                	ret

000000008000226c <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    8000226c:	1101                	add	sp,sp,-32
    8000226e:	ec06                	sd	ra,24(sp)
    80002270:	e822                	sd	s0,16(sp)
    80002272:	e426                	sd	s1,8(sp)
    80002274:	1000                	add	s0,sp,32
    80002276:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	ece080e7          	jalr	-306(ra) # 80002146 <argraw>
    80002280:	e088                	sd	a0,0(s1)
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	64a2                	ld	s1,8(sp)
    80002288:	6105                	add	sp,sp,32
    8000228a:	8082                	ret

000000008000228c <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    8000228c:	7179                	add	sp,sp,-48
    8000228e:	f406                	sd	ra,40(sp)
    80002290:	f022                	sd	s0,32(sp)
    80002292:	ec26                	sd	s1,24(sp)
    80002294:	e84a                	sd	s2,16(sp)
    80002296:	1800                	add	s0,sp,48
    80002298:	84ae                	mv	s1,a1
    8000229a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000229c:	fd840593          	add	a1,s0,-40
    800022a0:	00000097          	auipc	ra,0x0
    800022a4:	fcc080e7          	jalr	-52(ra) # 8000226c <argaddr>
  return fetchstr(addr, buf, max);
    800022a8:	864a                	mv	a2,s2
    800022aa:	85a6                	mv	a1,s1
    800022ac:	fd843503          	ld	a0,-40(s0)
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	f50080e7          	jalr	-176(ra) # 80002200 <fetchstr>
}
    800022b8:	70a2                	ld	ra,40(sp)
    800022ba:	7402                	ld	s0,32(sp)
    800022bc:	64e2                	ld	s1,24(sp)
    800022be:	6942                	ld	s2,16(sp)
    800022c0:	6145                	add	sp,sp,48
    800022c2:	8082                	ret

00000000800022c4 <syscall>:

/* End CMPT 332 group14 change Fall 2023 */

void
syscall(void)
{
    800022c4:	715d                	add	sp,sp,-80
    800022c6:	e486                	sd	ra,72(sp)
    800022c8:	e0a2                	sd	s0,64(sp)
    800022ca:	fc26                	sd	s1,56(sp)
    800022cc:	f84a                	sd	s2,48(sp)
    800022ce:	f44e                	sd	s3,40(sp)
    800022d0:	f052                	sd	s4,32(sp)
    800022d2:	ec56                	sd	s5,24(sp)
    800022d4:	e85a                	sd	s6,16(sp)
    800022d6:	e45e                	sd	s7,8(sp)
    800022d8:	0880                	add	s0,sp,80
  int num;
  struct proc *p = myproc();
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	d52080e7          	jalr	-686(ra) # 8000102c <myproc>
    800022e2:	89aa                	mv	s3,a0
  int i;
  int bit;

  /* End CMPT 332 group14 change Fall 2023 */

  num = p->trapframe->a7;
    800022e4:	6d24                	ld	s1,88(a0)
    800022e6:	74dc                	ld	a5,168(s1)
    800022e8:	00078b1b          	sext.w	s6,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022ec:	37fd                	addw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffbcedf>
    800022ee:	4759                	li	a4,22
    800022f0:	06f76863          	bltu	a4,a5,80002360 <syscall+0x9c>
    800022f4:	003b1713          	sll	a4,s6,0x3
    800022f8:	00006797          	auipc	a5,0x6
    800022fc:	1f878793          	add	a5,a5,504 # 800084f0 <syscalls>
    80002300:	97ba                	add	a5,a5,a4
    80002302:	639c                	ld	a5,0(a5)
    80002304:	cfb1                	beqz	a5,80002360 <syscall+0x9c>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    80002306:	9782                	jalr	a5
    80002308:	f8a8                	sd	a0,112(s1)

    /* Begin CMPT 332 group14 change Fall 2023 */

    if (p->tmask > 0) {
    8000230a:	1689a783          	lw	a5,360(s3)
    8000230e:	06f05a63          	blez	a5,80002382 <syscall+0xbe>
    80002312:	00006917          	auipc	s2,0x6
    80002316:	6a690913          	add	s2,s2,1702 # 800089b8 <syscall_names>
      for (i = 1; i < 32; i++) {
    8000231a:	4485                	li	s1,1
        bit = p->tmask & (1 << i);
    8000231c:	4a85                	li	s5,1
        if (bit != 0) {
          if (i == num) {
            printf("%d: syscall %s -> %d\n",
    8000231e:	00006b97          	auipc	s7,0x6
    80002322:	0dab8b93          	add	s7,s7,218 # 800083f8 <states.0+0x170>
      for (i = 1; i < 32; i++) {
    80002326:	02000a13          	li	s4,32
    8000232a:	a029                	j	80002334 <syscall+0x70>
    8000232c:	2485                	addw	s1,s1,1
    8000232e:	0921                	add	s2,s2,8
    80002330:	05448963          	beq	s1,s4,80002382 <syscall+0xbe>
        bit = p->tmask & (1 << i);
    80002334:	009a973b          	sllw	a4,s5,s1
    80002338:	1689a783          	lw	a5,360(s3)
    8000233c:	8ff9                	and	a5,a5,a4
        if (bit != 0) {
    8000233e:	2781                	sext.w	a5,a5
    80002340:	d7f5                	beqz	a5,8000232c <syscall+0x68>
          if (i == num) {
    80002342:	fe9b15e3          	bne	s6,s1,8000232c <syscall+0x68>
            printf("%d: syscall %s -> %d\n",
    80002346:	0589b783          	ld	a5,88(s3)
    8000234a:	7bb4                	ld	a3,112(a5)
    8000234c:	00093603          	ld	a2,0(s2)
    80002350:	0309a583          	lw	a1,48(s3)
    80002354:	855e                	mv	a0,s7
    80002356:	00004097          	auipc	ra,0x4
    8000235a:	bba080e7          	jalr	-1094(ra) # 80005f10 <printf>
    8000235e:	b7f9                	j	8000232c <syscall+0x68>
    }

    /* End CMPT 332 group14 change Fall 2023 */

  } else {
    printf("%d %s: unknown sys call %d\n",
    80002360:	86da                	mv	a3,s6
    80002362:	15898613          	add	a2,s3,344
    80002366:	0309a583          	lw	a1,48(s3)
    8000236a:	00006517          	auipc	a0,0x6
    8000236e:	0a650513          	add	a0,a0,166 # 80008410 <states.0+0x188>
    80002372:	00004097          	auipc	ra,0x4
    80002376:	b9e080e7          	jalr	-1122(ra) # 80005f10 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000237a:	0589b783          	ld	a5,88(s3)
    8000237e:	577d                	li	a4,-1
    80002380:	fbb8                	sd	a4,112(a5)
  }
}
    80002382:	60a6                	ld	ra,72(sp)
    80002384:	6406                	ld	s0,64(sp)
    80002386:	74e2                	ld	s1,56(sp)
    80002388:	7942                	ld	s2,48(sp)
    8000238a:	79a2                	ld	s3,40(sp)
    8000238c:	7a02                	ld	s4,32(sp)
    8000238e:	6ae2                	ld	s5,24(sp)
    80002390:	6b42                	ld	s6,16(sp)
    80002392:	6ba2                	ld	s7,8(sp)
    80002394:	6161                	add	sp,sp,80
    80002396:	8082                	ret

0000000080002398 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002398:	1101                	add	sp,sp,-32
    8000239a:	ec06                	sd	ra,24(sp)
    8000239c:	e822                	sd	s0,16(sp)
    8000239e:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800023a0:	fec40593          	add	a1,s0,-20
    800023a4:	4501                	li	a0,0
    800023a6:	00000097          	auipc	ra,0x0
    800023aa:	ea6080e7          	jalr	-346(ra) # 8000224c <argint>
  exit(n);
    800023ae:	fec42503          	lw	a0,-20(s0)
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	462080e7          	jalr	1122(ra) # 80001814 <exit>
  return 0;  /* not reached */
}
    800023ba:	4501                	li	a0,0
    800023bc:	60e2                	ld	ra,24(sp)
    800023be:	6442                	ld	s0,16(sp)
    800023c0:	6105                	add	sp,sp,32
    800023c2:	8082                	ret

00000000800023c4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800023c4:	1141                	add	sp,sp,-16
    800023c6:	e406                	sd	ra,8(sp)
    800023c8:	e022                	sd	s0,0(sp)
    800023ca:	0800                	add	s0,sp,16
  return myproc()->pid;
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	c60080e7          	jalr	-928(ra) # 8000102c <myproc>
}
    800023d4:	5908                	lw	a0,48(a0)
    800023d6:	60a2                	ld	ra,8(sp)
    800023d8:	6402                	ld	s0,0(sp)
    800023da:	0141                	add	sp,sp,16
    800023dc:	8082                	ret

00000000800023de <sys_fork>:

uint64
sys_fork(void)
{
    800023de:	1141                	add	sp,sp,-16
    800023e0:	e406                	sd	ra,8(sp)
    800023e2:	e022                	sd	s0,0(sp)
    800023e4:	0800                	add	s0,sp,16
  return fork();
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	000080e7          	jalr	ra # 800013e6 <fork>
}
    800023ee:	60a2                	ld	ra,8(sp)
    800023f0:	6402                	ld	s0,0(sp)
    800023f2:	0141                	add	sp,sp,16
    800023f4:	8082                	ret

00000000800023f6 <sys_wait>:

uint64
sys_wait(void)
{
    800023f6:	1101                	add	sp,sp,-32
    800023f8:	ec06                	sd	ra,24(sp)
    800023fa:	e822                	sd	s0,16(sp)
    800023fc:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800023fe:	fe840593          	add	a1,s0,-24
    80002402:	4501                	li	a0,0
    80002404:	00000097          	auipc	ra,0x0
    80002408:	e68080e7          	jalr	-408(ra) # 8000226c <argaddr>
  return wait(p);
    8000240c:	fe843503          	ld	a0,-24(s0)
    80002410:	fffff097          	auipc	ra,0xfffff
    80002414:	5aa080e7          	jalr	1450(ra) # 800019ba <wait>
}
    80002418:	60e2                	ld	ra,24(sp)
    8000241a:	6442                	ld	s0,16(sp)
    8000241c:	6105                	add	sp,sp,32
    8000241e:	8082                	ret

0000000080002420 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002420:	7179                	add	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000242a:	fdc40593          	add	a1,s0,-36
    8000242e:	4501                	li	a0,0
    80002430:	00000097          	auipc	ra,0x0
    80002434:	e1c080e7          	jalr	-484(ra) # 8000224c <argint>
  addr = myproc()->sz;
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	bf4080e7          	jalr	-1036(ra) # 8000102c <myproc>
    80002440:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002442:	fdc42503          	lw	a0,-36(s0)
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	f44080e7          	jalr	-188(ra) # 8000138a <growproc>
    8000244e:	00054863          	bltz	a0,8000245e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002452:	8526                	mv	a0,s1
    80002454:	70a2                	ld	ra,40(sp)
    80002456:	7402                	ld	s0,32(sp)
    80002458:	64e2                	ld	s1,24(sp)
    8000245a:	6145                	add	sp,sp,48
    8000245c:	8082                	ret
    return -1;
    8000245e:	54fd                	li	s1,-1
    80002460:	bfcd                	j	80002452 <sys_sbrk+0x32>

0000000080002462 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002462:	7139                	add	sp,sp,-64
    80002464:	fc06                	sd	ra,56(sp)
    80002466:	f822                	sd	s0,48(sp)
    80002468:	f426                	sd	s1,40(sp)
    8000246a:	f04a                	sd	s2,32(sp)
    8000246c:	ec4e                	sd	s3,24(sp)
    8000246e:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002470:	fcc40593          	add	a1,s0,-52
    80002474:	4501                	li	a0,0
    80002476:	00000097          	auipc	ra,0x0
    8000247a:	dd6080e7          	jalr	-554(ra) # 8000224c <argint>
  if(n < 0)
    8000247e:	fcc42783          	lw	a5,-52(s0)
    80002482:	0607cf63          	bltz	a5,80002500 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002486:	0002c517          	auipc	a0,0x2c
    8000248a:	67250513          	add	a0,a0,1650 # 8002eaf8 <tickslock>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	f70080e7          	jalr	-144(ra) # 800063fe <acquire>
  ticks0 = ticks;
    80002496:	00006917          	auipc	s2,0x6
    8000249a:	5f292903          	lw	s2,1522(s2) # 80008a88 <ticks>
  while(ticks - ticks0 < n){
    8000249e:	fcc42783          	lw	a5,-52(s0)
    800024a2:	cf9d                	beqz	a5,800024e0 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024a4:	0002c997          	auipc	s3,0x2c
    800024a8:	65498993          	add	s3,s3,1620 # 8002eaf8 <tickslock>
    800024ac:	00006497          	auipc	s1,0x6
    800024b0:	5dc48493          	add	s1,s1,1500 # 80008a88 <ticks>
    if(killed(myproc())){
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	b78080e7          	jalr	-1160(ra) # 8000102c <myproc>
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	4cc080e7          	jalr	1228(ra) # 80001988 <killed>
    800024c4:	e129                	bnez	a0,80002506 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800024c6:	85ce                	mv	a1,s3
    800024c8:	8526                	mv	a0,s1
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	216080e7          	jalr	534(ra) # 800016e0 <sleep>
  while(ticks - ticks0 < n){
    800024d2:	409c                	lw	a5,0(s1)
    800024d4:	412787bb          	subw	a5,a5,s2
    800024d8:	fcc42703          	lw	a4,-52(s0)
    800024dc:	fce7ece3          	bltu	a5,a4,800024b4 <sys_sleep+0x52>
  }
  release(&tickslock);
    800024e0:	0002c517          	auipc	a0,0x2c
    800024e4:	61850513          	add	a0,a0,1560 # 8002eaf8 <tickslock>
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	fca080e7          	jalr	-54(ra) # 800064b2 <release>
  return 0;
    800024f0:	4501                	li	a0,0
}
    800024f2:	70e2                	ld	ra,56(sp)
    800024f4:	7442                	ld	s0,48(sp)
    800024f6:	74a2                	ld	s1,40(sp)
    800024f8:	7902                	ld	s2,32(sp)
    800024fa:	69e2                	ld	s3,24(sp)
    800024fc:	6121                	add	sp,sp,64
    800024fe:	8082                	ret
    n = 0;
    80002500:	fc042623          	sw	zero,-52(s0)
    80002504:	b749                	j	80002486 <sys_sleep+0x24>
      release(&tickslock);
    80002506:	0002c517          	auipc	a0,0x2c
    8000250a:	5f250513          	add	a0,a0,1522 # 8002eaf8 <tickslock>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	fa4080e7          	jalr	-92(ra) # 800064b2 <release>
      return -1;
    80002516:	557d                	li	a0,-1
    80002518:	bfe9                	j	800024f2 <sys_sleep+0x90>

000000008000251a <sys_kill>:

uint64
sys_kill(void)
{
    8000251a:	1101                	add	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002522:	fec40593          	add	a1,s0,-20
    80002526:	4501                	li	a0,0
    80002528:	00000097          	auipc	ra,0x0
    8000252c:	d24080e7          	jalr	-732(ra) # 8000224c <argint>
  return kill(pid);
    80002530:	fec42503          	lw	a0,-20(s0)
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	3b6080e7          	jalr	950(ra) # 800018ea <kill>
}
    8000253c:	60e2                	ld	ra,24(sp)
    8000253e:	6442                	ld	s0,16(sp)
    80002540:	6105                	add	sp,sp,32
    80002542:	8082                	ret

0000000080002544 <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    80002544:	1101                	add	sp,sp,-32
    80002546:	ec06                	sd	ra,24(sp)
    80002548:	e822                	sd	s0,16(sp)
    8000254a:	e426                	sd	s1,8(sp)
    8000254c:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000254e:	0002c517          	auipc	a0,0x2c
    80002552:	5aa50513          	add	a0,a0,1450 # 8002eaf8 <tickslock>
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	ea8080e7          	jalr	-344(ra) # 800063fe <acquire>
  xticks = ticks;
    8000255e:	00006497          	auipc	s1,0x6
    80002562:	52a4a483          	lw	s1,1322(s1) # 80008a88 <ticks>
  release(&tickslock);
    80002566:	0002c517          	auipc	a0,0x2c
    8000256a:	59250513          	add	a0,a0,1426 # 8002eaf8 <tickslock>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	f44080e7          	jalr	-188(ra) # 800064b2 <release>
  return xticks;
}
    80002576:	02049513          	sll	a0,s1,0x20
    8000257a:	9101                	srl	a0,a0,0x20
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6105                	add	sp,sp,32
    80002584:	8082                	ret

0000000080002586 <sys_trace>:

/* enables tracing for the process that calls it */
/* and children that it subsequently forks. */
uint64
sys_trace(void)
{
    80002586:	1101                	add	sp,sp,-32
    80002588:	ec06                	sd	ra,24(sp)
    8000258a:	e822                	sd	s0,16(sp)
    8000258c:	1000                	add	s0,sp,32
  int mask;

  argint(0, &mask);
    8000258e:	fec40593          	add	a1,s0,-20
    80002592:	4501                	li	a0,0
    80002594:	00000097          	auipc	ra,0x0
    80002598:	cb8080e7          	jalr	-840(ra) # 8000224c <argint>
  myproc()->tmask = mask;
    8000259c:	fffff097          	auipc	ra,0xfffff
    800025a0:	a90080e7          	jalr	-1392(ra) # 8000102c <myproc>
    800025a4:	fec42783          	lw	a5,-20(s0)
    800025a8:	16f52423          	sw	a5,360(a0)
  return 0;
}
    800025ac:	4501                	li	a0,0
    800025ae:	60e2                	ld	ra,24(sp)
    800025b0:	6442                	ld	s0,16(sp)
    800025b2:	6105                	add	sp,sp,32
    800025b4:	8082                	ret

00000000800025b6 <sys_getNumFreePages>:

/* returns the number of free physical pages */
uint64
sys_getNumFreePages(void)
{
    800025b6:	1141                	add	sp,sp,-16
    800025b8:	e406                	sd	ra,8(sp)
    800025ba:	e022                	sd	s0,0(sp)
    800025bc:	0800                	add	s0,sp,16
  return nfree();
    800025be:	ffffe097          	auipc	ra,0xffffe
    800025c2:	c74080e7          	jalr	-908(ra) # 80000232 <nfree>
}
    800025c6:	60a2                	ld	ra,8(sp)
    800025c8:	6402                	ld	s0,0(sp)
    800025ca:	0141                	add	sp,sp,16
    800025cc:	8082                	ret

00000000800025ce <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800025ce:	7179                	add	sp,sp,-48
    800025d0:	f406                	sd	ra,40(sp)
    800025d2:	f022                	sd	s0,32(sp)
    800025d4:	ec26                	sd	s1,24(sp)
    800025d6:	e84a                	sd	s2,16(sp)
    800025d8:	e44e                	sd	s3,8(sp)
    800025da:	e052                	sd	s4,0(sp)
    800025dc:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025de:	00006597          	auipc	a1,0x6
    800025e2:	fd258593          	add	a1,a1,-46 # 800085b0 <syscalls+0xc0>
    800025e6:	0002c517          	auipc	a0,0x2c
    800025ea:	52a50513          	add	a0,a0,1322 # 8002eb10 <bcache>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	d80080e7          	jalr	-640(ra) # 8000636e <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    800025f6:	00034797          	auipc	a5,0x34
    800025fa:	51a78793          	add	a5,a5,1306 # 80036b10 <bcache+0x8000>
    800025fe:	00034717          	auipc	a4,0x34
    80002602:	77a70713          	add	a4,a4,1914 # 80036d78 <bcache+0x8268>
    80002606:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000260a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000260e:	0002c497          	auipc	s1,0x2c
    80002612:	51a48493          	add	s1,s1,1306 # 8002eb28 <bcache+0x18>
    b->next = bcache.head.next;
    80002616:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002618:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000261a:	00006a17          	auipc	s4,0x6
    8000261e:	f9ea0a13          	add	s4,s4,-98 # 800085b8 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002622:	2b893783          	ld	a5,696(s2)
    80002626:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002628:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000262c:	85d2                	mv	a1,s4
    8000262e:	01048513          	add	a0,s1,16
    80002632:	00001097          	auipc	ra,0x1
    80002636:	496080e7          	jalr	1174(ra) # 80003ac8 <initsleeplock>
    bcache.head.next->prev = b;
    8000263a:	2b893783          	ld	a5,696(s2)
    8000263e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002640:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002644:	45848493          	add	s1,s1,1112
    80002648:	fd349de3          	bne	s1,s3,80002622 <binit+0x54>
  }
}
    8000264c:	70a2                	ld	ra,40(sp)
    8000264e:	7402                	ld	s0,32(sp)
    80002650:	64e2                	ld	s1,24(sp)
    80002652:	6942                	ld	s2,16(sp)
    80002654:	69a2                	ld	s3,8(sp)
    80002656:	6a02                	ld	s4,0(sp)
    80002658:	6145                	add	sp,sp,48
    8000265a:	8082                	ret

000000008000265c <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    8000265c:	7179                	add	sp,sp,-48
    8000265e:	f406                	sd	ra,40(sp)
    80002660:	f022                	sd	s0,32(sp)
    80002662:	ec26                	sd	s1,24(sp)
    80002664:	e84a                	sd	s2,16(sp)
    80002666:	e44e                	sd	s3,8(sp)
    80002668:	1800                	add	s0,sp,48
    8000266a:	892a                	mv	s2,a0
    8000266c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000266e:	0002c517          	auipc	a0,0x2c
    80002672:	4a250513          	add	a0,a0,1186 # 8002eb10 <bcache>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	d88080e7          	jalr	-632(ra) # 800063fe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000267e:	00034497          	auipc	s1,0x34
    80002682:	74a4b483          	ld	s1,1866(s1) # 80036dc8 <bcache+0x82b8>
    80002686:	00034797          	auipc	a5,0x34
    8000268a:	6f278793          	add	a5,a5,1778 # 80036d78 <bcache+0x8268>
    8000268e:	02f48f63          	beq	s1,a5,800026cc <bread+0x70>
    80002692:	873e                	mv	a4,a5
    80002694:	a021                	j	8000269c <bread+0x40>
    80002696:	68a4                	ld	s1,80(s1)
    80002698:	02e48a63          	beq	s1,a4,800026cc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000269c:	449c                	lw	a5,8(s1)
    8000269e:	ff279ce3          	bne	a5,s2,80002696 <bread+0x3a>
    800026a2:	44dc                	lw	a5,12(s1)
    800026a4:	ff3799e3          	bne	a5,s3,80002696 <bread+0x3a>
      b->refcnt++;
    800026a8:	40bc                	lw	a5,64(s1)
    800026aa:	2785                	addw	a5,a5,1
    800026ac:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026ae:	0002c517          	auipc	a0,0x2c
    800026b2:	46250513          	add	a0,a0,1122 # 8002eb10 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	dfc080e7          	jalr	-516(ra) # 800064b2 <release>
      acquiresleep(&b->lock);
    800026be:	01048513          	add	a0,s1,16
    800026c2:	00001097          	auipc	ra,0x1
    800026c6:	440080e7          	jalr	1088(ra) # 80003b02 <acquiresleep>
      return b;
    800026ca:	a8b9                	j	80002728 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026cc:	00034497          	auipc	s1,0x34
    800026d0:	6f44b483          	ld	s1,1780(s1) # 80036dc0 <bcache+0x82b0>
    800026d4:	00034797          	auipc	a5,0x34
    800026d8:	6a478793          	add	a5,a5,1700 # 80036d78 <bcache+0x8268>
    800026dc:	00f48863          	beq	s1,a5,800026ec <bread+0x90>
    800026e0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800026e2:	40bc                	lw	a5,64(s1)
    800026e4:	cf81                	beqz	a5,800026fc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026e6:	64a4                	ld	s1,72(s1)
    800026e8:	fee49de3          	bne	s1,a4,800026e2 <bread+0x86>
  panic("bget: no buffers");
    800026ec:	00006517          	auipc	a0,0x6
    800026f0:	ed450513          	add	a0,a0,-300 # 800085c0 <syscalls+0xd0>
    800026f4:	00003097          	auipc	ra,0x3
    800026f8:	7d2080e7          	jalr	2002(ra) # 80005ec6 <panic>
      b->dev = dev;
    800026fc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002700:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002704:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002708:	4785                	li	a5,1
    8000270a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000270c:	0002c517          	auipc	a0,0x2c
    80002710:	40450513          	add	a0,a0,1028 # 8002eb10 <bcache>
    80002714:	00004097          	auipc	ra,0x4
    80002718:	d9e080e7          	jalr	-610(ra) # 800064b2 <release>
      acquiresleep(&b->lock);
    8000271c:	01048513          	add	a0,s1,16
    80002720:	00001097          	auipc	ra,0x1
    80002724:	3e2080e7          	jalr	994(ra) # 80003b02 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002728:	409c                	lw	a5,0(s1)
    8000272a:	cb89                	beqz	a5,8000273c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000272c:	8526                	mv	a0,s1
    8000272e:	70a2                	ld	ra,40(sp)
    80002730:	7402                	ld	s0,32(sp)
    80002732:	64e2                	ld	s1,24(sp)
    80002734:	6942                	ld	s2,16(sp)
    80002736:	69a2                	ld	s3,8(sp)
    80002738:	6145                	add	sp,sp,48
    8000273a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000273c:	4581                	li	a1,0
    8000273e:	8526                	mv	a0,s1
    80002740:	00003097          	auipc	ra,0x3
    80002744:	f82080e7          	jalr	-126(ra) # 800056c2 <virtio_disk_rw>
    b->valid = 1;
    80002748:	4785                	li	a5,1
    8000274a:	c09c                	sw	a5,0(s1)
  return b;
    8000274c:	b7c5                	j	8000272c <bread+0xd0>

000000008000274e <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    8000274e:	1101                	add	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	1000                	add	s0,sp,32
    80002758:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000275a:	0541                	add	a0,a0,16
    8000275c:	00001097          	auipc	ra,0x1
    80002760:	440080e7          	jalr	1088(ra) # 80003b9c <holdingsleep>
    80002764:	cd01                	beqz	a0,8000277c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002766:	4585                	li	a1,1
    80002768:	8526                	mv	a0,s1
    8000276a:	00003097          	auipc	ra,0x3
    8000276e:	f58080e7          	jalr	-168(ra) # 800056c2 <virtio_disk_rw>
}
    80002772:	60e2                	ld	ra,24(sp)
    80002774:	6442                	ld	s0,16(sp)
    80002776:	64a2                	ld	s1,8(sp)
    80002778:	6105                	add	sp,sp,32
    8000277a:	8082                	ret
    panic("bwrite");
    8000277c:	00006517          	auipc	a0,0x6
    80002780:	e5c50513          	add	a0,a0,-420 # 800085d8 <syscalls+0xe8>
    80002784:	00003097          	auipc	ra,0x3
    80002788:	742080e7          	jalr	1858(ra) # 80005ec6 <panic>

000000008000278c <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    8000278c:	1101                	add	sp,sp,-32
    8000278e:	ec06                	sd	ra,24(sp)
    80002790:	e822                	sd	s0,16(sp)
    80002792:	e426                	sd	s1,8(sp)
    80002794:	e04a                	sd	s2,0(sp)
    80002796:	1000                	add	s0,sp,32
    80002798:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000279a:	01050913          	add	s2,a0,16
    8000279e:	854a                	mv	a0,s2
    800027a0:	00001097          	auipc	ra,0x1
    800027a4:	3fc080e7          	jalr	1020(ra) # 80003b9c <holdingsleep>
    800027a8:	c925                	beqz	a0,80002818 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800027aa:	854a                	mv	a0,s2
    800027ac:	00001097          	auipc	ra,0x1
    800027b0:	3ac080e7          	jalr	940(ra) # 80003b58 <releasesleep>

  acquire(&bcache.lock);
    800027b4:	0002c517          	auipc	a0,0x2c
    800027b8:	35c50513          	add	a0,a0,860 # 8002eb10 <bcache>
    800027bc:	00004097          	auipc	ra,0x4
    800027c0:	c42080e7          	jalr	-958(ra) # 800063fe <acquire>
  b->refcnt--;
    800027c4:	40bc                	lw	a5,64(s1)
    800027c6:	37fd                	addw	a5,a5,-1
    800027c8:	0007871b          	sext.w	a4,a5
    800027cc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800027ce:	e71d                	bnez	a4,800027fc <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    800027d0:	68b8                	ld	a4,80(s1)
    800027d2:	64bc                	ld	a5,72(s1)
    800027d4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800027d6:	68b8                	ld	a4,80(s1)
    800027d8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800027da:	00034797          	auipc	a5,0x34
    800027de:	33678793          	add	a5,a5,822 # 80036b10 <bcache+0x8000>
    800027e2:	2b87b703          	ld	a4,696(a5)
    800027e6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027e8:	00034717          	auipc	a4,0x34
    800027ec:	59070713          	add	a4,a4,1424 # 80036d78 <bcache+0x8268>
    800027f0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027f2:	2b87b703          	ld	a4,696(a5)
    800027f6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027f8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027fc:	0002c517          	auipc	a0,0x2c
    80002800:	31450513          	add	a0,a0,788 # 8002eb10 <bcache>
    80002804:	00004097          	auipc	ra,0x4
    80002808:	cae080e7          	jalr	-850(ra) # 800064b2 <release>
}
    8000280c:	60e2                	ld	ra,24(sp)
    8000280e:	6442                	ld	s0,16(sp)
    80002810:	64a2                	ld	s1,8(sp)
    80002812:	6902                	ld	s2,0(sp)
    80002814:	6105                	add	sp,sp,32
    80002816:	8082                	ret
    panic("brelse");
    80002818:	00006517          	auipc	a0,0x6
    8000281c:	dc850513          	add	a0,a0,-568 # 800085e0 <syscalls+0xf0>
    80002820:	00003097          	auipc	ra,0x3
    80002824:	6a6080e7          	jalr	1702(ra) # 80005ec6 <panic>

0000000080002828 <bpin>:

void
bpin(struct buf *b) {
    80002828:	1101                	add	sp,sp,-32
    8000282a:	ec06                	sd	ra,24(sp)
    8000282c:	e822                	sd	s0,16(sp)
    8000282e:	e426                	sd	s1,8(sp)
    80002830:	1000                	add	s0,sp,32
    80002832:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002834:	0002c517          	auipc	a0,0x2c
    80002838:	2dc50513          	add	a0,a0,732 # 8002eb10 <bcache>
    8000283c:	00004097          	auipc	ra,0x4
    80002840:	bc2080e7          	jalr	-1086(ra) # 800063fe <acquire>
  b->refcnt++;
    80002844:	40bc                	lw	a5,64(s1)
    80002846:	2785                	addw	a5,a5,1
    80002848:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000284a:	0002c517          	auipc	a0,0x2c
    8000284e:	2c650513          	add	a0,a0,710 # 8002eb10 <bcache>
    80002852:	00004097          	auipc	ra,0x4
    80002856:	c60080e7          	jalr	-928(ra) # 800064b2 <release>
}
    8000285a:	60e2                	ld	ra,24(sp)
    8000285c:	6442                	ld	s0,16(sp)
    8000285e:	64a2                	ld	s1,8(sp)
    80002860:	6105                	add	sp,sp,32
    80002862:	8082                	ret

0000000080002864 <bunpin>:

void
bunpin(struct buf *b) {
    80002864:	1101                	add	sp,sp,-32
    80002866:	ec06                	sd	ra,24(sp)
    80002868:	e822                	sd	s0,16(sp)
    8000286a:	e426                	sd	s1,8(sp)
    8000286c:	1000                	add	s0,sp,32
    8000286e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002870:	0002c517          	auipc	a0,0x2c
    80002874:	2a050513          	add	a0,a0,672 # 8002eb10 <bcache>
    80002878:	00004097          	auipc	ra,0x4
    8000287c:	b86080e7          	jalr	-1146(ra) # 800063fe <acquire>
  b->refcnt--;
    80002880:	40bc                	lw	a5,64(s1)
    80002882:	37fd                	addw	a5,a5,-1
    80002884:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002886:	0002c517          	auipc	a0,0x2c
    8000288a:	28a50513          	add	a0,a0,650 # 8002eb10 <bcache>
    8000288e:	00004097          	auipc	ra,0x4
    80002892:	c24080e7          	jalr	-988(ra) # 800064b2 <release>
}
    80002896:	60e2                	ld	ra,24(sp)
    80002898:	6442                	ld	s0,16(sp)
    8000289a:	64a2                	ld	s1,8(sp)
    8000289c:	6105                	add	sp,sp,32
    8000289e:	8082                	ret

00000000800028a0 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    800028a0:	1101                	add	sp,sp,-32
    800028a2:	ec06                	sd	ra,24(sp)
    800028a4:	e822                	sd	s0,16(sp)
    800028a6:	e426                	sd	s1,8(sp)
    800028a8:	e04a                	sd	s2,0(sp)
    800028aa:	1000                	add	s0,sp,32
    800028ac:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800028ae:	00d5d59b          	srlw	a1,a1,0xd
    800028b2:	00035797          	auipc	a5,0x35
    800028b6:	93a7a783          	lw	a5,-1734(a5) # 800371ec <sb+0x1c>
    800028ba:	9dbd                	addw	a1,a1,a5
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	da0080e7          	jalr	-608(ra) # 8000265c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028c4:	0074f713          	and	a4,s1,7
    800028c8:	4785                	li	a5,1
    800028ca:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028ce:	14ce                	sll	s1,s1,0x33
    800028d0:	90d9                	srl	s1,s1,0x36
    800028d2:	00950733          	add	a4,a0,s1
    800028d6:	05874703          	lbu	a4,88(a4)
    800028da:	00e7f6b3          	and	a3,a5,a4
    800028de:	c69d                	beqz	a3,8000290c <bfree+0x6c>
    800028e0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028e2:	94aa                	add	s1,s1,a0
    800028e4:	fff7c793          	not	a5,a5
    800028e8:	8f7d                	and	a4,a4,a5
    800028ea:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028ee:	00001097          	auipc	ra,0x1
    800028f2:	0f6080e7          	jalr	246(ra) # 800039e4 <log_write>
  brelse(bp);
    800028f6:	854a                	mv	a0,s2
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	e94080e7          	jalr	-364(ra) # 8000278c <brelse>
}
    80002900:	60e2                	ld	ra,24(sp)
    80002902:	6442                	ld	s0,16(sp)
    80002904:	64a2                	ld	s1,8(sp)
    80002906:	6902                	ld	s2,0(sp)
    80002908:	6105                	add	sp,sp,32
    8000290a:	8082                	ret
    panic("freeing free block");
    8000290c:	00006517          	auipc	a0,0x6
    80002910:	cdc50513          	add	a0,a0,-804 # 800085e8 <syscalls+0xf8>
    80002914:	00003097          	auipc	ra,0x3
    80002918:	5b2080e7          	jalr	1458(ra) # 80005ec6 <panic>

000000008000291c <balloc>:
{
    8000291c:	711d                	add	sp,sp,-96
    8000291e:	ec86                	sd	ra,88(sp)
    80002920:	e8a2                	sd	s0,80(sp)
    80002922:	e4a6                	sd	s1,72(sp)
    80002924:	e0ca                	sd	s2,64(sp)
    80002926:	fc4e                	sd	s3,56(sp)
    80002928:	f852                	sd	s4,48(sp)
    8000292a:	f456                	sd	s5,40(sp)
    8000292c:	f05a                	sd	s6,32(sp)
    8000292e:	ec5e                	sd	s7,24(sp)
    80002930:	e862                	sd	s8,16(sp)
    80002932:	e466                	sd	s9,8(sp)
    80002934:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002936:	00035797          	auipc	a5,0x35
    8000293a:	89e7a783          	lw	a5,-1890(a5) # 800371d4 <sb+0x4>
    8000293e:	cff5                	beqz	a5,80002a3a <balloc+0x11e>
    80002940:	8baa                	mv	s7,a0
    80002942:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002944:	00035b17          	auipc	s6,0x35
    80002948:	88cb0b13          	add	s6,s6,-1908 # 800371d0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000294c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000294e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002950:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002952:	6c89                	lui	s9,0x2
    80002954:	a061                	j	800029dc <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    80002956:	97ca                	add	a5,a5,s2
    80002958:	8e55                	or	a2,a2,a3
    8000295a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000295e:	854a                	mv	a0,s2
    80002960:	00001097          	auipc	ra,0x1
    80002964:	084080e7          	jalr	132(ra) # 800039e4 <log_write>
        brelse(bp);
    80002968:	854a                	mv	a0,s2
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	e22080e7          	jalr	-478(ra) # 8000278c <brelse>
  bp = bread(dev, bno);
    80002972:	85a6                	mv	a1,s1
    80002974:	855e                	mv	a0,s7
    80002976:	00000097          	auipc	ra,0x0
    8000297a:	ce6080e7          	jalr	-794(ra) # 8000265c <bread>
    8000297e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002980:	40000613          	li	a2,1024
    80002984:	4581                	li	a1,0
    80002986:	05850513          	add	a0,a0,88
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	97e080e7          	jalr	-1666(ra) # 80000308 <memset>
  log_write(bp);
    80002992:	854a                	mv	a0,s2
    80002994:	00001097          	auipc	ra,0x1
    80002998:	050080e7          	jalr	80(ra) # 800039e4 <log_write>
  brelse(bp);
    8000299c:	854a                	mv	a0,s2
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	dee080e7          	jalr	-530(ra) # 8000278c <brelse>
}
    800029a6:	8526                	mv	a0,s1
    800029a8:	60e6                	ld	ra,88(sp)
    800029aa:	6446                	ld	s0,80(sp)
    800029ac:	64a6                	ld	s1,72(sp)
    800029ae:	6906                	ld	s2,64(sp)
    800029b0:	79e2                	ld	s3,56(sp)
    800029b2:	7a42                	ld	s4,48(sp)
    800029b4:	7aa2                	ld	s5,40(sp)
    800029b6:	7b02                	ld	s6,32(sp)
    800029b8:	6be2                	ld	s7,24(sp)
    800029ba:	6c42                	ld	s8,16(sp)
    800029bc:	6ca2                	ld	s9,8(sp)
    800029be:	6125                	add	sp,sp,96
    800029c0:	8082                	ret
    brelse(bp);
    800029c2:	854a                	mv	a0,s2
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	dc8080e7          	jalr	-568(ra) # 8000278c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800029cc:	015c87bb          	addw	a5,s9,s5
    800029d0:	00078a9b          	sext.w	s5,a5
    800029d4:	004b2703          	lw	a4,4(s6)
    800029d8:	06eaf163          	bgeu	s5,a4,80002a3a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800029dc:	41fad79b          	sraw	a5,s5,0x1f
    800029e0:	0137d79b          	srlw	a5,a5,0x13
    800029e4:	015787bb          	addw	a5,a5,s5
    800029e8:	40d7d79b          	sraw	a5,a5,0xd
    800029ec:	01cb2583          	lw	a1,28(s6)
    800029f0:	9dbd                	addw	a1,a1,a5
    800029f2:	855e                	mv	a0,s7
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	c68080e7          	jalr	-920(ra) # 8000265c <bread>
    800029fc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029fe:	004b2503          	lw	a0,4(s6)
    80002a02:	000a849b          	sext.w	s1,s5
    80002a06:	8762                	mv	a4,s8
    80002a08:	faa4fde3          	bgeu	s1,a0,800029c2 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002a0c:	00777693          	and	a3,a4,7
    80002a10:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    80002a14:	41f7579b          	sraw	a5,a4,0x1f
    80002a18:	01d7d79b          	srlw	a5,a5,0x1d
    80002a1c:	9fb9                	addw	a5,a5,a4
    80002a1e:	4037d79b          	sraw	a5,a5,0x3
    80002a22:	00f90633          	add	a2,s2,a5
    80002a26:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002a2a:	00c6f5b3          	and	a1,a3,a2
    80002a2e:	d585                	beqz	a1,80002956 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a30:	2705                	addw	a4,a4,1
    80002a32:	2485                	addw	s1,s1,1
    80002a34:	fd471ae3          	bne	a4,s4,80002a08 <balloc+0xec>
    80002a38:	b769                	j	800029c2 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002a3a:	00006517          	auipc	a0,0x6
    80002a3e:	bc650513          	add	a0,a0,-1082 # 80008600 <syscalls+0x110>
    80002a42:	00003097          	auipc	ra,0x3
    80002a46:	4ce080e7          	jalr	1230(ra) # 80005f10 <printf>
  return 0;
    80002a4a:	4481                	li	s1,0
    80002a4c:	bfa9                	j	800029a6 <balloc+0x8a>

0000000080002a4e <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80002a4e:	7179                	add	sp,sp,-48
    80002a50:	f406                	sd	ra,40(sp)
    80002a52:	f022                	sd	s0,32(sp)
    80002a54:	ec26                	sd	s1,24(sp)
    80002a56:	e84a                	sd	s2,16(sp)
    80002a58:	e44e                	sd	s3,8(sp)
    80002a5a:	e052                	sd	s4,0(sp)
    80002a5c:	1800                	add	s0,sp,48
    80002a5e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a60:	47ad                	li	a5,11
    80002a62:	02b7e863          	bltu	a5,a1,80002a92 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002a66:	02059793          	sll	a5,a1,0x20
    80002a6a:	01e7d593          	srl	a1,a5,0x1e
    80002a6e:	00b504b3          	add	s1,a0,a1
    80002a72:	0504a903          	lw	s2,80(s1)
    80002a76:	06091e63          	bnez	s2,80002af2 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002a7a:	4108                	lw	a0,0(a0)
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	ea0080e7          	jalr	-352(ra) # 8000291c <balloc>
    80002a84:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a88:	06090563          	beqz	s2,80002af2 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002a8c:	0524a823          	sw	s2,80(s1)
    80002a90:	a08d                	j	80002af2 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a92:	ff45849b          	addw	s1,a1,-12
    80002a96:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a9a:	0ff00793          	li	a5,255
    80002a9e:	08e7e563          	bltu	a5,a4,80002b28 <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002aa2:	08052903          	lw	s2,128(a0)
    80002aa6:	00091d63          	bnez	s2,80002ac0 <bmap+0x72>
      addr = balloc(ip->dev);
    80002aaa:	4108                	lw	a0,0(a0)
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	e70080e7          	jalr	-400(ra) # 8000291c <balloc>
    80002ab4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ab8:	02090d63          	beqz	s2,80002af2 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002abc:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002ac0:	85ca                	mv	a1,s2
    80002ac2:	0009a503          	lw	a0,0(s3)
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	b96080e7          	jalr	-1130(ra) # 8000265c <bread>
    80002ace:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002ad0:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002ad4:	02049713          	sll	a4,s1,0x20
    80002ad8:	01e75593          	srl	a1,a4,0x1e
    80002adc:	00b784b3          	add	s1,a5,a1
    80002ae0:	0004a903          	lw	s2,0(s1)
    80002ae4:	02090063          	beqz	s2,80002b04 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002ae8:	8552                	mv	a0,s4
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	ca2080e7          	jalr	-862(ra) # 8000278c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002af2:	854a                	mv	a0,s2
    80002af4:	70a2                	ld	ra,40(sp)
    80002af6:	7402                	ld	s0,32(sp)
    80002af8:	64e2                	ld	s1,24(sp)
    80002afa:	6942                	ld	s2,16(sp)
    80002afc:	69a2                	ld	s3,8(sp)
    80002afe:	6a02                	ld	s4,0(sp)
    80002b00:	6145                	add	sp,sp,48
    80002b02:	8082                	ret
      addr = balloc(ip->dev);
    80002b04:	0009a503          	lw	a0,0(s3)
    80002b08:	00000097          	auipc	ra,0x0
    80002b0c:	e14080e7          	jalr	-492(ra) # 8000291c <balloc>
    80002b10:	0005091b          	sext.w	s2,a0
      if(addr){
    80002b14:	fc090ae3          	beqz	s2,80002ae8 <bmap+0x9a>
        a[bn] = addr;
    80002b18:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002b1c:	8552                	mv	a0,s4
    80002b1e:	00001097          	auipc	ra,0x1
    80002b22:	ec6080e7          	jalr	-314(ra) # 800039e4 <log_write>
    80002b26:	b7c9                	j	80002ae8 <bmap+0x9a>
  panic("bmap: out of range");
    80002b28:	00006517          	auipc	a0,0x6
    80002b2c:	af050513          	add	a0,a0,-1296 # 80008618 <syscalls+0x128>
    80002b30:	00003097          	auipc	ra,0x3
    80002b34:	396080e7          	jalr	918(ra) # 80005ec6 <panic>

0000000080002b38 <iget>:
{
    80002b38:	7179                	add	sp,sp,-48
    80002b3a:	f406                	sd	ra,40(sp)
    80002b3c:	f022                	sd	s0,32(sp)
    80002b3e:	ec26                	sd	s1,24(sp)
    80002b40:	e84a                	sd	s2,16(sp)
    80002b42:	e44e                	sd	s3,8(sp)
    80002b44:	e052                	sd	s4,0(sp)
    80002b46:	1800                	add	s0,sp,48
    80002b48:	89aa                	mv	s3,a0
    80002b4a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b4c:	00034517          	auipc	a0,0x34
    80002b50:	6a450513          	add	a0,a0,1700 # 800371f0 <itable>
    80002b54:	00004097          	auipc	ra,0x4
    80002b58:	8aa080e7          	jalr	-1878(ra) # 800063fe <acquire>
  empty = 0;
    80002b5c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b5e:	00034497          	auipc	s1,0x34
    80002b62:	6aa48493          	add	s1,s1,1706 # 80037208 <itable+0x18>
    80002b66:	00036697          	auipc	a3,0x36
    80002b6a:	13268693          	add	a3,a3,306 # 80038c98 <log>
    80002b6e:	a039                	j	80002b7c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002b70:	02090b63          	beqz	s2,80002ba6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b74:	08848493          	add	s1,s1,136
    80002b78:	02d48a63          	beq	s1,a3,80002bac <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b7c:	449c                	lw	a5,8(s1)
    80002b7e:	fef059e3          	blez	a5,80002b70 <iget+0x38>
    80002b82:	4098                	lw	a4,0(s1)
    80002b84:	ff3716e3          	bne	a4,s3,80002b70 <iget+0x38>
    80002b88:	40d8                	lw	a4,4(s1)
    80002b8a:	ff4713e3          	bne	a4,s4,80002b70 <iget+0x38>
      ip->ref++;
    80002b8e:	2785                	addw	a5,a5,1
    80002b90:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b92:	00034517          	auipc	a0,0x34
    80002b96:	65e50513          	add	a0,a0,1630 # 800371f0 <itable>
    80002b9a:	00004097          	auipc	ra,0x4
    80002b9e:	918080e7          	jalr	-1768(ra) # 800064b2 <release>
      return ip;
    80002ba2:	8926                	mv	s2,s1
    80002ba4:	a03d                	j	80002bd2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002ba6:	f7f9                	bnez	a5,80002b74 <iget+0x3c>
    80002ba8:	8926                	mv	s2,s1
    80002baa:	b7e9                	j	80002b74 <iget+0x3c>
  if(empty == 0)
    80002bac:	02090c63          	beqz	s2,80002be4 <iget+0xac>
  ip->dev = dev;
    80002bb0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002bb4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002bb8:	4785                	li	a5,1
    80002bba:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002bbe:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002bc2:	00034517          	auipc	a0,0x34
    80002bc6:	62e50513          	add	a0,a0,1582 # 800371f0 <itable>
    80002bca:	00004097          	auipc	ra,0x4
    80002bce:	8e8080e7          	jalr	-1816(ra) # 800064b2 <release>
}
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	70a2                	ld	ra,40(sp)
    80002bd6:	7402                	ld	s0,32(sp)
    80002bd8:	64e2                	ld	s1,24(sp)
    80002bda:	6942                	ld	s2,16(sp)
    80002bdc:	69a2                	ld	s3,8(sp)
    80002bde:	6a02                	ld	s4,0(sp)
    80002be0:	6145                	add	sp,sp,48
    80002be2:	8082                	ret
    panic("iget: no inodes");
    80002be4:	00006517          	auipc	a0,0x6
    80002be8:	a4c50513          	add	a0,a0,-1460 # 80008630 <syscalls+0x140>
    80002bec:	00003097          	auipc	ra,0x3
    80002bf0:	2da080e7          	jalr	730(ra) # 80005ec6 <panic>

0000000080002bf4 <fsinit>:
fsinit(int dev) {
    80002bf4:	7179                	add	sp,sp,-48
    80002bf6:	f406                	sd	ra,40(sp)
    80002bf8:	f022                	sd	s0,32(sp)
    80002bfa:	ec26                	sd	s1,24(sp)
    80002bfc:	e84a                	sd	s2,16(sp)
    80002bfe:	e44e                	sd	s3,8(sp)
    80002c00:	1800                	add	s0,sp,48
    80002c02:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c04:	4585                	li	a1,1
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	a56080e7          	jalr	-1450(ra) # 8000265c <bread>
    80002c0e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c10:	00034997          	auipc	s3,0x34
    80002c14:	5c098993          	add	s3,s3,1472 # 800371d0 <sb>
    80002c18:	02000613          	li	a2,32
    80002c1c:	05850593          	add	a1,a0,88
    80002c20:	854e                	mv	a0,s3
    80002c22:	ffffd097          	auipc	ra,0xffffd
    80002c26:	742080e7          	jalr	1858(ra) # 80000364 <memmove>
  brelse(bp);
    80002c2a:	8526                	mv	a0,s1
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	b60080e7          	jalr	-1184(ra) # 8000278c <brelse>
  if(sb.magic != FSMAGIC)
    80002c34:	0009a703          	lw	a4,0(s3)
    80002c38:	102037b7          	lui	a5,0x10203
    80002c3c:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c40:	02f71263          	bne	a4,a5,80002c64 <fsinit+0x70>
  initlog(dev, &sb);
    80002c44:	00034597          	auipc	a1,0x34
    80002c48:	58c58593          	add	a1,a1,1420 # 800371d0 <sb>
    80002c4c:	854a                	mv	a0,s2
    80002c4e:	00001097          	auipc	ra,0x1
    80002c52:	b2c080e7          	jalr	-1236(ra) # 8000377a <initlog>
}
    80002c56:	70a2                	ld	ra,40(sp)
    80002c58:	7402                	ld	s0,32(sp)
    80002c5a:	64e2                	ld	s1,24(sp)
    80002c5c:	6942                	ld	s2,16(sp)
    80002c5e:	69a2                	ld	s3,8(sp)
    80002c60:	6145                	add	sp,sp,48
    80002c62:	8082                	ret
    panic("invalid file system");
    80002c64:	00006517          	auipc	a0,0x6
    80002c68:	9dc50513          	add	a0,a0,-1572 # 80008640 <syscalls+0x150>
    80002c6c:	00003097          	auipc	ra,0x3
    80002c70:	25a080e7          	jalr	602(ra) # 80005ec6 <panic>

0000000080002c74 <iinit>:
{
    80002c74:	7179                	add	sp,sp,-48
    80002c76:	f406                	sd	ra,40(sp)
    80002c78:	f022                	sd	s0,32(sp)
    80002c7a:	ec26                	sd	s1,24(sp)
    80002c7c:	e84a                	sd	s2,16(sp)
    80002c7e:	e44e                	sd	s3,8(sp)
    80002c80:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c82:	00006597          	auipc	a1,0x6
    80002c86:	9d658593          	add	a1,a1,-1578 # 80008658 <syscalls+0x168>
    80002c8a:	00034517          	auipc	a0,0x34
    80002c8e:	56650513          	add	a0,a0,1382 # 800371f0 <itable>
    80002c92:	00003097          	auipc	ra,0x3
    80002c96:	6dc080e7          	jalr	1756(ra) # 8000636e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c9a:	00034497          	auipc	s1,0x34
    80002c9e:	57e48493          	add	s1,s1,1406 # 80037218 <itable+0x28>
    80002ca2:	00036997          	auipc	s3,0x36
    80002ca6:	00698993          	add	s3,s3,6 # 80038ca8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002caa:	00006917          	auipc	s2,0x6
    80002cae:	9b690913          	add	s2,s2,-1610 # 80008660 <syscalls+0x170>
    80002cb2:	85ca                	mv	a1,s2
    80002cb4:	8526                	mv	a0,s1
    80002cb6:	00001097          	auipc	ra,0x1
    80002cba:	e12080e7          	jalr	-494(ra) # 80003ac8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002cbe:	08848493          	add	s1,s1,136
    80002cc2:	ff3498e3          	bne	s1,s3,80002cb2 <iinit+0x3e>
}
    80002cc6:	70a2                	ld	ra,40(sp)
    80002cc8:	7402                	ld	s0,32(sp)
    80002cca:	64e2                	ld	s1,24(sp)
    80002ccc:	6942                	ld	s2,16(sp)
    80002cce:	69a2                	ld	s3,8(sp)
    80002cd0:	6145                	add	sp,sp,48
    80002cd2:	8082                	ret

0000000080002cd4 <ialloc>:
{
    80002cd4:	7139                	add	sp,sp,-64
    80002cd6:	fc06                	sd	ra,56(sp)
    80002cd8:	f822                	sd	s0,48(sp)
    80002cda:	f426                	sd	s1,40(sp)
    80002cdc:	f04a                	sd	s2,32(sp)
    80002cde:	ec4e                	sd	s3,24(sp)
    80002ce0:	e852                	sd	s4,16(sp)
    80002ce2:	e456                	sd	s5,8(sp)
    80002ce4:	e05a                	sd	s6,0(sp)
    80002ce6:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ce8:	00034717          	auipc	a4,0x34
    80002cec:	4f472703          	lw	a4,1268(a4) # 800371dc <sb+0xc>
    80002cf0:	4785                	li	a5,1
    80002cf2:	04e7f863          	bgeu	a5,a4,80002d42 <ialloc+0x6e>
    80002cf6:	8aaa                	mv	s5,a0
    80002cf8:	8b2e                	mv	s6,a1
    80002cfa:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cfc:	00034a17          	auipc	s4,0x34
    80002d00:	4d4a0a13          	add	s4,s4,1236 # 800371d0 <sb>
    80002d04:	00495593          	srl	a1,s2,0x4
    80002d08:	018a2783          	lw	a5,24(s4)
    80002d0c:	9dbd                	addw	a1,a1,a5
    80002d0e:	8556                	mv	a0,s5
    80002d10:	00000097          	auipc	ra,0x0
    80002d14:	94c080e7          	jalr	-1716(ra) # 8000265c <bread>
    80002d18:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d1a:	05850993          	add	s3,a0,88
    80002d1e:	00f97793          	and	a5,s2,15
    80002d22:	079a                	sll	a5,a5,0x6
    80002d24:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    80002d26:	00099783          	lh	a5,0(s3)
    80002d2a:	cf9d                	beqz	a5,80002d68 <ialloc+0x94>
    brelse(bp);
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	a60080e7          	jalr	-1440(ra) # 8000278c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d34:	0905                	add	s2,s2,1
    80002d36:	00ca2703          	lw	a4,12(s4)
    80002d3a:	0009079b          	sext.w	a5,s2
    80002d3e:	fce7e3e3          	bltu	a5,a4,80002d04 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002d42:	00006517          	auipc	a0,0x6
    80002d46:	92650513          	add	a0,a0,-1754 # 80008668 <syscalls+0x178>
    80002d4a:	00003097          	auipc	ra,0x3
    80002d4e:	1c6080e7          	jalr	454(ra) # 80005f10 <printf>
  return 0;
    80002d52:	4501                	li	a0,0
}
    80002d54:	70e2                	ld	ra,56(sp)
    80002d56:	7442                	ld	s0,48(sp)
    80002d58:	74a2                	ld	s1,40(sp)
    80002d5a:	7902                	ld	s2,32(sp)
    80002d5c:	69e2                	ld	s3,24(sp)
    80002d5e:	6a42                	ld	s4,16(sp)
    80002d60:	6aa2                	ld	s5,8(sp)
    80002d62:	6b02                	ld	s6,0(sp)
    80002d64:	6121                	add	sp,sp,64
    80002d66:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d68:	04000613          	li	a2,64
    80002d6c:	4581                	li	a1,0
    80002d6e:	854e                	mv	a0,s3
    80002d70:	ffffd097          	auipc	ra,0xffffd
    80002d74:	598080e7          	jalr	1432(ra) # 80000308 <memset>
      dip->type = type;
    80002d78:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80002d7c:	8526                	mv	a0,s1
    80002d7e:	00001097          	auipc	ra,0x1
    80002d82:	c66080e7          	jalr	-922(ra) # 800039e4 <log_write>
      brelse(bp);
    80002d86:	8526                	mv	a0,s1
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	a04080e7          	jalr	-1532(ra) # 8000278c <brelse>
      return iget(dev, inum);
    80002d90:	0009059b          	sext.w	a1,s2
    80002d94:	8556                	mv	a0,s5
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	da2080e7          	jalr	-606(ra) # 80002b38 <iget>
    80002d9e:	bf5d                	j	80002d54 <ialloc+0x80>

0000000080002da0 <iupdate>:
{
    80002da0:	1101                	add	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	e04a                	sd	s2,0(sp)
    80002daa:	1000                	add	s0,sp,32
    80002dac:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dae:	415c                	lw	a5,4(a0)
    80002db0:	0047d79b          	srlw	a5,a5,0x4
    80002db4:	00034597          	auipc	a1,0x34
    80002db8:	4345a583          	lw	a1,1076(a1) # 800371e8 <sb+0x18>
    80002dbc:	9dbd                	addw	a1,a1,a5
    80002dbe:	4108                	lw	a0,0(a0)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	89c080e7          	jalr	-1892(ra) # 8000265c <bread>
    80002dc8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dca:	05850793          	add	a5,a0,88
    80002dce:	40d8                	lw	a4,4(s1)
    80002dd0:	8b3d                	and	a4,a4,15
    80002dd2:	071a                	sll	a4,a4,0x6
    80002dd4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002dd6:	04449703          	lh	a4,68(s1)
    80002dda:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002dde:	04649703          	lh	a4,70(s1)
    80002de2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002de6:	04849703          	lh	a4,72(s1)
    80002dea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dee:	04a49703          	lh	a4,74(s1)
    80002df2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002df6:	44f8                	lw	a4,76(s1)
    80002df8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dfa:	03400613          	li	a2,52
    80002dfe:	05048593          	add	a1,s1,80
    80002e02:	00c78513          	add	a0,a5,12
    80002e06:	ffffd097          	auipc	ra,0xffffd
    80002e0a:	55e080e7          	jalr	1374(ra) # 80000364 <memmove>
  log_write(bp);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	00001097          	auipc	ra,0x1
    80002e14:	bd4080e7          	jalr	-1068(ra) # 800039e4 <log_write>
  brelse(bp);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	00000097          	auipc	ra,0x0
    80002e1e:	972080e7          	jalr	-1678(ra) # 8000278c <brelse>
}
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6902                	ld	s2,0(sp)
    80002e2a:	6105                	add	sp,sp,32
    80002e2c:	8082                	ret

0000000080002e2e <idup>:
{
    80002e2e:	1101                	add	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	e426                	sd	s1,8(sp)
    80002e36:	1000                	add	s0,sp,32
    80002e38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e3a:	00034517          	auipc	a0,0x34
    80002e3e:	3b650513          	add	a0,a0,950 # 800371f0 <itable>
    80002e42:	00003097          	auipc	ra,0x3
    80002e46:	5bc080e7          	jalr	1468(ra) # 800063fe <acquire>
  ip->ref++;
    80002e4a:	449c                	lw	a5,8(s1)
    80002e4c:	2785                	addw	a5,a5,1
    80002e4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e50:	00034517          	auipc	a0,0x34
    80002e54:	3a050513          	add	a0,a0,928 # 800371f0 <itable>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	65a080e7          	jalr	1626(ra) # 800064b2 <release>
}
    80002e60:	8526                	mv	a0,s1
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6105                	add	sp,sp,32
    80002e6a:	8082                	ret

0000000080002e6c <ilock>:
{
    80002e6c:	1101                	add	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	e04a                	sd	s2,0(sp)
    80002e76:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e78:	c115                	beqz	a0,80002e9c <ilock+0x30>
    80002e7a:	84aa                	mv	s1,a0
    80002e7c:	451c                	lw	a5,8(a0)
    80002e7e:	00f05f63          	blez	a5,80002e9c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e82:	0541                	add	a0,a0,16
    80002e84:	00001097          	auipc	ra,0x1
    80002e88:	c7e080e7          	jalr	-898(ra) # 80003b02 <acquiresleep>
  if(ip->valid == 0){
    80002e8c:	40bc                	lw	a5,64(s1)
    80002e8e:	cf99                	beqz	a5,80002eac <ilock+0x40>
}
    80002e90:	60e2                	ld	ra,24(sp)
    80002e92:	6442                	ld	s0,16(sp)
    80002e94:	64a2                	ld	s1,8(sp)
    80002e96:	6902                	ld	s2,0(sp)
    80002e98:	6105                	add	sp,sp,32
    80002e9a:	8082                	ret
    panic("ilock");
    80002e9c:	00005517          	auipc	a0,0x5
    80002ea0:	7e450513          	add	a0,a0,2020 # 80008680 <syscalls+0x190>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	022080e7          	jalr	34(ra) # 80005ec6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002eac:	40dc                	lw	a5,4(s1)
    80002eae:	0047d79b          	srlw	a5,a5,0x4
    80002eb2:	00034597          	auipc	a1,0x34
    80002eb6:	3365a583          	lw	a1,822(a1) # 800371e8 <sb+0x18>
    80002eba:	9dbd                	addw	a1,a1,a5
    80002ebc:	4088                	lw	a0,0(s1)
    80002ebe:	fffff097          	auipc	ra,0xfffff
    80002ec2:	79e080e7          	jalr	1950(ra) # 8000265c <bread>
    80002ec6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ec8:	05850593          	add	a1,a0,88
    80002ecc:	40dc                	lw	a5,4(s1)
    80002ece:	8bbd                	and	a5,a5,15
    80002ed0:	079a                	sll	a5,a5,0x6
    80002ed2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ed4:	00059783          	lh	a5,0(a1)
    80002ed8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002edc:	00259783          	lh	a5,2(a1)
    80002ee0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ee4:	00459783          	lh	a5,4(a1)
    80002ee8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002eec:	00659783          	lh	a5,6(a1)
    80002ef0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ef4:	459c                	lw	a5,8(a1)
    80002ef6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ef8:	03400613          	li	a2,52
    80002efc:	05b1                	add	a1,a1,12
    80002efe:	05048513          	add	a0,s1,80
    80002f02:	ffffd097          	auipc	ra,0xffffd
    80002f06:	462080e7          	jalr	1122(ra) # 80000364 <memmove>
    brelse(bp);
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	880080e7          	jalr	-1920(ra) # 8000278c <brelse>
    ip->valid = 1;
    80002f14:	4785                	li	a5,1
    80002f16:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002f18:	04449783          	lh	a5,68(s1)
    80002f1c:	fbb5                	bnez	a5,80002e90 <ilock+0x24>
      panic("ilock: no type");
    80002f1e:	00005517          	auipc	a0,0x5
    80002f22:	76a50513          	add	a0,a0,1898 # 80008688 <syscalls+0x198>
    80002f26:	00003097          	auipc	ra,0x3
    80002f2a:	fa0080e7          	jalr	-96(ra) # 80005ec6 <panic>

0000000080002f2e <iunlock>:
{
    80002f2e:	1101                	add	sp,sp,-32
    80002f30:	ec06                	sd	ra,24(sp)
    80002f32:	e822                	sd	s0,16(sp)
    80002f34:	e426                	sd	s1,8(sp)
    80002f36:	e04a                	sd	s2,0(sp)
    80002f38:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f3a:	c905                	beqz	a0,80002f6a <iunlock+0x3c>
    80002f3c:	84aa                	mv	s1,a0
    80002f3e:	01050913          	add	s2,a0,16
    80002f42:	854a                	mv	a0,s2
    80002f44:	00001097          	auipc	ra,0x1
    80002f48:	c58080e7          	jalr	-936(ra) # 80003b9c <holdingsleep>
    80002f4c:	cd19                	beqz	a0,80002f6a <iunlock+0x3c>
    80002f4e:	449c                	lw	a5,8(s1)
    80002f50:	00f05d63          	blez	a5,80002f6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f54:	854a                	mv	a0,s2
    80002f56:	00001097          	auipc	ra,0x1
    80002f5a:	c02080e7          	jalr	-1022(ra) # 80003b58 <releasesleep>
}
    80002f5e:	60e2                	ld	ra,24(sp)
    80002f60:	6442                	ld	s0,16(sp)
    80002f62:	64a2                	ld	s1,8(sp)
    80002f64:	6902                	ld	s2,0(sp)
    80002f66:	6105                	add	sp,sp,32
    80002f68:	8082                	ret
    panic("iunlock");
    80002f6a:	00005517          	auipc	a0,0x5
    80002f6e:	72e50513          	add	a0,a0,1838 # 80008698 <syscalls+0x1a8>
    80002f72:	00003097          	auipc	ra,0x3
    80002f76:	f54080e7          	jalr	-172(ra) # 80005ec6 <panic>

0000000080002f7a <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    80002f7a:	7179                	add	sp,sp,-48
    80002f7c:	f406                	sd	ra,40(sp)
    80002f7e:	f022                	sd	s0,32(sp)
    80002f80:	ec26                	sd	s1,24(sp)
    80002f82:	e84a                	sd	s2,16(sp)
    80002f84:	e44e                	sd	s3,8(sp)
    80002f86:	e052                	sd	s4,0(sp)
    80002f88:	1800                	add	s0,sp,48
    80002f8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f8c:	05050493          	add	s1,a0,80
    80002f90:	08050913          	add	s2,a0,128
    80002f94:	a021                	j	80002f9c <itrunc+0x22>
    80002f96:	0491                	add	s1,s1,4
    80002f98:	01248d63          	beq	s1,s2,80002fb2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f9c:	408c                	lw	a1,0(s1)
    80002f9e:	dde5                	beqz	a1,80002f96 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002fa0:	0009a503          	lw	a0,0(s3)
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	8fc080e7          	jalr	-1796(ra) # 800028a0 <bfree>
      ip->addrs[i] = 0;
    80002fac:	0004a023          	sw	zero,0(s1)
    80002fb0:	b7dd                	j	80002f96 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002fb2:	0809a583          	lw	a1,128(s3)
    80002fb6:	e185                	bnez	a1,80002fd6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002fb8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002fbc:	854e                	mv	a0,s3
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	de2080e7          	jalr	-542(ra) # 80002da0 <iupdate>
}
    80002fc6:	70a2                	ld	ra,40(sp)
    80002fc8:	7402                	ld	s0,32(sp)
    80002fca:	64e2                	ld	s1,24(sp)
    80002fcc:	6942                	ld	s2,16(sp)
    80002fce:	69a2                	ld	s3,8(sp)
    80002fd0:	6a02                	ld	s4,0(sp)
    80002fd2:	6145                	add	sp,sp,48
    80002fd4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fd6:	0009a503          	lw	a0,0(s3)
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	682080e7          	jalr	1666(ra) # 8000265c <bread>
    80002fe2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fe4:	05850493          	add	s1,a0,88
    80002fe8:	45850913          	add	s2,a0,1112
    80002fec:	a021                	j	80002ff4 <itrunc+0x7a>
    80002fee:	0491                	add	s1,s1,4
    80002ff0:	01248b63          	beq	s1,s2,80003006 <itrunc+0x8c>
      if(a[j])
    80002ff4:	408c                	lw	a1,0(s1)
    80002ff6:	dde5                	beqz	a1,80002fee <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002ff8:	0009a503          	lw	a0,0(s3)
    80002ffc:	00000097          	auipc	ra,0x0
    80003000:	8a4080e7          	jalr	-1884(ra) # 800028a0 <bfree>
    80003004:	b7ed                	j	80002fee <itrunc+0x74>
    brelse(bp);
    80003006:	8552                	mv	a0,s4
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	784080e7          	jalr	1924(ra) # 8000278c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003010:	0809a583          	lw	a1,128(s3)
    80003014:	0009a503          	lw	a0,0(s3)
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	888080e7          	jalr	-1912(ra) # 800028a0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003020:	0809a023          	sw	zero,128(s3)
    80003024:	bf51                	j	80002fb8 <itrunc+0x3e>

0000000080003026 <iput>:
{
    80003026:	1101                	add	sp,sp,-32
    80003028:	ec06                	sd	ra,24(sp)
    8000302a:	e822                	sd	s0,16(sp)
    8000302c:	e426                	sd	s1,8(sp)
    8000302e:	e04a                	sd	s2,0(sp)
    80003030:	1000                	add	s0,sp,32
    80003032:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003034:	00034517          	auipc	a0,0x34
    80003038:	1bc50513          	add	a0,a0,444 # 800371f0 <itable>
    8000303c:	00003097          	auipc	ra,0x3
    80003040:	3c2080e7          	jalr	962(ra) # 800063fe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003044:	4498                	lw	a4,8(s1)
    80003046:	4785                	li	a5,1
    80003048:	02f70363          	beq	a4,a5,8000306e <iput+0x48>
  ip->ref--;
    8000304c:	449c                	lw	a5,8(s1)
    8000304e:	37fd                	addw	a5,a5,-1
    80003050:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003052:	00034517          	auipc	a0,0x34
    80003056:	19e50513          	add	a0,a0,414 # 800371f0 <itable>
    8000305a:	00003097          	auipc	ra,0x3
    8000305e:	458080e7          	jalr	1112(ra) # 800064b2 <release>
}
    80003062:	60e2                	ld	ra,24(sp)
    80003064:	6442                	ld	s0,16(sp)
    80003066:	64a2                	ld	s1,8(sp)
    80003068:	6902                	ld	s2,0(sp)
    8000306a:	6105                	add	sp,sp,32
    8000306c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000306e:	40bc                	lw	a5,64(s1)
    80003070:	dff1                	beqz	a5,8000304c <iput+0x26>
    80003072:	04a49783          	lh	a5,74(s1)
    80003076:	fbf9                	bnez	a5,8000304c <iput+0x26>
    acquiresleep(&ip->lock);
    80003078:	01048913          	add	s2,s1,16
    8000307c:	854a                	mv	a0,s2
    8000307e:	00001097          	auipc	ra,0x1
    80003082:	a84080e7          	jalr	-1404(ra) # 80003b02 <acquiresleep>
    release(&itable.lock);
    80003086:	00034517          	auipc	a0,0x34
    8000308a:	16a50513          	add	a0,a0,362 # 800371f0 <itable>
    8000308e:	00003097          	auipc	ra,0x3
    80003092:	424080e7          	jalr	1060(ra) # 800064b2 <release>
    itrunc(ip);
    80003096:	8526                	mv	a0,s1
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	ee2080e7          	jalr	-286(ra) # 80002f7a <itrunc>
    ip->type = 0;
    800030a0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800030a4:	8526                	mv	a0,s1
    800030a6:	00000097          	auipc	ra,0x0
    800030aa:	cfa080e7          	jalr	-774(ra) # 80002da0 <iupdate>
    ip->valid = 0;
    800030ae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800030b2:	854a                	mv	a0,s2
    800030b4:	00001097          	auipc	ra,0x1
    800030b8:	aa4080e7          	jalr	-1372(ra) # 80003b58 <releasesleep>
    acquire(&itable.lock);
    800030bc:	00034517          	auipc	a0,0x34
    800030c0:	13450513          	add	a0,a0,308 # 800371f0 <itable>
    800030c4:	00003097          	auipc	ra,0x3
    800030c8:	33a080e7          	jalr	826(ra) # 800063fe <acquire>
    800030cc:	b741                	j	8000304c <iput+0x26>

00000000800030ce <iunlockput>:
{
    800030ce:	1101                	add	sp,sp,-32
    800030d0:	ec06                	sd	ra,24(sp)
    800030d2:	e822                	sd	s0,16(sp)
    800030d4:	e426                	sd	s1,8(sp)
    800030d6:	1000                	add	s0,sp,32
    800030d8:	84aa                	mv	s1,a0
  iunlock(ip);
    800030da:	00000097          	auipc	ra,0x0
    800030de:	e54080e7          	jalr	-428(ra) # 80002f2e <iunlock>
  iput(ip);
    800030e2:	8526                	mv	a0,s1
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	f42080e7          	jalr	-190(ra) # 80003026 <iput>
}
    800030ec:	60e2                	ld	ra,24(sp)
    800030ee:	6442                	ld	s0,16(sp)
    800030f0:	64a2                	ld	s1,8(sp)
    800030f2:	6105                	add	sp,sp,32
    800030f4:	8082                	ret

00000000800030f6 <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    800030f6:	1141                	add	sp,sp,-16
    800030f8:	e422                	sd	s0,8(sp)
    800030fa:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800030fc:	411c                	lw	a5,0(a0)
    800030fe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003100:	415c                	lw	a5,4(a0)
    80003102:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003104:	04451783          	lh	a5,68(a0)
    80003108:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000310c:	04a51783          	lh	a5,74(a0)
    80003110:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003114:	04c56783          	lwu	a5,76(a0)
    80003118:	e99c                	sd	a5,16(a1)
}
    8000311a:	6422                	ld	s0,8(sp)
    8000311c:	0141                	add	sp,sp,16
    8000311e:	8082                	ret

0000000080003120 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003120:	457c                	lw	a5,76(a0)
    80003122:	0ed7e963          	bltu	a5,a3,80003214 <readi+0xf4>
{
    80003126:	7159                	add	sp,sp,-112
    80003128:	f486                	sd	ra,104(sp)
    8000312a:	f0a2                	sd	s0,96(sp)
    8000312c:	eca6                	sd	s1,88(sp)
    8000312e:	e8ca                	sd	s2,80(sp)
    80003130:	e4ce                	sd	s3,72(sp)
    80003132:	e0d2                	sd	s4,64(sp)
    80003134:	fc56                	sd	s5,56(sp)
    80003136:	f85a                	sd	s6,48(sp)
    80003138:	f45e                	sd	s7,40(sp)
    8000313a:	f062                	sd	s8,32(sp)
    8000313c:	ec66                	sd	s9,24(sp)
    8000313e:	e86a                	sd	s10,16(sp)
    80003140:	e46e                	sd	s11,8(sp)
    80003142:	1880                	add	s0,sp,112
    80003144:	8b2a                	mv	s6,a0
    80003146:	8bae                	mv	s7,a1
    80003148:	8a32                	mv	s4,a2
    8000314a:	84b6                	mv	s1,a3
    8000314c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000314e:	9f35                	addw	a4,a4,a3
    return 0;
    80003150:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003152:	0ad76063          	bltu	a4,a3,800031f2 <readi+0xd2>
  if(off + n > ip->size)
    80003156:	00e7f463          	bgeu	a5,a4,8000315e <readi+0x3e>
    n = ip->size - off;
    8000315a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000315e:	0a0a8963          	beqz	s5,80003210 <readi+0xf0>
    80003162:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003164:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003168:	5c7d                	li	s8,-1
    8000316a:	a82d                	j	800031a4 <readi+0x84>
    8000316c:	020d1d93          	sll	s11,s10,0x20
    80003170:	020ddd93          	srl	s11,s11,0x20
    80003174:	05890613          	add	a2,s2,88
    80003178:	86ee                	mv	a3,s11
    8000317a:	963a                	add	a2,a2,a4
    8000317c:	85d2                	mv	a1,s4
    8000317e:	855e                	mv	a0,s7
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	968080e7          	jalr	-1688(ra) # 80001ae8 <either_copyout>
    80003188:	05850d63          	beq	a0,s8,800031e2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000318c:	854a                	mv	a0,s2
    8000318e:	fffff097          	auipc	ra,0xfffff
    80003192:	5fe080e7          	jalr	1534(ra) # 8000278c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003196:	013d09bb          	addw	s3,s10,s3
    8000319a:	009d04bb          	addw	s1,s10,s1
    8000319e:	9a6e                	add	s4,s4,s11
    800031a0:	0559f763          	bgeu	s3,s5,800031ee <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800031a4:	00a4d59b          	srlw	a1,s1,0xa
    800031a8:	855a                	mv	a0,s6
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	8a4080e7          	jalr	-1884(ra) # 80002a4e <bmap>
    800031b2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031b6:	cd85                	beqz	a1,800031ee <readi+0xce>
    bp = bread(ip->dev, addr);
    800031b8:	000b2503          	lw	a0,0(s6)
    800031bc:	fffff097          	auipc	ra,0xfffff
    800031c0:	4a0080e7          	jalr	1184(ra) # 8000265c <bread>
    800031c4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031c6:	3ff4f713          	and	a4,s1,1023
    800031ca:	40ec87bb          	subw	a5,s9,a4
    800031ce:	413a86bb          	subw	a3,s5,s3
    800031d2:	8d3e                	mv	s10,a5
    800031d4:	2781                	sext.w	a5,a5
    800031d6:	0006861b          	sext.w	a2,a3
    800031da:	f8f679e3          	bgeu	a2,a5,8000316c <readi+0x4c>
    800031de:	8d36                	mv	s10,a3
    800031e0:	b771                	j	8000316c <readi+0x4c>
      brelse(bp);
    800031e2:	854a                	mv	a0,s2
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	5a8080e7          	jalr	1448(ra) # 8000278c <brelse>
      tot = -1;
    800031ec:	59fd                	li	s3,-1
  }
  return tot;
    800031ee:	0009851b          	sext.w	a0,s3
}
    800031f2:	70a6                	ld	ra,104(sp)
    800031f4:	7406                	ld	s0,96(sp)
    800031f6:	64e6                	ld	s1,88(sp)
    800031f8:	6946                	ld	s2,80(sp)
    800031fa:	69a6                	ld	s3,72(sp)
    800031fc:	6a06                	ld	s4,64(sp)
    800031fe:	7ae2                	ld	s5,56(sp)
    80003200:	7b42                	ld	s6,48(sp)
    80003202:	7ba2                	ld	s7,40(sp)
    80003204:	7c02                	ld	s8,32(sp)
    80003206:	6ce2                	ld	s9,24(sp)
    80003208:	6d42                	ld	s10,16(sp)
    8000320a:	6da2                	ld	s11,8(sp)
    8000320c:	6165                	add	sp,sp,112
    8000320e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003210:	89d6                	mv	s3,s5
    80003212:	bff1                	j	800031ee <readi+0xce>
    return 0;
    80003214:	4501                	li	a0,0
}
    80003216:	8082                	ret

0000000080003218 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003218:	457c                	lw	a5,76(a0)
    8000321a:	10d7e863          	bltu	a5,a3,8000332a <writei+0x112>
{
    8000321e:	7159                	add	sp,sp,-112
    80003220:	f486                	sd	ra,104(sp)
    80003222:	f0a2                	sd	s0,96(sp)
    80003224:	eca6                	sd	s1,88(sp)
    80003226:	e8ca                	sd	s2,80(sp)
    80003228:	e4ce                	sd	s3,72(sp)
    8000322a:	e0d2                	sd	s4,64(sp)
    8000322c:	fc56                	sd	s5,56(sp)
    8000322e:	f85a                	sd	s6,48(sp)
    80003230:	f45e                	sd	s7,40(sp)
    80003232:	f062                	sd	s8,32(sp)
    80003234:	ec66                	sd	s9,24(sp)
    80003236:	e86a                	sd	s10,16(sp)
    80003238:	e46e                	sd	s11,8(sp)
    8000323a:	1880                	add	s0,sp,112
    8000323c:	8aaa                	mv	s5,a0
    8000323e:	8bae                	mv	s7,a1
    80003240:	8a32                	mv	s4,a2
    80003242:	8936                	mv	s2,a3
    80003244:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003246:	00e687bb          	addw	a5,a3,a4
    8000324a:	0ed7e263          	bltu	a5,a3,8000332e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000324e:	00043737          	lui	a4,0x43
    80003252:	0ef76063          	bltu	a4,a5,80003332 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003256:	0c0b0863          	beqz	s6,80003326 <writei+0x10e>
    8000325a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000325c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003260:	5c7d                	li	s8,-1
    80003262:	a091                	j	800032a6 <writei+0x8e>
    80003264:	020d1d93          	sll	s11,s10,0x20
    80003268:	020ddd93          	srl	s11,s11,0x20
    8000326c:	05848513          	add	a0,s1,88
    80003270:	86ee                	mv	a3,s11
    80003272:	8652                	mv	a2,s4
    80003274:	85de                	mv	a1,s7
    80003276:	953a                	add	a0,a0,a4
    80003278:	fffff097          	auipc	ra,0xfffff
    8000327c:	8c6080e7          	jalr	-1850(ra) # 80001b3e <either_copyin>
    80003280:	07850263          	beq	a0,s8,800032e4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003284:	8526                	mv	a0,s1
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	75e080e7          	jalr	1886(ra) # 800039e4 <log_write>
    brelse(bp);
    8000328e:	8526                	mv	a0,s1
    80003290:	fffff097          	auipc	ra,0xfffff
    80003294:	4fc080e7          	jalr	1276(ra) # 8000278c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003298:	013d09bb          	addw	s3,s10,s3
    8000329c:	012d093b          	addw	s2,s10,s2
    800032a0:	9a6e                	add	s4,s4,s11
    800032a2:	0569f663          	bgeu	s3,s6,800032ee <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800032a6:	00a9559b          	srlw	a1,s2,0xa
    800032aa:	8556                	mv	a0,s5
    800032ac:	fffff097          	auipc	ra,0xfffff
    800032b0:	7a2080e7          	jalr	1954(ra) # 80002a4e <bmap>
    800032b4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800032b8:	c99d                	beqz	a1,800032ee <writei+0xd6>
    bp = bread(ip->dev, addr);
    800032ba:	000aa503          	lw	a0,0(s5)
    800032be:	fffff097          	auipc	ra,0xfffff
    800032c2:	39e080e7          	jalr	926(ra) # 8000265c <bread>
    800032c6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032c8:	3ff97713          	and	a4,s2,1023
    800032cc:	40ec87bb          	subw	a5,s9,a4
    800032d0:	413b06bb          	subw	a3,s6,s3
    800032d4:	8d3e                	mv	s10,a5
    800032d6:	2781                	sext.w	a5,a5
    800032d8:	0006861b          	sext.w	a2,a3
    800032dc:	f8f674e3          	bgeu	a2,a5,80003264 <writei+0x4c>
    800032e0:	8d36                	mv	s10,a3
    800032e2:	b749                	j	80003264 <writei+0x4c>
      brelse(bp);
    800032e4:	8526                	mv	a0,s1
    800032e6:	fffff097          	auipc	ra,0xfffff
    800032ea:	4a6080e7          	jalr	1190(ra) # 8000278c <brelse>
  }

  if(off > ip->size)
    800032ee:	04caa783          	lw	a5,76(s5)
    800032f2:	0127f463          	bgeu	a5,s2,800032fa <writei+0xe2>
    ip->size = off;
    800032f6:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    800032fa:	8556                	mv	a0,s5
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	aa4080e7          	jalr	-1372(ra) # 80002da0 <iupdate>

  return tot;
    80003304:	0009851b          	sext.w	a0,s3
}
    80003308:	70a6                	ld	ra,104(sp)
    8000330a:	7406                	ld	s0,96(sp)
    8000330c:	64e6                	ld	s1,88(sp)
    8000330e:	6946                	ld	s2,80(sp)
    80003310:	69a6                	ld	s3,72(sp)
    80003312:	6a06                	ld	s4,64(sp)
    80003314:	7ae2                	ld	s5,56(sp)
    80003316:	7b42                	ld	s6,48(sp)
    80003318:	7ba2                	ld	s7,40(sp)
    8000331a:	7c02                	ld	s8,32(sp)
    8000331c:	6ce2                	ld	s9,24(sp)
    8000331e:	6d42                	ld	s10,16(sp)
    80003320:	6da2                	ld	s11,8(sp)
    80003322:	6165                	add	sp,sp,112
    80003324:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003326:	89da                	mv	s3,s6
    80003328:	bfc9                	j	800032fa <writei+0xe2>
    return -1;
    8000332a:	557d                	li	a0,-1
}
    8000332c:	8082                	ret
    return -1;
    8000332e:	557d                	li	a0,-1
    80003330:	bfe1                	j	80003308 <writei+0xf0>
    return -1;
    80003332:	557d                	li	a0,-1
    80003334:	bfd1                	j	80003308 <writei+0xf0>

0000000080003336 <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003336:	1141                	add	sp,sp,-16
    80003338:	e406                	sd	ra,8(sp)
    8000333a:	e022                	sd	s0,0(sp)
    8000333c:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000333e:	4639                	li	a2,14
    80003340:	ffffd097          	auipc	ra,0xffffd
    80003344:	098080e7          	jalr	152(ra) # 800003d8 <strncmp>
}
    80003348:	60a2                	ld	ra,8(sp)
    8000334a:	6402                	ld	s0,0(sp)
    8000334c:	0141                	add	sp,sp,16
    8000334e:	8082                	ret

0000000080003350 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003350:	7139                	add	sp,sp,-64
    80003352:	fc06                	sd	ra,56(sp)
    80003354:	f822                	sd	s0,48(sp)
    80003356:	f426                	sd	s1,40(sp)
    80003358:	f04a                	sd	s2,32(sp)
    8000335a:	ec4e                	sd	s3,24(sp)
    8000335c:	e852                	sd	s4,16(sp)
    8000335e:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003360:	04451703          	lh	a4,68(a0)
    80003364:	4785                	li	a5,1
    80003366:	00f71a63          	bne	a4,a5,8000337a <dirlookup+0x2a>
    8000336a:	892a                	mv	s2,a0
    8000336c:	89ae                	mv	s3,a1
    8000336e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003370:	457c                	lw	a5,76(a0)
    80003372:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003374:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003376:	e79d                	bnez	a5,800033a4 <dirlookup+0x54>
    80003378:	a8a5                	j	800033f0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	32650513          	add	a0,a0,806 # 800086a0 <syscalls+0x1b0>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	b44080e7          	jalr	-1212(ra) # 80005ec6 <panic>
      panic("dirlookup read");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	32e50513          	add	a0,a0,814 # 800086b8 <syscalls+0x1c8>
    80003392:	00003097          	auipc	ra,0x3
    80003396:	b34080e7          	jalr	-1228(ra) # 80005ec6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000339a:	24c1                	addw	s1,s1,16
    8000339c:	04c92783          	lw	a5,76(s2)
    800033a0:	04f4f763          	bgeu	s1,a5,800033ee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a4:	4741                	li	a4,16
    800033a6:	86a6                	mv	a3,s1
    800033a8:	fc040613          	add	a2,s0,-64
    800033ac:	4581                	li	a1,0
    800033ae:	854a                	mv	a0,s2
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	d70080e7          	jalr	-656(ra) # 80003120 <readi>
    800033b8:	47c1                	li	a5,16
    800033ba:	fcf518e3          	bne	a0,a5,8000338a <dirlookup+0x3a>
    if(de.inum == 0)
    800033be:	fc045783          	lhu	a5,-64(s0)
    800033c2:	dfe1                	beqz	a5,8000339a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033c4:	fc240593          	add	a1,s0,-62
    800033c8:	854e                	mv	a0,s3
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	f6c080e7          	jalr	-148(ra) # 80003336 <namecmp>
    800033d2:	f561                	bnez	a0,8000339a <dirlookup+0x4a>
      if(poff)
    800033d4:	000a0463          	beqz	s4,800033dc <dirlookup+0x8c>
        *poff = off;
    800033d8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033dc:	fc045583          	lhu	a1,-64(s0)
    800033e0:	00092503          	lw	a0,0(s2)
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	754080e7          	jalr	1876(ra) # 80002b38 <iget>
    800033ec:	a011                	j	800033f0 <dirlookup+0xa0>
  return 0;
    800033ee:	4501                	li	a0,0
}
    800033f0:	70e2                	ld	ra,56(sp)
    800033f2:	7442                	ld	s0,48(sp)
    800033f4:	74a2                	ld	s1,40(sp)
    800033f6:	7902                	ld	s2,32(sp)
    800033f8:	69e2                	ld	s3,24(sp)
    800033fa:	6a42                	ld	s4,16(sp)
    800033fc:	6121                	add	sp,sp,64
    800033fe:	8082                	ret

0000000080003400 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003400:	711d                	add	sp,sp,-96
    80003402:	ec86                	sd	ra,88(sp)
    80003404:	e8a2                	sd	s0,80(sp)
    80003406:	e4a6                	sd	s1,72(sp)
    80003408:	e0ca                	sd	s2,64(sp)
    8000340a:	fc4e                	sd	s3,56(sp)
    8000340c:	f852                	sd	s4,48(sp)
    8000340e:	f456                	sd	s5,40(sp)
    80003410:	f05a                	sd	s6,32(sp)
    80003412:	ec5e                	sd	s7,24(sp)
    80003414:	e862                	sd	s8,16(sp)
    80003416:	e466                	sd	s9,8(sp)
    80003418:	1080                	add	s0,sp,96
    8000341a:	84aa                	mv	s1,a0
    8000341c:	8b2e                	mv	s6,a1
    8000341e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003420:	00054703          	lbu	a4,0(a0)
    80003424:	02f00793          	li	a5,47
    80003428:	02f70263          	beq	a4,a5,8000344c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000342c:	ffffe097          	auipc	ra,0xffffe
    80003430:	c00080e7          	jalr	-1024(ra) # 8000102c <myproc>
    80003434:	15053503          	ld	a0,336(a0)
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	9f6080e7          	jalr	-1546(ra) # 80002e2e <idup>
    80003440:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003442:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003446:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003448:	4b85                	li	s7,1
    8000344a:	a875                	j	80003506 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000344c:	4585                	li	a1,1
    8000344e:	4505                	li	a0,1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	6e8080e7          	jalr	1768(ra) # 80002b38 <iget>
    80003458:	8a2a                	mv	s4,a0
    8000345a:	b7e5                	j	80003442 <namex+0x42>
      iunlockput(ip);
    8000345c:	8552                	mv	a0,s4
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	c70080e7          	jalr	-912(ra) # 800030ce <iunlockput>
      return 0;
    80003466:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003468:	8552                	mv	a0,s4
    8000346a:	60e6                	ld	ra,88(sp)
    8000346c:	6446                	ld	s0,80(sp)
    8000346e:	64a6                	ld	s1,72(sp)
    80003470:	6906                	ld	s2,64(sp)
    80003472:	79e2                	ld	s3,56(sp)
    80003474:	7a42                	ld	s4,48(sp)
    80003476:	7aa2                	ld	s5,40(sp)
    80003478:	7b02                	ld	s6,32(sp)
    8000347a:	6be2                	ld	s7,24(sp)
    8000347c:	6c42                	ld	s8,16(sp)
    8000347e:	6ca2                	ld	s9,8(sp)
    80003480:	6125                	add	sp,sp,96
    80003482:	8082                	ret
      iunlock(ip);
    80003484:	8552                	mv	a0,s4
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	aa8080e7          	jalr	-1368(ra) # 80002f2e <iunlock>
      return ip;
    8000348e:	bfe9                	j	80003468 <namex+0x68>
      iunlockput(ip);
    80003490:	8552                	mv	a0,s4
    80003492:	00000097          	auipc	ra,0x0
    80003496:	c3c080e7          	jalr	-964(ra) # 800030ce <iunlockput>
      return 0;
    8000349a:	8a4e                	mv	s4,s3
    8000349c:	b7f1                	j	80003468 <namex+0x68>
  len = path - s;
    8000349e:	40998633          	sub	a2,s3,s1
    800034a2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800034a6:	099c5863          	bge	s8,s9,80003536 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800034aa:	4639                	li	a2,14
    800034ac:	85a6                	mv	a1,s1
    800034ae:	8556                	mv	a0,s5
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	eb4080e7          	jalr	-332(ra) # 80000364 <memmove>
    800034b8:	84ce                	mv	s1,s3
  while(*path == '/')
    800034ba:	0004c783          	lbu	a5,0(s1)
    800034be:	01279763          	bne	a5,s2,800034cc <namex+0xcc>
    path++;
    800034c2:	0485                	add	s1,s1,1
  while(*path == '/')
    800034c4:	0004c783          	lbu	a5,0(s1)
    800034c8:	ff278de3          	beq	a5,s2,800034c2 <namex+0xc2>
    ilock(ip);
    800034cc:	8552                	mv	a0,s4
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	99e080e7          	jalr	-1634(ra) # 80002e6c <ilock>
    if(ip->type != T_DIR){
    800034d6:	044a1783          	lh	a5,68(s4)
    800034da:	f97791e3          	bne	a5,s7,8000345c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034de:	000b0563          	beqz	s6,800034e8 <namex+0xe8>
    800034e2:	0004c783          	lbu	a5,0(s1)
    800034e6:	dfd9                	beqz	a5,80003484 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034e8:	4601                	li	a2,0
    800034ea:	85d6                	mv	a1,s5
    800034ec:	8552                	mv	a0,s4
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	e62080e7          	jalr	-414(ra) # 80003350 <dirlookup>
    800034f6:	89aa                	mv	s3,a0
    800034f8:	dd41                	beqz	a0,80003490 <namex+0x90>
    iunlockput(ip);
    800034fa:	8552                	mv	a0,s4
    800034fc:	00000097          	auipc	ra,0x0
    80003500:	bd2080e7          	jalr	-1070(ra) # 800030ce <iunlockput>
    ip = next;
    80003504:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003506:	0004c783          	lbu	a5,0(s1)
    8000350a:	01279763          	bne	a5,s2,80003518 <namex+0x118>
    path++;
    8000350e:	0485                	add	s1,s1,1
  while(*path == '/')
    80003510:	0004c783          	lbu	a5,0(s1)
    80003514:	ff278de3          	beq	a5,s2,8000350e <namex+0x10e>
  if(*path == 0)
    80003518:	cb9d                	beqz	a5,8000354e <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000351a:	0004c783          	lbu	a5,0(s1)
    8000351e:	89a6                	mv	s3,s1
  len = path - s;
    80003520:	4c81                	li	s9,0
    80003522:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003524:	01278963          	beq	a5,s2,80003536 <namex+0x136>
    80003528:	dbbd                	beqz	a5,8000349e <namex+0x9e>
    path++;
    8000352a:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    8000352c:	0009c783          	lbu	a5,0(s3)
    80003530:	ff279ce3          	bne	a5,s2,80003528 <namex+0x128>
    80003534:	b7ad                	j	8000349e <namex+0x9e>
    memmove(name, s, len);
    80003536:	2601                	sext.w	a2,a2
    80003538:	85a6                	mv	a1,s1
    8000353a:	8556                	mv	a0,s5
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	e28080e7          	jalr	-472(ra) # 80000364 <memmove>
    name[len] = 0;
    80003544:	9cd6                	add	s9,s9,s5
    80003546:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000354a:	84ce                	mv	s1,s3
    8000354c:	b7bd                	j	800034ba <namex+0xba>
  if(nameiparent){
    8000354e:	f00b0de3          	beqz	s6,80003468 <namex+0x68>
    iput(ip);
    80003552:	8552                	mv	a0,s4
    80003554:	00000097          	auipc	ra,0x0
    80003558:	ad2080e7          	jalr	-1326(ra) # 80003026 <iput>
    return 0;
    8000355c:	4a01                	li	s4,0
    8000355e:	b729                	j	80003468 <namex+0x68>

0000000080003560 <dirlink>:
{
    80003560:	7139                	add	sp,sp,-64
    80003562:	fc06                	sd	ra,56(sp)
    80003564:	f822                	sd	s0,48(sp)
    80003566:	f426                	sd	s1,40(sp)
    80003568:	f04a                	sd	s2,32(sp)
    8000356a:	ec4e                	sd	s3,24(sp)
    8000356c:	e852                	sd	s4,16(sp)
    8000356e:	0080                	add	s0,sp,64
    80003570:	892a                	mv	s2,a0
    80003572:	8a2e                	mv	s4,a1
    80003574:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003576:	4601                	li	a2,0
    80003578:	00000097          	auipc	ra,0x0
    8000357c:	dd8080e7          	jalr	-552(ra) # 80003350 <dirlookup>
    80003580:	e93d                	bnez	a0,800035f6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003582:	04c92483          	lw	s1,76(s2)
    80003586:	c49d                	beqz	s1,800035b4 <dirlink+0x54>
    80003588:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000358a:	4741                	li	a4,16
    8000358c:	86a6                	mv	a3,s1
    8000358e:	fc040613          	add	a2,s0,-64
    80003592:	4581                	li	a1,0
    80003594:	854a                	mv	a0,s2
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	b8a080e7          	jalr	-1142(ra) # 80003120 <readi>
    8000359e:	47c1                	li	a5,16
    800035a0:	06f51163          	bne	a0,a5,80003602 <dirlink+0xa2>
    if(de.inum == 0)
    800035a4:	fc045783          	lhu	a5,-64(s0)
    800035a8:	c791                	beqz	a5,800035b4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035aa:	24c1                	addw	s1,s1,16
    800035ac:	04c92783          	lw	a5,76(s2)
    800035b0:	fcf4ede3          	bltu	s1,a5,8000358a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035b4:	4639                	li	a2,14
    800035b6:	85d2                	mv	a1,s4
    800035b8:	fc240513          	add	a0,s0,-62
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	e58080e7          	jalr	-424(ra) # 80000414 <strncpy>
  de.inum = inum;
    800035c4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035c8:	4741                	li	a4,16
    800035ca:	86a6                	mv	a3,s1
    800035cc:	fc040613          	add	a2,s0,-64
    800035d0:	4581                	li	a1,0
    800035d2:	854a                	mv	a0,s2
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	c44080e7          	jalr	-956(ra) # 80003218 <writei>
    800035dc:	1541                	add	a0,a0,-16
    800035de:	00a03533          	snez	a0,a0
    800035e2:	40a00533          	neg	a0,a0
}
    800035e6:	70e2                	ld	ra,56(sp)
    800035e8:	7442                	ld	s0,48(sp)
    800035ea:	74a2                	ld	s1,40(sp)
    800035ec:	7902                	ld	s2,32(sp)
    800035ee:	69e2                	ld	s3,24(sp)
    800035f0:	6a42                	ld	s4,16(sp)
    800035f2:	6121                	add	sp,sp,64
    800035f4:	8082                	ret
    iput(ip);
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	a30080e7          	jalr	-1488(ra) # 80003026 <iput>
    return -1;
    800035fe:	557d                	li	a0,-1
    80003600:	b7dd                	j	800035e6 <dirlink+0x86>
      panic("dirlink read");
    80003602:	00005517          	auipc	a0,0x5
    80003606:	0c650513          	add	a0,a0,198 # 800086c8 <syscalls+0x1d8>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	8bc080e7          	jalr	-1860(ra) # 80005ec6 <panic>

0000000080003612 <namei>:

struct inode*
namei(char *path)
{
    80003612:	1101                	add	sp,sp,-32
    80003614:	ec06                	sd	ra,24(sp)
    80003616:	e822                	sd	s0,16(sp)
    80003618:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000361a:	fe040613          	add	a2,s0,-32
    8000361e:	4581                	li	a1,0
    80003620:	00000097          	auipc	ra,0x0
    80003624:	de0080e7          	jalr	-544(ra) # 80003400 <namex>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	6105                	add	sp,sp,32
    8000362e:	8082                	ret

0000000080003630 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003630:	1141                	add	sp,sp,-16
    80003632:	e406                	sd	ra,8(sp)
    80003634:	e022                	sd	s0,0(sp)
    80003636:	0800                	add	s0,sp,16
    80003638:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000363a:	4585                	li	a1,1
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	dc4080e7          	jalr	-572(ra) # 80003400 <namex>
}
    80003644:	60a2                	ld	ra,8(sp)
    80003646:	6402                	ld	s0,0(sp)
    80003648:	0141                	add	sp,sp,16
    8000364a:	8082                	ret

000000008000364c <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    8000364c:	1101                	add	sp,sp,-32
    8000364e:	ec06                	sd	ra,24(sp)
    80003650:	e822                	sd	s0,16(sp)
    80003652:	e426                	sd	s1,8(sp)
    80003654:	e04a                	sd	s2,0(sp)
    80003656:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003658:	00035917          	auipc	s2,0x35
    8000365c:	64090913          	add	s2,s2,1600 # 80038c98 <log>
    80003660:	01892583          	lw	a1,24(s2)
    80003664:	02892503          	lw	a0,40(s2)
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	ff4080e7          	jalr	-12(ra) # 8000265c <bread>
    80003670:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003672:	02c92603          	lw	a2,44(s2)
    80003676:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003678:	00c05f63          	blez	a2,80003696 <write_head+0x4a>
    8000367c:	00035717          	auipc	a4,0x35
    80003680:	64c70713          	add	a4,a4,1612 # 80038cc8 <log+0x30>
    80003684:	87aa                	mv	a5,a0
    80003686:	060a                	sll	a2,a2,0x2
    80003688:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000368a:	4314                	lw	a3,0(a4)
    8000368c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000368e:	0711                	add	a4,a4,4
    80003690:	0791                	add	a5,a5,4
    80003692:	fec79ce3          	bne	a5,a2,8000368a <write_head+0x3e>
  }
  bwrite(buf);
    80003696:	8526                	mv	a0,s1
    80003698:	fffff097          	auipc	ra,0xfffff
    8000369c:	0b6080e7          	jalr	182(ra) # 8000274e <bwrite>
  brelse(buf);
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	0ea080e7          	jalr	234(ra) # 8000278c <brelse>
}
    800036aa:	60e2                	ld	ra,24(sp)
    800036ac:	6442                	ld	s0,16(sp)
    800036ae:	64a2                	ld	s1,8(sp)
    800036b0:	6902                	ld	s2,0(sp)
    800036b2:	6105                	add	sp,sp,32
    800036b4:	8082                	ret

00000000800036b6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b6:	00035797          	auipc	a5,0x35
    800036ba:	60e7a783          	lw	a5,1550(a5) # 80038cc4 <log+0x2c>
    800036be:	0af05d63          	blez	a5,80003778 <install_trans+0xc2>
{
    800036c2:	7139                	add	sp,sp,-64
    800036c4:	fc06                	sd	ra,56(sp)
    800036c6:	f822                	sd	s0,48(sp)
    800036c8:	f426                	sd	s1,40(sp)
    800036ca:	f04a                	sd	s2,32(sp)
    800036cc:	ec4e                	sd	s3,24(sp)
    800036ce:	e852                	sd	s4,16(sp)
    800036d0:	e456                	sd	s5,8(sp)
    800036d2:	e05a                	sd	s6,0(sp)
    800036d4:	0080                	add	s0,sp,64
    800036d6:	8b2a                	mv	s6,a0
    800036d8:	00035a97          	auipc	s5,0x35
    800036dc:	5f0a8a93          	add	s5,s5,1520 # 80038cc8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    800036e2:	00035997          	auipc	s3,0x35
    800036e6:	5b698993          	add	s3,s3,1462 # 80038c98 <log>
    800036ea:	a00d                	j	8000370c <install_trans+0x56>
    brelse(lbuf);
    800036ec:	854a                	mv	a0,s2
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	09e080e7          	jalr	158(ra) # 8000278c <brelse>
    brelse(dbuf);
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	094080e7          	jalr	148(ra) # 8000278c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003700:	2a05                	addw	s4,s4,1
    80003702:	0a91                	add	s5,s5,4
    80003704:	02c9a783          	lw	a5,44(s3)
    80003708:	04fa5e63          	bge	s4,a5,80003764 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000370c:	0189a583          	lw	a1,24(s3)
    80003710:	014585bb          	addw	a1,a1,s4
    80003714:	2585                	addw	a1,a1,1
    80003716:	0289a503          	lw	a0,40(s3)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	f42080e7          	jalr	-190(ra) # 8000265c <bread>
    80003722:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	0289a503          	lw	a0,40(s3)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	f30080e7          	jalr	-208(ra) # 8000265c <bread>
    80003734:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    80003736:	40000613          	li	a2,1024
    8000373a:	05890593          	add	a1,s2,88
    8000373e:	05850513          	add	a0,a0,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	c22080e7          	jalr	-990(ra) # 80000364 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	002080e7          	jalr	2(ra) # 8000274e <bwrite>
    if(recovering == 0)
    80003754:	f80b1ce3          	bnez	s6,800036ec <install_trans+0x36>
      bunpin(dbuf);
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	10a080e7          	jalr	266(ra) # 80002864 <bunpin>
    80003762:	b769                	j	800036ec <install_trans+0x36>
}
    80003764:	70e2                	ld	ra,56(sp)
    80003766:	7442                	ld	s0,48(sp)
    80003768:	74a2                	ld	s1,40(sp)
    8000376a:	7902                	ld	s2,32(sp)
    8000376c:	69e2                	ld	s3,24(sp)
    8000376e:	6a42                	ld	s4,16(sp)
    80003770:	6aa2                	ld	s5,8(sp)
    80003772:	6b02                	ld	s6,0(sp)
    80003774:	6121                	add	sp,sp,64
    80003776:	8082                	ret
    80003778:	8082                	ret

000000008000377a <initlog>:
{
    8000377a:	7179                	add	sp,sp,-48
    8000377c:	f406                	sd	ra,40(sp)
    8000377e:	f022                	sd	s0,32(sp)
    80003780:	ec26                	sd	s1,24(sp)
    80003782:	e84a                	sd	s2,16(sp)
    80003784:	e44e                	sd	s3,8(sp)
    80003786:	1800                	add	s0,sp,48
    80003788:	892a                	mv	s2,a0
    8000378a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000378c:	00035497          	auipc	s1,0x35
    80003790:	50c48493          	add	s1,s1,1292 # 80038c98 <log>
    80003794:	00005597          	auipc	a1,0x5
    80003798:	f4458593          	add	a1,a1,-188 # 800086d8 <syscalls+0x1e8>
    8000379c:	8526                	mv	a0,s1
    8000379e:	00003097          	auipc	ra,0x3
    800037a2:	bd0080e7          	jalr	-1072(ra) # 8000636e <initlock>
  log.start = sb->logstart;
    800037a6:	0149a583          	lw	a1,20(s3)
    800037aa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800037ac:	0109a783          	lw	a5,16(s3)
    800037b0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037b2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037b6:	854a                	mv	a0,s2
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	ea4080e7          	jalr	-348(ra) # 8000265c <bread>
  log.lh.n = lh->n;
    800037c0:	4d30                	lw	a2,88(a0)
    800037c2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	00c05f63          	blez	a2,800037e2 <initlog+0x68>
    800037c8:	87aa                	mv	a5,a0
    800037ca:	00035717          	auipc	a4,0x35
    800037ce:	4fe70713          	add	a4,a4,1278 # 80038cc8 <log+0x30>
    800037d2:	060a                	sll	a2,a2,0x2
    800037d4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037d6:	4ff4                	lw	a3,92(a5)
    800037d8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037da:	0791                	add	a5,a5,4
    800037dc:	0711                	add	a4,a4,4
    800037de:	fec79ce3          	bne	a5,a2,800037d6 <initlog+0x5c>
  brelse(buf);
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	faa080e7          	jalr	-86(ra) # 8000278c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    800037ea:	4505                	li	a0,1
    800037ec:	00000097          	auipc	ra,0x0
    800037f0:	eca080e7          	jalr	-310(ra) # 800036b6 <install_trans>
  log.lh.n = 0;
    800037f4:	00035797          	auipc	a5,0x35
    800037f8:	4c07a823          	sw	zero,1232(a5) # 80038cc4 <log+0x2c>
  write_head(); /* clear the log */
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	e50080e7          	jalr	-432(ra) # 8000364c <write_head>
}
    80003804:	70a2                	ld	ra,40(sp)
    80003806:	7402                	ld	s0,32(sp)
    80003808:	64e2                	ld	s1,24(sp)
    8000380a:	6942                	ld	s2,16(sp)
    8000380c:	69a2                	ld	s3,8(sp)
    8000380e:	6145                	add	sp,sp,48
    80003810:	8082                	ret

0000000080003812 <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    80003812:	1101                	add	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	add	s0,sp,32
  acquire(&log.lock);
    8000381e:	00035517          	auipc	a0,0x35
    80003822:	47a50513          	add	a0,a0,1146 # 80038c98 <log>
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	bd8080e7          	jalr	-1064(ra) # 800063fe <acquire>
  while(1){
    if(log.committing){
    8000382e:	00035497          	auipc	s1,0x35
    80003832:	46a48493          	add	s1,s1,1130 # 80038c98 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003836:	4979                	li	s2,30
    80003838:	a039                	j	80003846 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000383a:	85a6                	mv	a1,s1
    8000383c:	8526                	mv	a0,s1
    8000383e:	ffffe097          	auipc	ra,0xffffe
    80003842:	ea2080e7          	jalr	-350(ra) # 800016e0 <sleep>
    if(log.committing){
    80003846:	50dc                	lw	a5,36(s1)
    80003848:	fbed                	bnez	a5,8000383a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000384a:	5098                	lw	a4,32(s1)
    8000384c:	2705                	addw	a4,a4,1
    8000384e:	0027179b          	sllw	a5,a4,0x2
    80003852:	9fb9                	addw	a5,a5,a4
    80003854:	0017979b          	sllw	a5,a5,0x1
    80003858:	54d4                	lw	a3,44(s1)
    8000385a:	9fb5                	addw	a5,a5,a3
    8000385c:	00f95963          	bge	s2,a5,8000386e <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    80003860:	85a6                	mv	a1,s1
    80003862:	8526                	mv	a0,s1
    80003864:	ffffe097          	auipc	ra,0xffffe
    80003868:	e7c080e7          	jalr	-388(ra) # 800016e0 <sleep>
    8000386c:	bfe9                	j	80003846 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000386e:	00035517          	auipc	a0,0x35
    80003872:	42a50513          	add	a0,a0,1066 # 80038c98 <log>
    80003876:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	c3a080e7          	jalr	-966(ra) # 800064b2 <release>
      break;
    }
  }
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	add	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    8000388c:	7139                	add	sp,sp,-64
    8000388e:	fc06                	sd	ra,56(sp)
    80003890:	f822                	sd	s0,48(sp)
    80003892:	f426                	sd	s1,40(sp)
    80003894:	f04a                	sd	s2,32(sp)
    80003896:	ec4e                	sd	s3,24(sp)
    80003898:	e852                	sd	s4,16(sp)
    8000389a:	e456                	sd	s5,8(sp)
    8000389c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000389e:	00035497          	auipc	s1,0x35
    800038a2:	3fa48493          	add	s1,s1,1018 # 80038c98 <log>
    800038a6:	8526                	mv	a0,s1
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	b56080e7          	jalr	-1194(ra) # 800063fe <acquire>
  log.outstanding -= 1;
    800038b0:	509c                	lw	a5,32(s1)
    800038b2:	37fd                	addw	a5,a5,-1
    800038b4:	0007891b          	sext.w	s2,a5
    800038b8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800038ba:	50dc                	lw	a5,36(s1)
    800038bc:	e7b9                	bnez	a5,8000390a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800038be:	04091e63          	bnez	s2,8000391a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038c2:	00035497          	auipc	s1,0x35
    800038c6:	3d648493          	add	s1,s1,982 # 80038c98 <log>
    800038ca:	4785                	li	a5,1
    800038cc:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    800038ce:	8526                	mv	a0,s1
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	be2080e7          	jalr	-1054(ra) # 800064b2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038d8:	54dc                	lw	a5,44(s1)
    800038da:	06f04763          	bgtz	a5,80003948 <end_op+0xbc>
    acquire(&log.lock);
    800038de:	00035497          	auipc	s1,0x35
    800038e2:	3ba48493          	add	s1,s1,954 # 80038c98 <log>
    800038e6:	8526                	mv	a0,s1
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	b16080e7          	jalr	-1258(ra) # 800063fe <acquire>
    log.committing = 0;
    800038f0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038f4:	8526                	mv	a0,s1
    800038f6:	ffffe097          	auipc	ra,0xffffe
    800038fa:	e4e080e7          	jalr	-434(ra) # 80001744 <wakeup>
    release(&log.lock);
    800038fe:	8526                	mv	a0,s1
    80003900:	00003097          	auipc	ra,0x3
    80003904:	bb2080e7          	jalr	-1102(ra) # 800064b2 <release>
}
    80003908:	a03d                	j	80003936 <end_op+0xaa>
    panic("log.committing");
    8000390a:	00005517          	auipc	a0,0x5
    8000390e:	dd650513          	add	a0,a0,-554 # 800086e0 <syscalls+0x1f0>
    80003912:	00002097          	auipc	ra,0x2
    80003916:	5b4080e7          	jalr	1460(ra) # 80005ec6 <panic>
    wakeup(&log);
    8000391a:	00035497          	auipc	s1,0x35
    8000391e:	37e48493          	add	s1,s1,894 # 80038c98 <log>
    80003922:	8526                	mv	a0,s1
    80003924:	ffffe097          	auipc	ra,0xffffe
    80003928:	e20080e7          	jalr	-480(ra) # 80001744 <wakeup>
  release(&log.lock);
    8000392c:	8526                	mv	a0,s1
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	b84080e7          	jalr	-1148(ra) # 800064b2 <release>
}
    80003936:	70e2                	ld	ra,56(sp)
    80003938:	7442                	ld	s0,48(sp)
    8000393a:	74a2                	ld	s1,40(sp)
    8000393c:	7902                	ld	s2,32(sp)
    8000393e:	69e2                	ld	s3,24(sp)
    80003940:	6a42                	ld	s4,16(sp)
    80003942:	6aa2                	ld	s5,8(sp)
    80003944:	6121                	add	sp,sp,64
    80003946:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003948:	00035a97          	auipc	s5,0x35
    8000394c:	380a8a93          	add	s5,s5,896 # 80038cc8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    80003950:	00035a17          	auipc	s4,0x35
    80003954:	348a0a13          	add	s4,s4,840 # 80038c98 <log>
    80003958:	018a2583          	lw	a1,24(s4)
    8000395c:	012585bb          	addw	a1,a1,s2
    80003960:	2585                	addw	a1,a1,1
    80003962:	028a2503          	lw	a0,40(s4)
    80003966:	fffff097          	auipc	ra,0xfffff
    8000396a:	cf6080e7          	jalr	-778(ra) # 8000265c <bread>
    8000396e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    80003970:	000aa583          	lw	a1,0(s5)
    80003974:	028a2503          	lw	a0,40(s4)
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	ce4080e7          	jalr	-796(ra) # 8000265c <bread>
    80003980:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003982:	40000613          	li	a2,1024
    80003986:	05850593          	add	a1,a0,88
    8000398a:	05848513          	add	a0,s1,88
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	9d6080e7          	jalr	-1578(ra) # 80000364 <memmove>
    bwrite(to);  /* write the log */
    80003996:	8526                	mv	a0,s1
    80003998:	fffff097          	auipc	ra,0xfffff
    8000399c:	db6080e7          	jalr	-586(ra) # 8000274e <bwrite>
    brelse(from);
    800039a0:	854e                	mv	a0,s3
    800039a2:	fffff097          	auipc	ra,0xfffff
    800039a6:	dea080e7          	jalr	-534(ra) # 8000278c <brelse>
    brelse(to);
    800039aa:	8526                	mv	a0,s1
    800039ac:	fffff097          	auipc	ra,0xfffff
    800039b0:	de0080e7          	jalr	-544(ra) # 8000278c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039b4:	2905                	addw	s2,s2,1
    800039b6:	0a91                	add	s5,s5,4
    800039b8:	02ca2783          	lw	a5,44(s4)
    800039bc:	f8f94ee3          	blt	s2,a5,80003958 <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	c8c080e7          	jalr	-884(ra) # 8000364c <write_head>
    install_trans(0); /* Now install writes to home locations */
    800039c8:	4501                	li	a0,0
    800039ca:	00000097          	auipc	ra,0x0
    800039ce:	cec080e7          	jalr	-788(ra) # 800036b6 <install_trans>
    log.lh.n = 0;
    800039d2:	00035797          	auipc	a5,0x35
    800039d6:	2e07a923          	sw	zero,754(a5) # 80038cc4 <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    800039da:	00000097          	auipc	ra,0x0
    800039de:	c72080e7          	jalr	-910(ra) # 8000364c <write_head>
    800039e2:	bdf5                	j	800038de <end_op+0x52>

00000000800039e4 <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    800039e4:	1101                	add	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	e04a                	sd	s2,0(sp)
    800039ee:	1000                	add	s0,sp,32
    800039f0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039f2:	00035917          	auipc	s2,0x35
    800039f6:	2a690913          	add	s2,s2,678 # 80038c98 <log>
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	a02080e7          	jalr	-1534(ra) # 800063fe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a04:	02c92603          	lw	a2,44(s2)
    80003a08:	47f5                	li	a5,29
    80003a0a:	06c7c563          	blt	a5,a2,80003a74 <log_write+0x90>
    80003a0e:	00035797          	auipc	a5,0x35
    80003a12:	2a67a783          	lw	a5,678(a5) # 80038cb4 <log+0x1c>
    80003a16:	37fd                	addw	a5,a5,-1
    80003a18:	04f65e63          	bge	a2,a5,80003a74 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a1c:	00035797          	auipc	a5,0x35
    80003a20:	29c7a783          	lw	a5,668(a5) # 80038cb8 <log+0x20>
    80003a24:	06f05063          	blez	a5,80003a84 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a28:	4781                	li	a5,0
    80003a2a:	06c05563          	blez	a2,80003a94 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003a2e:	44cc                	lw	a1,12(s1)
    80003a30:	00035717          	auipc	a4,0x35
    80003a34:	29870713          	add	a4,a4,664 # 80038cc8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a38:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003a3a:	4314                	lw	a3,0(a4)
    80003a3c:	04b68c63          	beq	a3,a1,80003a94 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a40:	2785                	addw	a5,a5,1
    80003a42:	0711                	add	a4,a4,4
    80003a44:	fef61be3          	bne	a2,a5,80003a3a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a48:	0621                	add	a2,a2,8
    80003a4a:	060a                	sll	a2,a2,0x2
    80003a4c:	00035797          	auipc	a5,0x35
    80003a50:	24c78793          	add	a5,a5,588 # 80038c98 <log>
    80003a54:	97b2                	add	a5,a5,a2
    80003a56:	44d8                	lw	a4,12(s1)
    80003a58:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	dcc080e7          	jalr	-564(ra) # 80002828 <bpin>
    log.lh.n++;
    80003a64:	00035717          	auipc	a4,0x35
    80003a68:	23470713          	add	a4,a4,564 # 80038c98 <log>
    80003a6c:	575c                	lw	a5,44(a4)
    80003a6e:	2785                	addw	a5,a5,1
    80003a70:	d75c                	sw	a5,44(a4)
    80003a72:	a82d                	j	80003aac <log_write+0xc8>
    panic("too big a transaction");
    80003a74:	00005517          	auipc	a0,0x5
    80003a78:	c7c50513          	add	a0,a0,-900 # 800086f0 <syscalls+0x200>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	44a080e7          	jalr	1098(ra) # 80005ec6 <panic>
    panic("log_write outside of trans");
    80003a84:	00005517          	auipc	a0,0x5
    80003a88:	c8450513          	add	a0,a0,-892 # 80008708 <syscalls+0x218>
    80003a8c:	00002097          	auipc	ra,0x2
    80003a90:	43a080e7          	jalr	1082(ra) # 80005ec6 <panic>
  log.lh.block[i] = b->blockno;
    80003a94:	00878693          	add	a3,a5,8
    80003a98:	068a                	sll	a3,a3,0x2
    80003a9a:	00035717          	auipc	a4,0x35
    80003a9e:	1fe70713          	add	a4,a4,510 # 80038c98 <log>
    80003aa2:	9736                	add	a4,a4,a3
    80003aa4:	44d4                	lw	a3,12(s1)
    80003aa6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    80003aa8:	faf609e3          	beq	a2,a5,80003a5a <log_write+0x76>
  }
  release(&log.lock);
    80003aac:	00035517          	auipc	a0,0x35
    80003ab0:	1ec50513          	add	a0,a0,492 # 80038c98 <log>
    80003ab4:	00003097          	auipc	ra,0x3
    80003ab8:	9fe080e7          	jalr	-1538(ra) # 800064b2 <release>
}
    80003abc:	60e2                	ld	ra,24(sp)
    80003abe:	6442                	ld	s0,16(sp)
    80003ac0:	64a2                	ld	s1,8(sp)
    80003ac2:	6902                	ld	s2,0(sp)
    80003ac4:	6105                	add	sp,sp,32
    80003ac6:	8082                	ret

0000000080003ac8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ac8:	1101                	add	sp,sp,-32
    80003aca:	ec06                	sd	ra,24(sp)
    80003acc:	e822                	sd	s0,16(sp)
    80003ace:	e426                	sd	s1,8(sp)
    80003ad0:	e04a                	sd	s2,0(sp)
    80003ad2:	1000                	add	s0,sp,32
    80003ad4:	84aa                	mv	s1,a0
    80003ad6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ad8:	00005597          	auipc	a1,0x5
    80003adc:	c5058593          	add	a1,a1,-944 # 80008728 <syscalls+0x238>
    80003ae0:	0521                	add	a0,a0,8
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	88c080e7          	jalr	-1908(ra) # 8000636e <initlock>
  lk->name = name;
    80003aea:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003aee:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003af2:	0204a423          	sw	zero,40(s1)
}
    80003af6:	60e2                	ld	ra,24(sp)
    80003af8:	6442                	ld	s0,16(sp)
    80003afa:	64a2                	ld	s1,8(sp)
    80003afc:	6902                	ld	s2,0(sp)
    80003afe:	6105                	add	sp,sp,32
    80003b00:	8082                	ret

0000000080003b02 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b02:	1101                	add	sp,sp,-32
    80003b04:	ec06                	sd	ra,24(sp)
    80003b06:	e822                	sd	s0,16(sp)
    80003b08:	e426                	sd	s1,8(sp)
    80003b0a:	e04a                	sd	s2,0(sp)
    80003b0c:	1000                	add	s0,sp,32
    80003b0e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b10:	00850913          	add	s2,a0,8
    80003b14:	854a                	mv	a0,s2
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	8e8080e7          	jalr	-1816(ra) # 800063fe <acquire>
  while (lk->locked) {
    80003b1e:	409c                	lw	a5,0(s1)
    80003b20:	cb89                	beqz	a5,80003b32 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b22:	85ca                	mv	a1,s2
    80003b24:	8526                	mv	a0,s1
    80003b26:	ffffe097          	auipc	ra,0xffffe
    80003b2a:	bba080e7          	jalr	-1094(ra) # 800016e0 <sleep>
  while (lk->locked) {
    80003b2e:	409c                	lw	a5,0(s1)
    80003b30:	fbed                	bnez	a5,80003b22 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b32:	4785                	li	a5,1
    80003b34:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b36:	ffffd097          	auipc	ra,0xffffd
    80003b3a:	4f6080e7          	jalr	1270(ra) # 8000102c <myproc>
    80003b3e:	591c                	lw	a5,48(a0)
    80003b40:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b42:	854a                	mv	a0,s2
    80003b44:	00003097          	auipc	ra,0x3
    80003b48:	96e080e7          	jalr	-1682(ra) # 800064b2 <release>
}
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	64a2                	ld	s1,8(sp)
    80003b52:	6902                	ld	s2,0(sp)
    80003b54:	6105                	add	sp,sp,32
    80003b56:	8082                	ret

0000000080003b58 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b58:	1101                	add	sp,sp,-32
    80003b5a:	ec06                	sd	ra,24(sp)
    80003b5c:	e822                	sd	s0,16(sp)
    80003b5e:	e426                	sd	s1,8(sp)
    80003b60:	e04a                	sd	s2,0(sp)
    80003b62:	1000                	add	s0,sp,32
    80003b64:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b66:	00850913          	add	s2,a0,8
    80003b6a:	854a                	mv	a0,s2
    80003b6c:	00003097          	auipc	ra,0x3
    80003b70:	892080e7          	jalr	-1902(ra) # 800063fe <acquire>
  lk->locked = 0;
    80003b74:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b78:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b7c:	8526                	mv	a0,s1
    80003b7e:	ffffe097          	auipc	ra,0xffffe
    80003b82:	bc6080e7          	jalr	-1082(ra) # 80001744 <wakeup>
  release(&lk->lk);
    80003b86:	854a                	mv	a0,s2
    80003b88:	00003097          	auipc	ra,0x3
    80003b8c:	92a080e7          	jalr	-1750(ra) # 800064b2 <release>
}
    80003b90:	60e2                	ld	ra,24(sp)
    80003b92:	6442                	ld	s0,16(sp)
    80003b94:	64a2                	ld	s1,8(sp)
    80003b96:	6902                	ld	s2,0(sp)
    80003b98:	6105                	add	sp,sp,32
    80003b9a:	8082                	ret

0000000080003b9c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b9c:	7179                	add	sp,sp,-48
    80003b9e:	f406                	sd	ra,40(sp)
    80003ba0:	f022                	sd	s0,32(sp)
    80003ba2:	ec26                	sd	s1,24(sp)
    80003ba4:	e84a                	sd	s2,16(sp)
    80003ba6:	e44e                	sd	s3,8(sp)
    80003ba8:	1800                	add	s0,sp,48
    80003baa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bac:	00850913          	add	s2,a0,8
    80003bb0:	854a                	mv	a0,s2
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	84c080e7          	jalr	-1972(ra) # 800063fe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bba:	409c                	lw	a5,0(s1)
    80003bbc:	ef99                	bnez	a5,80003bda <holdingsleep+0x3e>
    80003bbe:	4481                	li	s1,0
  release(&lk->lk);
    80003bc0:	854a                	mv	a0,s2
    80003bc2:	00003097          	auipc	ra,0x3
    80003bc6:	8f0080e7          	jalr	-1808(ra) # 800064b2 <release>
  return r;
}
    80003bca:	8526                	mv	a0,s1
    80003bcc:	70a2                	ld	ra,40(sp)
    80003bce:	7402                	ld	s0,32(sp)
    80003bd0:	64e2                	ld	s1,24(sp)
    80003bd2:	6942                	ld	s2,16(sp)
    80003bd4:	69a2                	ld	s3,8(sp)
    80003bd6:	6145                	add	sp,sp,48
    80003bd8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bda:	0284a983          	lw	s3,40(s1)
    80003bde:	ffffd097          	auipc	ra,0xffffd
    80003be2:	44e080e7          	jalr	1102(ra) # 8000102c <myproc>
    80003be6:	5904                	lw	s1,48(a0)
    80003be8:	413484b3          	sub	s1,s1,s3
    80003bec:	0014b493          	seqz	s1,s1
    80003bf0:	bfc1                	j	80003bc0 <holdingsleep+0x24>

0000000080003bf2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bf2:	1141                	add	sp,sp,-16
    80003bf4:	e406                	sd	ra,8(sp)
    80003bf6:	e022                	sd	s0,0(sp)
    80003bf8:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bfa:	00005597          	auipc	a1,0x5
    80003bfe:	b3e58593          	add	a1,a1,-1218 # 80008738 <syscalls+0x248>
    80003c02:	00035517          	auipc	a0,0x35
    80003c06:	1de50513          	add	a0,a0,478 # 80038de0 <ftable>
    80003c0a:	00002097          	auipc	ra,0x2
    80003c0e:	764080e7          	jalr	1892(ra) # 8000636e <initlock>
}
    80003c12:	60a2                	ld	ra,8(sp)
    80003c14:	6402                	ld	s0,0(sp)
    80003c16:	0141                	add	sp,sp,16
    80003c18:	8082                	ret

0000000080003c1a <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80003c1a:	1101                	add	sp,sp,-32
    80003c1c:	ec06                	sd	ra,24(sp)
    80003c1e:	e822                	sd	s0,16(sp)
    80003c20:	e426                	sd	s1,8(sp)
    80003c22:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c24:	00035517          	auipc	a0,0x35
    80003c28:	1bc50513          	add	a0,a0,444 # 80038de0 <ftable>
    80003c2c:	00002097          	auipc	ra,0x2
    80003c30:	7d2080e7          	jalr	2002(ra) # 800063fe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c34:	00035497          	auipc	s1,0x35
    80003c38:	1c448493          	add	s1,s1,452 # 80038df8 <ftable+0x18>
    80003c3c:	00036717          	auipc	a4,0x36
    80003c40:	15c70713          	add	a4,a4,348 # 80039d98 <disk>
    if(f->ref == 0){
    80003c44:	40dc                	lw	a5,4(s1)
    80003c46:	cf99                	beqz	a5,80003c64 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c48:	02848493          	add	s1,s1,40
    80003c4c:	fee49ce3          	bne	s1,a4,80003c44 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c50:	00035517          	auipc	a0,0x35
    80003c54:	19050513          	add	a0,a0,400 # 80038de0 <ftable>
    80003c58:	00003097          	auipc	ra,0x3
    80003c5c:	85a080e7          	jalr	-1958(ra) # 800064b2 <release>
  return 0;
    80003c60:	4481                	li	s1,0
    80003c62:	a819                	j	80003c78 <filealloc+0x5e>
      f->ref = 1;
    80003c64:	4785                	li	a5,1
    80003c66:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c68:	00035517          	auipc	a0,0x35
    80003c6c:	17850513          	add	a0,a0,376 # 80038de0 <ftable>
    80003c70:	00003097          	auipc	ra,0x3
    80003c74:	842080e7          	jalr	-1982(ra) # 800064b2 <release>
}
    80003c78:	8526                	mv	a0,s1
    80003c7a:	60e2                	ld	ra,24(sp)
    80003c7c:	6442                	ld	s0,16(sp)
    80003c7e:	64a2                	ld	s1,8(sp)
    80003c80:	6105                	add	sp,sp,32
    80003c82:	8082                	ret

0000000080003c84 <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    80003c84:	1101                	add	sp,sp,-32
    80003c86:	ec06                	sd	ra,24(sp)
    80003c88:	e822                	sd	s0,16(sp)
    80003c8a:	e426                	sd	s1,8(sp)
    80003c8c:	1000                	add	s0,sp,32
    80003c8e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c90:	00035517          	auipc	a0,0x35
    80003c94:	15050513          	add	a0,a0,336 # 80038de0 <ftable>
    80003c98:	00002097          	auipc	ra,0x2
    80003c9c:	766080e7          	jalr	1894(ra) # 800063fe <acquire>
  if(f->ref < 1)
    80003ca0:	40dc                	lw	a5,4(s1)
    80003ca2:	02f05263          	blez	a5,80003cc6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ca6:	2785                	addw	a5,a5,1
    80003ca8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003caa:	00035517          	auipc	a0,0x35
    80003cae:	13650513          	add	a0,a0,310 # 80038de0 <ftable>
    80003cb2:	00003097          	auipc	ra,0x3
    80003cb6:	800080e7          	jalr	-2048(ra) # 800064b2 <release>
  return f;
}
    80003cba:	8526                	mv	a0,s1
    80003cbc:	60e2                	ld	ra,24(sp)
    80003cbe:	6442                	ld	s0,16(sp)
    80003cc0:	64a2                	ld	s1,8(sp)
    80003cc2:	6105                	add	sp,sp,32
    80003cc4:	8082                	ret
    panic("filedup");
    80003cc6:	00005517          	auipc	a0,0x5
    80003cca:	a7a50513          	add	a0,a0,-1414 # 80008740 <syscalls+0x250>
    80003cce:	00002097          	auipc	ra,0x2
    80003cd2:	1f8080e7          	jalr	504(ra) # 80005ec6 <panic>

0000000080003cd6 <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80003cd6:	7139                	add	sp,sp,-64
    80003cd8:	fc06                	sd	ra,56(sp)
    80003cda:	f822                	sd	s0,48(sp)
    80003cdc:	f426                	sd	s1,40(sp)
    80003cde:	f04a                	sd	s2,32(sp)
    80003ce0:	ec4e                	sd	s3,24(sp)
    80003ce2:	e852                	sd	s4,16(sp)
    80003ce4:	e456                	sd	s5,8(sp)
    80003ce6:	0080                	add	s0,sp,64
    80003ce8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cea:	00035517          	auipc	a0,0x35
    80003cee:	0f650513          	add	a0,a0,246 # 80038de0 <ftable>
    80003cf2:	00002097          	auipc	ra,0x2
    80003cf6:	70c080e7          	jalr	1804(ra) # 800063fe <acquire>
  if(f->ref < 1)
    80003cfa:	40dc                	lw	a5,4(s1)
    80003cfc:	06f05163          	blez	a5,80003d5e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003d00:	37fd                	addw	a5,a5,-1
    80003d02:	0007871b          	sext.w	a4,a5
    80003d06:	c0dc                	sw	a5,4(s1)
    80003d08:	06e04363          	bgtz	a4,80003d6e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d0c:	0004a903          	lw	s2,0(s1)
    80003d10:	0094ca83          	lbu	s5,9(s1)
    80003d14:	0104ba03          	ld	s4,16(s1)
    80003d18:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d1c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d20:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d24:	00035517          	auipc	a0,0x35
    80003d28:	0bc50513          	add	a0,a0,188 # 80038de0 <ftable>
    80003d2c:	00002097          	auipc	ra,0x2
    80003d30:	786080e7          	jalr	1926(ra) # 800064b2 <release>

  if(ff.type == FD_PIPE){
    80003d34:	4785                	li	a5,1
    80003d36:	04f90d63          	beq	s2,a5,80003d90 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d3a:	3979                	addw	s2,s2,-2
    80003d3c:	4785                	li	a5,1
    80003d3e:	0527e063          	bltu	a5,s2,80003d7e <fileclose+0xa8>
    begin_op();
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	ad0080e7          	jalr	-1328(ra) # 80003812 <begin_op>
    iput(ff.ip);
    80003d4a:	854e                	mv	a0,s3
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	2da080e7          	jalr	730(ra) # 80003026 <iput>
    end_op();
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	b38080e7          	jalr	-1224(ra) # 8000388c <end_op>
    80003d5c:	a00d                	j	80003d7e <fileclose+0xa8>
    panic("fileclose");
    80003d5e:	00005517          	auipc	a0,0x5
    80003d62:	9ea50513          	add	a0,a0,-1558 # 80008748 <syscalls+0x258>
    80003d66:	00002097          	auipc	ra,0x2
    80003d6a:	160080e7          	jalr	352(ra) # 80005ec6 <panic>
    release(&ftable.lock);
    80003d6e:	00035517          	auipc	a0,0x35
    80003d72:	07250513          	add	a0,a0,114 # 80038de0 <ftable>
    80003d76:	00002097          	auipc	ra,0x2
    80003d7a:	73c080e7          	jalr	1852(ra) # 800064b2 <release>
  }
}
    80003d7e:	70e2                	ld	ra,56(sp)
    80003d80:	7442                	ld	s0,48(sp)
    80003d82:	74a2                	ld	s1,40(sp)
    80003d84:	7902                	ld	s2,32(sp)
    80003d86:	69e2                	ld	s3,24(sp)
    80003d88:	6a42                	ld	s4,16(sp)
    80003d8a:	6aa2                	ld	s5,8(sp)
    80003d8c:	6121                	add	sp,sp,64
    80003d8e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d90:	85d6                	mv	a1,s5
    80003d92:	8552                	mv	a0,s4
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	348080e7          	jalr	840(ra) # 800040dc <pipeclose>
    80003d9c:	b7cd                	j	80003d7e <fileclose+0xa8>

0000000080003d9e <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80003d9e:	715d                	add	sp,sp,-80
    80003da0:	e486                	sd	ra,72(sp)
    80003da2:	e0a2                	sd	s0,64(sp)
    80003da4:	fc26                	sd	s1,56(sp)
    80003da6:	f84a                	sd	s2,48(sp)
    80003da8:	f44e                	sd	s3,40(sp)
    80003daa:	0880                	add	s0,sp,80
    80003dac:	84aa                	mv	s1,a0
    80003dae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003db0:	ffffd097          	auipc	ra,0xffffd
    80003db4:	27c080e7          	jalr	636(ra) # 8000102c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003db8:	409c                	lw	a5,0(s1)
    80003dba:	37f9                	addw	a5,a5,-2
    80003dbc:	4705                	li	a4,1
    80003dbe:	04f76763          	bltu	a4,a5,80003e0c <filestat+0x6e>
    80003dc2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003dc4:	6c88                	ld	a0,24(s1)
    80003dc6:	fffff097          	auipc	ra,0xfffff
    80003dca:	0a6080e7          	jalr	166(ra) # 80002e6c <ilock>
    stati(f->ip, &st);
    80003dce:	fb840593          	add	a1,s0,-72
    80003dd2:	6c88                	ld	a0,24(s1)
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	322080e7          	jalr	802(ra) # 800030f6 <stati>
    iunlock(f->ip);
    80003ddc:	6c88                	ld	a0,24(s1)
    80003dde:	fffff097          	auipc	ra,0xfffff
    80003de2:	150080e7          	jalr	336(ra) # 80002f2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003de6:	46e1                	li	a3,24
    80003de8:	fb840613          	add	a2,s0,-72
    80003dec:	85ce                	mv	a1,s3
    80003dee:	05093503          	ld	a0,80(s2)
    80003df2:	ffffd097          	auipc	ra,0xffffd
    80003df6:	ec6080e7          	jalr	-314(ra) # 80000cb8 <copyout>
    80003dfa:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003dfe:	60a6                	ld	ra,72(sp)
    80003e00:	6406                	ld	s0,64(sp)
    80003e02:	74e2                	ld	s1,56(sp)
    80003e04:	7942                	ld	s2,48(sp)
    80003e06:	79a2                	ld	s3,40(sp)
    80003e08:	6161                	add	sp,sp,80
    80003e0a:	8082                	ret
  return -1;
    80003e0c:	557d                	li	a0,-1
    80003e0e:	bfc5                	j	80003dfe <filestat+0x60>

0000000080003e10 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e10:	7179                	add	sp,sp,-48
    80003e12:	f406                	sd	ra,40(sp)
    80003e14:	f022                	sd	s0,32(sp)
    80003e16:	ec26                	sd	s1,24(sp)
    80003e18:	e84a                	sd	s2,16(sp)
    80003e1a:	e44e                	sd	s3,8(sp)
    80003e1c:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e1e:	00854783          	lbu	a5,8(a0)
    80003e22:	c3d5                	beqz	a5,80003ec6 <fileread+0xb6>
    80003e24:	84aa                	mv	s1,a0
    80003e26:	89ae                	mv	s3,a1
    80003e28:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e2a:	411c                	lw	a5,0(a0)
    80003e2c:	4705                	li	a4,1
    80003e2e:	04e78963          	beq	a5,a4,80003e80 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e32:	470d                	li	a4,3
    80003e34:	04e78d63          	beq	a5,a4,80003e8e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e38:	4709                	li	a4,2
    80003e3a:	06e79e63          	bne	a5,a4,80003eb6 <fileread+0xa6>
    ilock(f->ip);
    80003e3e:	6d08                	ld	a0,24(a0)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	02c080e7          	jalr	44(ra) # 80002e6c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e48:	874a                	mv	a4,s2
    80003e4a:	5094                	lw	a3,32(s1)
    80003e4c:	864e                	mv	a2,s3
    80003e4e:	4585                	li	a1,1
    80003e50:	6c88                	ld	a0,24(s1)
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	2ce080e7          	jalr	718(ra) # 80003120 <readi>
    80003e5a:	892a                	mv	s2,a0
    80003e5c:	00a05563          	blez	a0,80003e66 <fileread+0x56>
      f->off += r;
    80003e60:	509c                	lw	a5,32(s1)
    80003e62:	9fa9                	addw	a5,a5,a0
    80003e64:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e66:	6c88                	ld	a0,24(s1)
    80003e68:	fffff097          	auipc	ra,0xfffff
    80003e6c:	0c6080e7          	jalr	198(ra) # 80002f2e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e70:	854a                	mv	a0,s2
    80003e72:	70a2                	ld	ra,40(sp)
    80003e74:	7402                	ld	s0,32(sp)
    80003e76:	64e2                	ld	s1,24(sp)
    80003e78:	6942                	ld	s2,16(sp)
    80003e7a:	69a2                	ld	s3,8(sp)
    80003e7c:	6145                	add	sp,sp,48
    80003e7e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e80:	6908                	ld	a0,16(a0)
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	3c2080e7          	jalr	962(ra) # 80004244 <piperead>
    80003e8a:	892a                	mv	s2,a0
    80003e8c:	b7d5                	j	80003e70 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e8e:	02451783          	lh	a5,36(a0)
    80003e92:	03079693          	sll	a3,a5,0x30
    80003e96:	92c1                	srl	a3,a3,0x30
    80003e98:	4725                	li	a4,9
    80003e9a:	02d76863          	bltu	a4,a3,80003eca <fileread+0xba>
    80003e9e:	0792                	sll	a5,a5,0x4
    80003ea0:	00035717          	auipc	a4,0x35
    80003ea4:	ea070713          	add	a4,a4,-352 # 80038d40 <devsw>
    80003ea8:	97ba                	add	a5,a5,a4
    80003eaa:	639c                	ld	a5,0(a5)
    80003eac:	c38d                	beqz	a5,80003ece <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003eae:	4505                	li	a0,1
    80003eb0:	9782                	jalr	a5
    80003eb2:	892a                	mv	s2,a0
    80003eb4:	bf75                	j	80003e70 <fileread+0x60>
    panic("fileread");
    80003eb6:	00005517          	auipc	a0,0x5
    80003eba:	8a250513          	add	a0,a0,-1886 # 80008758 <syscalls+0x268>
    80003ebe:	00002097          	auipc	ra,0x2
    80003ec2:	008080e7          	jalr	8(ra) # 80005ec6 <panic>
    return -1;
    80003ec6:	597d                	li	s2,-1
    80003ec8:	b765                	j	80003e70 <fileread+0x60>
      return -1;
    80003eca:	597d                	li	s2,-1
    80003ecc:	b755                	j	80003e70 <fileread+0x60>
    80003ece:	597d                	li	s2,-1
    80003ed0:	b745                	j	80003e70 <fileread+0x60>

0000000080003ed2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ed2:	00954783          	lbu	a5,9(a0)
    80003ed6:	10078e63          	beqz	a5,80003ff2 <filewrite+0x120>
{
    80003eda:	715d                	add	sp,sp,-80
    80003edc:	e486                	sd	ra,72(sp)
    80003ede:	e0a2                	sd	s0,64(sp)
    80003ee0:	fc26                	sd	s1,56(sp)
    80003ee2:	f84a                	sd	s2,48(sp)
    80003ee4:	f44e                	sd	s3,40(sp)
    80003ee6:	f052                	sd	s4,32(sp)
    80003ee8:	ec56                	sd	s5,24(sp)
    80003eea:	e85a                	sd	s6,16(sp)
    80003eec:	e45e                	sd	s7,8(sp)
    80003eee:	e062                	sd	s8,0(sp)
    80003ef0:	0880                	add	s0,sp,80
    80003ef2:	892a                	mv	s2,a0
    80003ef4:	8b2e                	mv	s6,a1
    80003ef6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ef8:	411c                	lw	a5,0(a0)
    80003efa:	4705                	li	a4,1
    80003efc:	02e78263          	beq	a5,a4,80003f20 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f00:	470d                	li	a4,3
    80003f02:	02e78563          	beq	a5,a4,80003f2c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f06:	4709                	li	a4,2
    80003f08:	0ce79d63          	bne	a5,a4,80003fe2 <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f0c:	0ac05b63          	blez	a2,80003fc2 <filewrite+0xf0>
    int i = 0;
    80003f10:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f12:	6b85                	lui	s7,0x1
    80003f14:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f18:	6c05                	lui	s8,0x1
    80003f1a:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f1e:	a851                	j	80003fb2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f20:	6908                	ld	a0,16(a0)
    80003f22:	00000097          	auipc	ra,0x0
    80003f26:	22a080e7          	jalr	554(ra) # 8000414c <pipewrite>
    80003f2a:	a045                	j	80003fca <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f2c:	02451783          	lh	a5,36(a0)
    80003f30:	03079693          	sll	a3,a5,0x30
    80003f34:	92c1                	srl	a3,a3,0x30
    80003f36:	4725                	li	a4,9
    80003f38:	0ad76f63          	bltu	a4,a3,80003ff6 <filewrite+0x124>
    80003f3c:	0792                	sll	a5,a5,0x4
    80003f3e:	00035717          	auipc	a4,0x35
    80003f42:	e0270713          	add	a4,a4,-510 # 80038d40 <devsw>
    80003f46:	97ba                	add	a5,a5,a4
    80003f48:	679c                	ld	a5,8(a5)
    80003f4a:	cbc5                	beqz	a5,80003ffa <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003f4c:	4505                	li	a0,1
    80003f4e:	9782                	jalr	a5
    80003f50:	a8ad                	j	80003fca <filewrite+0xf8>
      if(n1 > max)
    80003f52:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	8bc080e7          	jalr	-1860(ra) # 80003812 <begin_op>
      ilock(f->ip);
    80003f5e:	01893503          	ld	a0,24(s2)
    80003f62:	fffff097          	auipc	ra,0xfffff
    80003f66:	f0a080e7          	jalr	-246(ra) # 80002e6c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f6a:	8756                	mv	a4,s5
    80003f6c:	02092683          	lw	a3,32(s2)
    80003f70:	01698633          	add	a2,s3,s6
    80003f74:	4585                	li	a1,1
    80003f76:	01893503          	ld	a0,24(s2)
    80003f7a:	fffff097          	auipc	ra,0xfffff
    80003f7e:	29e080e7          	jalr	670(ra) # 80003218 <writei>
    80003f82:	84aa                	mv	s1,a0
    80003f84:	00a05763          	blez	a0,80003f92 <filewrite+0xc0>
        f->off += r;
    80003f88:	02092783          	lw	a5,32(s2)
    80003f8c:	9fa9                	addw	a5,a5,a0
    80003f8e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f92:	01893503          	ld	a0,24(s2)
    80003f96:	fffff097          	auipc	ra,0xfffff
    80003f9a:	f98080e7          	jalr	-104(ra) # 80002f2e <iunlock>
      end_op();
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	8ee080e7          	jalr	-1810(ra) # 8000388c <end_op>

      if(r != n1){
    80003fa6:	009a9f63          	bne	s5,s1,80003fc4 <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    80003faa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fae:	0149db63          	bge	s3,s4,80003fc4 <filewrite+0xf2>
      int n1 = n - i;
    80003fb2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fb6:	0004879b          	sext.w	a5,s1
    80003fba:	f8fbdce3          	bge	s7,a5,80003f52 <filewrite+0x80>
    80003fbe:	84e2                	mv	s1,s8
    80003fc0:	bf49                	j	80003f52 <filewrite+0x80>
    int i = 0;
    80003fc2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003fc4:	033a1d63          	bne	s4,s3,80003ffe <filewrite+0x12c>
    80003fc8:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003fca:	60a6                	ld	ra,72(sp)
    80003fcc:	6406                	ld	s0,64(sp)
    80003fce:	74e2                	ld	s1,56(sp)
    80003fd0:	7942                	ld	s2,48(sp)
    80003fd2:	79a2                	ld	s3,40(sp)
    80003fd4:	7a02                	ld	s4,32(sp)
    80003fd6:	6ae2                	ld	s5,24(sp)
    80003fd8:	6b42                	ld	s6,16(sp)
    80003fda:	6ba2                	ld	s7,8(sp)
    80003fdc:	6c02                	ld	s8,0(sp)
    80003fde:	6161                	add	sp,sp,80
    80003fe0:	8082                	ret
    panic("filewrite");
    80003fe2:	00004517          	auipc	a0,0x4
    80003fe6:	78650513          	add	a0,a0,1926 # 80008768 <syscalls+0x278>
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	edc080e7          	jalr	-292(ra) # 80005ec6 <panic>
    return -1;
    80003ff2:	557d                	li	a0,-1
}
    80003ff4:	8082                	ret
      return -1;
    80003ff6:	557d                	li	a0,-1
    80003ff8:	bfc9                	j	80003fca <filewrite+0xf8>
    80003ffa:	557d                	li	a0,-1
    80003ffc:	b7f9                	j	80003fca <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003ffe:	557d                	li	a0,-1
    80004000:	b7e9                	j	80003fca <filewrite+0xf8>

0000000080004002 <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004002:	7179                	add	sp,sp,-48
    80004004:	f406                	sd	ra,40(sp)
    80004006:	f022                	sd	s0,32(sp)
    80004008:	ec26                	sd	s1,24(sp)
    8000400a:	e84a                	sd	s2,16(sp)
    8000400c:	e44e                	sd	s3,8(sp)
    8000400e:	e052                	sd	s4,0(sp)
    80004010:	1800                	add	s0,sp,48
    80004012:	84aa                	mv	s1,a0
    80004014:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004016:	0005b023          	sd	zero,0(a1)
    8000401a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000401e:	00000097          	auipc	ra,0x0
    80004022:	bfc080e7          	jalr	-1028(ra) # 80003c1a <filealloc>
    80004026:	e088                	sd	a0,0(s1)
    80004028:	c551                	beqz	a0,800040b4 <pipealloc+0xb2>
    8000402a:	00000097          	auipc	ra,0x0
    8000402e:	bf0080e7          	jalr	-1040(ra) # 80003c1a <filealloc>
    80004032:	00aa3023          	sd	a0,0(s4)
    80004036:	c92d                	beqz	a0,800040a8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004038:	ffffc097          	auipc	ra,0xffffc
    8000403c:	15c080e7          	jalr	348(ra) # 80000194 <kalloc>
    80004040:	892a                	mv	s2,a0
    80004042:	c125                	beqz	a0,800040a2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004044:	4985                	li	s3,1
    80004046:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000404a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000404e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004052:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004056:	00004597          	auipc	a1,0x4
    8000405a:	3f258593          	add	a1,a1,1010 # 80008448 <states.0+0x1c0>
    8000405e:	00002097          	auipc	ra,0x2
    80004062:	310080e7          	jalr	784(ra) # 8000636e <initlock>
  (*f0)->type = FD_PIPE;
    80004066:	609c                	ld	a5,0(s1)
    80004068:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000406c:	609c                	ld	a5,0(s1)
    8000406e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004072:	609c                	ld	a5,0(s1)
    80004074:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004078:	609c                	ld	a5,0(s1)
    8000407a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000407e:	000a3783          	ld	a5,0(s4)
    80004082:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004086:	000a3783          	ld	a5,0(s4)
    8000408a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000408e:	000a3783          	ld	a5,0(s4)
    80004092:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004096:	000a3783          	ld	a5,0(s4)
    8000409a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000409e:	4501                	li	a0,0
    800040a0:	a025                	j	800040c8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040a2:	6088                	ld	a0,0(s1)
    800040a4:	e501                	bnez	a0,800040ac <pipealloc+0xaa>
    800040a6:	a039                	j	800040b4 <pipealloc+0xb2>
    800040a8:	6088                	ld	a0,0(s1)
    800040aa:	c51d                	beqz	a0,800040d8 <pipealloc+0xd6>
    fileclose(*f0);
    800040ac:	00000097          	auipc	ra,0x0
    800040b0:	c2a080e7          	jalr	-982(ra) # 80003cd6 <fileclose>
  if(*f1)
    800040b4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040b8:	557d                	li	a0,-1
  if(*f1)
    800040ba:	c799                	beqz	a5,800040c8 <pipealloc+0xc6>
    fileclose(*f1);
    800040bc:	853e                	mv	a0,a5
    800040be:	00000097          	auipc	ra,0x0
    800040c2:	c18080e7          	jalr	-1000(ra) # 80003cd6 <fileclose>
  return -1;
    800040c6:	557d                	li	a0,-1
}
    800040c8:	70a2                	ld	ra,40(sp)
    800040ca:	7402                	ld	s0,32(sp)
    800040cc:	64e2                	ld	s1,24(sp)
    800040ce:	6942                	ld	s2,16(sp)
    800040d0:	69a2                	ld	s3,8(sp)
    800040d2:	6a02                	ld	s4,0(sp)
    800040d4:	6145                	add	sp,sp,48
    800040d6:	8082                	ret
  return -1;
    800040d8:	557d                	li	a0,-1
    800040da:	b7fd                	j	800040c8 <pipealloc+0xc6>

00000000800040dc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800040dc:	1101                	add	sp,sp,-32
    800040de:	ec06                	sd	ra,24(sp)
    800040e0:	e822                	sd	s0,16(sp)
    800040e2:	e426                	sd	s1,8(sp)
    800040e4:	e04a                	sd	s2,0(sp)
    800040e6:	1000                	add	s0,sp,32
    800040e8:	84aa                	mv	s1,a0
    800040ea:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040ec:	00002097          	auipc	ra,0x2
    800040f0:	312080e7          	jalr	786(ra) # 800063fe <acquire>
  if(writable){
    800040f4:	02090d63          	beqz	s2,8000412e <pipeclose+0x52>
    pi->writeopen = 0;
    800040f8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040fc:	21848513          	add	a0,s1,536
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	644080e7          	jalr	1604(ra) # 80001744 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004108:	2204b783          	ld	a5,544(s1)
    8000410c:	eb95                	bnez	a5,80004140 <pipeclose+0x64>
    release(&pi->lock);
    8000410e:	8526                	mv	a0,s1
    80004110:	00002097          	auipc	ra,0x2
    80004114:	3a2080e7          	jalr	930(ra) # 800064b2 <release>
    kfree((char*)pi);
    80004118:	8526                	mv	a0,s1
    8000411a:	ffffc097          	auipc	ra,0xffffc
    8000411e:	f02080e7          	jalr	-254(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004122:	60e2                	ld	ra,24(sp)
    80004124:	6442                	ld	s0,16(sp)
    80004126:	64a2                	ld	s1,8(sp)
    80004128:	6902                	ld	s2,0(sp)
    8000412a:	6105                	add	sp,sp,32
    8000412c:	8082                	ret
    pi->readopen = 0;
    8000412e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004132:	21c48513          	add	a0,s1,540
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	60e080e7          	jalr	1550(ra) # 80001744 <wakeup>
    8000413e:	b7e9                	j	80004108 <pipeclose+0x2c>
    release(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	370080e7          	jalr	880(ra) # 800064b2 <release>
}
    8000414a:	bfe1                	j	80004122 <pipeclose+0x46>

000000008000414c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000414c:	711d                	add	sp,sp,-96
    8000414e:	ec86                	sd	ra,88(sp)
    80004150:	e8a2                	sd	s0,80(sp)
    80004152:	e4a6                	sd	s1,72(sp)
    80004154:	e0ca                	sd	s2,64(sp)
    80004156:	fc4e                	sd	s3,56(sp)
    80004158:	f852                	sd	s4,48(sp)
    8000415a:	f456                	sd	s5,40(sp)
    8000415c:	f05a                	sd	s6,32(sp)
    8000415e:	ec5e                	sd	s7,24(sp)
    80004160:	e862                	sd	s8,16(sp)
    80004162:	1080                	add	s0,sp,96
    80004164:	84aa                	mv	s1,a0
    80004166:	8aae                	mv	s5,a1
    80004168:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	ec2080e7          	jalr	-318(ra) # 8000102c <myproc>
    80004172:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004174:	8526                	mv	a0,s1
    80004176:	00002097          	auipc	ra,0x2
    8000417a:	288080e7          	jalr	648(ra) # 800063fe <acquire>
  while(i < n){
    8000417e:	0b405663          	blez	s4,8000422a <pipewrite+0xde>
  int i = 0;
    80004182:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004184:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004186:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000418a:	21c48b93          	add	s7,s1,540
    8000418e:	a089                	j	800041d0 <pipewrite+0x84>
      release(&pi->lock);
    80004190:	8526                	mv	a0,s1
    80004192:	00002097          	auipc	ra,0x2
    80004196:	320080e7          	jalr	800(ra) # 800064b2 <release>
      return -1;
    8000419a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000419c:	854a                	mv	a0,s2
    8000419e:	60e6                	ld	ra,88(sp)
    800041a0:	6446                	ld	s0,80(sp)
    800041a2:	64a6                	ld	s1,72(sp)
    800041a4:	6906                	ld	s2,64(sp)
    800041a6:	79e2                	ld	s3,56(sp)
    800041a8:	7a42                	ld	s4,48(sp)
    800041aa:	7aa2                	ld	s5,40(sp)
    800041ac:	7b02                	ld	s6,32(sp)
    800041ae:	6be2                	ld	s7,24(sp)
    800041b0:	6c42                	ld	s8,16(sp)
    800041b2:	6125                	add	sp,sp,96
    800041b4:	8082                	ret
      wakeup(&pi->nread);
    800041b6:	8562                	mv	a0,s8
    800041b8:	ffffd097          	auipc	ra,0xffffd
    800041bc:	58c080e7          	jalr	1420(ra) # 80001744 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041c0:	85a6                	mv	a1,s1
    800041c2:	855e                	mv	a0,s7
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	51c080e7          	jalr	1308(ra) # 800016e0 <sleep>
  while(i < n){
    800041cc:	07495063          	bge	s2,s4,8000422c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    800041d0:	2204a783          	lw	a5,544(s1)
    800041d4:	dfd5                	beqz	a5,80004190 <pipewrite+0x44>
    800041d6:	854e                	mv	a0,s3
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	7b0080e7          	jalr	1968(ra) # 80001988 <killed>
    800041e0:	f945                	bnez	a0,80004190 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    800041e2:	2184a783          	lw	a5,536(s1)
    800041e6:	21c4a703          	lw	a4,540(s1)
    800041ea:	2007879b          	addw	a5,a5,512
    800041ee:	fcf704e3          	beq	a4,a5,800041b6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041f2:	4685                	li	a3,1
    800041f4:	01590633          	add	a2,s2,s5
    800041f8:	faf40593          	add	a1,s0,-81
    800041fc:	0509b503          	ld	a0,80(s3)
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	b78080e7          	jalr	-1160(ra) # 80000d78 <copyin>
    80004208:	03650263          	beq	a0,s6,8000422c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000420c:	21c4a783          	lw	a5,540(s1)
    80004210:	0017871b          	addw	a4,a5,1
    80004214:	20e4ae23          	sw	a4,540(s1)
    80004218:	1ff7f793          	and	a5,a5,511
    8000421c:	97a6                	add	a5,a5,s1
    8000421e:	faf44703          	lbu	a4,-81(s0)
    80004222:	00e78c23          	sb	a4,24(a5)
      i++;
    80004226:	2905                	addw	s2,s2,1
    80004228:	b755                	j	800041cc <pipewrite+0x80>
  int i = 0;
    8000422a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000422c:	21848513          	add	a0,s1,536
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	514080e7          	jalr	1300(ra) # 80001744 <wakeup>
  release(&pi->lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	278080e7          	jalr	632(ra) # 800064b2 <release>
  return i;
    80004242:	bfa9                	j	8000419c <pipewrite+0x50>

0000000080004244 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004244:	715d                	add	sp,sp,-80
    80004246:	e486                	sd	ra,72(sp)
    80004248:	e0a2                	sd	s0,64(sp)
    8000424a:	fc26                	sd	s1,56(sp)
    8000424c:	f84a                	sd	s2,48(sp)
    8000424e:	f44e                	sd	s3,40(sp)
    80004250:	f052                	sd	s4,32(sp)
    80004252:	ec56                	sd	s5,24(sp)
    80004254:	e85a                	sd	s6,16(sp)
    80004256:	0880                	add	s0,sp,80
    80004258:	84aa                	mv	s1,a0
    8000425a:	892e                	mv	s2,a1
    8000425c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000425e:	ffffd097          	auipc	ra,0xffffd
    80004262:	dce080e7          	jalr	-562(ra) # 8000102c <myproc>
    80004266:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004268:	8526                	mv	a0,s1
    8000426a:	00002097          	auipc	ra,0x2
    8000426e:	194080e7          	jalr	404(ra) # 800063fe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004272:	2184a703          	lw	a4,536(s1)
    80004276:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    8000427a:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    8000427e:	02f71763          	bne	a4,a5,800042ac <piperead+0x68>
    80004282:	2244a783          	lw	a5,548(s1)
    80004286:	c39d                	beqz	a5,800042ac <piperead+0x68>
    if(killed(pr)){
    80004288:	8552                	mv	a0,s4
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	6fe080e7          	jalr	1790(ra) # 80001988 <killed>
    80004292:	e949                	bnez	a0,80004324 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004294:	85a6                	mv	a1,s1
    80004296:	854e                	mv	a0,s3
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	448080e7          	jalr	1096(ra) # 800016e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    800042a0:	2184a703          	lw	a4,536(s1)
    800042a4:	21c4a783          	lw	a5,540(s1)
    800042a8:	fcf70de3          	beq	a4,a5,80004282 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800042ac:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042ae:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800042b0:	05505463          	blez	s5,800042f8 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800042b4:	2184a783          	lw	a5,536(s1)
    800042b8:	21c4a703          	lw	a4,540(s1)
    800042bc:	02f70e63          	beq	a4,a5,800042f8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042c0:	0017871b          	addw	a4,a5,1
    800042c4:	20e4ac23          	sw	a4,536(s1)
    800042c8:	1ff7f793          	and	a5,a5,511
    800042cc:	97a6                	add	a5,a5,s1
    800042ce:	0187c783          	lbu	a5,24(a5)
    800042d2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042d6:	4685                	li	a3,1
    800042d8:	fbf40613          	add	a2,s0,-65
    800042dc:	85ca                	mv	a1,s2
    800042de:	050a3503          	ld	a0,80(s4)
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	9d6080e7          	jalr	-1578(ra) # 80000cb8 <copyout>
    800042ea:	01650763          	beq	a0,s6,800042f8 <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800042ee:	2985                	addw	s3,s3,1
    800042f0:	0905                	add	s2,s2,1
    800042f2:	fd3a91e3          	bne	s5,s3,800042b4 <piperead+0x70>
    800042f6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    800042f8:	21c48513          	add	a0,s1,540
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	448080e7          	jalr	1096(ra) # 80001744 <wakeup>
  release(&pi->lock);
    80004304:	8526                	mv	a0,s1
    80004306:	00002097          	auipc	ra,0x2
    8000430a:	1ac080e7          	jalr	428(ra) # 800064b2 <release>
  return i;
}
    8000430e:	854e                	mv	a0,s3
    80004310:	60a6                	ld	ra,72(sp)
    80004312:	6406                	ld	s0,64(sp)
    80004314:	74e2                	ld	s1,56(sp)
    80004316:	7942                	ld	s2,48(sp)
    80004318:	79a2                	ld	s3,40(sp)
    8000431a:	7a02                	ld	s4,32(sp)
    8000431c:	6ae2                	ld	s5,24(sp)
    8000431e:	6b42                	ld	s6,16(sp)
    80004320:	6161                	add	sp,sp,80
    80004322:	8082                	ret
      release(&pi->lock);
    80004324:	8526                	mv	a0,s1
    80004326:	00002097          	auipc	ra,0x2
    8000432a:	18c080e7          	jalr	396(ra) # 800064b2 <release>
      return -1;
    8000432e:	59fd                	li	s3,-1
    80004330:	bff9                	j	8000430e <piperead+0xca>

0000000080004332 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004332:	1141                	add	sp,sp,-16
    80004334:	e422                	sd	s0,8(sp)
    80004336:	0800                	add	s0,sp,16
    80004338:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000433a:	8905                	and	a0,a0,1
    8000433c:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000433e:	8b89                	and	a5,a5,2
    80004340:	c399                	beqz	a5,80004346 <flags2perm+0x14>
      perm |= PTE_W;
    80004342:	00456513          	or	a0,a0,4
    return perm;
}
    80004346:	6422                	ld	s0,8(sp)
    80004348:	0141                	add	sp,sp,16
    8000434a:	8082                	ret

000000008000434c <exec>:

int
exec(char *path, char **argv)
{
    8000434c:	df010113          	add	sp,sp,-528
    80004350:	20113423          	sd	ra,520(sp)
    80004354:	20813023          	sd	s0,512(sp)
    80004358:	ffa6                	sd	s1,504(sp)
    8000435a:	fbca                	sd	s2,496(sp)
    8000435c:	f7ce                	sd	s3,488(sp)
    8000435e:	f3d2                	sd	s4,480(sp)
    80004360:	efd6                	sd	s5,472(sp)
    80004362:	ebda                	sd	s6,464(sp)
    80004364:	e7de                	sd	s7,456(sp)
    80004366:	e3e2                	sd	s8,448(sp)
    80004368:	ff66                	sd	s9,440(sp)
    8000436a:	fb6a                	sd	s10,432(sp)
    8000436c:	f76e                	sd	s11,424(sp)
    8000436e:	0c00                	add	s0,sp,528
    80004370:	892a                	mv	s2,a0
    80004372:	dea43c23          	sd	a0,-520(s0)
    80004376:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	cb2080e7          	jalr	-846(ra) # 8000102c <myproc>
    80004382:	84aa                	mv	s1,a0

  begin_op();
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	48e080e7          	jalr	1166(ra) # 80003812 <begin_op>

  if((ip = namei(path)) == 0){
    8000438c:	854a                	mv	a0,s2
    8000438e:	fffff097          	auipc	ra,0xfffff
    80004392:	284080e7          	jalr	644(ra) # 80003612 <namei>
    80004396:	c92d                	beqz	a0,80004408 <exec+0xbc>
    80004398:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000439a:	fffff097          	auipc	ra,0xfffff
    8000439e:	ad2080e7          	jalr	-1326(ra) # 80002e6c <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043a2:	04000713          	li	a4,64
    800043a6:	4681                	li	a3,0
    800043a8:	e5040613          	add	a2,s0,-432
    800043ac:	4581                	li	a1,0
    800043ae:	8552                	mv	a0,s4
    800043b0:	fffff097          	auipc	ra,0xfffff
    800043b4:	d70080e7          	jalr	-656(ra) # 80003120 <readi>
    800043b8:	04000793          	li	a5,64
    800043bc:	00f51a63          	bne	a0,a5,800043d0 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800043c0:	e5042703          	lw	a4,-432(s0)
    800043c4:	464c47b7          	lui	a5,0x464c4
    800043c8:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043cc:	04f70463          	beq	a4,a5,80004414 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043d0:	8552                	mv	a0,s4
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	cfc080e7          	jalr	-772(ra) # 800030ce <iunlockput>
    end_op();
    800043da:	fffff097          	auipc	ra,0xfffff
    800043de:	4b2080e7          	jalr	1202(ra) # 8000388c <end_op>
  }
  return -1;
    800043e2:	557d                	li	a0,-1
}
    800043e4:	20813083          	ld	ra,520(sp)
    800043e8:	20013403          	ld	s0,512(sp)
    800043ec:	74fe                	ld	s1,504(sp)
    800043ee:	795e                	ld	s2,496(sp)
    800043f0:	79be                	ld	s3,488(sp)
    800043f2:	7a1e                	ld	s4,480(sp)
    800043f4:	6afe                	ld	s5,472(sp)
    800043f6:	6b5e                	ld	s6,464(sp)
    800043f8:	6bbe                	ld	s7,456(sp)
    800043fa:	6c1e                	ld	s8,448(sp)
    800043fc:	7cfa                	ld	s9,440(sp)
    800043fe:	7d5a                	ld	s10,432(sp)
    80004400:	7dba                	ld	s11,424(sp)
    80004402:	21010113          	add	sp,sp,528
    80004406:	8082                	ret
    end_op();
    80004408:	fffff097          	auipc	ra,0xfffff
    8000440c:	484080e7          	jalr	1156(ra) # 8000388c <end_op>
    return -1;
    80004410:	557d                	li	a0,-1
    80004412:	bfc9                	j	800043e4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004414:	8526                	mv	a0,s1
    80004416:	ffffd097          	auipc	ra,0xffffd
    8000441a:	cde080e7          	jalr	-802(ra) # 800010f4 <proc_pagetable>
    8000441e:	8b2a                	mv	s6,a0
    80004420:	d945                	beqz	a0,800043d0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004422:	e7042d03          	lw	s10,-400(s0)
    80004426:	e8845783          	lhu	a5,-376(s0)
    8000442a:	10078463          	beqz	a5,80004532 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000442e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004430:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004432:	6c85                	lui	s9,0x1
    80004434:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004438:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000443c:	6a85                	lui	s5,0x1
    8000443e:	a0b5                	j	800044aa <exec+0x15e>
      panic("loadseg: address should exist");
    80004440:	00004517          	auipc	a0,0x4
    80004444:	33850513          	add	a0,a0,824 # 80008778 <syscalls+0x288>
    80004448:	00002097          	auipc	ra,0x2
    8000444c:	a7e080e7          	jalr	-1410(ra) # 80005ec6 <panic>
    if(sz - i < PGSIZE)
    80004450:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004452:	8726                	mv	a4,s1
    80004454:	012c06bb          	addw	a3,s8,s2
    80004458:	4581                	li	a1,0
    8000445a:	8552                	mv	a0,s4
    8000445c:	fffff097          	auipc	ra,0xfffff
    80004460:	cc4080e7          	jalr	-828(ra) # 80003120 <readi>
    80004464:	2501                	sext.w	a0,a0
    80004466:	24a49863          	bne	s1,a0,800046b6 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000446a:	012a893b          	addw	s2,s5,s2
    8000446e:	03397563          	bgeu	s2,s3,80004498 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004472:	02091593          	sll	a1,s2,0x20
    80004476:	9181                	srl	a1,a1,0x20
    80004478:	95de                	add	a1,a1,s7
    8000447a:	855a                	mv	a0,s6
    8000447c:	ffffc097          	auipc	ra,0xffffc
    80004480:	214080e7          	jalr	532(ra) # 80000690 <walkaddr>
    80004484:	862a                	mv	a2,a0
    if(pa == 0)
    80004486:	dd4d                	beqz	a0,80004440 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004488:	412984bb          	subw	s1,s3,s2
    8000448c:	0004879b          	sext.w	a5,s1
    80004490:	fcfcf0e3          	bgeu	s9,a5,80004450 <exec+0x104>
    80004494:	84d6                	mv	s1,s5
    80004496:	bf6d                	j	80004450 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004498:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000449c:	2d85                	addw	s11,s11,1
    8000449e:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800044a2:	e8845783          	lhu	a5,-376(s0)
    800044a6:	08fdd763          	bge	s11,a5,80004534 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044aa:	2d01                	sext.w	s10,s10
    800044ac:	03800713          	li	a4,56
    800044b0:	86ea                	mv	a3,s10
    800044b2:	e1840613          	add	a2,s0,-488
    800044b6:	4581                	li	a1,0
    800044b8:	8552                	mv	a0,s4
    800044ba:	fffff097          	auipc	ra,0xfffff
    800044be:	c66080e7          	jalr	-922(ra) # 80003120 <readi>
    800044c2:	03800793          	li	a5,56
    800044c6:	1ef51663          	bne	a0,a5,800046b2 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    800044ca:	e1842783          	lw	a5,-488(s0)
    800044ce:	4705                	li	a4,1
    800044d0:	fce796e3          	bne	a5,a4,8000449c <exec+0x150>
    if(ph.memsz < ph.filesz)
    800044d4:	e4043483          	ld	s1,-448(s0)
    800044d8:	e3843783          	ld	a5,-456(s0)
    800044dc:	1ef4e863          	bltu	s1,a5,800046cc <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e0:	e2843783          	ld	a5,-472(s0)
    800044e4:	94be                	add	s1,s1,a5
    800044e6:	1ef4e663          	bltu	s1,a5,800046d2 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800044ea:	df043703          	ld	a4,-528(s0)
    800044ee:	8ff9                	and	a5,a5,a4
    800044f0:	1e079463          	bnez	a5,800046d8 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044f4:	e1c42503          	lw	a0,-484(s0)
    800044f8:	00000097          	auipc	ra,0x0
    800044fc:	e3a080e7          	jalr	-454(ra) # 80004332 <flags2perm>
    80004500:	86aa                	mv	a3,a0
    80004502:	8626                	mv	a2,s1
    80004504:	85ca                	mv	a1,s2
    80004506:	855a                	mv	a0,s6
    80004508:	ffffc097          	auipc	ra,0xffffc
    8000450c:	560080e7          	jalr	1376(ra) # 80000a68 <uvmalloc>
    80004510:	e0a43423          	sd	a0,-504(s0)
    80004514:	1c050563          	beqz	a0,800046de <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004518:	e2843b83          	ld	s7,-472(s0)
    8000451c:	e2042c03          	lw	s8,-480(s0)
    80004520:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004524:	00098463          	beqz	s3,8000452c <exec+0x1e0>
    80004528:	4901                	li	s2,0
    8000452a:	b7a1                	j	80004472 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000452c:	e0843903          	ld	s2,-504(s0)
    80004530:	b7b5                	j	8000449c <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004532:	4901                	li	s2,0
  iunlockput(ip);
    80004534:	8552                	mv	a0,s4
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	b98080e7          	jalr	-1128(ra) # 800030ce <iunlockput>
  end_op();
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	34e080e7          	jalr	846(ra) # 8000388c <end_op>
  p = myproc();
    80004546:	ffffd097          	auipc	ra,0xffffd
    8000454a:	ae6080e7          	jalr	-1306(ra) # 8000102c <myproc>
    8000454e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004550:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004554:	6985                	lui	s3,0x1
    80004556:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004558:	99ca                	add	s3,s3,s2
    8000455a:	77fd                	lui	a5,0xfffff
    8000455c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004560:	4691                	li	a3,4
    80004562:	6609                	lui	a2,0x2
    80004564:	964e                	add	a2,a2,s3
    80004566:	85ce                	mv	a1,s3
    80004568:	855a                	mv	a0,s6
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	4fe080e7          	jalr	1278(ra) # 80000a68 <uvmalloc>
    80004572:	892a                	mv	s2,a0
    80004574:	e0a43423          	sd	a0,-504(s0)
    80004578:	e509                	bnez	a0,80004582 <exec+0x236>
  if(pagetable)
    8000457a:	e1343423          	sd	s3,-504(s0)
    8000457e:	4a01                	li	s4,0
    80004580:	aa1d                	j	800046b6 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004582:	75f9                	lui	a1,0xffffe
    80004584:	95aa                	add	a1,a1,a0
    80004586:	855a                	mv	a0,s6
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	6fe080e7          	jalr	1790(ra) # 80000c86 <uvmclear>
  stackbase = sp - PGSIZE;
    80004590:	7bfd                	lui	s7,0xfffff
    80004592:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004594:	e0043783          	ld	a5,-512(s0)
    80004598:	6388                	ld	a0,0(a5)
    8000459a:	c52d                	beqz	a0,80004604 <exec+0x2b8>
    8000459c:	e9040993          	add	s3,s0,-368
    800045a0:	f9040c13          	add	s8,s0,-112
    800045a4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045a6:	ffffc097          	auipc	ra,0xffffc
    800045aa:	edc080e7          	jalr	-292(ra) # 80000482 <strlen>
    800045ae:	0015079b          	addw	a5,a0,1
    800045b2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    800045b6:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800045ba:	13796563          	bltu	s2,s7,800046e4 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045be:	e0043d03          	ld	s10,-512(s0)
    800045c2:	000d3a03          	ld	s4,0(s10)
    800045c6:	8552                	mv	a0,s4
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	eba080e7          	jalr	-326(ra) # 80000482 <strlen>
    800045d0:	0015069b          	addw	a3,a0,1
    800045d4:	8652                	mv	a2,s4
    800045d6:	85ca                	mv	a1,s2
    800045d8:	855a                	mv	a0,s6
    800045da:	ffffc097          	auipc	ra,0xffffc
    800045de:	6de080e7          	jalr	1758(ra) # 80000cb8 <copyout>
    800045e2:	10054363          	bltz	a0,800046e8 <exec+0x39c>
    ustack[argc] = sp;
    800045e6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045ea:	0485                	add	s1,s1,1
    800045ec:	008d0793          	add	a5,s10,8
    800045f0:	e0f43023          	sd	a5,-512(s0)
    800045f4:	008d3503          	ld	a0,8(s10)
    800045f8:	c909                	beqz	a0,8000460a <exec+0x2be>
    if(argc >= MAXARG)
    800045fa:	09a1                	add	s3,s3,8
    800045fc:	fb8995e3          	bne	s3,s8,800045a6 <exec+0x25a>
  ip = 0;
    80004600:	4a01                	li	s4,0
    80004602:	a855                	j	800046b6 <exec+0x36a>
  sp = sz;
    80004604:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004608:	4481                	li	s1,0
  ustack[argc] = 0;
    8000460a:	00349793          	sll	a5,s1,0x3
    8000460e:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffbce70>
    80004612:	97a2                	add	a5,a5,s0
    80004614:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004618:	00148693          	add	a3,s1,1
    8000461c:	068e                	sll	a3,a3,0x3
    8000461e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004622:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004626:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000462a:	f57968e3          	bltu	s2,s7,8000457a <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000462e:	e9040613          	add	a2,s0,-368
    80004632:	85ca                	mv	a1,s2
    80004634:	855a                	mv	a0,s6
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	682080e7          	jalr	1666(ra) # 80000cb8 <copyout>
    8000463e:	0a054763          	bltz	a0,800046ec <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004642:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004646:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000464a:	df843783          	ld	a5,-520(s0)
    8000464e:	0007c703          	lbu	a4,0(a5)
    80004652:	cf11                	beqz	a4,8000466e <exec+0x322>
    80004654:	0785                	add	a5,a5,1
    if(*s == '/')
    80004656:	02f00693          	li	a3,47
    8000465a:	a039                	j	80004668 <exec+0x31c>
      last = s+1;
    8000465c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004660:	0785                	add	a5,a5,1
    80004662:	fff7c703          	lbu	a4,-1(a5)
    80004666:	c701                	beqz	a4,8000466e <exec+0x322>
    if(*s == '/')
    80004668:	fed71ce3          	bne	a4,a3,80004660 <exec+0x314>
    8000466c:	bfc5                	j	8000465c <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000466e:	4641                	li	a2,16
    80004670:	df843583          	ld	a1,-520(s0)
    80004674:	158a8513          	add	a0,s5,344
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	dd8080e7          	jalr	-552(ra) # 80000450 <safestrcpy>
  oldpagetable = p->pagetable;
    80004680:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004684:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004688:	e0843783          	ld	a5,-504(s0)
    8000468c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    80004690:	058ab783          	ld	a5,88(s5)
    80004694:	e6843703          	ld	a4,-408(s0)
    80004698:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    8000469a:	058ab783          	ld	a5,88(s5)
    8000469e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046a2:	85e6                	mv	a1,s9
    800046a4:	ffffd097          	auipc	ra,0xffffd
    800046a8:	aec080e7          	jalr	-1300(ra) # 80001190 <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    800046ac:	0004851b          	sext.w	a0,s1
    800046b0:	bb15                	j	800043e4 <exec+0x98>
    800046b2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800046b6:	e0843583          	ld	a1,-504(s0)
    800046ba:	855a                	mv	a0,s6
    800046bc:	ffffd097          	auipc	ra,0xffffd
    800046c0:	ad4080e7          	jalr	-1324(ra) # 80001190 <proc_freepagetable>
  return -1;
    800046c4:	557d                	li	a0,-1
  if(ip){
    800046c6:	d00a0fe3          	beqz	s4,800043e4 <exec+0x98>
    800046ca:	b319                	j	800043d0 <exec+0x84>
    800046cc:	e1243423          	sd	s2,-504(s0)
    800046d0:	b7dd                	j	800046b6 <exec+0x36a>
    800046d2:	e1243423          	sd	s2,-504(s0)
    800046d6:	b7c5                	j	800046b6 <exec+0x36a>
    800046d8:	e1243423          	sd	s2,-504(s0)
    800046dc:	bfe9                	j	800046b6 <exec+0x36a>
    800046de:	e1243423          	sd	s2,-504(s0)
    800046e2:	bfd1                	j	800046b6 <exec+0x36a>
  ip = 0;
    800046e4:	4a01                	li	s4,0
    800046e6:	bfc1                	j	800046b6 <exec+0x36a>
    800046e8:	4a01                	li	s4,0
  if(pagetable)
    800046ea:	b7f1                	j	800046b6 <exec+0x36a>
  sz = sz1;
    800046ec:	e0843983          	ld	s3,-504(s0)
    800046f0:	b569                	j	8000457a <exec+0x22e>

00000000800046f2 <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046f2:	7179                	add	sp,sp,-48
    800046f4:	f406                	sd	ra,40(sp)
    800046f6:	f022                	sd	s0,32(sp)
    800046f8:	ec26                	sd	s1,24(sp)
    800046fa:	e84a                	sd	s2,16(sp)
    800046fc:	1800                	add	s0,sp,48
    800046fe:	892e                	mv	s2,a1
    80004700:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004702:	fdc40593          	add	a1,s0,-36
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	b46080e7          	jalr	-1210(ra) # 8000224c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000470e:	fdc42703          	lw	a4,-36(s0)
    80004712:	47bd                	li	a5,15
    80004714:	02e7eb63          	bltu	a5,a4,8000474a <argfd+0x58>
    80004718:	ffffd097          	auipc	ra,0xffffd
    8000471c:	914080e7          	jalr	-1772(ra) # 8000102c <myproc>
    80004720:	fdc42703          	lw	a4,-36(s0)
    80004724:	01a70793          	add	a5,a4,26
    80004728:	078e                	sll	a5,a5,0x3
    8000472a:	953e                	add	a0,a0,a5
    8000472c:	611c                	ld	a5,0(a0)
    8000472e:	c385                	beqz	a5,8000474e <argfd+0x5c>
    return -1;
  if(pfd)
    80004730:	00090463          	beqz	s2,80004738 <argfd+0x46>
    *pfd = fd;
    80004734:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004738:	4501                	li	a0,0
  if(pf)
    8000473a:	c091                	beqz	s1,8000473e <argfd+0x4c>
    *pf = f;
    8000473c:	e09c                	sd	a5,0(s1)
}
    8000473e:	70a2                	ld	ra,40(sp)
    80004740:	7402                	ld	s0,32(sp)
    80004742:	64e2                	ld	s1,24(sp)
    80004744:	6942                	ld	s2,16(sp)
    80004746:	6145                	add	sp,sp,48
    80004748:	8082                	ret
    return -1;
    8000474a:	557d                	li	a0,-1
    8000474c:	bfcd                	j	8000473e <argfd+0x4c>
    8000474e:	557d                	li	a0,-1
    80004750:	b7fd                	j	8000473e <argfd+0x4c>

0000000080004752 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    80004752:	1101                	add	sp,sp,-32
    80004754:	ec06                	sd	ra,24(sp)
    80004756:	e822                	sd	s0,16(sp)
    80004758:	e426                	sd	s1,8(sp)
    8000475a:	1000                	add	s0,sp,32
    8000475c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000475e:	ffffd097          	auipc	ra,0xffffd
    80004762:	8ce080e7          	jalr	-1842(ra) # 8000102c <myproc>
    80004766:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004768:	0d050793          	add	a5,a0,208
    8000476c:	4501                	li	a0,0
    8000476e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004770:	6398                	ld	a4,0(a5)
    80004772:	cb19                	beqz	a4,80004788 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004774:	2505                	addw	a0,a0,1
    80004776:	07a1                	add	a5,a5,8
    80004778:	fed51ce3          	bne	a0,a3,80004770 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000477c:	557d                	li	a0,-1
}
    8000477e:	60e2                	ld	ra,24(sp)
    80004780:	6442                	ld	s0,16(sp)
    80004782:	64a2                	ld	s1,8(sp)
    80004784:	6105                	add	sp,sp,32
    80004786:	8082                	ret
      p->ofile[fd] = f;
    80004788:	01a50793          	add	a5,a0,26
    8000478c:	078e                	sll	a5,a5,0x3
    8000478e:	963e                	add	a2,a2,a5
    80004790:	e204                	sd	s1,0(a2)
      return fd;
    80004792:	b7f5                	j	8000477e <fdalloc+0x2c>

0000000080004794 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004794:	715d                	add	sp,sp,-80
    80004796:	e486                	sd	ra,72(sp)
    80004798:	e0a2                	sd	s0,64(sp)
    8000479a:	fc26                	sd	s1,56(sp)
    8000479c:	f84a                	sd	s2,48(sp)
    8000479e:	f44e                	sd	s3,40(sp)
    800047a0:	f052                	sd	s4,32(sp)
    800047a2:	ec56                	sd	s5,24(sp)
    800047a4:	e85a                	sd	s6,16(sp)
    800047a6:	0880                	add	s0,sp,80
    800047a8:	8b2e                	mv	s6,a1
    800047aa:	89b2                	mv	s3,a2
    800047ac:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800047ae:	fb040593          	add	a1,s0,-80
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	e7e080e7          	jalr	-386(ra) # 80003630 <nameiparent>
    800047ba:	84aa                	mv	s1,a0
    800047bc:	14050b63          	beqz	a0,80004912 <create+0x17e>
    return 0;

  ilock(dp);
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	6ac080e7          	jalr	1708(ra) # 80002e6c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047c8:	4601                	li	a2,0
    800047ca:	fb040593          	add	a1,s0,-80
    800047ce:	8526                	mv	a0,s1
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	b80080e7          	jalr	-1152(ra) # 80003350 <dirlookup>
    800047d8:	8aaa                	mv	s5,a0
    800047da:	c921                	beqz	a0,8000482a <create+0x96>
    iunlockput(dp);
    800047dc:	8526                	mv	a0,s1
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	8f0080e7          	jalr	-1808(ra) # 800030ce <iunlockput>
    ilock(ip);
    800047e6:	8556                	mv	a0,s5
    800047e8:	ffffe097          	auipc	ra,0xffffe
    800047ec:	684080e7          	jalr	1668(ra) # 80002e6c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047f0:	4789                	li	a5,2
    800047f2:	02fb1563          	bne	s6,a5,8000481c <create+0x88>
    800047f6:	044ad783          	lhu	a5,68(s5)
    800047fa:	37f9                	addw	a5,a5,-2
    800047fc:	17c2                	sll	a5,a5,0x30
    800047fe:	93c1                	srl	a5,a5,0x30
    80004800:	4705                	li	a4,1
    80004802:	00f76d63          	bltu	a4,a5,8000481c <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004806:	8556                	mv	a0,s5
    80004808:	60a6                	ld	ra,72(sp)
    8000480a:	6406                	ld	s0,64(sp)
    8000480c:	74e2                	ld	s1,56(sp)
    8000480e:	7942                	ld	s2,48(sp)
    80004810:	79a2                	ld	s3,40(sp)
    80004812:	7a02                	ld	s4,32(sp)
    80004814:	6ae2                	ld	s5,24(sp)
    80004816:	6b42                	ld	s6,16(sp)
    80004818:	6161                	add	sp,sp,80
    8000481a:	8082                	ret
    iunlockput(ip);
    8000481c:	8556                	mv	a0,s5
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	8b0080e7          	jalr	-1872(ra) # 800030ce <iunlockput>
    return 0;
    80004826:	4a81                	li	s5,0
    80004828:	bff9                	j	80004806 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000482a:	85da                	mv	a1,s6
    8000482c:	4088                	lw	a0,0(s1)
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	4a6080e7          	jalr	1190(ra) # 80002cd4 <ialloc>
    80004836:	8a2a                	mv	s4,a0
    80004838:	c529                	beqz	a0,80004882 <create+0xee>
  ilock(ip);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	632080e7          	jalr	1586(ra) # 80002e6c <ilock>
  ip->major = major;
    80004842:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004846:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000484a:	4905                	li	s2,1
    8000484c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004850:	8552                	mv	a0,s4
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	54e080e7          	jalr	1358(ra) # 80002da0 <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    8000485a:	032b0b63          	beq	s6,s2,80004890 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000485e:	004a2603          	lw	a2,4(s4)
    80004862:	fb040593          	add	a1,s0,-80
    80004866:	8526                	mv	a0,s1
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	cf8080e7          	jalr	-776(ra) # 80003560 <dirlink>
    80004870:	06054f63          	bltz	a0,800048ee <create+0x15a>
  iunlockput(dp);
    80004874:	8526                	mv	a0,s1
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	858080e7          	jalr	-1960(ra) # 800030ce <iunlockput>
  return ip;
    8000487e:	8ad2                	mv	s5,s4
    80004880:	b759                	j	80004806 <create+0x72>
    iunlockput(dp);
    80004882:	8526                	mv	a0,s1
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	84a080e7          	jalr	-1974(ra) # 800030ce <iunlockput>
    return 0;
    8000488c:	8ad2                	mv	s5,s4
    8000488e:	bfa5                	j	80004806 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004890:	004a2603          	lw	a2,4(s4)
    80004894:	00004597          	auipc	a1,0x4
    80004898:	f0458593          	add	a1,a1,-252 # 80008798 <syscalls+0x2a8>
    8000489c:	8552                	mv	a0,s4
    8000489e:	fffff097          	auipc	ra,0xfffff
    800048a2:	cc2080e7          	jalr	-830(ra) # 80003560 <dirlink>
    800048a6:	04054463          	bltz	a0,800048ee <create+0x15a>
    800048aa:	40d0                	lw	a2,4(s1)
    800048ac:	00004597          	auipc	a1,0x4
    800048b0:	ef458593          	add	a1,a1,-268 # 800087a0 <syscalls+0x2b0>
    800048b4:	8552                	mv	a0,s4
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	caa080e7          	jalr	-854(ra) # 80003560 <dirlink>
    800048be:	02054863          	bltz	a0,800048ee <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800048c2:	004a2603          	lw	a2,4(s4)
    800048c6:	fb040593          	add	a1,s0,-80
    800048ca:	8526                	mv	a0,s1
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	c94080e7          	jalr	-876(ra) # 80003560 <dirlink>
    800048d4:	00054d63          	bltz	a0,800048ee <create+0x15a>
    dp->nlink++;  /* for ".." */
    800048d8:	04a4d783          	lhu	a5,74(s1)
    800048dc:	2785                	addw	a5,a5,1
    800048de:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	4bc080e7          	jalr	1212(ra) # 80002da0 <iupdate>
    800048ec:	b761                	j	80004874 <create+0xe0>
  ip->nlink = 0;
    800048ee:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800048f2:	8552                	mv	a0,s4
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	4ac080e7          	jalr	1196(ra) # 80002da0 <iupdate>
  iunlockput(ip);
    800048fc:	8552                	mv	a0,s4
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	7d0080e7          	jalr	2000(ra) # 800030ce <iunlockput>
  iunlockput(dp);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	7c6080e7          	jalr	1990(ra) # 800030ce <iunlockput>
  return 0;
    80004910:	bddd                	j	80004806 <create+0x72>
    return 0;
    80004912:	8aaa                	mv	s5,a0
    80004914:	bdcd                	j	80004806 <create+0x72>

0000000080004916 <sys_dup>:
{
    80004916:	7179                	add	sp,sp,-48
    80004918:	f406                	sd	ra,40(sp)
    8000491a:	f022                	sd	s0,32(sp)
    8000491c:	ec26                	sd	s1,24(sp)
    8000491e:	e84a                	sd	s2,16(sp)
    80004920:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004922:	fd840613          	add	a2,s0,-40
    80004926:	4581                	li	a1,0
    80004928:	4501                	li	a0,0
    8000492a:	00000097          	auipc	ra,0x0
    8000492e:	dc8080e7          	jalr	-568(ra) # 800046f2 <argfd>
    return -1;
    80004932:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004934:	02054363          	bltz	a0,8000495a <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004938:	fd843903          	ld	s2,-40(s0)
    8000493c:	854a                	mv	a0,s2
    8000493e:	00000097          	auipc	ra,0x0
    80004942:	e14080e7          	jalr	-492(ra) # 80004752 <fdalloc>
    80004946:	84aa                	mv	s1,a0
    return -1;
    80004948:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000494a:	00054863          	bltz	a0,8000495a <sys_dup+0x44>
  filedup(f);
    8000494e:	854a                	mv	a0,s2
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	334080e7          	jalr	820(ra) # 80003c84 <filedup>
  return fd;
    80004958:	87a6                	mv	a5,s1
}
    8000495a:	853e                	mv	a0,a5
    8000495c:	70a2                	ld	ra,40(sp)
    8000495e:	7402                	ld	s0,32(sp)
    80004960:	64e2                	ld	s1,24(sp)
    80004962:	6942                	ld	s2,16(sp)
    80004964:	6145                	add	sp,sp,48
    80004966:	8082                	ret

0000000080004968 <sys_read>:
{
    80004968:	7179                	add	sp,sp,-48
    8000496a:	f406                	sd	ra,40(sp)
    8000496c:	f022                	sd	s0,32(sp)
    8000496e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004970:	fd840593          	add	a1,s0,-40
    80004974:	4505                	li	a0,1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	8f6080e7          	jalr	-1802(ra) # 8000226c <argaddr>
  argint(2, &n);
    8000497e:	fe440593          	add	a1,s0,-28
    80004982:	4509                	li	a0,2
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	8c8080e7          	jalr	-1848(ra) # 8000224c <argint>
  if(argfd(0, 0, &f) < 0)
    8000498c:	fe840613          	add	a2,s0,-24
    80004990:	4581                	li	a1,0
    80004992:	4501                	li	a0,0
    80004994:	00000097          	auipc	ra,0x0
    80004998:	d5e080e7          	jalr	-674(ra) # 800046f2 <argfd>
    8000499c:	87aa                	mv	a5,a0
    return -1;
    8000499e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049a0:	0007cc63          	bltz	a5,800049b8 <sys_read+0x50>
  return fileread(f, p, n);
    800049a4:	fe442603          	lw	a2,-28(s0)
    800049a8:	fd843583          	ld	a1,-40(s0)
    800049ac:	fe843503          	ld	a0,-24(s0)
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	460080e7          	jalr	1120(ra) # 80003e10 <fileread>
}
    800049b8:	70a2                	ld	ra,40(sp)
    800049ba:	7402                	ld	s0,32(sp)
    800049bc:	6145                	add	sp,sp,48
    800049be:	8082                	ret

00000000800049c0 <sys_write>:
{
    800049c0:	7179                	add	sp,sp,-48
    800049c2:	f406                	sd	ra,40(sp)
    800049c4:	f022                	sd	s0,32(sp)
    800049c6:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800049c8:	fd840593          	add	a1,s0,-40
    800049cc:	4505                	li	a0,1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	89e080e7          	jalr	-1890(ra) # 8000226c <argaddr>
  argint(2, &n);
    800049d6:	fe440593          	add	a1,s0,-28
    800049da:	4509                	li	a0,2
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	870080e7          	jalr	-1936(ra) # 8000224c <argint>
  if(argfd(0, 0, &f) < 0)
    800049e4:	fe840613          	add	a2,s0,-24
    800049e8:	4581                	li	a1,0
    800049ea:	4501                	li	a0,0
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	d06080e7          	jalr	-762(ra) # 800046f2 <argfd>
    800049f4:	87aa                	mv	a5,a0
    return -1;
    800049f6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049f8:	0007cc63          	bltz	a5,80004a10 <sys_write+0x50>
  return filewrite(f, p, n);
    800049fc:	fe442603          	lw	a2,-28(s0)
    80004a00:	fd843583          	ld	a1,-40(s0)
    80004a04:	fe843503          	ld	a0,-24(s0)
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	4ca080e7          	jalr	1226(ra) # 80003ed2 <filewrite>
}
    80004a10:	70a2                	ld	ra,40(sp)
    80004a12:	7402                	ld	s0,32(sp)
    80004a14:	6145                	add	sp,sp,48
    80004a16:	8082                	ret

0000000080004a18 <sys_close>:
{
    80004a18:	1101                	add	sp,sp,-32
    80004a1a:	ec06                	sd	ra,24(sp)
    80004a1c:	e822                	sd	s0,16(sp)
    80004a1e:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a20:	fe040613          	add	a2,s0,-32
    80004a24:	fec40593          	add	a1,s0,-20
    80004a28:	4501                	li	a0,0
    80004a2a:	00000097          	auipc	ra,0x0
    80004a2e:	cc8080e7          	jalr	-824(ra) # 800046f2 <argfd>
    return -1;
    80004a32:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a34:	02054463          	bltz	a0,80004a5c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a38:	ffffc097          	auipc	ra,0xffffc
    80004a3c:	5f4080e7          	jalr	1524(ra) # 8000102c <myproc>
    80004a40:	fec42783          	lw	a5,-20(s0)
    80004a44:	07e9                	add	a5,a5,26
    80004a46:	078e                	sll	a5,a5,0x3
    80004a48:	953e                	add	a0,a0,a5
    80004a4a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a4e:	fe043503          	ld	a0,-32(s0)
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	284080e7          	jalr	644(ra) # 80003cd6 <fileclose>
  return 0;
    80004a5a:	4781                	li	a5,0
}
    80004a5c:	853e                	mv	a0,a5
    80004a5e:	60e2                	ld	ra,24(sp)
    80004a60:	6442                	ld	s0,16(sp)
    80004a62:	6105                	add	sp,sp,32
    80004a64:	8082                	ret

0000000080004a66 <sys_fstat>:
{
    80004a66:	1101                	add	sp,sp,-32
    80004a68:	ec06                	sd	ra,24(sp)
    80004a6a:	e822                	sd	s0,16(sp)
    80004a6c:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004a6e:	fe040593          	add	a1,s0,-32
    80004a72:	4505                	li	a0,1
    80004a74:	ffffd097          	auipc	ra,0xffffd
    80004a78:	7f8080e7          	jalr	2040(ra) # 8000226c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a7c:	fe840613          	add	a2,s0,-24
    80004a80:	4581                	li	a1,0
    80004a82:	4501                	li	a0,0
    80004a84:	00000097          	auipc	ra,0x0
    80004a88:	c6e080e7          	jalr	-914(ra) # 800046f2 <argfd>
    80004a8c:	87aa                	mv	a5,a0
    return -1;
    80004a8e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a90:	0007ca63          	bltz	a5,80004aa4 <sys_fstat+0x3e>
  return filestat(f, st);
    80004a94:	fe043583          	ld	a1,-32(s0)
    80004a98:	fe843503          	ld	a0,-24(s0)
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	302080e7          	jalr	770(ra) # 80003d9e <filestat>
}
    80004aa4:	60e2                	ld	ra,24(sp)
    80004aa6:	6442                	ld	s0,16(sp)
    80004aa8:	6105                	add	sp,sp,32
    80004aaa:	8082                	ret

0000000080004aac <sys_link>:
{
    80004aac:	7169                	add	sp,sp,-304
    80004aae:	f606                	sd	ra,296(sp)
    80004ab0:	f222                	sd	s0,288(sp)
    80004ab2:	ee26                	sd	s1,280(sp)
    80004ab4:	ea4a                	sd	s2,272(sp)
    80004ab6:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ab8:	08000613          	li	a2,128
    80004abc:	ed040593          	add	a1,s0,-304
    80004ac0:	4501                	li	a0,0
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	7ca080e7          	jalr	1994(ra) # 8000228c <argstr>
    return -1;
    80004aca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004acc:	10054e63          	bltz	a0,80004be8 <sys_link+0x13c>
    80004ad0:	08000613          	li	a2,128
    80004ad4:	f5040593          	add	a1,s0,-176
    80004ad8:	4505                	li	a0,1
    80004ada:	ffffd097          	auipc	ra,0xffffd
    80004ade:	7b2080e7          	jalr	1970(ra) # 8000228c <argstr>
    return -1;
    80004ae2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ae4:	10054263          	bltz	a0,80004be8 <sys_link+0x13c>
  begin_op();
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	d2a080e7          	jalr	-726(ra) # 80003812 <begin_op>
  if((ip = namei(old)) == 0){
    80004af0:	ed040513          	add	a0,s0,-304
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	b1e080e7          	jalr	-1250(ra) # 80003612 <namei>
    80004afc:	84aa                	mv	s1,a0
    80004afe:	c551                	beqz	a0,80004b8a <sys_link+0xde>
  ilock(ip);
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	36c080e7          	jalr	876(ra) # 80002e6c <ilock>
  if(ip->type == T_DIR){
    80004b08:	04449703          	lh	a4,68(s1)
    80004b0c:	4785                	li	a5,1
    80004b0e:	08f70463          	beq	a4,a5,80004b96 <sys_link+0xea>
  ip->nlink++;
    80004b12:	04a4d783          	lhu	a5,74(s1)
    80004b16:	2785                	addw	a5,a5,1
    80004b18:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	282080e7          	jalr	642(ra) # 80002da0 <iupdate>
  iunlock(ip);
    80004b26:	8526                	mv	a0,s1
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	406080e7          	jalr	1030(ra) # 80002f2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b30:	fd040593          	add	a1,s0,-48
    80004b34:	f5040513          	add	a0,s0,-176
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	af8080e7          	jalr	-1288(ra) # 80003630 <nameiparent>
    80004b40:	892a                	mv	s2,a0
    80004b42:	c935                	beqz	a0,80004bb6 <sys_link+0x10a>
  ilock(dp);
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	328080e7          	jalr	808(ra) # 80002e6c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b4c:	00092703          	lw	a4,0(s2)
    80004b50:	409c                	lw	a5,0(s1)
    80004b52:	04f71d63          	bne	a4,a5,80004bac <sys_link+0x100>
    80004b56:	40d0                	lw	a2,4(s1)
    80004b58:	fd040593          	add	a1,s0,-48
    80004b5c:	854a                	mv	a0,s2
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	a02080e7          	jalr	-1534(ra) # 80003560 <dirlink>
    80004b66:	04054363          	bltz	a0,80004bac <sys_link+0x100>
  iunlockput(dp);
    80004b6a:	854a                	mv	a0,s2
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	562080e7          	jalr	1378(ra) # 800030ce <iunlockput>
  iput(ip);
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	4b0080e7          	jalr	1200(ra) # 80003026 <iput>
  end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	d0e080e7          	jalr	-754(ra) # 8000388c <end_op>
  return 0;
    80004b86:	4781                	li	a5,0
    80004b88:	a085                	j	80004be8 <sys_link+0x13c>
    end_op();
    80004b8a:	fffff097          	auipc	ra,0xfffff
    80004b8e:	d02080e7          	jalr	-766(ra) # 8000388c <end_op>
    return -1;
    80004b92:	57fd                	li	a5,-1
    80004b94:	a891                	j	80004be8 <sys_link+0x13c>
    iunlockput(ip);
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	536080e7          	jalr	1334(ra) # 800030ce <iunlockput>
    end_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	cec080e7          	jalr	-788(ra) # 8000388c <end_op>
    return -1;
    80004ba8:	57fd                	li	a5,-1
    80004baa:	a83d                	j	80004be8 <sys_link+0x13c>
    iunlockput(dp);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	520080e7          	jalr	1312(ra) # 800030ce <iunlockput>
  ilock(ip);
    80004bb6:	8526                	mv	a0,s1
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	2b4080e7          	jalr	692(ra) # 80002e6c <ilock>
  ip->nlink--;
    80004bc0:	04a4d783          	lhu	a5,74(s1)
    80004bc4:	37fd                	addw	a5,a5,-1
    80004bc6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	1d4080e7          	jalr	468(ra) # 80002da0 <iupdate>
  iunlockput(ip);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	4f8080e7          	jalr	1272(ra) # 800030ce <iunlockput>
  end_op();
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	cae080e7          	jalr	-850(ra) # 8000388c <end_op>
  return -1;
    80004be6:	57fd                	li	a5,-1
}
    80004be8:	853e                	mv	a0,a5
    80004bea:	70b2                	ld	ra,296(sp)
    80004bec:	7412                	ld	s0,288(sp)
    80004bee:	64f2                	ld	s1,280(sp)
    80004bf0:	6952                	ld	s2,272(sp)
    80004bf2:	6155                	add	sp,sp,304
    80004bf4:	8082                	ret

0000000080004bf6 <sys_unlink>:
{
    80004bf6:	7151                	add	sp,sp,-240
    80004bf8:	f586                	sd	ra,232(sp)
    80004bfa:	f1a2                	sd	s0,224(sp)
    80004bfc:	eda6                	sd	s1,216(sp)
    80004bfe:	e9ca                	sd	s2,208(sp)
    80004c00:	e5ce                	sd	s3,200(sp)
    80004c02:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c04:	08000613          	li	a2,128
    80004c08:	f3040593          	add	a1,s0,-208
    80004c0c:	4501                	li	a0,0
    80004c0e:	ffffd097          	auipc	ra,0xffffd
    80004c12:	67e080e7          	jalr	1662(ra) # 8000228c <argstr>
    80004c16:	18054163          	bltz	a0,80004d98 <sys_unlink+0x1a2>
  begin_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	bf8080e7          	jalr	-1032(ra) # 80003812 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c22:	fb040593          	add	a1,s0,-80
    80004c26:	f3040513          	add	a0,s0,-208
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	a06080e7          	jalr	-1530(ra) # 80003630 <nameiparent>
    80004c32:	84aa                	mv	s1,a0
    80004c34:	c979                	beqz	a0,80004d0a <sys_unlink+0x114>
  ilock(dp);
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	236080e7          	jalr	566(ra) # 80002e6c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c3e:	00004597          	auipc	a1,0x4
    80004c42:	b5a58593          	add	a1,a1,-1190 # 80008798 <syscalls+0x2a8>
    80004c46:	fb040513          	add	a0,s0,-80
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	6ec080e7          	jalr	1772(ra) # 80003336 <namecmp>
    80004c52:	14050a63          	beqz	a0,80004da6 <sys_unlink+0x1b0>
    80004c56:	00004597          	auipc	a1,0x4
    80004c5a:	b4a58593          	add	a1,a1,-1206 # 800087a0 <syscalls+0x2b0>
    80004c5e:	fb040513          	add	a0,s0,-80
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	6d4080e7          	jalr	1748(ra) # 80003336 <namecmp>
    80004c6a:	12050e63          	beqz	a0,80004da6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c6e:	f2c40613          	add	a2,s0,-212
    80004c72:	fb040593          	add	a1,s0,-80
    80004c76:	8526                	mv	a0,s1
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	6d8080e7          	jalr	1752(ra) # 80003350 <dirlookup>
    80004c80:	892a                	mv	s2,a0
    80004c82:	12050263          	beqz	a0,80004da6 <sys_unlink+0x1b0>
  ilock(ip);
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	1e6080e7          	jalr	486(ra) # 80002e6c <ilock>
  if(ip->nlink < 1)
    80004c8e:	04a91783          	lh	a5,74(s2)
    80004c92:	08f05263          	blez	a5,80004d16 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c96:	04491703          	lh	a4,68(s2)
    80004c9a:	4785                	li	a5,1
    80004c9c:	08f70563          	beq	a4,a5,80004d26 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ca0:	4641                	li	a2,16
    80004ca2:	4581                	li	a1,0
    80004ca4:	fc040513          	add	a0,s0,-64
    80004ca8:	ffffb097          	auipc	ra,0xffffb
    80004cac:	660080e7          	jalr	1632(ra) # 80000308 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cb0:	4741                	li	a4,16
    80004cb2:	f2c42683          	lw	a3,-212(s0)
    80004cb6:	fc040613          	add	a2,s0,-64
    80004cba:	4581                	li	a1,0
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	55a080e7          	jalr	1370(ra) # 80003218 <writei>
    80004cc6:	47c1                	li	a5,16
    80004cc8:	0af51563          	bne	a0,a5,80004d72 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ccc:	04491703          	lh	a4,68(s2)
    80004cd0:	4785                	li	a5,1
    80004cd2:	0af70863          	beq	a4,a5,80004d82 <sys_unlink+0x18c>
  iunlockput(dp);
    80004cd6:	8526                	mv	a0,s1
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	3f6080e7          	jalr	1014(ra) # 800030ce <iunlockput>
  ip->nlink--;
    80004ce0:	04a95783          	lhu	a5,74(s2)
    80004ce4:	37fd                	addw	a5,a5,-1
    80004ce6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cea:	854a                	mv	a0,s2
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	0b4080e7          	jalr	180(ra) # 80002da0 <iupdate>
  iunlockput(ip);
    80004cf4:	854a                	mv	a0,s2
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	3d8080e7          	jalr	984(ra) # 800030ce <iunlockput>
  end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	b8e080e7          	jalr	-1138(ra) # 8000388c <end_op>
  return 0;
    80004d06:	4501                	li	a0,0
    80004d08:	a84d                	j	80004dba <sys_unlink+0x1c4>
    end_op();
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	b82080e7          	jalr	-1150(ra) # 8000388c <end_op>
    return -1;
    80004d12:	557d                	li	a0,-1
    80004d14:	a05d                	j	80004dba <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004d16:	00004517          	auipc	a0,0x4
    80004d1a:	a9250513          	add	a0,a0,-1390 # 800087a8 <syscalls+0x2b8>
    80004d1e:	00001097          	auipc	ra,0x1
    80004d22:	1a8080e7          	jalr	424(ra) # 80005ec6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d26:	04c92703          	lw	a4,76(s2)
    80004d2a:	02000793          	li	a5,32
    80004d2e:	f6e7f9e3          	bgeu	a5,a4,80004ca0 <sys_unlink+0xaa>
    80004d32:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d36:	4741                	li	a4,16
    80004d38:	86ce                	mv	a3,s3
    80004d3a:	f1840613          	add	a2,s0,-232
    80004d3e:	4581                	li	a1,0
    80004d40:	854a                	mv	a0,s2
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	3de080e7          	jalr	990(ra) # 80003120 <readi>
    80004d4a:	47c1                	li	a5,16
    80004d4c:	00f51b63          	bne	a0,a5,80004d62 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d50:	f1845783          	lhu	a5,-232(s0)
    80004d54:	e7a1                	bnez	a5,80004d9c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d56:	29c1                	addw	s3,s3,16
    80004d58:	04c92783          	lw	a5,76(s2)
    80004d5c:	fcf9ede3          	bltu	s3,a5,80004d36 <sys_unlink+0x140>
    80004d60:	b781                	j	80004ca0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d62:	00004517          	auipc	a0,0x4
    80004d66:	a5e50513          	add	a0,a0,-1442 # 800087c0 <syscalls+0x2d0>
    80004d6a:	00001097          	auipc	ra,0x1
    80004d6e:	15c080e7          	jalr	348(ra) # 80005ec6 <panic>
    panic("unlink: writei");
    80004d72:	00004517          	auipc	a0,0x4
    80004d76:	a6650513          	add	a0,a0,-1434 # 800087d8 <syscalls+0x2e8>
    80004d7a:	00001097          	auipc	ra,0x1
    80004d7e:	14c080e7          	jalr	332(ra) # 80005ec6 <panic>
    dp->nlink--;
    80004d82:	04a4d783          	lhu	a5,74(s1)
    80004d86:	37fd                	addw	a5,a5,-1
    80004d88:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	012080e7          	jalr	18(ra) # 80002da0 <iupdate>
    80004d96:	b781                	j	80004cd6 <sys_unlink+0xe0>
    return -1;
    80004d98:	557d                	li	a0,-1
    80004d9a:	a005                	j	80004dba <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d9c:	854a                	mv	a0,s2
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	330080e7          	jalr	816(ra) # 800030ce <iunlockput>
  iunlockput(dp);
    80004da6:	8526                	mv	a0,s1
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	326080e7          	jalr	806(ra) # 800030ce <iunlockput>
  end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	adc080e7          	jalr	-1316(ra) # 8000388c <end_op>
  return -1;
    80004db8:	557d                	li	a0,-1
}
    80004dba:	70ae                	ld	ra,232(sp)
    80004dbc:	740e                	ld	s0,224(sp)
    80004dbe:	64ee                	ld	s1,216(sp)
    80004dc0:	694e                	ld	s2,208(sp)
    80004dc2:	69ae                	ld	s3,200(sp)
    80004dc4:	616d                	add	sp,sp,240
    80004dc6:	8082                	ret

0000000080004dc8 <sys_open>:

uint64
sys_open(void)
{
    80004dc8:	7131                	add	sp,sp,-192
    80004dca:	fd06                	sd	ra,184(sp)
    80004dcc:	f922                	sd	s0,176(sp)
    80004dce:	f526                	sd	s1,168(sp)
    80004dd0:	f14a                	sd	s2,160(sp)
    80004dd2:	ed4e                	sd	s3,152(sp)
    80004dd4:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004dd6:	f4c40593          	add	a1,s0,-180
    80004dda:	4505                	li	a0,1
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	470080e7          	jalr	1136(ra) # 8000224c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004de4:	08000613          	li	a2,128
    80004de8:	f5040593          	add	a1,s0,-176
    80004dec:	4501                	li	a0,0
    80004dee:	ffffd097          	auipc	ra,0xffffd
    80004df2:	49e080e7          	jalr	1182(ra) # 8000228c <argstr>
    80004df6:	87aa                	mv	a5,a0
    return -1;
    80004df8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dfa:	0a07c863          	bltz	a5,80004eaa <sys_open+0xe2>

  begin_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	a14080e7          	jalr	-1516(ra) # 80003812 <begin_op>

  if(omode & O_CREATE){
    80004e06:	f4c42783          	lw	a5,-180(s0)
    80004e0a:	2007f793          	and	a5,a5,512
    80004e0e:	cbdd                	beqz	a5,80004ec4 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004e10:	4681                	li	a3,0
    80004e12:	4601                	li	a2,0
    80004e14:	4589                	li	a1,2
    80004e16:	f5040513          	add	a0,s0,-176
    80004e1a:	00000097          	auipc	ra,0x0
    80004e1e:	97a080e7          	jalr	-1670(ra) # 80004794 <create>
    80004e22:	84aa                	mv	s1,a0
    if(ip == 0){
    80004e24:	c951                	beqz	a0,80004eb8 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e26:	04449703          	lh	a4,68(s1)
    80004e2a:	478d                	li	a5,3
    80004e2c:	00f71763          	bne	a4,a5,80004e3a <sys_open+0x72>
    80004e30:	0464d703          	lhu	a4,70(s1)
    80004e34:	47a5                	li	a5,9
    80004e36:	0ce7ec63          	bltu	a5,a4,80004f0e <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	de0080e7          	jalr	-544(ra) # 80003c1a <filealloc>
    80004e42:	892a                	mv	s2,a0
    80004e44:	c56d                	beqz	a0,80004f2e <sys_open+0x166>
    80004e46:	00000097          	auipc	ra,0x0
    80004e4a:	90c080e7          	jalr	-1780(ra) # 80004752 <fdalloc>
    80004e4e:	89aa                	mv	s3,a0
    80004e50:	0c054a63          	bltz	a0,80004f24 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e54:	04449703          	lh	a4,68(s1)
    80004e58:	478d                	li	a5,3
    80004e5a:	0ef70563          	beq	a4,a5,80004f44 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e5e:	4789                	li	a5,2
    80004e60:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e64:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e68:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e6c:	f4c42783          	lw	a5,-180(s0)
    80004e70:	0017c713          	xor	a4,a5,1
    80004e74:	8b05                	and	a4,a4,1
    80004e76:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e7a:	0037f713          	and	a4,a5,3
    80004e7e:	00e03733          	snez	a4,a4
    80004e82:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e86:	4007f793          	and	a5,a5,1024
    80004e8a:	c791                	beqz	a5,80004e96 <sys_open+0xce>
    80004e8c:	04449703          	lh	a4,68(s1)
    80004e90:	4789                	li	a5,2
    80004e92:	0cf70063          	beq	a4,a5,80004f52 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004e96:	8526                	mv	a0,s1
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	096080e7          	jalr	150(ra) # 80002f2e <iunlock>
  end_op();
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	9ec080e7          	jalr	-1556(ra) # 8000388c <end_op>

  return fd;
    80004ea8:	854e                	mv	a0,s3
}
    80004eaa:	70ea                	ld	ra,184(sp)
    80004eac:	744a                	ld	s0,176(sp)
    80004eae:	74aa                	ld	s1,168(sp)
    80004eb0:	790a                	ld	s2,160(sp)
    80004eb2:	69ea                	ld	s3,152(sp)
    80004eb4:	6129                	add	sp,sp,192
    80004eb6:	8082                	ret
      end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	9d4080e7          	jalr	-1580(ra) # 8000388c <end_op>
      return -1;
    80004ec0:	557d                	li	a0,-1
    80004ec2:	b7e5                	j	80004eaa <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004ec4:	f5040513          	add	a0,s0,-176
    80004ec8:	ffffe097          	auipc	ra,0xffffe
    80004ecc:	74a080e7          	jalr	1866(ra) # 80003612 <namei>
    80004ed0:	84aa                	mv	s1,a0
    80004ed2:	c905                	beqz	a0,80004f02 <sys_open+0x13a>
    ilock(ip);
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	f98080e7          	jalr	-104(ra) # 80002e6c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004edc:	04449703          	lh	a4,68(s1)
    80004ee0:	4785                	li	a5,1
    80004ee2:	f4f712e3          	bne	a4,a5,80004e26 <sys_open+0x5e>
    80004ee6:	f4c42783          	lw	a5,-180(s0)
    80004eea:	dba1                	beqz	a5,80004e3a <sys_open+0x72>
      iunlockput(ip);
    80004eec:	8526                	mv	a0,s1
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	1e0080e7          	jalr	480(ra) # 800030ce <iunlockput>
      end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	996080e7          	jalr	-1642(ra) # 8000388c <end_op>
      return -1;
    80004efe:	557d                	li	a0,-1
    80004f00:	b76d                	j	80004eaa <sys_open+0xe2>
      end_op();
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	98a080e7          	jalr	-1654(ra) # 8000388c <end_op>
      return -1;
    80004f0a:	557d                	li	a0,-1
    80004f0c:	bf79                	j	80004eaa <sys_open+0xe2>
    iunlockput(ip);
    80004f0e:	8526                	mv	a0,s1
    80004f10:	ffffe097          	auipc	ra,0xffffe
    80004f14:	1be080e7          	jalr	446(ra) # 800030ce <iunlockput>
    end_op();
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	974080e7          	jalr	-1676(ra) # 8000388c <end_op>
    return -1;
    80004f20:	557d                	li	a0,-1
    80004f22:	b761                	j	80004eaa <sys_open+0xe2>
      fileclose(f);
    80004f24:	854a                	mv	a0,s2
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	db0080e7          	jalr	-592(ra) # 80003cd6 <fileclose>
    iunlockput(ip);
    80004f2e:	8526                	mv	a0,s1
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	19e080e7          	jalr	414(ra) # 800030ce <iunlockput>
    end_op();
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	954080e7          	jalr	-1708(ra) # 8000388c <end_op>
    return -1;
    80004f40:	557d                	li	a0,-1
    80004f42:	b7a5                	j	80004eaa <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004f44:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004f48:	04649783          	lh	a5,70(s1)
    80004f4c:	02f91223          	sh	a5,36(s2)
    80004f50:	bf21                	j	80004e68 <sys_open+0xa0>
    itrunc(ip);
    80004f52:	8526                	mv	a0,s1
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	026080e7          	jalr	38(ra) # 80002f7a <itrunc>
    80004f5c:	bf2d                	j	80004e96 <sys_open+0xce>

0000000080004f5e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f5e:	7175                	add	sp,sp,-144
    80004f60:	e506                	sd	ra,136(sp)
    80004f62:	e122                	sd	s0,128(sp)
    80004f64:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	8ac080e7          	jalr	-1876(ra) # 80003812 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f6e:	08000613          	li	a2,128
    80004f72:	f7040593          	add	a1,s0,-144
    80004f76:	4501                	li	a0,0
    80004f78:	ffffd097          	auipc	ra,0xffffd
    80004f7c:	314080e7          	jalr	788(ra) # 8000228c <argstr>
    80004f80:	02054963          	bltz	a0,80004fb2 <sys_mkdir+0x54>
    80004f84:	4681                	li	a3,0
    80004f86:	4601                	li	a2,0
    80004f88:	4585                	li	a1,1
    80004f8a:	f7040513          	add	a0,s0,-144
    80004f8e:	00000097          	auipc	ra,0x0
    80004f92:	806080e7          	jalr	-2042(ra) # 80004794 <create>
    80004f96:	cd11                	beqz	a0,80004fb2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	136080e7          	jalr	310(ra) # 800030ce <iunlockput>
  end_op();
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	8ec080e7          	jalr	-1812(ra) # 8000388c <end_op>
  return 0;
    80004fa8:	4501                	li	a0,0
}
    80004faa:	60aa                	ld	ra,136(sp)
    80004fac:	640a                	ld	s0,128(sp)
    80004fae:	6149                	add	sp,sp,144
    80004fb0:	8082                	ret
    end_op();
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	8da080e7          	jalr	-1830(ra) # 8000388c <end_op>
    return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	b7fd                	j	80004faa <sys_mkdir+0x4c>

0000000080004fbe <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fbe:	7135                	add	sp,sp,-160
    80004fc0:	ed06                	sd	ra,152(sp)
    80004fc2:	e922                	sd	s0,144(sp)
    80004fc4:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	84c080e7          	jalr	-1972(ra) # 80003812 <begin_op>
  argint(1, &major);
    80004fce:	f6c40593          	add	a1,s0,-148
    80004fd2:	4505                	li	a0,1
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	278080e7          	jalr	632(ra) # 8000224c <argint>
  argint(2, &minor);
    80004fdc:	f6840593          	add	a1,s0,-152
    80004fe0:	4509                	li	a0,2
    80004fe2:	ffffd097          	auipc	ra,0xffffd
    80004fe6:	26a080e7          	jalr	618(ra) # 8000224c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fea:	08000613          	li	a2,128
    80004fee:	f7040593          	add	a1,s0,-144
    80004ff2:	4501                	li	a0,0
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	298080e7          	jalr	664(ra) # 8000228c <argstr>
    80004ffc:	02054b63          	bltz	a0,80005032 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005000:	f6841683          	lh	a3,-152(s0)
    80005004:	f6c41603          	lh	a2,-148(s0)
    80005008:	458d                	li	a1,3
    8000500a:	f7040513          	add	a0,s0,-144
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	786080e7          	jalr	1926(ra) # 80004794 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005016:	cd11                	beqz	a0,80005032 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	0b6080e7          	jalr	182(ra) # 800030ce <iunlockput>
  end_op();
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	86c080e7          	jalr	-1940(ra) # 8000388c <end_op>
  return 0;
    80005028:	4501                	li	a0,0
}
    8000502a:	60ea                	ld	ra,152(sp)
    8000502c:	644a                	ld	s0,144(sp)
    8000502e:	610d                	add	sp,sp,160
    80005030:	8082                	ret
    end_op();
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	85a080e7          	jalr	-1958(ra) # 8000388c <end_op>
    return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	b7fd                	j	8000502a <sys_mknod+0x6c>

000000008000503e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000503e:	7135                	add	sp,sp,-160
    80005040:	ed06                	sd	ra,152(sp)
    80005042:	e922                	sd	s0,144(sp)
    80005044:	e526                	sd	s1,136(sp)
    80005046:	e14a                	sd	s2,128(sp)
    80005048:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	fe2080e7          	jalr	-30(ra) # 8000102c <myproc>
    80005052:	892a                	mv	s2,a0
  
  begin_op();
    80005054:	ffffe097          	auipc	ra,0xffffe
    80005058:	7be080e7          	jalr	1982(ra) # 80003812 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000505c:	08000613          	li	a2,128
    80005060:	f6040593          	add	a1,s0,-160
    80005064:	4501                	li	a0,0
    80005066:	ffffd097          	auipc	ra,0xffffd
    8000506a:	226080e7          	jalr	550(ra) # 8000228c <argstr>
    8000506e:	04054b63          	bltz	a0,800050c4 <sys_chdir+0x86>
    80005072:	f6040513          	add	a0,s0,-160
    80005076:	ffffe097          	auipc	ra,0xffffe
    8000507a:	59c080e7          	jalr	1436(ra) # 80003612 <namei>
    8000507e:	84aa                	mv	s1,a0
    80005080:	c131                	beqz	a0,800050c4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005082:	ffffe097          	auipc	ra,0xffffe
    80005086:	dea080e7          	jalr	-534(ra) # 80002e6c <ilock>
  if(ip->type != T_DIR){
    8000508a:	04449703          	lh	a4,68(s1)
    8000508e:	4785                	li	a5,1
    80005090:	04f71063          	bne	a4,a5,800050d0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005094:	8526                	mv	a0,s1
    80005096:	ffffe097          	auipc	ra,0xffffe
    8000509a:	e98080e7          	jalr	-360(ra) # 80002f2e <iunlock>
  iput(p->cwd);
    8000509e:	15093503          	ld	a0,336(s2)
    800050a2:	ffffe097          	auipc	ra,0xffffe
    800050a6:	f84080e7          	jalr	-124(ra) # 80003026 <iput>
  end_op();
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	7e2080e7          	jalr	2018(ra) # 8000388c <end_op>
  p->cwd = ip;
    800050b2:	14993823          	sd	s1,336(s2)
  return 0;
    800050b6:	4501                	li	a0,0
}
    800050b8:	60ea                	ld	ra,152(sp)
    800050ba:	644a                	ld	s0,144(sp)
    800050bc:	64aa                	ld	s1,136(sp)
    800050be:	690a                	ld	s2,128(sp)
    800050c0:	610d                	add	sp,sp,160
    800050c2:	8082                	ret
    end_op();
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	7c8080e7          	jalr	1992(ra) # 8000388c <end_op>
    return -1;
    800050cc:	557d                	li	a0,-1
    800050ce:	b7ed                	j	800050b8 <sys_chdir+0x7a>
    iunlockput(ip);
    800050d0:	8526                	mv	a0,s1
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	ffc080e7          	jalr	-4(ra) # 800030ce <iunlockput>
    end_op();
    800050da:	ffffe097          	auipc	ra,0xffffe
    800050de:	7b2080e7          	jalr	1970(ra) # 8000388c <end_op>
    return -1;
    800050e2:	557d                	li	a0,-1
    800050e4:	bfd1                	j	800050b8 <sys_chdir+0x7a>

00000000800050e6 <sys_exec>:

uint64
sys_exec(void)
{
    800050e6:	7121                	add	sp,sp,-448
    800050e8:	ff06                	sd	ra,440(sp)
    800050ea:	fb22                	sd	s0,432(sp)
    800050ec:	f726                	sd	s1,424(sp)
    800050ee:	f34a                	sd	s2,416(sp)
    800050f0:	ef4e                	sd	s3,408(sp)
    800050f2:	eb52                	sd	s4,400(sp)
    800050f4:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050f6:	e4840593          	add	a1,s0,-440
    800050fa:	4505                	li	a0,1
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	170080e7          	jalr	368(ra) # 8000226c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005104:	08000613          	li	a2,128
    80005108:	f5040593          	add	a1,s0,-176
    8000510c:	4501                	li	a0,0
    8000510e:	ffffd097          	auipc	ra,0xffffd
    80005112:	17e080e7          	jalr	382(ra) # 8000228c <argstr>
    80005116:	87aa                	mv	a5,a0
    return -1;
    80005118:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000511a:	0c07c263          	bltz	a5,800051de <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    8000511e:	10000613          	li	a2,256
    80005122:	4581                	li	a1,0
    80005124:	e5040513          	add	a0,s0,-432
    80005128:	ffffb097          	auipc	ra,0xffffb
    8000512c:	1e0080e7          	jalr	480(ra) # 80000308 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005130:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005134:	89a6                	mv	s3,s1
    80005136:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005138:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000513c:	00391513          	sll	a0,s2,0x3
    80005140:	e4040593          	add	a1,s0,-448
    80005144:	e4843783          	ld	a5,-440(s0)
    80005148:	953e                	add	a0,a0,a5
    8000514a:	ffffd097          	auipc	ra,0xffffd
    8000514e:	064080e7          	jalr	100(ra) # 800021ae <fetchaddr>
    80005152:	02054a63          	bltz	a0,80005186 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005156:	e4043783          	ld	a5,-448(s0)
    8000515a:	c3b9                	beqz	a5,800051a0 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000515c:	ffffb097          	auipc	ra,0xffffb
    80005160:	038080e7          	jalr	56(ra) # 80000194 <kalloc>
    80005164:	85aa                	mv	a1,a0
    80005166:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000516a:	cd11                	beqz	a0,80005186 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000516c:	6605                	lui	a2,0x1
    8000516e:	e4043503          	ld	a0,-448(s0)
    80005172:	ffffd097          	auipc	ra,0xffffd
    80005176:	08e080e7          	jalr	142(ra) # 80002200 <fetchstr>
    8000517a:	00054663          	bltz	a0,80005186 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000517e:	0905                	add	s2,s2,1
    80005180:	09a1                	add	s3,s3,8
    80005182:	fb491de3          	bne	s2,s4,8000513c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005186:	f5040913          	add	s2,s0,-176
    8000518a:	6088                	ld	a0,0(s1)
    8000518c:	c921                	beqz	a0,800051dc <sys_exec+0xf6>
    kfree(argv[i]);
    8000518e:	ffffb097          	auipc	ra,0xffffb
    80005192:	e8e080e7          	jalr	-370(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005196:	04a1                	add	s1,s1,8
    80005198:	ff2499e3          	bne	s1,s2,8000518a <sys_exec+0xa4>
  return -1;
    8000519c:	557d                	li	a0,-1
    8000519e:	a081                	j	800051de <sys_exec+0xf8>
      argv[i] = 0;
    800051a0:	0009079b          	sext.w	a5,s2
    800051a4:	078e                	sll	a5,a5,0x3
    800051a6:	fd078793          	add	a5,a5,-48
    800051aa:	97a2                	add	a5,a5,s0
    800051ac:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800051b0:	e5040593          	add	a1,s0,-432
    800051b4:	f5040513          	add	a0,s0,-176
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	194080e7          	jalr	404(ra) # 8000434c <exec>
    800051c0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051c2:	f5040993          	add	s3,s0,-176
    800051c6:	6088                	ld	a0,0(s1)
    800051c8:	c901                	beqz	a0,800051d8 <sys_exec+0xf2>
    kfree(argv[i]);
    800051ca:	ffffb097          	auipc	ra,0xffffb
    800051ce:	e52080e7          	jalr	-430(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051d2:	04a1                	add	s1,s1,8
    800051d4:	ff3499e3          	bne	s1,s3,800051c6 <sys_exec+0xe0>
  return ret;
    800051d8:	854a                	mv	a0,s2
    800051da:	a011                	j	800051de <sys_exec+0xf8>
  return -1;
    800051dc:	557d                	li	a0,-1
}
    800051de:	70fa                	ld	ra,440(sp)
    800051e0:	745a                	ld	s0,432(sp)
    800051e2:	74ba                	ld	s1,424(sp)
    800051e4:	791a                	ld	s2,416(sp)
    800051e6:	69fa                	ld	s3,408(sp)
    800051e8:	6a5a                	ld	s4,400(sp)
    800051ea:	6139                	add	sp,sp,448
    800051ec:	8082                	ret

00000000800051ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800051ee:	7139                	add	sp,sp,-64
    800051f0:	fc06                	sd	ra,56(sp)
    800051f2:	f822                	sd	s0,48(sp)
    800051f4:	f426                	sd	s1,40(sp)
    800051f6:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	e34080e7          	jalr	-460(ra) # 8000102c <myproc>
    80005200:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005202:	fd840593          	add	a1,s0,-40
    80005206:	4501                	li	a0,0
    80005208:	ffffd097          	auipc	ra,0xffffd
    8000520c:	064080e7          	jalr	100(ra) # 8000226c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005210:	fc840593          	add	a1,s0,-56
    80005214:	fd040513          	add	a0,s0,-48
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	dea080e7          	jalr	-534(ra) # 80004002 <pipealloc>
    return -1;
    80005220:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005222:	0c054463          	bltz	a0,800052ea <sys_pipe+0xfc>
  fd0 = -1;
    80005226:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000522a:	fd043503          	ld	a0,-48(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	524080e7          	jalr	1316(ra) # 80004752 <fdalloc>
    80005236:	fca42223          	sw	a0,-60(s0)
    8000523a:	08054b63          	bltz	a0,800052d0 <sys_pipe+0xe2>
    8000523e:	fc843503          	ld	a0,-56(s0)
    80005242:	fffff097          	auipc	ra,0xfffff
    80005246:	510080e7          	jalr	1296(ra) # 80004752 <fdalloc>
    8000524a:	fca42023          	sw	a0,-64(s0)
    8000524e:	06054863          	bltz	a0,800052be <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005252:	4691                	li	a3,4
    80005254:	fc440613          	add	a2,s0,-60
    80005258:	fd843583          	ld	a1,-40(s0)
    8000525c:	68a8                	ld	a0,80(s1)
    8000525e:	ffffc097          	auipc	ra,0xffffc
    80005262:	a5a080e7          	jalr	-1446(ra) # 80000cb8 <copyout>
    80005266:	02054063          	bltz	a0,80005286 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000526a:	4691                	li	a3,4
    8000526c:	fc040613          	add	a2,s0,-64
    80005270:	fd843583          	ld	a1,-40(s0)
    80005274:	0591                	add	a1,a1,4
    80005276:	68a8                	ld	a0,80(s1)
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	a40080e7          	jalr	-1472(ra) # 80000cb8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005280:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005282:	06055463          	bgez	a0,800052ea <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005286:	fc442783          	lw	a5,-60(s0)
    8000528a:	07e9                	add	a5,a5,26
    8000528c:	078e                	sll	a5,a5,0x3
    8000528e:	97a6                	add	a5,a5,s1
    80005290:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005294:	fc042783          	lw	a5,-64(s0)
    80005298:	07e9                	add	a5,a5,26
    8000529a:	078e                	sll	a5,a5,0x3
    8000529c:	94be                	add	s1,s1,a5
    8000529e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052a2:	fd043503          	ld	a0,-48(s0)
    800052a6:	fffff097          	auipc	ra,0xfffff
    800052aa:	a30080e7          	jalr	-1488(ra) # 80003cd6 <fileclose>
    fileclose(wf);
    800052ae:	fc843503          	ld	a0,-56(s0)
    800052b2:	fffff097          	auipc	ra,0xfffff
    800052b6:	a24080e7          	jalr	-1500(ra) # 80003cd6 <fileclose>
    return -1;
    800052ba:	57fd                	li	a5,-1
    800052bc:	a03d                	j	800052ea <sys_pipe+0xfc>
    if(fd0 >= 0)
    800052be:	fc442783          	lw	a5,-60(s0)
    800052c2:	0007c763          	bltz	a5,800052d0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800052c6:	07e9                	add	a5,a5,26
    800052c8:	078e                	sll	a5,a5,0x3
    800052ca:	97a6                	add	a5,a5,s1
    800052cc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052d0:	fd043503          	ld	a0,-48(s0)
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	a02080e7          	jalr	-1534(ra) # 80003cd6 <fileclose>
    fileclose(wf);
    800052dc:	fc843503          	ld	a0,-56(s0)
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	9f6080e7          	jalr	-1546(ra) # 80003cd6 <fileclose>
    return -1;
    800052e8:	57fd                	li	a5,-1
}
    800052ea:	853e                	mv	a0,a5
    800052ec:	70e2                	ld	ra,56(sp)
    800052ee:	7442                	ld	s0,48(sp)
    800052f0:	74a2                	ld	s1,40(sp)
    800052f2:	6121                	add	sp,sp,64
    800052f4:	8082                	ret
	...

0000000080005300 <kernelvec>:
    80005300:	7111                	add	sp,sp,-256
    80005302:	e006                	sd	ra,0(sp)
    80005304:	e40a                	sd	sp,8(sp)
    80005306:	e80e                	sd	gp,16(sp)
    80005308:	ec12                	sd	tp,24(sp)
    8000530a:	f016                	sd	t0,32(sp)
    8000530c:	f41a                	sd	t1,40(sp)
    8000530e:	f81e                	sd	t2,48(sp)
    80005310:	fc22                	sd	s0,56(sp)
    80005312:	e0a6                	sd	s1,64(sp)
    80005314:	e4aa                	sd	a0,72(sp)
    80005316:	e8ae                	sd	a1,80(sp)
    80005318:	ecb2                	sd	a2,88(sp)
    8000531a:	f0b6                	sd	a3,96(sp)
    8000531c:	f4ba                	sd	a4,104(sp)
    8000531e:	f8be                	sd	a5,112(sp)
    80005320:	fcc2                	sd	a6,120(sp)
    80005322:	e146                	sd	a7,128(sp)
    80005324:	e54a                	sd	s2,136(sp)
    80005326:	e94e                	sd	s3,144(sp)
    80005328:	ed52                	sd	s4,152(sp)
    8000532a:	f156                	sd	s5,160(sp)
    8000532c:	f55a                	sd	s6,168(sp)
    8000532e:	f95e                	sd	s7,176(sp)
    80005330:	fd62                	sd	s8,184(sp)
    80005332:	e1e6                	sd	s9,192(sp)
    80005334:	e5ea                	sd	s10,200(sp)
    80005336:	e9ee                	sd	s11,208(sp)
    80005338:	edf2                	sd	t3,216(sp)
    8000533a:	f1f6                	sd	t4,224(sp)
    8000533c:	f5fa                	sd	t5,232(sp)
    8000533e:	f9fe                	sd	t6,240(sp)
    80005340:	d3bfc0ef          	jal	8000207a <kerneltrap>
    80005344:	6082                	ld	ra,0(sp)
    80005346:	6122                	ld	sp,8(sp)
    80005348:	61c2                	ld	gp,16(sp)
    8000534a:	7282                	ld	t0,32(sp)
    8000534c:	7322                	ld	t1,40(sp)
    8000534e:	73c2                	ld	t2,48(sp)
    80005350:	7462                	ld	s0,56(sp)
    80005352:	6486                	ld	s1,64(sp)
    80005354:	6526                	ld	a0,72(sp)
    80005356:	65c6                	ld	a1,80(sp)
    80005358:	6666                	ld	a2,88(sp)
    8000535a:	7686                	ld	a3,96(sp)
    8000535c:	7726                	ld	a4,104(sp)
    8000535e:	77c6                	ld	a5,112(sp)
    80005360:	7866                	ld	a6,120(sp)
    80005362:	688a                	ld	a7,128(sp)
    80005364:	692a                	ld	s2,136(sp)
    80005366:	69ca                	ld	s3,144(sp)
    80005368:	6a6a                	ld	s4,152(sp)
    8000536a:	7a8a                	ld	s5,160(sp)
    8000536c:	7b2a                	ld	s6,168(sp)
    8000536e:	7bca                	ld	s7,176(sp)
    80005370:	7c6a                	ld	s8,184(sp)
    80005372:	6c8e                	ld	s9,192(sp)
    80005374:	6d2e                	ld	s10,200(sp)
    80005376:	6dce                	ld	s11,208(sp)
    80005378:	6e6e                	ld	t3,216(sp)
    8000537a:	7e8e                	ld	t4,224(sp)
    8000537c:	7f2e                	ld	t5,232(sp)
    8000537e:	7fce                	ld	t6,240(sp)
    80005380:	6111                	add	sp,sp,256
    80005382:	10200073          	sret
    80005386:	00000013          	nop
    8000538a:	00000013          	nop
    8000538e:	0001                	nop

0000000080005390 <timervec>:
    80005390:	34051573          	csrrw	a0,mscratch,a0
    80005394:	e10c                	sd	a1,0(a0)
    80005396:	e510                	sd	a2,8(a0)
    80005398:	e914                	sd	a3,16(a0)
    8000539a:	6d0c                	ld	a1,24(a0)
    8000539c:	7110                	ld	a2,32(a0)
    8000539e:	6194                	ld	a3,0(a1)
    800053a0:	96b2                	add	a3,a3,a2
    800053a2:	e194                	sd	a3,0(a1)
    800053a4:	4589                	li	a1,2
    800053a6:	14459073          	csrw	sip,a1
    800053aa:	6914                	ld	a3,16(a0)
    800053ac:	6510                	ld	a2,8(a0)
    800053ae:	610c                	ld	a1,0(a0)
    800053b0:	34051573          	csrrw	a0,mscratch,a0
    800053b4:	30200073          	mret
	...

00000000800053ba <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    800053ba:	1141                	add	sp,sp,-16
    800053bc:	e422                	sd	s0,8(sp)
    800053be:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053c0:	0c0007b7          	lui	a5,0xc000
    800053c4:	4705                	li	a4,1
    800053c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053c8:	c3d8                	sw	a4,4(a5)
}
    800053ca:	6422                	ld	s0,8(sp)
    800053cc:	0141                	add	sp,sp,16
    800053ce:	8082                	ret

00000000800053d0 <plicinithart>:

void
plicinithart(void)
{
    800053d0:	1141                	add	sp,sp,-16
    800053d2:	e406                	sd	ra,8(sp)
    800053d4:	e022                	sd	s0,0(sp)
    800053d6:	0800                	add	s0,sp,16
  int hart = cpuid();
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	c28080e7          	jalr	-984(ra) # 80001000 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053e0:	0085171b          	sllw	a4,a0,0x8
    800053e4:	0c0027b7          	lui	a5,0xc002
    800053e8:	97ba                	add	a5,a5,a4
    800053ea:	40200713          	li	a4,1026
    800053ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053f2:	00d5151b          	sllw	a0,a0,0xd
    800053f6:	0c2017b7          	lui	a5,0xc201
    800053fa:	97aa                	add	a5,a5,a0
    800053fc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	add	sp,sp,16
    80005406:	8082                	ret

0000000080005408 <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005408:	1141                	add	sp,sp,-16
    8000540a:	e406                	sd	ra,8(sp)
    8000540c:	e022                	sd	s0,0(sp)
    8000540e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005410:	ffffc097          	auipc	ra,0xffffc
    80005414:	bf0080e7          	jalr	-1040(ra) # 80001000 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005418:	00d5151b          	sllw	a0,a0,0xd
    8000541c:	0c2017b7          	lui	a5,0xc201
    80005420:	97aa                	add	a5,a5,a0
  return irq;
}
    80005422:	43c8                	lw	a0,4(a5)
    80005424:	60a2                	ld	ra,8(sp)
    80005426:	6402                	ld	s0,0(sp)
    80005428:	0141                	add	sp,sp,16
    8000542a:	8082                	ret

000000008000542c <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    8000542c:	1101                	add	sp,sp,-32
    8000542e:	ec06                	sd	ra,24(sp)
    80005430:	e822                	sd	s0,16(sp)
    80005432:	e426                	sd	s1,8(sp)
    80005434:	1000                	add	s0,sp,32
    80005436:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	bc8080e7          	jalr	-1080(ra) # 80001000 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005440:	00d5151b          	sllw	a0,a0,0xd
    80005444:	0c2017b7          	lui	a5,0xc201
    80005448:	97aa                	add	a5,a5,a0
    8000544a:	c3c4                	sw	s1,4(a5)
}
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	64a2                	ld	s1,8(sp)
    80005452:	6105                	add	sp,sp,32
    80005454:	8082                	ret

0000000080005456 <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    80005456:	1141                	add	sp,sp,-16
    80005458:	e406                	sd	ra,8(sp)
    8000545a:	e022                	sd	s0,0(sp)
    8000545c:	0800                	add	s0,sp,16
  if(i >= NUM)
    8000545e:	479d                	li	a5,7
    80005460:	04a7cc63          	blt	a5,a0,800054b8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005464:	00035797          	auipc	a5,0x35
    80005468:	93478793          	add	a5,a5,-1740 # 80039d98 <disk>
    8000546c:	97aa                	add	a5,a5,a0
    8000546e:	0187c783          	lbu	a5,24(a5)
    80005472:	ebb9                	bnez	a5,800054c8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005474:	00451693          	sll	a3,a0,0x4
    80005478:	00035797          	auipc	a5,0x35
    8000547c:	92078793          	add	a5,a5,-1760 # 80039d98 <disk>
    80005480:	6398                	ld	a4,0(a5)
    80005482:	9736                	add	a4,a4,a3
    80005484:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005488:	6398                	ld	a4,0(a5)
    8000548a:	9736                	add	a4,a4,a3
    8000548c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005490:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005494:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005498:	97aa                	add	a5,a5,a0
    8000549a:	4705                	li	a4,1
    8000549c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800054a0:	00035517          	auipc	a0,0x35
    800054a4:	91050513          	add	a0,a0,-1776 # 80039db0 <disk+0x18>
    800054a8:	ffffc097          	auipc	ra,0xffffc
    800054ac:	29c080e7          	jalr	668(ra) # 80001744 <wakeup>
}
    800054b0:	60a2                	ld	ra,8(sp)
    800054b2:	6402                	ld	s0,0(sp)
    800054b4:	0141                	add	sp,sp,16
    800054b6:	8082                	ret
    panic("free_desc 1");
    800054b8:	00003517          	auipc	a0,0x3
    800054bc:	33050513          	add	a0,a0,816 # 800087e8 <syscalls+0x2f8>
    800054c0:	00001097          	auipc	ra,0x1
    800054c4:	a06080e7          	jalr	-1530(ra) # 80005ec6 <panic>
    panic("free_desc 2");
    800054c8:	00003517          	auipc	a0,0x3
    800054cc:	33050513          	add	a0,a0,816 # 800087f8 <syscalls+0x308>
    800054d0:	00001097          	auipc	ra,0x1
    800054d4:	9f6080e7          	jalr	-1546(ra) # 80005ec6 <panic>

00000000800054d8 <virtio_disk_init>:
{
    800054d8:	1101                	add	sp,sp,-32
    800054da:	ec06                	sd	ra,24(sp)
    800054dc:	e822                	sd	s0,16(sp)
    800054de:	e426                	sd	s1,8(sp)
    800054e0:	e04a                	sd	s2,0(sp)
    800054e2:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054e4:	00003597          	auipc	a1,0x3
    800054e8:	32458593          	add	a1,a1,804 # 80008808 <syscalls+0x318>
    800054ec:	00035517          	auipc	a0,0x35
    800054f0:	9d450513          	add	a0,a0,-1580 # 80039ec0 <disk+0x128>
    800054f4:	00001097          	auipc	ra,0x1
    800054f8:	e7a080e7          	jalr	-390(ra) # 8000636e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054fc:	100017b7          	lui	a5,0x10001
    80005500:	4398                	lw	a4,0(a5)
    80005502:	2701                	sext.w	a4,a4
    80005504:	747277b7          	lui	a5,0x74727
    80005508:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000550c:	14f71b63          	bne	a4,a5,80005662 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005510:	100017b7          	lui	a5,0x10001
    80005514:	43dc                	lw	a5,4(a5)
    80005516:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005518:	4709                	li	a4,2
    8000551a:	14e79463          	bne	a5,a4,80005662 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000551e:	100017b7          	lui	a5,0x10001
    80005522:	479c                	lw	a5,8(a5)
    80005524:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005526:	12e79e63          	bne	a5,a4,80005662 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000552a:	100017b7          	lui	a5,0x10001
    8000552e:	47d8                	lw	a4,12(a5)
    80005530:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005532:	554d47b7          	lui	a5,0x554d4
    80005536:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000553a:	12f71463          	bne	a4,a5,80005662 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000553e:	100017b7          	lui	a5,0x10001
    80005542:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005546:	4705                	li	a4,1
    80005548:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000554a:	470d                	li	a4,3
    8000554c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000554e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005550:	c7ffe6b7          	lui	a3,0xc7ffe
    80005554:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fbc63f>
    80005558:	8f75                	and	a4,a4,a3
    8000555a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555c:	472d                	li	a4,11
    8000555e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005560:	5bbc                	lw	a5,112(a5)
    80005562:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005566:	8ba1                	and	a5,a5,8
    80005568:	10078563          	beqz	a5,80005672 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000556c:	100017b7          	lui	a5,0x10001
    80005570:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005574:	43fc                	lw	a5,68(a5)
    80005576:	2781                	sext.w	a5,a5
    80005578:	10079563          	bnez	a5,80005682 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	5bdc                	lw	a5,52(a5)
    80005582:	2781                	sext.w	a5,a5
  if(max == 0)
    80005584:	10078763          	beqz	a5,80005692 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005588:	471d                	li	a4,7
    8000558a:	10f77c63          	bgeu	a4,a5,800056a2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000558e:	ffffb097          	auipc	ra,0xffffb
    80005592:	c06080e7          	jalr	-1018(ra) # 80000194 <kalloc>
    80005596:	00035497          	auipc	s1,0x35
    8000559a:	80248493          	add	s1,s1,-2046 # 80039d98 <disk>
    8000559e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800055a0:	ffffb097          	auipc	ra,0xffffb
    800055a4:	bf4080e7          	jalr	-1036(ra) # 80000194 <kalloc>
    800055a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800055aa:	ffffb097          	auipc	ra,0xffffb
    800055ae:	bea080e7          	jalr	-1046(ra) # 80000194 <kalloc>
    800055b2:	87aa                	mv	a5,a0
    800055b4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800055b6:	6088                	ld	a0,0(s1)
    800055b8:	cd6d                	beqz	a0,800056b2 <virtio_disk_init+0x1da>
    800055ba:	00034717          	auipc	a4,0x34
    800055be:	7e673703          	ld	a4,2022(a4) # 80039da0 <disk+0x8>
    800055c2:	cb65                	beqz	a4,800056b2 <virtio_disk_init+0x1da>
    800055c4:	c7fd                	beqz	a5,800056b2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800055c6:	6605                	lui	a2,0x1
    800055c8:	4581                	li	a1,0
    800055ca:	ffffb097          	auipc	ra,0xffffb
    800055ce:	d3e080e7          	jalr	-706(ra) # 80000308 <memset>
  memset(disk.avail, 0, PGSIZE);
    800055d2:	00034497          	auipc	s1,0x34
    800055d6:	7c648493          	add	s1,s1,1990 # 80039d98 <disk>
    800055da:	6605                	lui	a2,0x1
    800055dc:	4581                	li	a1,0
    800055de:	6488                	ld	a0,8(s1)
    800055e0:	ffffb097          	auipc	ra,0xffffb
    800055e4:	d28080e7          	jalr	-728(ra) # 80000308 <memset>
  memset(disk.used, 0, PGSIZE);
    800055e8:	6605                	lui	a2,0x1
    800055ea:	4581                	li	a1,0
    800055ec:	6888                	ld	a0,16(s1)
    800055ee:	ffffb097          	auipc	ra,0xffffb
    800055f2:	d1a080e7          	jalr	-742(ra) # 80000308 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055f6:	100017b7          	lui	a5,0x10001
    800055fa:	4721                	li	a4,8
    800055fc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055fe:	4098                	lw	a4,0(s1)
    80005600:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005604:	40d8                	lw	a4,4(s1)
    80005606:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000560a:	6498                	ld	a4,8(s1)
    8000560c:	0007069b          	sext.w	a3,a4
    80005610:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005614:	9701                	sra	a4,a4,0x20
    80005616:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000561a:	6898                	ld	a4,16(s1)
    8000561c:	0007069b          	sext.w	a3,a4
    80005620:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005624:	9701                	sra	a4,a4,0x20
    80005626:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000562a:	4705                	li	a4,1
    8000562c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000562e:	00e48c23          	sb	a4,24(s1)
    80005632:	00e48ca3          	sb	a4,25(s1)
    80005636:	00e48d23          	sb	a4,26(s1)
    8000563a:	00e48da3          	sb	a4,27(s1)
    8000563e:	00e48e23          	sb	a4,28(s1)
    80005642:	00e48ea3          	sb	a4,29(s1)
    80005646:	00e48f23          	sb	a4,30(s1)
    8000564a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000564e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005652:	0727a823          	sw	s2,112(a5)
}
    80005656:	60e2                	ld	ra,24(sp)
    80005658:	6442                	ld	s0,16(sp)
    8000565a:	64a2                	ld	s1,8(sp)
    8000565c:	6902                	ld	s2,0(sp)
    8000565e:	6105                	add	sp,sp,32
    80005660:	8082                	ret
    panic("could not find virtio disk");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	1b650513          	add	a0,a0,438 # 80008818 <syscalls+0x328>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	85c080e7          	jalr	-1956(ra) # 80005ec6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	1c650513          	add	a0,a0,454 # 80008838 <syscalls+0x348>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	84c080e7          	jalr	-1972(ra) # 80005ec6 <panic>
    panic("virtio disk should not be ready");
    80005682:	00003517          	auipc	a0,0x3
    80005686:	1d650513          	add	a0,a0,470 # 80008858 <syscalls+0x368>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	83c080e7          	jalr	-1988(ra) # 80005ec6 <panic>
    panic("virtio disk has no queue 0");
    80005692:	00003517          	auipc	a0,0x3
    80005696:	1e650513          	add	a0,a0,486 # 80008878 <syscalls+0x388>
    8000569a:	00001097          	auipc	ra,0x1
    8000569e:	82c080e7          	jalr	-2004(ra) # 80005ec6 <panic>
    panic("virtio disk max queue too short");
    800056a2:	00003517          	auipc	a0,0x3
    800056a6:	1f650513          	add	a0,a0,502 # 80008898 <syscalls+0x3a8>
    800056aa:	00001097          	auipc	ra,0x1
    800056ae:	81c080e7          	jalr	-2020(ra) # 80005ec6 <panic>
    panic("virtio disk kalloc");
    800056b2:	00003517          	auipc	a0,0x3
    800056b6:	20650513          	add	a0,a0,518 # 800088b8 <syscalls+0x3c8>
    800056ba:	00001097          	auipc	ra,0x1
    800056be:	80c080e7          	jalr	-2036(ra) # 80005ec6 <panic>

00000000800056c2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800056c2:	7159                	add	sp,sp,-112
    800056c4:	f486                	sd	ra,104(sp)
    800056c6:	f0a2                	sd	s0,96(sp)
    800056c8:	eca6                	sd	s1,88(sp)
    800056ca:	e8ca                	sd	s2,80(sp)
    800056cc:	e4ce                	sd	s3,72(sp)
    800056ce:	e0d2                	sd	s4,64(sp)
    800056d0:	fc56                	sd	s5,56(sp)
    800056d2:	f85a                	sd	s6,48(sp)
    800056d4:	f45e                	sd	s7,40(sp)
    800056d6:	f062                	sd	s8,32(sp)
    800056d8:	ec66                	sd	s9,24(sp)
    800056da:	e86a                	sd	s10,16(sp)
    800056dc:	1880                	add	s0,sp,112
    800056de:	8a2a                	mv	s4,a0
    800056e0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056e2:	00c52c83          	lw	s9,12(a0)
    800056e6:	001c9c9b          	sllw	s9,s9,0x1
    800056ea:	1c82                	sll	s9,s9,0x20
    800056ec:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056f0:	00034517          	auipc	a0,0x34
    800056f4:	7d050513          	add	a0,a0,2000 # 80039ec0 <disk+0x128>
    800056f8:	00001097          	auipc	ra,0x1
    800056fc:	d06080e7          	jalr	-762(ra) # 800063fe <acquire>
  for(int i = 0; i < 3; i++){
    80005700:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005702:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005704:	00034b17          	auipc	s6,0x34
    80005708:	694b0b13          	add	s6,s6,1684 # 80039d98 <disk>
  for(int i = 0; i < 3; i++){
    8000570c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000570e:	00034c17          	auipc	s8,0x34
    80005712:	7b2c0c13          	add	s8,s8,1970 # 80039ec0 <disk+0x128>
    80005716:	a095                	j	8000577a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005718:	00fb0733          	add	a4,s6,a5
    8000571c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005720:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005722:	0207c563          	bltz	a5,8000574c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005726:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005728:	0591                	add	a1,a1,4
    8000572a:	05560d63          	beq	a2,s5,80005784 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000572e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005730:	00034717          	auipc	a4,0x34
    80005734:	66870713          	add	a4,a4,1640 # 80039d98 <disk>
    80005738:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000573a:	01874683          	lbu	a3,24(a4)
    8000573e:	fee9                	bnez	a3,80005718 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005740:	2785                	addw	a5,a5,1
    80005742:	0705                	add	a4,a4,1
    80005744:	fe979be3          	bne	a5,s1,8000573a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005748:	57fd                	li	a5,-1
    8000574a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000574c:	00c05e63          	blez	a2,80005768 <virtio_disk_rw+0xa6>
    80005750:	060a                	sll	a2,a2,0x2
    80005752:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005756:	0009a503          	lw	a0,0(s3)
    8000575a:	00000097          	auipc	ra,0x0
    8000575e:	cfc080e7          	jalr	-772(ra) # 80005456 <free_desc>
      for(int j = 0; j < i; j++)
    80005762:	0991                	add	s3,s3,4
    80005764:	ffa999e3          	bne	s3,s10,80005756 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005768:	85e2                	mv	a1,s8
    8000576a:	00034517          	auipc	a0,0x34
    8000576e:	64650513          	add	a0,a0,1606 # 80039db0 <disk+0x18>
    80005772:	ffffc097          	auipc	ra,0xffffc
    80005776:	f6e080e7          	jalr	-146(ra) # 800016e0 <sleep>
  for(int i = 0; i < 3; i++){
    8000577a:	f9040993          	add	s3,s0,-112
{
    8000577e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005780:	864a                	mv	a2,s2
    80005782:	b775                	j	8000572e <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005784:	f9042503          	lw	a0,-112(s0)
    80005788:	00a50713          	add	a4,a0,10
    8000578c:	0712                	sll	a4,a4,0x4

  if(write)
    8000578e:	00034797          	auipc	a5,0x34
    80005792:	60a78793          	add	a5,a5,1546 # 80039d98 <disk>
    80005796:	00e786b3          	add	a3,a5,a4
    8000579a:	01703633          	snez	a2,s7
    8000579e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    800057a0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800057a4:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057a8:	f6070613          	add	a2,a4,-160
    800057ac:	6394                	ld	a3,0(a5)
    800057ae:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057b0:	00870593          	add	a1,a4,8
    800057b4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057b6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057b8:	0007b803          	ld	a6,0(a5)
    800057bc:	9642                	add	a2,a2,a6
    800057be:	46c1                	li	a3,16
    800057c0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057c2:	4585                	li	a1,1
    800057c4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800057c8:	f9442683          	lw	a3,-108(s0)
    800057cc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800057d0:	0692                	sll	a3,a3,0x4
    800057d2:	9836                	add	a6,a6,a3
    800057d4:	058a0613          	add	a2,s4,88
    800057d8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800057dc:	0007b803          	ld	a6,0(a5)
    800057e0:	96c2                	add	a3,a3,a6
    800057e2:	40000613          	li	a2,1024
    800057e6:	c690                	sw	a2,8(a3)
  if(write)
    800057e8:	001bb613          	seqz	a2,s7
    800057ec:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057f0:	00166613          	or	a2,a2,1
    800057f4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800057f8:	f9842603          	lw	a2,-104(s0)
    800057fc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    80005800:	00250693          	add	a3,a0,2
    80005804:	0692                	sll	a3,a3,0x4
    80005806:	96be                	add	a3,a3,a5
    80005808:	58fd                	li	a7,-1
    8000580a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000580e:	0612                	sll	a2,a2,0x4
    80005810:	9832                	add	a6,a6,a2
    80005812:	f9070713          	add	a4,a4,-112
    80005816:	973e                	add	a4,a4,a5
    80005818:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000581c:	6398                	ld	a4,0(a5)
    8000581e:	9732                	add	a4,a4,a2
    80005820:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    80005822:	4609                	li	a2,2
    80005824:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005828:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    8000582c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005830:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005834:	6794                	ld	a3,8(a5)
    80005836:	0026d703          	lhu	a4,2(a3)
    8000583a:	8b1d                	and	a4,a4,7
    8000583c:	0706                	sll	a4,a4,0x1
    8000583e:	96ba                	add	a3,a3,a4
    80005840:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005844:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    80005848:	6798                	ld	a4,8(a5)
    8000584a:	00275783          	lhu	a5,2(a4)
    8000584e:	2785                	addw	a5,a5,1
    80005850:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005854:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    80005858:	100017b7          	lui	a5,0x10001
    8000585c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    80005860:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005864:	00034917          	auipc	s2,0x34
    80005868:	65c90913          	add	s2,s2,1628 # 80039ec0 <disk+0x128>
  while(b->disk == 1) {
    8000586c:	4485                	li	s1,1
    8000586e:	00b79c63          	bne	a5,a1,80005886 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005872:	85ca                	mv	a1,s2
    80005874:	8552                	mv	a0,s4
    80005876:	ffffc097          	auipc	ra,0xffffc
    8000587a:	e6a080e7          	jalr	-406(ra) # 800016e0 <sleep>
  while(b->disk == 1) {
    8000587e:	004a2783          	lw	a5,4(s4)
    80005882:	fe9788e3          	beq	a5,s1,80005872 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005886:	f9042903          	lw	s2,-112(s0)
    8000588a:	00290713          	add	a4,s2,2
    8000588e:	0712                	sll	a4,a4,0x4
    80005890:	00034797          	auipc	a5,0x34
    80005894:	50878793          	add	a5,a5,1288 # 80039d98 <disk>
    80005898:	97ba                	add	a5,a5,a4
    8000589a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000589e:	00034997          	auipc	s3,0x34
    800058a2:	4fa98993          	add	s3,s3,1274 # 80039d98 <disk>
    800058a6:	00491713          	sll	a4,s2,0x4
    800058aa:	0009b783          	ld	a5,0(s3)
    800058ae:	97ba                	add	a5,a5,a4
    800058b0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058b4:	854a                	mv	a0,s2
    800058b6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058ba:	00000097          	auipc	ra,0x0
    800058be:	b9c080e7          	jalr	-1124(ra) # 80005456 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058c2:	8885                	and	s1,s1,1
    800058c4:	f0ed                	bnez	s1,800058a6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058c6:	00034517          	auipc	a0,0x34
    800058ca:	5fa50513          	add	a0,a0,1530 # 80039ec0 <disk+0x128>
    800058ce:	00001097          	auipc	ra,0x1
    800058d2:	be4080e7          	jalr	-1052(ra) # 800064b2 <release>
}
    800058d6:	70a6                	ld	ra,104(sp)
    800058d8:	7406                	ld	s0,96(sp)
    800058da:	64e6                	ld	s1,88(sp)
    800058dc:	6946                	ld	s2,80(sp)
    800058de:	69a6                	ld	s3,72(sp)
    800058e0:	6a06                	ld	s4,64(sp)
    800058e2:	7ae2                	ld	s5,56(sp)
    800058e4:	7b42                	ld	s6,48(sp)
    800058e6:	7ba2                	ld	s7,40(sp)
    800058e8:	7c02                	ld	s8,32(sp)
    800058ea:	6ce2                	ld	s9,24(sp)
    800058ec:	6d42                	ld	s10,16(sp)
    800058ee:	6165                	add	sp,sp,112
    800058f0:	8082                	ret

00000000800058f2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058f2:	1101                	add	sp,sp,-32
    800058f4:	ec06                	sd	ra,24(sp)
    800058f6:	e822                	sd	s0,16(sp)
    800058f8:	e426                	sd	s1,8(sp)
    800058fa:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058fc:	00034497          	auipc	s1,0x34
    80005900:	49c48493          	add	s1,s1,1180 # 80039d98 <disk>
    80005904:	00034517          	auipc	a0,0x34
    80005908:	5bc50513          	add	a0,a0,1468 # 80039ec0 <disk+0x128>
    8000590c:	00001097          	auipc	ra,0x1
    80005910:	af2080e7          	jalr	-1294(ra) # 800063fe <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005914:	10001737          	lui	a4,0x10001
    80005918:	533c                	lw	a5,96(a4)
    8000591a:	8b8d                	and	a5,a5,3
    8000591c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000591e:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    80005922:	689c                	ld	a5,16(s1)
    80005924:	0204d703          	lhu	a4,32(s1)
    80005928:	0027d783          	lhu	a5,2(a5)
    8000592c:	04f70863          	beq	a4,a5,8000597c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005930:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005934:	6898                	ld	a4,16(s1)
    80005936:	0204d783          	lhu	a5,32(s1)
    8000593a:	8b9d                	and	a5,a5,7
    8000593c:	078e                	sll	a5,a5,0x3
    8000593e:	97ba                	add	a5,a5,a4
    80005940:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005942:	00278713          	add	a4,a5,2
    80005946:	0712                	sll	a4,a4,0x4
    80005948:	9726                	add	a4,a4,s1
    8000594a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000594e:	e721                	bnez	a4,80005996 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005950:	0789                	add	a5,a5,2
    80005952:	0792                	sll	a5,a5,0x4
    80005954:	97a6                	add	a5,a5,s1
    80005956:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    80005958:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	de8080e7          	jalr	-536(ra) # 80001744 <wakeup>

    disk.used_idx += 1;
    80005964:	0204d783          	lhu	a5,32(s1)
    80005968:	2785                	addw	a5,a5,1
    8000596a:	17c2                	sll	a5,a5,0x30
    8000596c:	93c1                	srl	a5,a5,0x30
    8000596e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005972:	6898                	ld	a4,16(s1)
    80005974:	00275703          	lhu	a4,2(a4)
    80005978:	faf71ce3          	bne	a4,a5,80005930 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000597c:	00034517          	auipc	a0,0x34
    80005980:	54450513          	add	a0,a0,1348 # 80039ec0 <disk+0x128>
    80005984:	00001097          	auipc	ra,0x1
    80005988:	b2e080e7          	jalr	-1234(ra) # 800064b2 <release>
}
    8000598c:	60e2                	ld	ra,24(sp)
    8000598e:	6442                	ld	s0,16(sp)
    80005990:	64a2                	ld	s1,8(sp)
    80005992:	6105                	add	sp,sp,32
    80005994:	8082                	ret
      panic("virtio_disk_intr status");
    80005996:	00003517          	auipc	a0,0x3
    8000599a:	f3a50513          	add	a0,a0,-198 # 800088d0 <syscalls+0x3e0>
    8000599e:	00000097          	auipc	ra,0x0
    800059a2:	528080e7          	jalr	1320(ra) # 80005ec6 <panic>

00000000800059a6 <timerinit>:
/* at timervec in kernelvec.S, */
/* which turns them into software interrupts for */
/* devintr() in trap.c. */
void
timerinit()
{
    800059a6:	1141                	add	sp,sp,-16
    800059a8:	e422                	sd	s0,8(sp)
    800059aa:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059ac:	f14027f3          	csrr	a5,mhartid
  /* each CPU has a separate source of timer interrupts. */
  int id = r_mhartid();
    800059b0:	0007859b          	sext.w	a1,a5

  /* ask the CLINT for a timer interrupt. */
  int interval = 1000000; /* cycles; about 1/10th second in qemu. */
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059b4:	0037979b          	sllw	a5,a5,0x3
    800059b8:	02004737          	lui	a4,0x2004
    800059bc:	97ba                	add	a5,a5,a4
    800059be:	0200c737          	lui	a4,0x200c
    800059c2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059c6:	000f4637          	lui	a2,0xf4
    800059ca:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059ce:	9732                	add	a4,a4,a2
    800059d0:	e398                	sd	a4,0(a5)

  /* prepare information in scratch[] for timervec. */
  /* scratch[0..2] : space for timervec to save registers. */
  /* scratch[3] : address of CLINT MTIMECMP register. */
  /* scratch[4] : desired interval (in cycles) between timer interrupts. */
  uint64 *scratch = &timer_scratch[id][0];
    800059d2:	00259693          	sll	a3,a1,0x2
    800059d6:	96ae                	add	a3,a3,a1
    800059d8:	068e                	sll	a3,a3,0x3
    800059da:	00034717          	auipc	a4,0x34
    800059de:	50670713          	add	a4,a4,1286 # 80039ee0 <timer_scratch>
    800059e2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059e4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059e6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059e8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059ec:	00000797          	auipc	a5,0x0
    800059f0:	9a478793          	add	a5,a5,-1628 # 80005390 <timervec>
    800059f4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059f8:	300027f3          	csrr	a5,mstatus

  /* set the machine-mode trap handler. */
  w_mtvec((uint64)timervec);

  /* enable machine-mode interrupts. */
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059fc:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a00:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a04:	304027f3          	csrr	a5,mie

  /* enable machine-mode timer interrupts. */
  w_mie(r_mie() | MIE_MTIE);
    80005a08:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a0c:	30479073          	csrw	mie,a5
}
    80005a10:	6422                	ld	s0,8(sp)
    80005a12:	0141                	add	sp,sp,16
    80005a14:	8082                	ret

0000000080005a16 <start>:
{
    80005a16:	1141                	add	sp,sp,-16
    80005a18:	e406                	sd	ra,8(sp)
    80005a1a:	e022                	sd	s0,0(sp)
    80005a1c:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a1e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a22:	7779                	lui	a4,0xffffe
    80005a24:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbc6df>
    80005a28:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a2a:	6705                	lui	a4,0x1
    80005a2c:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a30:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a32:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a36:	ffffb797          	auipc	a5,0xffffb
    80005a3a:	a7678793          	add	a5,a5,-1418 # 800004ac <main>
    80005a3e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a42:	4781                	li	a5,0
    80005a44:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a48:	67c1                	lui	a5,0x10
    80005a4a:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a4c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a50:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a54:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a58:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a5c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a60:	57fd                	li	a5,-1
    80005a62:	83a9                	srl	a5,a5,0xa
    80005a64:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a68:	47bd                	li	a5,15
    80005a6a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	f38080e7          	jalr	-200(ra) # 800059a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a76:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a7a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a7c:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a7e:	30200073          	mret
}
    80005a82:	60a2                	ld	ra,8(sp)
    80005a84:	6402                	ld	s0,0(sp)
    80005a86:	0141                	add	sp,sp,16
    80005a88:	8082                	ret

0000000080005a8a <consolewrite>:
/* */
/* user write()s to the console go here. */
/* */
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a8a:	715d                	add	sp,sp,-80
    80005a8c:	e486                	sd	ra,72(sp)
    80005a8e:	e0a2                	sd	s0,64(sp)
    80005a90:	fc26                	sd	s1,56(sp)
    80005a92:	f84a                	sd	s2,48(sp)
    80005a94:	f44e                	sd	s3,40(sp)
    80005a96:	f052                	sd	s4,32(sp)
    80005a98:	ec56                	sd	s5,24(sp)
    80005a9a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a9c:	04c05763          	blez	a2,80005aea <consolewrite+0x60>
    80005aa0:	8a2a                	mv	s4,a0
    80005aa2:	84ae                	mv	s1,a1
    80005aa4:	89b2                	mv	s3,a2
    80005aa6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005aa8:	5afd                	li	s5,-1
    80005aaa:	4685                	li	a3,1
    80005aac:	8626                	mv	a2,s1
    80005aae:	85d2                	mv	a1,s4
    80005ab0:	fbf40513          	add	a0,s0,-65
    80005ab4:	ffffc097          	auipc	ra,0xffffc
    80005ab8:	08a080e7          	jalr	138(ra) # 80001b3e <either_copyin>
    80005abc:	01550d63          	beq	a0,s5,80005ad6 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005ac0:	fbf44503          	lbu	a0,-65(s0)
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	780080e7          	jalr	1920(ra) # 80006244 <uartputc>
  for(i = 0; i < n; i++){
    80005acc:	2905                	addw	s2,s2,1
    80005ace:	0485                	add	s1,s1,1
    80005ad0:	fd299de3          	bne	s3,s2,80005aaa <consolewrite+0x20>
    80005ad4:	894e                	mv	s2,s3
  }

  return i;
}
    80005ad6:	854a                	mv	a0,s2
    80005ad8:	60a6                	ld	ra,72(sp)
    80005ada:	6406                	ld	s0,64(sp)
    80005adc:	74e2                	ld	s1,56(sp)
    80005ade:	7942                	ld	s2,48(sp)
    80005ae0:	79a2                	ld	s3,40(sp)
    80005ae2:	7a02                	ld	s4,32(sp)
    80005ae4:	6ae2                	ld	s5,24(sp)
    80005ae6:	6161                	add	sp,sp,80
    80005ae8:	8082                	ret
  for(i = 0; i < n; i++){
    80005aea:	4901                	li	s2,0
    80005aec:	b7ed                	j	80005ad6 <consolewrite+0x4c>

0000000080005aee <consoleread>:
/* user_dist indicates whether dst is a user */
/* or kernel address. */
/* */
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aee:	711d                	add	sp,sp,-96
    80005af0:	ec86                	sd	ra,88(sp)
    80005af2:	e8a2                	sd	s0,80(sp)
    80005af4:	e4a6                	sd	s1,72(sp)
    80005af6:	e0ca                	sd	s2,64(sp)
    80005af8:	fc4e                	sd	s3,56(sp)
    80005afa:	f852                	sd	s4,48(sp)
    80005afc:	f456                	sd	s5,40(sp)
    80005afe:	f05a                	sd	s6,32(sp)
    80005b00:	ec5e                	sd	s7,24(sp)
    80005b02:	1080                	add	s0,sp,96
    80005b04:	8aaa                	mv	s5,a0
    80005b06:	8a2e                	mv	s4,a1
    80005b08:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b0a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b0e:	0003c517          	auipc	a0,0x3c
    80005b12:	51250513          	add	a0,a0,1298 # 80042020 <cons>
    80005b16:	00001097          	auipc	ra,0x1
    80005b1a:	8e8080e7          	jalr	-1816(ra) # 800063fe <acquire>
  while(n > 0){
    /* wait until interrupt handler has put some */
    /* input into cons.buffer. */
    while(cons.r == cons.w){
    80005b1e:	0003c497          	auipc	s1,0x3c
    80005b22:	50248493          	add	s1,s1,1282 # 80042020 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b26:	0003c917          	auipc	s2,0x3c
    80005b2a:	59290913          	add	s2,s2,1426 # 800420b8 <cons+0x98>
  while(n > 0){
    80005b2e:	09305263          	blez	s3,80005bb2 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005b32:	0984a783          	lw	a5,152(s1)
    80005b36:	09c4a703          	lw	a4,156(s1)
    80005b3a:	02f71763          	bne	a4,a5,80005b68 <consoleread+0x7a>
      if(killed(myproc())){
    80005b3e:	ffffb097          	auipc	ra,0xffffb
    80005b42:	4ee080e7          	jalr	1262(ra) # 8000102c <myproc>
    80005b46:	ffffc097          	auipc	ra,0xffffc
    80005b4a:	e42080e7          	jalr	-446(ra) # 80001988 <killed>
    80005b4e:	ed2d                	bnez	a0,80005bc8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005b50:	85a6                	mv	a1,s1
    80005b52:	854a                	mv	a0,s2
    80005b54:	ffffc097          	auipc	ra,0xffffc
    80005b58:	b8c080e7          	jalr	-1140(ra) # 800016e0 <sleep>
    while(cons.r == cons.w){
    80005b5c:	0984a783          	lw	a5,152(s1)
    80005b60:	09c4a703          	lw	a4,156(s1)
    80005b64:	fcf70de3          	beq	a4,a5,80005b3e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b68:	0003c717          	auipc	a4,0x3c
    80005b6c:	4b870713          	add	a4,a4,1208 # 80042020 <cons>
    80005b70:	0017869b          	addw	a3,a5,1
    80005b74:	08d72c23          	sw	a3,152(a4)
    80005b78:	07f7f693          	and	a3,a5,127
    80005b7c:	9736                	add	a4,a4,a3
    80005b7e:	01874703          	lbu	a4,24(a4)
    80005b82:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  /* end-of-file */
    80005b86:	4691                	li	a3,4
    80005b88:	06db8463          	beq	s7,a3,80005bf0 <consoleread+0x102>
      }
      break;
    }

    /* copy the input byte to the user-space buffer. */
    cbuf = c;
    80005b8c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b90:	4685                	li	a3,1
    80005b92:	faf40613          	add	a2,s0,-81
    80005b96:	85d2                	mv	a1,s4
    80005b98:	8556                	mv	a0,s5
    80005b9a:	ffffc097          	auipc	ra,0xffffc
    80005b9e:	f4e080e7          	jalr	-178(ra) # 80001ae8 <either_copyout>
    80005ba2:	57fd                	li	a5,-1
    80005ba4:	00f50763          	beq	a0,a5,80005bb2 <consoleread+0xc4>
      break;

    dst++;
    80005ba8:	0a05                	add	s4,s4,1
    --n;
    80005baa:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005bac:	47a9                	li	a5,10
    80005bae:	f8fb90e3          	bne	s7,a5,80005b2e <consoleread+0x40>
      /* a whole line has arrived, return to */
      /* the user-level read(). */
      break;
    }
  }
  release(&cons.lock);
    80005bb2:	0003c517          	auipc	a0,0x3c
    80005bb6:	46e50513          	add	a0,a0,1134 # 80042020 <cons>
    80005bba:	00001097          	auipc	ra,0x1
    80005bbe:	8f8080e7          	jalr	-1800(ra) # 800064b2 <release>

  return target - n;
    80005bc2:	413b053b          	subw	a0,s6,s3
    80005bc6:	a811                	j	80005bda <consoleread+0xec>
        release(&cons.lock);
    80005bc8:	0003c517          	auipc	a0,0x3c
    80005bcc:	45850513          	add	a0,a0,1112 # 80042020 <cons>
    80005bd0:	00001097          	auipc	ra,0x1
    80005bd4:	8e2080e7          	jalr	-1822(ra) # 800064b2 <release>
        return -1;
    80005bd8:	557d                	li	a0,-1
}
    80005bda:	60e6                	ld	ra,88(sp)
    80005bdc:	6446                	ld	s0,80(sp)
    80005bde:	64a6                	ld	s1,72(sp)
    80005be0:	6906                	ld	s2,64(sp)
    80005be2:	79e2                	ld	s3,56(sp)
    80005be4:	7a42                	ld	s4,48(sp)
    80005be6:	7aa2                	ld	s5,40(sp)
    80005be8:	7b02                	ld	s6,32(sp)
    80005bea:	6be2                	ld	s7,24(sp)
    80005bec:	6125                	add	sp,sp,96
    80005bee:	8082                	ret
      if(n < target){
    80005bf0:	0009871b          	sext.w	a4,s3
    80005bf4:	fb677fe3          	bgeu	a4,s6,80005bb2 <consoleread+0xc4>
        cons.r--;
    80005bf8:	0003c717          	auipc	a4,0x3c
    80005bfc:	4cf72023          	sw	a5,1216(a4) # 800420b8 <cons+0x98>
    80005c00:	bf4d                	j	80005bb2 <consoleread+0xc4>

0000000080005c02 <consputc>:
{
    80005c02:	1141                	add	sp,sp,-16
    80005c04:	e406                	sd	ra,8(sp)
    80005c06:	e022                	sd	s0,0(sp)
    80005c08:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005c0a:	10000793          	li	a5,256
    80005c0e:	00f50a63          	beq	a0,a5,80005c22 <consputc+0x20>
    uartputc_sync(c);
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	560080e7          	jalr	1376(ra) # 80006172 <uartputc_sync>
}
    80005c1a:	60a2                	ld	ra,8(sp)
    80005c1c:	6402                	ld	s0,0(sp)
    80005c1e:	0141                	add	sp,sp,16
    80005c20:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c22:	4521                	li	a0,8
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	54e080e7          	jalr	1358(ra) # 80006172 <uartputc_sync>
    80005c2c:	02000513          	li	a0,32
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	542080e7          	jalr	1346(ra) # 80006172 <uartputc_sync>
    80005c38:	4521                	li	a0,8
    80005c3a:	00000097          	auipc	ra,0x0
    80005c3e:	538080e7          	jalr	1336(ra) # 80006172 <uartputc_sync>
    80005c42:	bfe1                	j	80005c1a <consputc+0x18>

0000000080005c44 <consoleintr>:
/* do erase/kill processing, append to cons.buf, */
/* wake up consoleread() if a whole line has arrived. */
/* */
void
consoleintr(int c)
{
    80005c44:	1101                	add	sp,sp,-32
    80005c46:	ec06                	sd	ra,24(sp)
    80005c48:	e822                	sd	s0,16(sp)
    80005c4a:	e426                	sd	s1,8(sp)
    80005c4c:	e04a                	sd	s2,0(sp)
    80005c4e:	1000                	add	s0,sp,32
    80005c50:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c52:	0003c517          	auipc	a0,0x3c
    80005c56:	3ce50513          	add	a0,a0,974 # 80042020 <cons>
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	7a4080e7          	jalr	1956(ra) # 800063fe <acquire>

  switch(c){
    80005c62:	47d5                	li	a5,21
    80005c64:	0af48663          	beq	s1,a5,80005d10 <consoleintr+0xcc>
    80005c68:	0297ca63          	blt	a5,s1,80005c9c <consoleintr+0x58>
    80005c6c:	47a1                	li	a5,8
    80005c6e:	0ef48763          	beq	s1,a5,80005d5c <consoleintr+0x118>
    80005c72:	47c1                	li	a5,16
    80005c74:	10f49a63          	bne	s1,a5,80005d88 <consoleintr+0x144>
  case C('P'):  /* Print process list. */
    procdump();
    80005c78:	ffffc097          	auipc	ra,0xffffc
    80005c7c:	f1c080e7          	jalr	-228(ra) # 80001b94 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c80:	0003c517          	auipc	a0,0x3c
    80005c84:	3a050513          	add	a0,a0,928 # 80042020 <cons>
    80005c88:	00001097          	auipc	ra,0x1
    80005c8c:	82a080e7          	jalr	-2006(ra) # 800064b2 <release>
}
    80005c90:	60e2                	ld	ra,24(sp)
    80005c92:	6442                	ld	s0,16(sp)
    80005c94:	64a2                	ld	s1,8(sp)
    80005c96:	6902                	ld	s2,0(sp)
    80005c98:	6105                	add	sp,sp,32
    80005c9a:	8082                	ret
  switch(c){
    80005c9c:	07f00793          	li	a5,127
    80005ca0:	0af48e63          	beq	s1,a5,80005d5c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ca4:	0003c717          	auipc	a4,0x3c
    80005ca8:	37c70713          	add	a4,a4,892 # 80042020 <cons>
    80005cac:	0a072783          	lw	a5,160(a4)
    80005cb0:	09872703          	lw	a4,152(a4)
    80005cb4:	9f99                	subw	a5,a5,a4
    80005cb6:	07f00713          	li	a4,127
    80005cba:	fcf763e3          	bltu	a4,a5,80005c80 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005cbe:	47b5                	li	a5,13
    80005cc0:	0cf48763          	beq	s1,a5,80005d8e <consoleintr+0x14a>
      consputc(c);
    80005cc4:	8526                	mv	a0,s1
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	f3c080e7          	jalr	-196(ra) # 80005c02 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cce:	0003c797          	auipc	a5,0x3c
    80005cd2:	35278793          	add	a5,a5,850 # 80042020 <cons>
    80005cd6:	0a07a683          	lw	a3,160(a5)
    80005cda:	0016871b          	addw	a4,a3,1
    80005cde:	0007061b          	sext.w	a2,a4
    80005ce2:	0ae7a023          	sw	a4,160(a5)
    80005ce6:	07f6f693          	and	a3,a3,127
    80005cea:	97b6                	add	a5,a5,a3
    80005cec:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cf0:	47a9                	li	a5,10
    80005cf2:	0cf48563          	beq	s1,a5,80005dbc <consoleintr+0x178>
    80005cf6:	4791                	li	a5,4
    80005cf8:	0cf48263          	beq	s1,a5,80005dbc <consoleintr+0x178>
    80005cfc:	0003c797          	auipc	a5,0x3c
    80005d00:	3bc7a783          	lw	a5,956(a5) # 800420b8 <cons+0x98>
    80005d04:	9f1d                	subw	a4,a4,a5
    80005d06:	08000793          	li	a5,128
    80005d0a:	f6f71be3          	bne	a4,a5,80005c80 <consoleintr+0x3c>
    80005d0e:	a07d                	j	80005dbc <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005d10:	0003c717          	auipc	a4,0x3c
    80005d14:	31070713          	add	a4,a4,784 # 80042020 <cons>
    80005d18:	0a072783          	lw	a5,160(a4)
    80005d1c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d20:	0003c497          	auipc	s1,0x3c
    80005d24:	30048493          	add	s1,s1,768 # 80042020 <cons>
    while(cons.e != cons.w &&
    80005d28:	4929                	li	s2,10
    80005d2a:	f4f70be3          	beq	a4,a5,80005c80 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d2e:	37fd                	addw	a5,a5,-1
    80005d30:	07f7f713          	and	a4,a5,127
    80005d34:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d36:	01874703          	lbu	a4,24(a4)
    80005d3a:	f52703e3          	beq	a4,s2,80005c80 <consoleintr+0x3c>
      cons.e--;
    80005d3e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d42:	10000513          	li	a0,256
    80005d46:	00000097          	auipc	ra,0x0
    80005d4a:	ebc080e7          	jalr	-324(ra) # 80005c02 <consputc>
    while(cons.e != cons.w &&
    80005d4e:	0a04a783          	lw	a5,160(s1)
    80005d52:	09c4a703          	lw	a4,156(s1)
    80005d56:	fcf71ce3          	bne	a4,a5,80005d2e <consoleintr+0xea>
    80005d5a:	b71d                	j	80005c80 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d5c:	0003c717          	auipc	a4,0x3c
    80005d60:	2c470713          	add	a4,a4,708 # 80042020 <cons>
    80005d64:	0a072783          	lw	a5,160(a4)
    80005d68:	09c72703          	lw	a4,156(a4)
    80005d6c:	f0f70ae3          	beq	a4,a5,80005c80 <consoleintr+0x3c>
      cons.e--;
    80005d70:	37fd                	addw	a5,a5,-1
    80005d72:	0003c717          	auipc	a4,0x3c
    80005d76:	34f72723          	sw	a5,846(a4) # 800420c0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d7a:	10000513          	li	a0,256
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	e84080e7          	jalr	-380(ra) # 80005c02 <consputc>
    80005d86:	bded                	j	80005c80 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d88:	ee048ce3          	beqz	s1,80005c80 <consoleintr+0x3c>
    80005d8c:	bf21                	j	80005ca4 <consoleintr+0x60>
      consputc(c);
    80005d8e:	4529                	li	a0,10
    80005d90:	00000097          	auipc	ra,0x0
    80005d94:	e72080e7          	jalr	-398(ra) # 80005c02 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d98:	0003c797          	auipc	a5,0x3c
    80005d9c:	28878793          	add	a5,a5,648 # 80042020 <cons>
    80005da0:	0a07a703          	lw	a4,160(a5)
    80005da4:	0017069b          	addw	a3,a4,1
    80005da8:	0006861b          	sext.w	a2,a3
    80005dac:	0ad7a023          	sw	a3,160(a5)
    80005db0:	07f77713          	and	a4,a4,127
    80005db4:	97ba                	add	a5,a5,a4
    80005db6:	4729                	li	a4,10
    80005db8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005dbc:	0003c797          	auipc	a5,0x3c
    80005dc0:	30c7a023          	sw	a2,768(a5) # 800420bc <cons+0x9c>
        wakeup(&cons.r);
    80005dc4:	0003c517          	auipc	a0,0x3c
    80005dc8:	2f450513          	add	a0,a0,756 # 800420b8 <cons+0x98>
    80005dcc:	ffffc097          	auipc	ra,0xffffc
    80005dd0:	978080e7          	jalr	-1672(ra) # 80001744 <wakeup>
    80005dd4:	b575                	j	80005c80 <consoleintr+0x3c>

0000000080005dd6 <consoleinit>:

void
consoleinit(void)
{
    80005dd6:	1141                	add	sp,sp,-16
    80005dd8:	e406                	sd	ra,8(sp)
    80005dda:	e022                	sd	s0,0(sp)
    80005ddc:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dde:	00003597          	auipc	a1,0x3
    80005de2:	b0a58593          	add	a1,a1,-1270 # 800088e8 <syscalls+0x3f8>
    80005de6:	0003c517          	auipc	a0,0x3c
    80005dea:	23a50513          	add	a0,a0,570 # 80042020 <cons>
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	580080e7          	jalr	1408(ra) # 8000636e <initlock>

  uartinit();
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	32c080e7          	jalr	812(ra) # 80006122 <uartinit>

  /* connect read and write system calls */
  /* to consoleread and consolewrite. */
  devsw[CONSOLE].read = consoleread;
    80005dfe:	00033797          	auipc	a5,0x33
    80005e02:	f4278793          	add	a5,a5,-190 # 80038d40 <devsw>
    80005e06:	00000717          	auipc	a4,0x0
    80005e0a:	ce870713          	add	a4,a4,-792 # 80005aee <consoleread>
    80005e0e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e10:	00000717          	auipc	a4,0x0
    80005e14:	c7a70713          	add	a4,a4,-902 # 80005a8a <consolewrite>
    80005e18:	ef98                	sd	a4,24(a5)
}
    80005e1a:	60a2                	ld	ra,8(sp)
    80005e1c:	6402                	ld	s0,0(sp)
    80005e1e:	0141                	add	sp,sp,16
    80005e20:	8082                	ret

0000000080005e22 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e22:	7179                	add	sp,sp,-48
    80005e24:	f406                	sd	ra,40(sp)
    80005e26:	f022                	sd	s0,32(sp)
    80005e28:	ec26                	sd	s1,24(sp)
    80005e2a:	e84a                	sd	s2,16(sp)
    80005e2c:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e2e:	c219                	beqz	a2,80005e34 <printint+0x12>
    80005e30:	08054763          	bltz	a0,80005ebe <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e34:	2501                	sext.w	a0,a0
    80005e36:	4881                	li	a7,0
    80005e38:	fd040693          	add	a3,s0,-48

  i = 0;
    80005e3c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e3e:	2581                	sext.w	a1,a1
    80005e40:	00003617          	auipc	a2,0x3
    80005e44:	ad860613          	add	a2,a2,-1320 # 80008918 <digits>
    80005e48:	883a                	mv	a6,a4
    80005e4a:	2705                	addw	a4,a4,1
    80005e4c:	02b577bb          	remuw	a5,a0,a1
    80005e50:	1782                	sll	a5,a5,0x20
    80005e52:	9381                	srl	a5,a5,0x20
    80005e54:	97b2                	add	a5,a5,a2
    80005e56:	0007c783          	lbu	a5,0(a5)
    80005e5a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e5e:	0005079b          	sext.w	a5,a0
    80005e62:	02b5553b          	divuw	a0,a0,a1
    80005e66:	0685                	add	a3,a3,1
    80005e68:	feb7f0e3          	bgeu	a5,a1,80005e48 <printint+0x26>

  if(sign)
    80005e6c:	00088c63          	beqz	a7,80005e84 <printint+0x62>
    buf[i++] = '-';
    80005e70:	fe070793          	add	a5,a4,-32
    80005e74:	00878733          	add	a4,a5,s0
    80005e78:	02d00793          	li	a5,45
    80005e7c:	fef70823          	sb	a5,-16(a4)
    80005e80:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005e84:	02e05763          	blez	a4,80005eb2 <printint+0x90>
    80005e88:	fd040793          	add	a5,s0,-48
    80005e8c:	00e784b3          	add	s1,a5,a4
    80005e90:	fff78913          	add	s2,a5,-1
    80005e94:	993a                	add	s2,s2,a4
    80005e96:	377d                	addw	a4,a4,-1
    80005e98:	1702                	sll	a4,a4,0x20
    80005e9a:	9301                	srl	a4,a4,0x20
    80005e9c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ea0:	fff4c503          	lbu	a0,-1(s1)
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	d5e080e7          	jalr	-674(ra) # 80005c02 <consputc>
  while(--i >= 0)
    80005eac:	14fd                	add	s1,s1,-1
    80005eae:	ff2499e3          	bne	s1,s2,80005ea0 <printint+0x7e>
}
    80005eb2:	70a2                	ld	ra,40(sp)
    80005eb4:	7402                	ld	s0,32(sp)
    80005eb6:	64e2                	ld	s1,24(sp)
    80005eb8:	6942                	ld	s2,16(sp)
    80005eba:	6145                	add	sp,sp,48
    80005ebc:	8082                	ret
    x = -xx;
    80005ebe:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ec2:	4885                	li	a7,1
    x = -xx;
    80005ec4:	bf95                	j	80005e38 <printint+0x16>

0000000080005ec6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ec6:	1101                	add	sp,sp,-32
    80005ec8:	ec06                	sd	ra,24(sp)
    80005eca:	e822                	sd	s0,16(sp)
    80005ecc:	e426                	sd	s1,8(sp)
    80005ece:	1000                	add	s0,sp,32
    80005ed0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ed2:	0003c797          	auipc	a5,0x3c
    80005ed6:	2007a723          	sw	zero,526(a5) # 800420e0 <pr+0x18>
  printf("panic: ");
    80005eda:	00003517          	auipc	a0,0x3
    80005ede:	a1650513          	add	a0,a0,-1514 # 800088f0 <syscalls+0x400>
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	02e080e7          	jalr	46(ra) # 80005f10 <printf>
  printf(s);
    80005eea:	8526                	mv	a0,s1
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	024080e7          	jalr	36(ra) # 80005f10 <printf>
  printf("\n");
    80005ef4:	00002517          	auipc	a0,0x2
    80005ef8:	15450513          	add	a0,a0,340 # 80008048 <etext+0x48>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	014080e7          	jalr	20(ra) # 80005f10 <printf>
  panicked = 1; /* freeze uart output from other CPUs */
    80005f04:	4785                	li	a5,1
    80005f06:	00003717          	auipc	a4,0x3
    80005f0a:	b8f72323          	sw	a5,-1146(a4) # 80008a8c <panicked>
  for(;;)
    80005f0e:	a001                	j	80005f0e <panic+0x48>

0000000080005f10 <printf>:
{
    80005f10:	7131                	add	sp,sp,-192
    80005f12:	fc86                	sd	ra,120(sp)
    80005f14:	f8a2                	sd	s0,112(sp)
    80005f16:	f4a6                	sd	s1,104(sp)
    80005f18:	f0ca                	sd	s2,96(sp)
    80005f1a:	ecce                	sd	s3,88(sp)
    80005f1c:	e8d2                	sd	s4,80(sp)
    80005f1e:	e4d6                	sd	s5,72(sp)
    80005f20:	e0da                	sd	s6,64(sp)
    80005f22:	fc5e                	sd	s7,56(sp)
    80005f24:	f862                	sd	s8,48(sp)
    80005f26:	f466                	sd	s9,40(sp)
    80005f28:	f06a                	sd	s10,32(sp)
    80005f2a:	ec6e                	sd	s11,24(sp)
    80005f2c:	0100                	add	s0,sp,128
    80005f2e:	8a2a                	mv	s4,a0
    80005f30:	e40c                	sd	a1,8(s0)
    80005f32:	e810                	sd	a2,16(s0)
    80005f34:	ec14                	sd	a3,24(s0)
    80005f36:	f018                	sd	a4,32(s0)
    80005f38:	f41c                	sd	a5,40(s0)
    80005f3a:	03043823          	sd	a6,48(s0)
    80005f3e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f42:	0003cd97          	auipc	s11,0x3c
    80005f46:	19edad83          	lw	s11,414(s11) # 800420e0 <pr+0x18>
  if(locking)
    80005f4a:	020d9b63          	bnez	s11,80005f80 <printf+0x70>
  if (fmt == 0)
    80005f4e:	040a0263          	beqz	s4,80005f92 <printf+0x82>
  va_start(ap, fmt);
    80005f52:	00840793          	add	a5,s0,8
    80005f56:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f5a:	000a4503          	lbu	a0,0(s4)
    80005f5e:	14050f63          	beqz	a0,800060bc <printf+0x1ac>
    80005f62:	4981                	li	s3,0
    if(c != '%'){
    80005f64:	02500a93          	li	s5,37
    switch(c){
    80005f68:	07000b93          	li	s7,112
  consputc('x');
    80005f6c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f6e:	00003b17          	auipc	s6,0x3
    80005f72:	9aab0b13          	add	s6,s6,-1622 # 80008918 <digits>
    switch(c){
    80005f76:	07300c93          	li	s9,115
    80005f7a:	06400c13          	li	s8,100
    80005f7e:	a82d                	j	80005fb8 <printf+0xa8>
    acquire(&pr.lock);
    80005f80:	0003c517          	auipc	a0,0x3c
    80005f84:	14850513          	add	a0,a0,328 # 800420c8 <pr>
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	476080e7          	jalr	1142(ra) # 800063fe <acquire>
    80005f90:	bf7d                	j	80005f4e <printf+0x3e>
    panic("null fmt");
    80005f92:	00003517          	auipc	a0,0x3
    80005f96:	96e50513          	add	a0,a0,-1682 # 80008900 <syscalls+0x410>
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	f2c080e7          	jalr	-212(ra) # 80005ec6 <panic>
      consputc(c);
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	c60080e7          	jalr	-928(ra) # 80005c02 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005faa:	2985                	addw	s3,s3,1
    80005fac:	013a07b3          	add	a5,s4,s3
    80005fb0:	0007c503          	lbu	a0,0(a5)
    80005fb4:	10050463          	beqz	a0,800060bc <printf+0x1ac>
    if(c != '%'){
    80005fb8:	ff5515e3          	bne	a0,s5,80005fa2 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005fbc:	2985                	addw	s3,s3,1
    80005fbe:	013a07b3          	add	a5,s4,s3
    80005fc2:	0007c783          	lbu	a5,0(a5)
    80005fc6:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005fca:	cbed                	beqz	a5,800060bc <printf+0x1ac>
    switch(c){
    80005fcc:	05778a63          	beq	a5,s7,80006020 <printf+0x110>
    80005fd0:	02fbf663          	bgeu	s7,a5,80005ffc <printf+0xec>
    80005fd4:	09978863          	beq	a5,s9,80006064 <printf+0x154>
    80005fd8:	07800713          	li	a4,120
    80005fdc:	0ce79563          	bne	a5,a4,800060a6 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005fe0:	f8843783          	ld	a5,-120(s0)
    80005fe4:	00878713          	add	a4,a5,8
    80005fe8:	f8e43423          	sd	a4,-120(s0)
    80005fec:	4605                	li	a2,1
    80005fee:	85ea                	mv	a1,s10
    80005ff0:	4388                	lw	a0,0(a5)
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	e30080e7          	jalr	-464(ra) # 80005e22 <printint>
      break;
    80005ffa:	bf45                	j	80005faa <printf+0x9a>
    switch(c){
    80005ffc:	09578f63          	beq	a5,s5,8000609a <printf+0x18a>
    80006000:	0b879363          	bne	a5,s8,800060a6 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006004:	f8843783          	ld	a5,-120(s0)
    80006008:	00878713          	add	a4,a5,8
    8000600c:	f8e43423          	sd	a4,-120(s0)
    80006010:	4605                	li	a2,1
    80006012:	45a9                	li	a1,10
    80006014:	4388                	lw	a0,0(a5)
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	e0c080e7          	jalr	-500(ra) # 80005e22 <printint>
      break;
    8000601e:	b771                	j	80005faa <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006020:	f8843783          	ld	a5,-120(s0)
    80006024:	00878713          	add	a4,a5,8
    80006028:	f8e43423          	sd	a4,-120(s0)
    8000602c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006030:	03000513          	li	a0,48
    80006034:	00000097          	auipc	ra,0x0
    80006038:	bce080e7          	jalr	-1074(ra) # 80005c02 <consputc>
  consputc('x');
    8000603c:	07800513          	li	a0,120
    80006040:	00000097          	auipc	ra,0x0
    80006044:	bc2080e7          	jalr	-1086(ra) # 80005c02 <consputc>
    80006048:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000604a:	03c95793          	srl	a5,s2,0x3c
    8000604e:	97da                	add	a5,a5,s6
    80006050:	0007c503          	lbu	a0,0(a5)
    80006054:	00000097          	auipc	ra,0x0
    80006058:	bae080e7          	jalr	-1106(ra) # 80005c02 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000605c:	0912                	sll	s2,s2,0x4
    8000605e:	34fd                	addw	s1,s1,-1
    80006060:	f4ed                	bnez	s1,8000604a <printf+0x13a>
    80006062:	b7a1                	j	80005faa <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006064:	f8843783          	ld	a5,-120(s0)
    80006068:	00878713          	add	a4,a5,8
    8000606c:	f8e43423          	sd	a4,-120(s0)
    80006070:	6384                	ld	s1,0(a5)
    80006072:	cc89                	beqz	s1,8000608c <printf+0x17c>
      for(; *s; s++)
    80006074:	0004c503          	lbu	a0,0(s1)
    80006078:	d90d                	beqz	a0,80005faa <printf+0x9a>
        consputc(*s);
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	b88080e7          	jalr	-1144(ra) # 80005c02 <consputc>
      for(; *s; s++)
    80006082:	0485                	add	s1,s1,1
    80006084:	0004c503          	lbu	a0,0(s1)
    80006088:	f96d                	bnez	a0,8000607a <printf+0x16a>
    8000608a:	b705                	j	80005faa <printf+0x9a>
        s = "(null)";
    8000608c:	00003497          	auipc	s1,0x3
    80006090:	86c48493          	add	s1,s1,-1940 # 800088f8 <syscalls+0x408>
      for(; *s; s++)
    80006094:	02800513          	li	a0,40
    80006098:	b7cd                	j	8000607a <printf+0x16a>
      consputc('%');
    8000609a:	8556                	mv	a0,s5
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	b66080e7          	jalr	-1178(ra) # 80005c02 <consputc>
      break;
    800060a4:	b719                	j	80005faa <printf+0x9a>
      consputc('%');
    800060a6:	8556                	mv	a0,s5
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	b5a080e7          	jalr	-1190(ra) # 80005c02 <consputc>
      consputc(c);
    800060b0:	8526                	mv	a0,s1
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	b50080e7          	jalr	-1200(ra) # 80005c02 <consputc>
      break;
    800060ba:	bdc5                	j	80005faa <printf+0x9a>
  if(locking)
    800060bc:	020d9163          	bnez	s11,800060de <printf+0x1ce>
}
    800060c0:	70e6                	ld	ra,120(sp)
    800060c2:	7446                	ld	s0,112(sp)
    800060c4:	74a6                	ld	s1,104(sp)
    800060c6:	7906                	ld	s2,96(sp)
    800060c8:	69e6                	ld	s3,88(sp)
    800060ca:	6a46                	ld	s4,80(sp)
    800060cc:	6aa6                	ld	s5,72(sp)
    800060ce:	6b06                	ld	s6,64(sp)
    800060d0:	7be2                	ld	s7,56(sp)
    800060d2:	7c42                	ld	s8,48(sp)
    800060d4:	7ca2                	ld	s9,40(sp)
    800060d6:	7d02                	ld	s10,32(sp)
    800060d8:	6de2                	ld	s11,24(sp)
    800060da:	6129                	add	sp,sp,192
    800060dc:	8082                	ret
    release(&pr.lock);
    800060de:	0003c517          	auipc	a0,0x3c
    800060e2:	fea50513          	add	a0,a0,-22 # 800420c8 <pr>
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	3cc080e7          	jalr	972(ra) # 800064b2 <release>
}
    800060ee:	bfc9                	j	800060c0 <printf+0x1b0>

00000000800060f0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060f0:	1101                	add	sp,sp,-32
    800060f2:	ec06                	sd	ra,24(sp)
    800060f4:	e822                	sd	s0,16(sp)
    800060f6:	e426                	sd	s1,8(sp)
    800060f8:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800060fa:	0003c497          	auipc	s1,0x3c
    800060fe:	fce48493          	add	s1,s1,-50 # 800420c8 <pr>
    80006102:	00003597          	auipc	a1,0x3
    80006106:	80e58593          	add	a1,a1,-2034 # 80008910 <syscalls+0x420>
    8000610a:	8526                	mv	a0,s1
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	262080e7          	jalr	610(ra) # 8000636e <initlock>
  pr.locking = 1;
    80006114:	4785                	li	a5,1
    80006116:	cc9c                	sw	a5,24(s1)
}
    80006118:	60e2                	ld	ra,24(sp)
    8000611a:	6442                	ld	s0,16(sp)
    8000611c:	64a2                	ld	s1,8(sp)
    8000611e:	6105                	add	sp,sp,32
    80006120:	8082                	ret

0000000080006122 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006122:	1141                	add	sp,sp,-16
    80006124:	e406                	sd	ra,8(sp)
    80006126:	e022                	sd	s0,0(sp)
    80006128:	0800                	add	s0,sp,16
  /* disable interrupts. */
  WriteReg(IER, 0x00);
    8000612a:	100007b7          	lui	a5,0x10000
    8000612e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  /* special mode to set baud rate. */
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006132:	f8000713          	li	a4,-128
    80006136:	00e781a3          	sb	a4,3(a5)

  /* LSB for baud rate of 38.4K. */
  WriteReg(0, 0x03);
    8000613a:	470d                	li	a4,3
    8000613c:	00e78023          	sb	a4,0(a5)

  /* MSB for baud rate of 38.4K. */
  WriteReg(1, 0x00);
    80006140:	000780a3          	sb	zero,1(a5)

  /* leave set-baud mode, */
  /* and set word length to 8 bits, no parity. */
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006144:	00e781a3          	sb	a4,3(a5)

  /* reset and enable FIFOs. */
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006148:	469d                	li	a3,7
    8000614a:	00d78123          	sb	a3,2(a5)

  /* enable transmit and receive interrupts. */
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000614e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006152:	00002597          	auipc	a1,0x2
    80006156:	7de58593          	add	a1,a1,2014 # 80008930 <digits+0x18>
    8000615a:	0003c517          	auipc	a0,0x3c
    8000615e:	f8e50513          	add	a0,a0,-114 # 800420e8 <uart_tx_lock>
    80006162:	00000097          	auipc	ra,0x0
    80006166:	20c080e7          	jalr	524(ra) # 8000636e <initlock>
}
    8000616a:	60a2                	ld	ra,8(sp)
    8000616c:	6402                	ld	s0,0(sp)
    8000616e:	0141                	add	sp,sp,16
    80006170:	8082                	ret

0000000080006172 <uartputc_sync>:
/* use interrupts, for use by kernel printf() and */
/* to echo characters. it spins waiting for the uart's */
/* output register to be empty. */
void
uartputc_sync(int c)
{
    80006172:	1101                	add	sp,sp,-32
    80006174:	ec06                	sd	ra,24(sp)
    80006176:	e822                	sd	s0,16(sp)
    80006178:	e426                	sd	s1,8(sp)
    8000617a:	1000                	add	s0,sp,32
    8000617c:	84aa                	mv	s1,a0
  push_off();
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	234080e7          	jalr	564(ra) # 800063b2 <push_off>

  if(panicked){
    80006186:	00003797          	auipc	a5,0x3
    8000618a:	9067a783          	lw	a5,-1786(a5) # 80008a8c <panicked>
    for(;;)
      ;
  }

  /* wait for Transmit Holding Empty to be set in LSR. */
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000618e:	10000737          	lui	a4,0x10000
  if(panicked){
    80006192:	c391                	beqz	a5,80006196 <uartputc_sync+0x24>
    for(;;)
    80006194:	a001                	j	80006194 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006196:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000619a:	0207f793          	and	a5,a5,32
    8000619e:	dfe5                	beqz	a5,80006196 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061a0:	0ff4f513          	zext.b	a0,s1
    800061a4:	100007b7          	lui	a5,0x10000
    800061a8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	2a6080e7          	jalr	678(ra) # 80006452 <pop_off>
}
    800061b4:	60e2                	ld	ra,24(sp)
    800061b6:	6442                	ld	s0,16(sp)
    800061b8:	64a2                	ld	s1,8(sp)
    800061ba:	6105                	add	sp,sp,32
    800061bc:	8082                	ret

00000000800061be <uartstart>:
/* called from both the top- and bottom-half. */
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061be:	00003797          	auipc	a5,0x3
    800061c2:	8d27b783          	ld	a5,-1838(a5) # 80008a90 <uart_tx_r>
    800061c6:	00003717          	auipc	a4,0x3
    800061ca:	8d273703          	ld	a4,-1838(a4) # 80008a98 <uart_tx_w>
    800061ce:	06f70a63          	beq	a4,a5,80006242 <uartstart+0x84>
{
    800061d2:	7139                	add	sp,sp,-64
    800061d4:	fc06                	sd	ra,56(sp)
    800061d6:	f822                	sd	s0,48(sp)
    800061d8:	f426                	sd	s1,40(sp)
    800061da:	f04a                	sd	s2,32(sp)
    800061dc:	ec4e                	sd	s3,24(sp)
    800061de:	e852                	sd	s4,16(sp)
    800061e0:	e456                	sd	s5,8(sp)
    800061e2:	0080                	add	s0,sp,64
      /* transmit buffer is empty. */
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061e4:	10000937          	lui	s2,0x10000
      /* so we cannot give it another byte. */
      /* it will interrupt when it's ready for a new byte. */
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061e8:	0003ca17          	auipc	s4,0x3c
    800061ec:	f00a0a13          	add	s4,s4,-256 # 800420e8 <uart_tx_lock>
    uart_tx_r += 1;
    800061f0:	00003497          	auipc	s1,0x3
    800061f4:	8a048493          	add	s1,s1,-1888 # 80008a90 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061f8:	00003997          	auipc	s3,0x3
    800061fc:	8a098993          	add	s3,s3,-1888 # 80008a98 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006200:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006204:	02077713          	and	a4,a4,32
    80006208:	c705                	beqz	a4,80006230 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000620a:	01f7f713          	and	a4,a5,31
    8000620e:	9752                	add	a4,a4,s4
    80006210:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006214:	0785                	add	a5,a5,1
    80006216:	e09c                	sd	a5,0(s1)
    
    /* maybe uartputc() is waiting for space in the buffer. */
    wakeup(&uart_tx_r);
    80006218:	8526                	mv	a0,s1
    8000621a:	ffffb097          	auipc	ra,0xffffb
    8000621e:	52a080e7          	jalr	1322(ra) # 80001744 <wakeup>
    
    WriteReg(THR, c);
    80006222:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006226:	609c                	ld	a5,0(s1)
    80006228:	0009b703          	ld	a4,0(s3)
    8000622c:	fcf71ae3          	bne	a4,a5,80006200 <uartstart+0x42>
  }
}
    80006230:	70e2                	ld	ra,56(sp)
    80006232:	7442                	ld	s0,48(sp)
    80006234:	74a2                	ld	s1,40(sp)
    80006236:	7902                	ld	s2,32(sp)
    80006238:	69e2                	ld	s3,24(sp)
    8000623a:	6a42                	ld	s4,16(sp)
    8000623c:	6aa2                	ld	s5,8(sp)
    8000623e:	6121                	add	sp,sp,64
    80006240:	8082                	ret
    80006242:	8082                	ret

0000000080006244 <uartputc>:
{
    80006244:	7179                	add	sp,sp,-48
    80006246:	f406                	sd	ra,40(sp)
    80006248:	f022                	sd	s0,32(sp)
    8000624a:	ec26                	sd	s1,24(sp)
    8000624c:	e84a                	sd	s2,16(sp)
    8000624e:	e44e                	sd	s3,8(sp)
    80006250:	e052                	sd	s4,0(sp)
    80006252:	1800                	add	s0,sp,48
    80006254:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006256:	0003c517          	auipc	a0,0x3c
    8000625a:	e9250513          	add	a0,a0,-366 # 800420e8 <uart_tx_lock>
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	1a0080e7          	jalr	416(ra) # 800063fe <acquire>
  if(panicked){
    80006266:	00003797          	auipc	a5,0x3
    8000626a:	8267a783          	lw	a5,-2010(a5) # 80008a8c <panicked>
    8000626e:	e7c9                	bnez	a5,800062f8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006270:	00003717          	auipc	a4,0x3
    80006274:	82873703          	ld	a4,-2008(a4) # 80008a98 <uart_tx_w>
    80006278:	00003797          	auipc	a5,0x3
    8000627c:	8187b783          	ld	a5,-2024(a5) # 80008a90 <uart_tx_r>
    80006280:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006284:	0003c997          	auipc	s3,0x3c
    80006288:	e6498993          	add	s3,s3,-412 # 800420e8 <uart_tx_lock>
    8000628c:	00003497          	auipc	s1,0x3
    80006290:	80448493          	add	s1,s1,-2044 # 80008a90 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006294:	00003917          	auipc	s2,0x3
    80006298:	80490913          	add	s2,s2,-2044 # 80008a98 <uart_tx_w>
    8000629c:	00e79f63          	bne	a5,a4,800062ba <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800062a0:	85ce                	mv	a1,s3
    800062a2:	8526                	mv	a0,s1
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	43c080e7          	jalr	1084(ra) # 800016e0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062ac:	00093703          	ld	a4,0(s2)
    800062b0:	609c                	ld	a5,0(s1)
    800062b2:	02078793          	add	a5,a5,32
    800062b6:	fee785e3          	beq	a5,a4,800062a0 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062ba:	0003c497          	auipc	s1,0x3c
    800062be:	e2e48493          	add	s1,s1,-466 # 800420e8 <uart_tx_lock>
    800062c2:	01f77793          	and	a5,a4,31
    800062c6:	97a6                	add	a5,a5,s1
    800062c8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800062cc:	0705                	add	a4,a4,1
    800062ce:	00002797          	auipc	a5,0x2
    800062d2:	7ce7b523          	sd	a4,1994(a5) # 80008a98 <uart_tx_w>
  uartstart();
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	ee8080e7          	jalr	-280(ra) # 800061be <uartstart>
  release(&uart_tx_lock);
    800062de:	8526                	mv	a0,s1
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	1d2080e7          	jalr	466(ra) # 800064b2 <release>
}
    800062e8:	70a2                	ld	ra,40(sp)
    800062ea:	7402                	ld	s0,32(sp)
    800062ec:	64e2                	ld	s1,24(sp)
    800062ee:	6942                	ld	s2,16(sp)
    800062f0:	69a2                	ld	s3,8(sp)
    800062f2:	6a02                	ld	s4,0(sp)
    800062f4:	6145                	add	sp,sp,48
    800062f6:	8082                	ret
    for(;;)
    800062f8:	a001                	j	800062f8 <uartputc+0xb4>

00000000800062fa <uartgetc>:

/* read one input character from the UART. */
/* return -1 if none is waiting. */
int
uartgetc(void)
{
    800062fa:	1141                	add	sp,sp,-16
    800062fc:	e422                	sd	s0,8(sp)
    800062fe:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006300:	100007b7          	lui	a5,0x10000
    80006304:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006308:	8b85                	and	a5,a5,1
    8000630a:	cb81                	beqz	a5,8000631a <uartgetc+0x20>
    /* input data is ready. */
    return ReadReg(RHR);
    8000630c:	100007b7          	lui	a5,0x10000
    80006310:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006314:	6422                	ld	s0,8(sp)
    80006316:	0141                	add	sp,sp,16
    80006318:	8082                	ret
    return -1;
    8000631a:	557d                	li	a0,-1
    8000631c:	bfe5                	j	80006314 <uartgetc+0x1a>

000000008000631e <uartintr>:
/* handle a uart interrupt, raised because input has */
/* arrived, or the uart is ready for more output, or */
/* both. called from devintr(). */
void
uartintr(void)
{
    8000631e:	1101                	add	sp,sp,-32
    80006320:	ec06                	sd	ra,24(sp)
    80006322:	e822                	sd	s0,16(sp)
    80006324:	e426                	sd	s1,8(sp)
    80006326:	1000                	add	s0,sp,32
  /* read and process incoming characters. */
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006328:	54fd                	li	s1,-1
    8000632a:	a029                	j	80006334 <uartintr+0x16>
      break;
    consoleintr(c);
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	918080e7          	jalr	-1768(ra) # 80005c44 <consoleintr>
    int c = uartgetc();
    80006334:	00000097          	auipc	ra,0x0
    80006338:	fc6080e7          	jalr	-58(ra) # 800062fa <uartgetc>
    if(c == -1)
    8000633c:	fe9518e3          	bne	a0,s1,8000632c <uartintr+0xe>
  }

  /* send buffered characters. */
  acquire(&uart_tx_lock);
    80006340:	0003c497          	auipc	s1,0x3c
    80006344:	da848493          	add	s1,s1,-600 # 800420e8 <uart_tx_lock>
    80006348:	8526                	mv	a0,s1
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	0b4080e7          	jalr	180(ra) # 800063fe <acquire>
  uartstart();
    80006352:	00000097          	auipc	ra,0x0
    80006356:	e6c080e7          	jalr	-404(ra) # 800061be <uartstart>
  release(&uart_tx_lock);
    8000635a:	8526                	mv	a0,s1
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	156080e7          	jalr	342(ra) # 800064b2 <release>
}
    80006364:	60e2                	ld	ra,24(sp)
    80006366:	6442                	ld	s0,16(sp)
    80006368:	64a2                	ld	s1,8(sp)
    8000636a:	6105                	add	sp,sp,32
    8000636c:	8082                	ret

000000008000636e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000636e:	1141                	add	sp,sp,-16
    80006370:	e422                	sd	s0,8(sp)
    80006372:	0800                	add	s0,sp,16
  lk->name = name;
    80006374:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006376:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000637a:	00053823          	sd	zero,16(a0)
}
    8000637e:	6422                	ld	s0,8(sp)
    80006380:	0141                	add	sp,sp,16
    80006382:	8082                	ret

0000000080006384 <holding>:
/* Interrupts must be off. */
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006384:	411c                	lw	a5,0(a0)
    80006386:	e399                	bnez	a5,8000638c <holding+0x8>
    80006388:	4501                	li	a0,0
  return r;
}
    8000638a:	8082                	ret
{
    8000638c:	1101                	add	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006396:	6904                	ld	s1,16(a0)
    80006398:	ffffb097          	auipc	ra,0xffffb
    8000639c:	c78080e7          	jalr	-904(ra) # 80001010 <mycpu>
    800063a0:	40a48533          	sub	a0,s1,a0
    800063a4:	00153513          	seqz	a0,a0
}
    800063a8:	60e2                	ld	ra,24(sp)
    800063aa:	6442                	ld	s0,16(sp)
    800063ac:	64a2                	ld	s1,8(sp)
    800063ae:	6105                	add	sp,sp,32
    800063b0:	8082                	ret

00000000800063b2 <push_off>:
/* it takes two pop_off()s to undo two push_off()s.  Also, if interrupts */
/* are initially off, then push_off, pop_off leaves them off. */

void
push_off(void)
{
    800063b2:	1101                	add	sp,sp,-32
    800063b4:	ec06                	sd	ra,24(sp)
    800063b6:	e822                	sd	s0,16(sp)
    800063b8:	e426                	sd	s1,8(sp)
    800063ba:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063bc:	100024f3          	csrr	s1,sstatus
    800063c0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063c4:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063c6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063ca:	ffffb097          	auipc	ra,0xffffb
    800063ce:	c46080e7          	jalr	-954(ra) # 80001010 <mycpu>
    800063d2:	5d3c                	lw	a5,120(a0)
    800063d4:	cf89                	beqz	a5,800063ee <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063d6:	ffffb097          	auipc	ra,0xffffb
    800063da:	c3a080e7          	jalr	-966(ra) # 80001010 <mycpu>
    800063de:	5d3c                	lw	a5,120(a0)
    800063e0:	2785                	addw	a5,a5,1
    800063e2:	dd3c                	sw	a5,120(a0)
}
    800063e4:	60e2                	ld	ra,24(sp)
    800063e6:	6442                	ld	s0,16(sp)
    800063e8:	64a2                	ld	s1,8(sp)
    800063ea:	6105                	add	sp,sp,32
    800063ec:	8082                	ret
    mycpu()->intena = old;
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	c22080e7          	jalr	-990(ra) # 80001010 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063f6:	8085                	srl	s1,s1,0x1
    800063f8:	8885                	and	s1,s1,1
    800063fa:	dd64                	sw	s1,124(a0)
    800063fc:	bfe9                	j	800063d6 <push_off+0x24>

00000000800063fe <acquire>:
{
    800063fe:	1101                	add	sp,sp,-32
    80006400:	ec06                	sd	ra,24(sp)
    80006402:	e822                	sd	s0,16(sp)
    80006404:	e426                	sd	s1,8(sp)
    80006406:	1000                	add	s0,sp,32
    80006408:	84aa                	mv	s1,a0
  push_off(); /* disable interrupts to avoid deadlock. */
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	fa8080e7          	jalr	-88(ra) # 800063b2 <push_off>
  if(holding(lk))
    80006412:	8526                	mv	a0,s1
    80006414:	00000097          	auipc	ra,0x0
    80006418:	f70080e7          	jalr	-144(ra) # 80006384 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000641c:	4705                	li	a4,1
  if(holding(lk))
    8000641e:	e115                	bnez	a0,80006442 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006420:	87ba                	mv	a5,a4
    80006422:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006426:	2781                	sext.w	a5,a5
    80006428:	ffe5                	bnez	a5,80006420 <acquire+0x22>
  __sync_synchronize();
    8000642a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000642e:	ffffb097          	auipc	ra,0xffffb
    80006432:	be2080e7          	jalr	-1054(ra) # 80001010 <mycpu>
    80006436:	e888                	sd	a0,16(s1)
}
    80006438:	60e2                	ld	ra,24(sp)
    8000643a:	6442                	ld	s0,16(sp)
    8000643c:	64a2                	ld	s1,8(sp)
    8000643e:	6105                	add	sp,sp,32
    80006440:	8082                	ret
    panic("acquire");
    80006442:	00002517          	auipc	a0,0x2
    80006446:	4f650513          	add	a0,a0,1270 # 80008938 <digits+0x20>
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	a7c080e7          	jalr	-1412(ra) # 80005ec6 <panic>

0000000080006452 <pop_off>:

void
pop_off(void)
{
    80006452:	1141                	add	sp,sp,-16
    80006454:	e406                	sd	ra,8(sp)
    80006456:	e022                	sd	s0,0(sp)
    80006458:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    8000645a:	ffffb097          	auipc	ra,0xffffb
    8000645e:	bb6080e7          	jalr	-1098(ra) # 80001010 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006462:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006466:	8b89                	and	a5,a5,2
  if(intr_get())
    80006468:	e78d                	bnez	a5,80006492 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000646a:	5d3c                	lw	a5,120(a0)
    8000646c:	02f05b63          	blez	a5,800064a2 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006470:	37fd                	addw	a5,a5,-1
    80006472:	0007871b          	sext.w	a4,a5
    80006476:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006478:	eb09                	bnez	a4,8000648a <pop_off+0x38>
    8000647a:	5d7c                	lw	a5,124(a0)
    8000647c:	c799                	beqz	a5,8000648a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000647e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006482:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006486:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000648a:	60a2                	ld	ra,8(sp)
    8000648c:	6402                	ld	s0,0(sp)
    8000648e:	0141                	add	sp,sp,16
    80006490:	8082                	ret
    panic("pop_off - interruptible");
    80006492:	00002517          	auipc	a0,0x2
    80006496:	4ae50513          	add	a0,a0,1198 # 80008940 <digits+0x28>
    8000649a:	00000097          	auipc	ra,0x0
    8000649e:	a2c080e7          	jalr	-1492(ra) # 80005ec6 <panic>
    panic("pop_off");
    800064a2:	00002517          	auipc	a0,0x2
    800064a6:	4b650513          	add	a0,a0,1206 # 80008958 <digits+0x40>
    800064aa:	00000097          	auipc	ra,0x0
    800064ae:	a1c080e7          	jalr	-1508(ra) # 80005ec6 <panic>

00000000800064b2 <release>:
{
    800064b2:	1101                	add	sp,sp,-32
    800064b4:	ec06                	sd	ra,24(sp)
    800064b6:	e822                	sd	s0,16(sp)
    800064b8:	e426                	sd	s1,8(sp)
    800064ba:	1000                	add	s0,sp,32
    800064bc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	ec6080e7          	jalr	-314(ra) # 80006384 <holding>
    800064c6:	c115                	beqz	a0,800064ea <release+0x38>
  lk->cpu = 0;
    800064c8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064cc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064d0:	0f50000f          	fence	iorw,ow
    800064d4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	f7a080e7          	jalr	-134(ra) # 80006452 <pop_off>
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	add	sp,sp,32
    800064e8:	8082                	ret
    panic("release");
    800064ea:	00002517          	auipc	a0,0x2
    800064ee:	47650513          	add	a0,a0,1142 # 80008960 <digits+0x48>
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	9d4080e7          	jalr	-1580(ra) # 80005ec6 <panic>
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
