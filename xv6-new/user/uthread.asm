
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct spinlock lockArr [STACK_SIZE];
int initialized; 
/*End of CMPT 332 GROUP 14 Change, Fall 2023*/              
void 
thread_init(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	e2a78793          	add	a5,a5,-470 # e30 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	e0f73923          	sd	a5,-494(a4) # e20 <current_thread>
  current_thread->state = RUNNING;
  16:	4705                	li	a4,1
  18:	c398                	sw	a4,0(a5)
}
  1a:	6422                	ld	s0,8(sp)
  1c:	0141                	add	sp,sp,16
  1e:	8082                	ret

0000000000000020 <thread_schedule>:

void 
thread_schedule(void)
{
  20:	1141                	add	sp,sp,-16
  22:	e406                	sd	ra,8(sp)
  24:	e022                	sd	s0,0(sp)
  26:	0800                	add	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  28:	00001517          	auipc	a0,0x1
  2c:	df853503          	ld	a0,-520(a0) # e20 <current_thread>
  30:	08050593          	add	a1,a0,128
  34:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  36:	00001617          	auipc	a2,0x1
  3a:	ffa60613          	add	a2,a2,-6 # 1030 <lockArr>
      t = all_thread;
    if(t->state == RUNNABLE) {
  3e:	4689                	li	a3,2
  40:	a801                	j	50 <thread_schedule+0x30>
  42:	4198                	lw	a4,0(a1)
  44:	02d70a63          	beq	a4,a3,78 <thread_schedule+0x58>
      next_thread = t;
      break;
    }
    t = t + 1;
  48:	08058593          	add	a1,a1,128
  for(int i = 0; i < MAX_THREAD; i++){
  4c:	37fd                	addw	a5,a5,-1
  4e:	cb81                	beqz	a5,5e <thread_schedule+0x3e>
    if(t >= all_thread + MAX_THREAD)
  50:	fec5e9e3          	bltu	a1,a2,42 <thread_schedule+0x22>
      t = all_thread;
  54:	00001597          	auipc	a1,0x1
  58:	ddc58593          	add	a1,a1,-548 # e30 <all_thread>
  5c:	b7dd                	j	42 <thread_schedule+0x22>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  5e:	00001517          	auipc	a0,0x1
  62:	c2a50513          	add	a0,a0,-982 # c88 <malloc+0xea>
  66:	00001097          	auipc	ra,0x1
  6a:	a80080e7          	jalr	-1408(ra) # ae6 <printf>
    exit(-1);
  6e:	557d                	li	a0,-1
  70:	00000097          	auipc	ra,0x0
  74:	6fe080e7          	jalr	1790(ra) # 76e <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  78:	02b50063          	beq	a0,a1,98 <thread_schedule+0x78>
    next_thread->state = RUNNING;
  7c:	4785                	li	a5,1
  7e:	c19c                	sw	a5,0(a1)
    t = current_thread;
  80:	00001797          	auipc	a5,0x1
  84:	da078793          	add	a5,a5,-608 # e20 <current_thread>
  88:	6388                	ld	a0,0(a5)
    current_thread = next_thread;
  8a:	e38c                	sd	a1,0(a5)
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch(&t->context, &next_thread->context);
  8c:	05a1                	add	a1,a1,8
  8e:	0521                	add	a0,a0,8
  90:	00000097          	auipc	ra,0x0
  94:	3ee080e7          	jalr	1006(ra) # 47e <thread_switch>
  } else
    next_thread = 0;
}
  98:	60a2                	ld	ra,8(sp)
  9a:	6402                	ld	s0,0(sp)
  9c:	0141                	add	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <thread_create>:

void 
thread_create(void (*func)())
{
  a0:	1101                	add	sp,sp,-32
  a2:	ec06                	sd	ra,24(sp)
  a4:	e822                	sd	s0,16(sp)
  a6:	e426                	sd	s1,8(sp)
  a8:	e04a                	sd	s2,0(sp)
  aa:	1000                	add	s0,sp,32
  ac:	892a                	mv	s2,a0
  struct thread *t; 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  ae:	00001497          	auipc	s1,0x1
  b2:	d8248493          	add	s1,s1,-638 # e30 <all_thread>
  b6:	00001717          	auipc	a4,0x1
  ba:	f7a70713          	add	a4,a4,-134 # 1030 <lockArr>
    if (t->state == FREE) break;
  be:	409c                	lw	a5,0(s1)
  c0:	c789                	beqz	a5,ca <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c2:	08048493          	add	s1,s1,128
  c6:	fee49ce3          	bne	s1,a4,be <thread_create+0x1e>
  }
  t->state = RUNNABLE;
  ca:	4789                	li	a5,2
  cc:	c09c                	sw	a5,0(s1)
  // YOUR CODE HERE
  t->stack = (char*)malloc(STACK_SIZE * sizeof(char));
  ce:	6509                	lui	a0,0x2
  d0:	00001097          	auipc	ra,0x1
  d4:	ace080e7          	jalr	-1330(ra) # b9e <malloc>
  d8:	fca8                	sd	a0,120(s1)
  t->context.ra = (uint64)func;
  da:	0124b423          	sd	s2,8(s1)
  t->context.sp = (uint64)t->stack;
  de:	e888                	sd	a0,16(s1)
}
  e0:	60e2                	ld	ra,24(sp)
  e2:	6442                	ld	s0,16(sp)
  e4:	64a2                	ld	s1,8(sp)
  e6:	6902                	ld	s2,0(sp)
  e8:	6105                	add	sp,sp,32
  ea:	8082                	ret

00000000000000ec <thread_yield>:

void 
thread_yield(void)
{
  ec:	1141                	add	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	add	s0,sp,16
  current_thread->state = RUNNABLE;
  f4:	00001797          	auipc	a5,0x1
  f8:	d2c7b783          	ld	a5,-724(a5) # e20 <current_thread>
  fc:	4709                	li	a4,2
  fe:	c398                	sw	a4,0(a5)
  thread_schedule();
 100:	00000097          	auipc	ra,0x0
 104:	f20080e7          	jalr	-224(ra) # 20 <thread_schedule>
}
 108:	60a2                	ld	ra,8(sp)
 10a:	6402                	ld	s0,0(sp)
 10c:	0141                	add	sp,sp,16
 10e:	8082                	ret

0000000000000110 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 110:	7179                	add	sp,sp,-48
 112:	f406                	sd	ra,40(sp)
 114:	f022                	sd	s0,32(sp)
 116:	ec26                	sd	s1,24(sp)
 118:	e84a                	sd	s2,16(sp)
 11a:	e44e                	sd	s3,8(sp)
 11c:	e052                	sd	s4,0(sp)
 11e:	1800                	add	s0,sp,48
  int i;
  printf("thread_a started\n");
 120:	00001517          	auipc	a0,0x1
 124:	b9050513          	add	a0,a0,-1136 # cb0 <malloc+0x112>
 128:	00001097          	auipc	ra,0x1
 12c:	9be080e7          	jalr	-1602(ra) # ae6 <printf>
  a_started = 1;
 130:	4785                	li	a5,1
 132:	00001717          	auipc	a4,0x1
 136:	cef72123          	sw	a5,-798(a4) # e14 <a_started>
  while(b_started == 0 || c_started == 0)
 13a:	00001497          	auipc	s1,0x1
 13e:	cd648493          	add	s1,s1,-810 # e10 <b_started>
 142:	00001917          	auipc	s2,0x1
 146:	cca90913          	add	s2,s2,-822 # e0c <c_started>
 14a:	a029                	j	154 <thread_a+0x44>
    thread_yield();
 14c:	00000097          	auipc	ra,0x0
 150:	fa0080e7          	jalr	-96(ra) # ec <thread_yield>
  while(b_started == 0 || c_started == 0)
 154:	409c                	lw	a5,0(s1)
 156:	2781                	sext.w	a5,a5
 158:	dbf5                	beqz	a5,14c <thread_a+0x3c>
 15a:	00092783          	lw	a5,0(s2)
 15e:	2781                	sext.w	a5,a5
 160:	d7f5                	beqz	a5,14c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 162:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 164:	00001a17          	auipc	s4,0x1
 168:	b64a0a13          	add	s4,s4,-1180 # cc8 <malloc+0x12a>
    a_n += 1;
 16c:	00001917          	auipc	s2,0x1
 170:	c9c90913          	add	s2,s2,-868 # e08 <a_n>
  for (i = 0; i < 100; i++) {
 174:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 178:	85a6                	mv	a1,s1
 17a:	8552                	mv	a0,s4
 17c:	00001097          	auipc	ra,0x1
 180:	96a080e7          	jalr	-1686(ra) # ae6 <printf>
    a_n += 1;
 184:	00092783          	lw	a5,0(s2)
 188:	2785                	addw	a5,a5,1
 18a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 18e:	00000097          	auipc	ra,0x0
 192:	f5e080e7          	jalr	-162(ra) # ec <thread_yield>
  for (i = 0; i < 100; i++) {
 196:	2485                	addw	s1,s1,1
 198:	ff3490e3          	bne	s1,s3,178 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 19c:	00001597          	auipc	a1,0x1
 1a0:	c6c5a583          	lw	a1,-916(a1) # e08 <a_n>
 1a4:	00001517          	auipc	a0,0x1
 1a8:	b3450513          	add	a0,a0,-1228 # cd8 <malloc+0x13a>
 1ac:	00001097          	auipc	ra,0x1
 1b0:	93a080e7          	jalr	-1734(ra) # ae6 <printf>

  current_thread->state = FREE;
 1b4:	00001797          	auipc	a5,0x1
 1b8:	c6c7b783          	ld	a5,-916(a5) # e20 <current_thread>
 1bc:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1c0:	00000097          	auipc	ra,0x0
 1c4:	e60080e7          	jalr	-416(ra) # 20 <thread_schedule>
}
 1c8:	70a2                	ld	ra,40(sp)
 1ca:	7402                	ld	s0,32(sp)
 1cc:	64e2                	ld	s1,24(sp)
 1ce:	6942                	ld	s2,16(sp)
 1d0:	69a2                	ld	s3,8(sp)
 1d2:	6a02                	ld	s4,0(sp)
 1d4:	6145                	add	sp,sp,48
 1d6:	8082                	ret

00000000000001d8 <thread_b>:

void 
thread_b(void)
{
 1d8:	7179                	add	sp,sp,-48
 1da:	f406                	sd	ra,40(sp)
 1dc:	f022                	sd	s0,32(sp)
 1de:	ec26                	sd	s1,24(sp)
 1e0:	e84a                	sd	s2,16(sp)
 1e2:	e44e                	sd	s3,8(sp)
 1e4:	e052                	sd	s4,0(sp)
 1e6:	1800                	add	s0,sp,48
  int i;
  printf("thread_b started\n");
 1e8:	00001517          	auipc	a0,0x1
 1ec:	b1050513          	add	a0,a0,-1264 # cf8 <malloc+0x15a>
 1f0:	00001097          	auipc	ra,0x1
 1f4:	8f6080e7          	jalr	-1802(ra) # ae6 <printf>
  b_started = 1;
 1f8:	4785                	li	a5,1
 1fa:	00001717          	auipc	a4,0x1
 1fe:	c0f72b23          	sw	a5,-1002(a4) # e10 <b_started>
  while(a_started == 0 || c_started == 0)
 202:	00001497          	auipc	s1,0x1
 206:	c1248493          	add	s1,s1,-1006 # e14 <a_started>
 20a:	00001917          	auipc	s2,0x1
 20e:	c0290913          	add	s2,s2,-1022 # e0c <c_started>
 212:	a029                	j	21c <thread_b+0x44>
    thread_yield();
 214:	00000097          	auipc	ra,0x0
 218:	ed8080e7          	jalr	-296(ra) # ec <thread_yield>
  while(a_started == 0 || c_started == 0)
 21c:	409c                	lw	a5,0(s1)
 21e:	2781                	sext.w	a5,a5
 220:	dbf5                	beqz	a5,214 <thread_b+0x3c>
 222:	00092783          	lw	a5,0(s2)
 226:	2781                	sext.w	a5,a5
 228:	d7f5                	beqz	a5,214 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 22a:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 22c:	00001a17          	auipc	s4,0x1
 230:	ae4a0a13          	add	s4,s4,-1308 # d10 <malloc+0x172>
    b_n += 1;
 234:	00001917          	auipc	s2,0x1
 238:	bd090913          	add	s2,s2,-1072 # e04 <b_n>
  for (i = 0; i < 100; i++) {
 23c:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 240:	85a6                	mv	a1,s1
 242:	8552                	mv	a0,s4
 244:	00001097          	auipc	ra,0x1
 248:	8a2080e7          	jalr	-1886(ra) # ae6 <printf>
    b_n += 1;
 24c:	00092783          	lw	a5,0(s2)
 250:	2785                	addw	a5,a5,1
 252:	00f92023          	sw	a5,0(s2)
    thread_yield();
 256:	00000097          	auipc	ra,0x0
 25a:	e96080e7          	jalr	-362(ra) # ec <thread_yield>
  for (i = 0; i < 100; i++) {
 25e:	2485                	addw	s1,s1,1
 260:	ff3490e3          	bne	s1,s3,240 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 264:	00001597          	auipc	a1,0x1
 268:	ba05a583          	lw	a1,-1120(a1) # e04 <b_n>
 26c:	00001517          	auipc	a0,0x1
 270:	ab450513          	add	a0,a0,-1356 # d20 <malloc+0x182>
 274:	00001097          	auipc	ra,0x1
 278:	872080e7          	jalr	-1934(ra) # ae6 <printf>

  current_thread->state = FREE;
 27c:	00001797          	auipc	a5,0x1
 280:	ba47b783          	ld	a5,-1116(a5) # e20 <current_thread>
 284:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 288:	00000097          	auipc	ra,0x0
 28c:	d98080e7          	jalr	-616(ra) # 20 <thread_schedule>
}
 290:	70a2                	ld	ra,40(sp)
 292:	7402                	ld	s0,32(sp)
 294:	64e2                	ld	s1,24(sp)
 296:	6942                	ld	s2,16(sp)
 298:	69a2                	ld	s3,8(sp)
 29a:	6a02                	ld	s4,0(sp)
 29c:	6145                	add	sp,sp,48
 29e:	8082                	ret

00000000000002a0 <thread_c>:

void 
thread_c(void)
{
 2a0:	7179                	add	sp,sp,-48
 2a2:	f406                	sd	ra,40(sp)
 2a4:	f022                	sd	s0,32(sp)
 2a6:	ec26                	sd	s1,24(sp)
 2a8:	e84a                	sd	s2,16(sp)
 2aa:	e44e                	sd	s3,8(sp)
 2ac:	e052                	sd	s4,0(sp)
 2ae:	1800                	add	s0,sp,48
  int i;
  printf("thread_c started\n");
 2b0:	00001517          	auipc	a0,0x1
 2b4:	a9050513          	add	a0,a0,-1392 # d40 <malloc+0x1a2>
 2b8:	00001097          	auipc	ra,0x1
 2bc:	82e080e7          	jalr	-2002(ra) # ae6 <printf>
  c_started = 1;
 2c0:	4785                	li	a5,1
 2c2:	00001717          	auipc	a4,0x1
 2c6:	b4f72523          	sw	a5,-1206(a4) # e0c <c_started>
  while(a_started == 0 || b_started == 0)
 2ca:	00001497          	auipc	s1,0x1
 2ce:	b4a48493          	add	s1,s1,-1206 # e14 <a_started>
 2d2:	00001917          	auipc	s2,0x1
 2d6:	b3e90913          	add	s2,s2,-1218 # e10 <b_started>
 2da:	a029                	j	2e4 <thread_c+0x44>
    thread_yield();
 2dc:	00000097          	auipc	ra,0x0
 2e0:	e10080e7          	jalr	-496(ra) # ec <thread_yield>
  while(a_started == 0 || b_started == 0)
 2e4:	409c                	lw	a5,0(s1)
 2e6:	2781                	sext.w	a5,a5
 2e8:	dbf5                	beqz	a5,2dc <thread_c+0x3c>
 2ea:	00092783          	lw	a5,0(s2)
 2ee:	2781                	sext.w	a5,a5
 2f0:	d7f5                	beqz	a5,2dc <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 2f2:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 2f4:	00001a17          	auipc	s4,0x1
 2f8:	a64a0a13          	add	s4,s4,-1436 # d58 <malloc+0x1ba>
    c_n += 1;
 2fc:	00001917          	auipc	s2,0x1
 300:	b0490913          	add	s2,s2,-1276 # e00 <c_n>
  for (i = 0; i < 100; i++) {
 304:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 308:	85a6                	mv	a1,s1
 30a:	8552                	mv	a0,s4
 30c:	00000097          	auipc	ra,0x0
 310:	7da080e7          	jalr	2010(ra) # ae6 <printf>
    c_n += 1;
 314:	00092783          	lw	a5,0(s2)
 318:	2785                	addw	a5,a5,1
 31a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 31e:	00000097          	auipc	ra,0x0
 322:	dce080e7          	jalr	-562(ra) # ec <thread_yield>
  for (i = 0; i < 100; i++) {
 326:	2485                	addw	s1,s1,1
 328:	ff3490e3          	bne	s1,s3,308 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 32c:	00001597          	auipc	a1,0x1
 330:	ad45a583          	lw	a1,-1324(a1) # e00 <c_n>
 334:	00001517          	auipc	a0,0x1
 338:	a3450513          	add	a0,a0,-1484 # d68 <malloc+0x1ca>
 33c:	00000097          	auipc	ra,0x0
 340:	7aa080e7          	jalr	1962(ra) # ae6 <printf>

  current_thread->state = FREE;
 344:	00001797          	auipc	a5,0x1
 348:	adc7b783          	ld	a5,-1316(a5) # e20 <current_thread>
 34c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 350:	00000097          	auipc	ra,0x0
 354:	cd0080e7          	jalr	-816(ra) # 20 <thread_schedule>
}
 358:	70a2                	ld	ra,40(sp)
 35a:	7402                	ld	s0,32(sp)
 35c:	64e2                	ld	s1,24(sp)
 35e:	6942                	ld	s2,16(sp)
 360:	69a2                	ld	s3,8(sp)
 362:	6a02                	ld	s4,0(sp)
 364:	6145                	add	sp,sp,48
 366:	8082                	ret

0000000000000368 <mtx_create>:
/* CMPT332 GROUP 14 Change, 2023 */

/* creates a mutex lock and returns an opaque ID 
 * lock starts out in the "locked" state (binary true or false)
*/
int mtx_create (int locked) {
 368:	1141                	add	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	add	s0,sp,16
    initialized = 0;
    if (initialized == 0) {
        lock.lockedState = locked;
        lock.thread = current_thread;
        lock.id = lockId;
        lockArr[lockId] = lock;
 36e:	00001797          	auipc	a5,0x1
 372:	cc278793          	add	a5,a5,-830 # 1030 <lockArr>
 376:	c388                	sw	a0,0(a5)
 378:	00001717          	auipc	a4,0x1
 37c:	aa873703          	ld	a4,-1368(a4) # e20 <current_thread>
 380:	e798                	sd	a4,8(a5)
 382:	0007a823          	sw	zero,16(a5)
        initialized = 1;
 386:	4785                	li	a5,1
 388:	00001717          	auipc	a4,0x1
 38c:	a8f72823          	sw	a5,-1392(a4) # e18 <initialized>
        lock.thread = current_thread;
        lock.id = lockId;
        lockArr[lockId] = lock;
    }
    return lockId;
}
 390:	4501                	li	a0,0
 392:	6422                	ld	s0,8(sp)
 394:	0141                	add	sp,sp,16
 396:	8082                	ret

0000000000000398 <mtx_lock>:

/*
 * block until the lock has been acquired 
*/
int mtx_lock (int lock_id) {
 398:	1141                	add	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	add	s0,sp,16
    for (;;) {
       if (lockArr[lock_id].lockedState == 0) {
 39e:	00151793          	sll	a5,a0,0x1
 3a2:	97aa                	add	a5,a5,a0
 3a4:	078e                	sll	a5,a5,0x3
 3a6:	00001717          	auipc	a4,0x1
 3aa:	c8a70713          	add	a4,a4,-886 # 1030 <lockArr>
 3ae:	97ba                	add	a5,a5,a4
 3b0:	439c                	lw	a5,0(a5)
 3b2:	e381                	bnez	a5,3b2 <mtx_lock+0x1a>
            lockArr[lock_id].lockedState = 1;
 3b4:	00151793          	sll	a5,a0,0x1
 3b8:	97aa                	add	a5,a5,a0
 3ba:	078e                	sll	a5,a5,0x3
 3bc:	00001717          	auipc	a4,0x1
 3c0:	c7470713          	add	a4,a4,-908 # 1030 <lockArr>
 3c4:	97ba                	add	a5,a5,a4
 3c6:	4705                	li	a4,1
 3c8:	c398                	sw	a4,0(a5)
            break; 
       }
    }
    return 0;
}
 3ca:	4501                	li	a0,0
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	add	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <mtx_unlock>:

/* 
 * release the lock, potentially unblocking a waiting thread 
*/

int mtx_unlock (int lock_id) {
 3d2:	1141                	add	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	add	s0,sp,16
    lockArr[lock_id].lockedState = 0;
 3d8:	00001697          	auipc	a3,0x1
 3dc:	c5868693          	add	a3,a3,-936 # 1030 <lockArr>
 3e0:	00151793          	sll	a5,a0,0x1
 3e4:	00a78733          	add	a4,a5,a0
 3e8:	070e                	sll	a4,a4,0x3
 3ea:	9736                	add	a4,a4,a3
 3ec:	00072023          	sw	zero,0(a4)
    lockArr[lock_id].thread = NULL;
 3f0:	00073423          	sd	zero,8(a4)
    return 0;
}
 3f4:	4501                	li	a0,0
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	add	sp,sp,16
 3fa:	8082                	ret

00000000000003fc <main>:

int 
main(int argc, char *argv[]) 
{
 3fc:	1141                	add	sp,sp,-16
 3fe:	e406                	sd	ra,8(sp)
 400:	e022                	sd	s0,0(sp)
 402:	0800                	add	s0,sp,16
  a_started = b_started = c_started = 0;
 404:	00001797          	auipc	a5,0x1
 408:	a007a423          	sw	zero,-1528(a5) # e0c <c_started>
 40c:	00001797          	auipc	a5,0x1
 410:	a007a223          	sw	zero,-1532(a5) # e10 <b_started>
 414:	00001797          	auipc	a5,0x1
 418:	a007a023          	sw	zero,-1536(a5) # e14 <a_started>
  a_n = b_n = c_n = 0;
 41c:	00001797          	auipc	a5,0x1
 420:	9e07a223          	sw	zero,-1564(a5) # e00 <c_n>
 424:	00001797          	auipc	a5,0x1
 428:	9e07a023          	sw	zero,-1568(a5) # e04 <b_n>
 42c:	00001797          	auipc	a5,0x1
 430:	9c07ae23          	sw	zero,-1572(a5) # e08 <a_n>
  thread_init();
 434:	00000097          	auipc	ra,0x0
 438:	bcc080e7          	jalr	-1076(ra) # 0 <thread_init>
  thread_create(thread_a);
 43c:	00000517          	auipc	a0,0x0
 440:	cd450513          	add	a0,a0,-812 # 110 <thread_a>
 444:	00000097          	auipc	ra,0x0
 448:	c5c080e7          	jalr	-932(ra) # a0 <thread_create>
  thread_create(thread_b);
 44c:	00000517          	auipc	a0,0x0
 450:	d8c50513          	add	a0,a0,-628 # 1d8 <thread_b>
 454:	00000097          	auipc	ra,0x0
 458:	c4c080e7          	jalr	-948(ra) # a0 <thread_create>
  thread_create(thread_c);
 45c:	00000517          	auipc	a0,0x0
 460:	e4450513          	add	a0,a0,-444 # 2a0 <thread_c>
 464:	00000097          	auipc	ra,0x0
 468:	c3c080e7          	jalr	-964(ra) # a0 <thread_create>
  thread_schedule();
 46c:	00000097          	auipc	ra,0x0
 470:	bb4080e7          	jalr	-1100(ra) # 20 <thread_schedule>
  exit(0);
 474:	4501                	li	a0,0
 476:	00000097          	auipc	ra,0x0
 47a:	2f8080e7          	jalr	760(ra) # 76e <exit>

000000000000047e <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    sd ra, 0(a0)
 47e:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
 482:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
 486:	e900                	sd	s0,16(a0)
    sd s1, 24(a0)
 488:	ed04                	sd	s1,24(a0)
    sd s2, 32(a0)
 48a:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
 48e:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
 492:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
 496:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
 49a:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
 49e:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
 4a2:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
 4a6:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
 4aa:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
 4ae:	07b53423          	sd	s11,104(a0)

    ld ra, 0(a1)
 4b2:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
 4b6:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
 4ba:	6980                	ld	s0,16(a1)
    ld s1, 24(a1)
 4bc:	6d84                	ld	s1,24(a1)
    ld s2, 32(a1)
 4be:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
 4c2:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
 4c6:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
 4ca:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
 4ce:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
 4d2:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
 4d6:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
 4da:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
 4de:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
 4e2:	0685bd83          	ld	s11,104(a1)
    
  
	ret    /* return to ra */
 4e6:	8082                	ret

00000000000004e8 <_main>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
_main()
{
 4e8:	1141                	add	sp,sp,-16
 4ea:	e406                	sd	ra,8(sp)
 4ec:	e022                	sd	s0,0(sp)
 4ee:	0800                	add	s0,sp,16
  extern int main();
  main();
 4f0:	00000097          	auipc	ra,0x0
 4f4:	f0c080e7          	jalr	-244(ra) # 3fc <main>
  exit(0);
 4f8:	4501                	li	a0,0
 4fa:	00000097          	auipc	ra,0x0
 4fe:	274080e7          	jalr	628(ra) # 76e <exit>

0000000000000502 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 502:	1141                	add	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 508:	87aa                	mv	a5,a0
 50a:	0585                	add	a1,a1,1
 50c:	0785                	add	a5,a5,1
 50e:	fff5c703          	lbu	a4,-1(a1)
 512:	fee78fa3          	sb	a4,-1(a5)
 516:	fb75                	bnez	a4,50a <strcpy+0x8>
    ;
  return os;
}
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	add	sp,sp,16
 51c:	8082                	ret

000000000000051e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 51e:	1141                	add	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 524:	00054783          	lbu	a5,0(a0)
 528:	cb91                	beqz	a5,53c <strcmp+0x1e>
 52a:	0005c703          	lbu	a4,0(a1)
 52e:	00f71763          	bne	a4,a5,53c <strcmp+0x1e>
    p++, q++;
 532:	0505                	add	a0,a0,1
 534:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 536:	00054783          	lbu	a5,0(a0)
 53a:	fbe5                	bnez	a5,52a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 53c:	0005c503          	lbu	a0,0(a1)
}
 540:	40a7853b          	subw	a0,a5,a0
 544:	6422                	ld	s0,8(sp)
 546:	0141                	add	sp,sp,16
 548:	8082                	ret

000000000000054a <strlen>:

uint
strlen(const char *s)
{
 54a:	1141                	add	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 550:	00054783          	lbu	a5,0(a0)
 554:	cf91                	beqz	a5,570 <strlen+0x26>
 556:	0505                	add	a0,a0,1
 558:	87aa                	mv	a5,a0
 55a:	86be                	mv	a3,a5
 55c:	0785                	add	a5,a5,1
 55e:	fff7c703          	lbu	a4,-1(a5)
 562:	ff65                	bnez	a4,55a <strlen+0x10>
 564:	40a6853b          	subw	a0,a3,a0
 568:	2505                	addw	a0,a0,1
    ;
  return n;
}
 56a:	6422                	ld	s0,8(sp)
 56c:	0141                	add	sp,sp,16
 56e:	8082                	ret
  for(n = 0; s[n]; n++)
 570:	4501                	li	a0,0
 572:	bfe5                	j	56a <strlen+0x20>

0000000000000574 <memset>:

void*
memset(void *dst, int c, uint n)
{
 574:	1141                	add	sp,sp,-16
 576:	e422                	sd	s0,8(sp)
 578:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 57a:	ca19                	beqz	a2,590 <memset+0x1c>
 57c:	87aa                	mv	a5,a0
 57e:	1602                	sll	a2,a2,0x20
 580:	9201                	srl	a2,a2,0x20
 582:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 586:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 58a:	0785                	add	a5,a5,1
 58c:	fee79de3          	bne	a5,a4,586 <memset+0x12>
  }
  return dst;
}
 590:	6422                	ld	s0,8(sp)
 592:	0141                	add	sp,sp,16
 594:	8082                	ret

0000000000000596 <strchr>:

char*
strchr(const char *s, char c)
{
 596:	1141                	add	sp,sp,-16
 598:	e422                	sd	s0,8(sp)
 59a:	0800                	add	s0,sp,16
  for(; *s; s++)
 59c:	00054783          	lbu	a5,0(a0)
 5a0:	cb99                	beqz	a5,5b6 <strchr+0x20>
    if(*s == c)
 5a2:	00f58763          	beq	a1,a5,5b0 <strchr+0x1a>
  for(; *s; s++)
 5a6:	0505                	add	a0,a0,1
 5a8:	00054783          	lbu	a5,0(a0)
 5ac:	fbfd                	bnez	a5,5a2 <strchr+0xc>
      return (char*)s;
  return 0;
 5ae:	4501                	li	a0,0
}
 5b0:	6422                	ld	s0,8(sp)
 5b2:	0141                	add	sp,sp,16
 5b4:	8082                	ret
  return 0;
 5b6:	4501                	li	a0,0
 5b8:	bfe5                	j	5b0 <strchr+0x1a>

00000000000005ba <gets>:

char*
gets(char *buf, int max)
{
 5ba:	711d                	add	sp,sp,-96
 5bc:	ec86                	sd	ra,88(sp)
 5be:	e8a2                	sd	s0,80(sp)
 5c0:	e4a6                	sd	s1,72(sp)
 5c2:	e0ca                	sd	s2,64(sp)
 5c4:	fc4e                	sd	s3,56(sp)
 5c6:	f852                	sd	s4,48(sp)
 5c8:	f456                	sd	s5,40(sp)
 5ca:	f05a                	sd	s6,32(sp)
 5cc:	ec5e                	sd	s7,24(sp)
 5ce:	1080                	add	s0,sp,96
 5d0:	8baa                	mv	s7,a0
 5d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d4:	892a                	mv	s2,a0
 5d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5d8:	4aa9                	li	s5,10
 5da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5dc:	89a6                	mv	s3,s1
 5de:	2485                	addw	s1,s1,1
 5e0:	0344d863          	bge	s1,s4,610 <gets+0x56>
    cc = read(0, &c, 1);
 5e4:	4605                	li	a2,1
 5e6:	faf40593          	add	a1,s0,-81
 5ea:	4501                	li	a0,0
 5ec:	00000097          	auipc	ra,0x0
 5f0:	19a080e7          	jalr	410(ra) # 786 <read>
    if(cc < 1)
 5f4:	00a05e63          	blez	a0,610 <gets+0x56>
    buf[i++] = c;
 5f8:	faf44783          	lbu	a5,-81(s0)
 5fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 600:	01578763          	beq	a5,s5,60e <gets+0x54>
 604:	0905                	add	s2,s2,1
 606:	fd679be3          	bne	a5,s6,5dc <gets+0x22>
  for(i=0; i+1 < max; ){
 60a:	89a6                	mv	s3,s1
 60c:	a011                	j	610 <gets+0x56>
 60e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 610:	99de                	add	s3,s3,s7
 612:	00098023          	sb	zero,0(s3)
  return buf;
}
 616:	855e                	mv	a0,s7
 618:	60e6                	ld	ra,88(sp)
 61a:	6446                	ld	s0,80(sp)
 61c:	64a6                	ld	s1,72(sp)
 61e:	6906                	ld	s2,64(sp)
 620:	79e2                	ld	s3,56(sp)
 622:	7a42                	ld	s4,48(sp)
 624:	7aa2                	ld	s5,40(sp)
 626:	7b02                	ld	s6,32(sp)
 628:	6be2                	ld	s7,24(sp)
 62a:	6125                	add	sp,sp,96
 62c:	8082                	ret

000000000000062e <stat>:

int
stat(const char *n, struct stat *st)
{
 62e:	1101                	add	sp,sp,-32
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	e426                	sd	s1,8(sp)
 636:	e04a                	sd	s2,0(sp)
 638:	1000                	add	s0,sp,32
 63a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 63c:	4581                	li	a1,0
 63e:	00000097          	auipc	ra,0x0
 642:	170080e7          	jalr	368(ra) # 7ae <open>
  if(fd < 0)
 646:	02054563          	bltz	a0,670 <stat+0x42>
 64a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 64c:	85ca                	mv	a1,s2
 64e:	00000097          	auipc	ra,0x0
 652:	178080e7          	jalr	376(ra) # 7c6 <fstat>
 656:	892a                	mv	s2,a0
  close(fd);
 658:	8526                	mv	a0,s1
 65a:	00000097          	auipc	ra,0x0
 65e:	13c080e7          	jalr	316(ra) # 796 <close>
  return r;
}
 662:	854a                	mv	a0,s2
 664:	60e2                	ld	ra,24(sp)
 666:	6442                	ld	s0,16(sp)
 668:	64a2                	ld	s1,8(sp)
 66a:	6902                	ld	s2,0(sp)
 66c:	6105                	add	sp,sp,32
 66e:	8082                	ret
    return -1;
 670:	597d                	li	s2,-1
 672:	bfc5                	j	662 <stat+0x34>

0000000000000674 <atoi>:

int
atoi(const char *s)
{
 674:	1141                	add	sp,sp,-16
 676:	e422                	sd	s0,8(sp)
 678:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 67a:	00054683          	lbu	a3,0(a0)
 67e:	fd06879b          	addw	a5,a3,-48
 682:	0ff7f793          	zext.b	a5,a5
 686:	4625                	li	a2,9
 688:	02f66863          	bltu	a2,a5,6b8 <atoi+0x44>
 68c:	872a                	mv	a4,a0
  n = 0;
 68e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 690:	0705                	add	a4,a4,1
 692:	0025179b          	sllw	a5,a0,0x2
 696:	9fa9                	addw	a5,a5,a0
 698:	0017979b          	sllw	a5,a5,0x1
 69c:	9fb5                	addw	a5,a5,a3
 69e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6a2:	00074683          	lbu	a3,0(a4)
 6a6:	fd06879b          	addw	a5,a3,-48
 6aa:	0ff7f793          	zext.b	a5,a5
 6ae:	fef671e3          	bgeu	a2,a5,690 <atoi+0x1c>
  return n;
}
 6b2:	6422                	ld	s0,8(sp)
 6b4:	0141                	add	sp,sp,16
 6b6:	8082                	ret
  n = 0;
 6b8:	4501                	li	a0,0
 6ba:	bfe5                	j	6b2 <atoi+0x3e>

00000000000006bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6bc:	1141                	add	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6c2:	02b57463          	bgeu	a0,a1,6ea <memmove+0x2e>
    while(n-- > 0)
 6c6:	00c05f63          	blez	a2,6e4 <memmove+0x28>
 6ca:	1602                	sll	a2,a2,0x20
 6cc:	9201                	srl	a2,a2,0x20
 6ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 6d4:	0585                	add	a1,a1,1
 6d6:	0705                	add	a4,a4,1
 6d8:	fff5c683          	lbu	a3,-1(a1)
 6dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6e0:	fee79ae3          	bne	a5,a4,6d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6e4:	6422                	ld	s0,8(sp)
 6e6:	0141                	add	sp,sp,16
 6e8:	8082                	ret
    dst += n;
 6ea:	00c50733          	add	a4,a0,a2
    src += n;
 6ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6f0:	fec05ae3          	blez	a2,6e4 <memmove+0x28>
 6f4:	fff6079b          	addw	a5,a2,-1
 6f8:	1782                	sll	a5,a5,0x20
 6fa:	9381                	srl	a5,a5,0x20
 6fc:	fff7c793          	not	a5,a5
 700:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 702:	15fd                	add	a1,a1,-1
 704:	177d                	add	a4,a4,-1
 706:	0005c683          	lbu	a3,0(a1)
 70a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 70e:	fee79ae3          	bne	a5,a4,702 <memmove+0x46>
 712:	bfc9                	j	6e4 <memmove+0x28>

0000000000000714 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 714:	1141                	add	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 71a:	ca05                	beqz	a2,74a <memcmp+0x36>
 71c:	fff6069b          	addw	a3,a2,-1
 720:	1682                	sll	a3,a3,0x20
 722:	9281                	srl	a3,a3,0x20
 724:	0685                	add	a3,a3,1
 726:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 728:	00054783          	lbu	a5,0(a0)
 72c:	0005c703          	lbu	a4,0(a1)
 730:	00e79863          	bne	a5,a4,740 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 734:	0505                	add	a0,a0,1
    p2++;
 736:	0585                	add	a1,a1,1
  while (n-- > 0) {
 738:	fed518e3          	bne	a0,a3,728 <memcmp+0x14>
  }
  return 0;
 73c:	4501                	li	a0,0
 73e:	a019                	j	744 <memcmp+0x30>
      return *p1 - *p2;
 740:	40e7853b          	subw	a0,a5,a4
}
 744:	6422                	ld	s0,8(sp)
 746:	0141                	add	sp,sp,16
 748:	8082                	ret
  return 0;
 74a:	4501                	li	a0,0
 74c:	bfe5                	j	744 <memcmp+0x30>

000000000000074e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 74e:	1141                	add	sp,sp,-16
 750:	e406                	sd	ra,8(sp)
 752:	e022                	sd	s0,0(sp)
 754:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 756:	00000097          	auipc	ra,0x0
 75a:	f66080e7          	jalr	-154(ra) # 6bc <memmove>
}
 75e:	60a2                	ld	ra,8(sp)
 760:	6402                	ld	s0,0(sp)
 762:	0141                	add	sp,sp,16
 764:	8082                	ret

0000000000000766 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 766:	4885                	li	a7,1
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <exit>:
.global exit
exit:
 li a7, SYS_exit
 76e:	4889                	li	a7,2
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <wait>:
.global wait
wait:
 li a7, SYS_wait
 776:	488d                	li	a7,3
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 77e:	4891                	li	a7,4
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <read>:
.global read
read:
 li a7, SYS_read
 786:	4895                	li	a7,5
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <write>:
.global write
write:
 li a7, SYS_write
 78e:	48c1                	li	a7,16
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <close>:
.global close
close:
 li a7, SYS_close
 796:	48d5                	li	a7,21
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <kill>:
.global kill
kill:
 li a7, SYS_kill
 79e:	4899                	li	a7,6
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7a6:	489d                	li	a7,7
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <open>:
.global open
open:
 li a7, SYS_open
 7ae:	48bd                	li	a7,15
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7b6:	48c5                	li	a7,17
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7be:	48c9                	li	a7,18
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7c6:	48a1                	li	a7,8
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <link>:
.global link
link:
 li a7, SYS_link
 7ce:	48cd                	li	a7,19
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7d6:	48d1                	li	a7,20
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7de:	48a5                	li	a7,9
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7e6:	48a9                	li	a7,10
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ee:	48ad                	li	a7,11
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7f6:	48b1                	li	a7,12
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7fe:	48b5                	li	a7,13
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 806:	48b9                	li	a7,14
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <trace>:
.global trace
trace:
 li a7, SYS_trace
 80e:	48d9                	li	a7,22
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <getNumFreePages>:
.global getNumFreePages
getNumFreePages:
 li a7, SYS_getNumFreePages
 816:	48dd                	li	a7,23
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 81e:	1101                	add	sp,sp,-32
 820:	ec06                	sd	ra,24(sp)
 822:	e822                	sd	s0,16(sp)
 824:	1000                	add	s0,sp,32
 826:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 82a:	4605                	li	a2,1
 82c:	fef40593          	add	a1,s0,-17
 830:	00000097          	auipc	ra,0x0
 834:	f5e080e7          	jalr	-162(ra) # 78e <write>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6105                	add	sp,sp,32
 83e:	8082                	ret

0000000000000840 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 840:	7139                	add	sp,sp,-64
 842:	fc06                	sd	ra,56(sp)
 844:	f822                	sd	s0,48(sp)
 846:	f426                	sd	s1,40(sp)
 848:	f04a                	sd	s2,32(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	add	s0,sp,64
 84e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 850:	c299                	beqz	a3,856 <printint+0x16>
 852:	0805c963          	bltz	a1,8e4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 856:	2581                	sext.w	a1,a1
  neg = 0;
 858:	4881                	li	a7,0
 85a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 85e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 860:	2601                	sext.w	a2,a2
 862:	00000517          	auipc	a0,0x0
 866:	58650513          	add	a0,a0,1414 # de8 <digits>
 86a:	883a                	mv	a6,a4
 86c:	2705                	addw	a4,a4,1
 86e:	02c5f7bb          	remuw	a5,a1,a2
 872:	1782                	sll	a5,a5,0x20
 874:	9381                	srl	a5,a5,0x20
 876:	97aa                	add	a5,a5,a0
 878:	0007c783          	lbu	a5,0(a5)
 87c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 880:	0005879b          	sext.w	a5,a1
 884:	02c5d5bb          	divuw	a1,a1,a2
 888:	0685                	add	a3,a3,1
 88a:	fec7f0e3          	bgeu	a5,a2,86a <printint+0x2a>
  if(neg)
 88e:	00088c63          	beqz	a7,8a6 <printint+0x66>
    buf[i++] = '-';
 892:	fd070793          	add	a5,a4,-48
 896:	00878733          	add	a4,a5,s0
 89a:	02d00793          	li	a5,45
 89e:	fef70823          	sb	a5,-16(a4)
 8a2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8a6:	02e05863          	blez	a4,8d6 <printint+0x96>
 8aa:	fc040793          	add	a5,s0,-64
 8ae:	00e78933          	add	s2,a5,a4
 8b2:	fff78993          	add	s3,a5,-1
 8b6:	99ba                	add	s3,s3,a4
 8b8:	377d                	addw	a4,a4,-1
 8ba:	1702                	sll	a4,a4,0x20
 8bc:	9301                	srl	a4,a4,0x20
 8be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8c2:	fff94583          	lbu	a1,-1(s2)
 8c6:	8526                	mv	a0,s1
 8c8:	00000097          	auipc	ra,0x0
 8cc:	f56080e7          	jalr	-170(ra) # 81e <putc>
  while(--i >= 0)
 8d0:	197d                	add	s2,s2,-1
 8d2:	ff3918e3          	bne	s2,s3,8c2 <printint+0x82>
}
 8d6:	70e2                	ld	ra,56(sp)
 8d8:	7442                	ld	s0,48(sp)
 8da:	74a2                	ld	s1,40(sp)
 8dc:	7902                	ld	s2,32(sp)
 8de:	69e2                	ld	s3,24(sp)
 8e0:	6121                	add	sp,sp,64
 8e2:	8082                	ret
    x = -xx;
 8e4:	40b005bb          	negw	a1,a1
    neg = 1;
 8e8:	4885                	li	a7,1
    x = -xx;
 8ea:	bf85                	j	85a <printint+0x1a>

00000000000008ec <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8ec:	715d                	add	sp,sp,-80
 8ee:	e486                	sd	ra,72(sp)
 8f0:	e0a2                	sd	s0,64(sp)
 8f2:	fc26                	sd	s1,56(sp)
 8f4:	f84a                	sd	s2,48(sp)
 8f6:	f44e                	sd	s3,40(sp)
 8f8:	f052                	sd	s4,32(sp)
 8fa:	ec56                	sd	s5,24(sp)
 8fc:	e85a                	sd	s6,16(sp)
 8fe:	e45e                	sd	s7,8(sp)
 900:	e062                	sd	s8,0(sp)
 902:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 904:	0005c903          	lbu	s2,0(a1)
 908:	18090c63          	beqz	s2,aa0 <vprintf+0x1b4>
 90c:	8aaa                	mv	s5,a0
 90e:	8bb2                	mv	s7,a2
 910:	00158493          	add	s1,a1,1
  state = 0;
 914:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 916:	02500a13          	li	s4,37
 91a:	4b55                	li	s6,21
 91c:	a839                	j	93a <vprintf+0x4e>
        putc(fd, c);
 91e:	85ca                	mv	a1,s2
 920:	8556                	mv	a0,s5
 922:	00000097          	auipc	ra,0x0
 926:	efc080e7          	jalr	-260(ra) # 81e <putc>
 92a:	a019                	j	930 <vprintf+0x44>
    } else if(state == '%'){
 92c:	01498d63          	beq	s3,s4,946 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 930:	0485                	add	s1,s1,1
 932:	fff4c903          	lbu	s2,-1(s1)
 936:	16090563          	beqz	s2,aa0 <vprintf+0x1b4>
    if(state == 0){
 93a:	fe0999e3          	bnez	s3,92c <vprintf+0x40>
      if(c == '%'){
 93e:	ff4910e3          	bne	s2,s4,91e <vprintf+0x32>
        state = '%';
 942:	89d2                	mv	s3,s4
 944:	b7f5                	j	930 <vprintf+0x44>
      if(c == 'd'){
 946:	13490263          	beq	s2,s4,a6a <vprintf+0x17e>
 94a:	f9d9079b          	addw	a5,s2,-99
 94e:	0ff7f793          	zext.b	a5,a5
 952:	12fb6563          	bltu	s6,a5,a7c <vprintf+0x190>
 956:	f9d9079b          	addw	a5,s2,-99
 95a:	0ff7f713          	zext.b	a4,a5
 95e:	10eb6f63          	bltu	s6,a4,a7c <vprintf+0x190>
 962:	00271793          	sll	a5,a4,0x2
 966:	00000717          	auipc	a4,0x0
 96a:	42a70713          	add	a4,a4,1066 # d90 <malloc+0x1f2>
 96e:	97ba                	add	a5,a5,a4
 970:	439c                	lw	a5,0(a5)
 972:	97ba                	add	a5,a5,a4
 974:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 976:	008b8913          	add	s2,s7,8
 97a:	4685                	li	a3,1
 97c:	4629                	li	a2,10
 97e:	000ba583          	lw	a1,0(s7)
 982:	8556                	mv	a0,s5
 984:	00000097          	auipc	ra,0x0
 988:	ebc080e7          	jalr	-324(ra) # 840 <printint>
 98c:	8bca                	mv	s7,s2
      } else {
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 98e:	4981                	li	s3,0
 990:	b745                	j	930 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 992:	008b8913          	add	s2,s7,8
 996:	4681                	li	a3,0
 998:	4629                	li	a2,10
 99a:	000ba583          	lw	a1,0(s7)
 99e:	8556                	mv	a0,s5
 9a0:	00000097          	auipc	ra,0x0
 9a4:	ea0080e7          	jalr	-352(ra) # 840 <printint>
 9a8:	8bca                	mv	s7,s2
      state = 0;
 9aa:	4981                	li	s3,0
 9ac:	b751                	j	930 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 9ae:	008b8913          	add	s2,s7,8
 9b2:	4681                	li	a3,0
 9b4:	4641                	li	a2,16
 9b6:	000ba583          	lw	a1,0(s7)
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e84080e7          	jalr	-380(ra) # 840 <printint>
 9c4:	8bca                	mv	s7,s2
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	b7a5                	j	930 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 9ca:	008b8c13          	add	s8,s7,8
 9ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9d2:	03000593          	li	a1,48
 9d6:	8556                	mv	a0,s5
 9d8:	00000097          	auipc	ra,0x0
 9dc:	e46080e7          	jalr	-442(ra) # 81e <putc>
  putc(fd, 'x');
 9e0:	07800593          	li	a1,120
 9e4:	8556                	mv	a0,s5
 9e6:	00000097          	auipc	ra,0x0
 9ea:	e38080e7          	jalr	-456(ra) # 81e <putc>
 9ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9f0:	00000b97          	auipc	s7,0x0
 9f4:	3f8b8b93          	add	s7,s7,1016 # de8 <digits>
 9f8:	03c9d793          	srl	a5,s3,0x3c
 9fc:	97de                	add	a5,a5,s7
 9fe:	0007c583          	lbu	a1,0(a5)
 a02:	8556                	mv	a0,s5
 a04:	00000097          	auipc	ra,0x0
 a08:	e1a080e7          	jalr	-486(ra) # 81e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a0c:	0992                	sll	s3,s3,0x4
 a0e:	397d                	addw	s2,s2,-1
 a10:	fe0914e3          	bnez	s2,9f8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 a14:	8be2                	mv	s7,s8
      state = 0;
 a16:	4981                	li	s3,0
 a18:	bf21                	j	930 <vprintf+0x44>
        s = va_arg(ap, char*);
 a1a:	008b8993          	add	s3,s7,8
 a1e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 a22:	02090163          	beqz	s2,a44 <vprintf+0x158>
        while(*s != 0){
 a26:	00094583          	lbu	a1,0(s2)
 a2a:	c9a5                	beqz	a1,a9a <vprintf+0x1ae>
          putc(fd, *s);
 a2c:	8556                	mv	a0,s5
 a2e:	00000097          	auipc	ra,0x0
 a32:	df0080e7          	jalr	-528(ra) # 81e <putc>
          s++;
 a36:	0905                	add	s2,s2,1
        while(*s != 0){
 a38:	00094583          	lbu	a1,0(s2)
 a3c:	f9e5                	bnez	a1,a2c <vprintf+0x140>
        s = va_arg(ap, char*);
 a3e:	8bce                	mv	s7,s3
      state = 0;
 a40:	4981                	li	s3,0
 a42:	b5fd                	j	930 <vprintf+0x44>
          s = "(null)";
 a44:	00000917          	auipc	s2,0x0
 a48:	34490913          	add	s2,s2,836 # d88 <malloc+0x1ea>
        while(*s != 0){
 a4c:	02800593          	li	a1,40
 a50:	bff1                	j	a2c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 a52:	008b8913          	add	s2,s7,8
 a56:	000bc583          	lbu	a1,0(s7)
 a5a:	8556                	mv	a0,s5
 a5c:	00000097          	auipc	ra,0x0
 a60:	dc2080e7          	jalr	-574(ra) # 81e <putc>
 a64:	8bca                	mv	s7,s2
      state = 0;
 a66:	4981                	li	s3,0
 a68:	b5e1                	j	930 <vprintf+0x44>
        putc(fd, c);
 a6a:	02500593          	li	a1,37
 a6e:	8556                	mv	a0,s5
 a70:	00000097          	auipc	ra,0x0
 a74:	dae080e7          	jalr	-594(ra) # 81e <putc>
      state = 0;
 a78:	4981                	li	s3,0
 a7a:	bd5d                	j	930 <vprintf+0x44>
        putc(fd, '%');
 a7c:	02500593          	li	a1,37
 a80:	8556                	mv	a0,s5
 a82:	00000097          	auipc	ra,0x0
 a86:	d9c080e7          	jalr	-612(ra) # 81e <putc>
        putc(fd, c);
 a8a:	85ca                	mv	a1,s2
 a8c:	8556                	mv	a0,s5
 a8e:	00000097          	auipc	ra,0x0
 a92:	d90080e7          	jalr	-624(ra) # 81e <putc>
      state = 0;
 a96:	4981                	li	s3,0
 a98:	bd61                	j	930 <vprintf+0x44>
        s = va_arg(ap, char*);
 a9a:	8bce                	mv	s7,s3
      state = 0;
 a9c:	4981                	li	s3,0
 a9e:	bd49                	j	930 <vprintf+0x44>
    }
  }
}
 aa0:	60a6                	ld	ra,72(sp)
 aa2:	6406                	ld	s0,64(sp)
 aa4:	74e2                	ld	s1,56(sp)
 aa6:	7942                	ld	s2,48(sp)
 aa8:	79a2                	ld	s3,40(sp)
 aaa:	7a02                	ld	s4,32(sp)
 aac:	6ae2                	ld	s5,24(sp)
 aae:	6b42                	ld	s6,16(sp)
 ab0:	6ba2                	ld	s7,8(sp)
 ab2:	6c02                	ld	s8,0(sp)
 ab4:	6161                	add	sp,sp,80
 ab6:	8082                	ret

0000000000000ab8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ab8:	715d                	add	sp,sp,-80
 aba:	ec06                	sd	ra,24(sp)
 abc:	e822                	sd	s0,16(sp)
 abe:	1000                	add	s0,sp,32
 ac0:	e010                	sd	a2,0(s0)
 ac2:	e414                	sd	a3,8(s0)
 ac4:	e818                	sd	a4,16(s0)
 ac6:	ec1c                	sd	a5,24(s0)
 ac8:	03043023          	sd	a6,32(s0)
 acc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ad0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ad4:	8622                	mv	a2,s0
 ad6:	00000097          	auipc	ra,0x0
 ada:	e16080e7          	jalr	-490(ra) # 8ec <vprintf>
}
 ade:	60e2                	ld	ra,24(sp)
 ae0:	6442                	ld	s0,16(sp)
 ae2:	6161                	add	sp,sp,80
 ae4:	8082                	ret

0000000000000ae6 <printf>:

void
printf(const char *fmt, ...)
{
 ae6:	711d                	add	sp,sp,-96
 ae8:	ec06                	sd	ra,24(sp)
 aea:	e822                	sd	s0,16(sp)
 aec:	1000                	add	s0,sp,32
 aee:	e40c                	sd	a1,8(s0)
 af0:	e810                	sd	a2,16(s0)
 af2:	ec14                	sd	a3,24(s0)
 af4:	f018                	sd	a4,32(s0)
 af6:	f41c                	sd	a5,40(s0)
 af8:	03043823          	sd	a6,48(s0)
 afc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b00:	00840613          	add	a2,s0,8
 b04:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b08:	85aa                	mv	a1,a0
 b0a:	4505                	li	a0,1
 b0c:	00000097          	auipc	ra,0x0
 b10:	de0080e7          	jalr	-544(ra) # 8ec <vprintf>
}
 b14:	60e2                	ld	ra,24(sp)
 b16:	6442                	ld	s0,16(sp)
 b18:	6125                	add	sp,sp,96
 b1a:	8082                	ret

0000000000000b1c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b1c:	1141                	add	sp,sp,-16
 b1e:	e422                	sd	s0,8(sp)
 b20:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b22:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b26:	00000797          	auipc	a5,0x0
 b2a:	3027b783          	ld	a5,770(a5) # e28 <freep>
 b2e:	a02d                	j	b58 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b30:	4618                	lw	a4,8(a2)
 b32:	9f2d                	addw	a4,a4,a1
 b34:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b38:	6398                	ld	a4,0(a5)
 b3a:	6310                	ld	a2,0(a4)
 b3c:	a83d                	j	b7a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b3e:	ff852703          	lw	a4,-8(a0)
 b42:	9f31                	addw	a4,a4,a2
 b44:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b46:	ff053683          	ld	a3,-16(a0)
 b4a:	a091                	j	b8e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b4c:	6398                	ld	a4,0(a5)
 b4e:	00e7e463          	bltu	a5,a4,b56 <free+0x3a>
 b52:	00e6ea63          	bltu	a3,a4,b66 <free+0x4a>
{
 b56:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b58:	fed7fae3          	bgeu	a5,a3,b4c <free+0x30>
 b5c:	6398                	ld	a4,0(a5)
 b5e:	00e6e463          	bltu	a3,a4,b66 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b62:	fee7eae3          	bltu	a5,a4,b56 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b66:	ff852583          	lw	a1,-8(a0)
 b6a:	6390                	ld	a2,0(a5)
 b6c:	02059813          	sll	a6,a1,0x20
 b70:	01c85713          	srl	a4,a6,0x1c
 b74:	9736                	add	a4,a4,a3
 b76:	fae60de3          	beq	a2,a4,b30 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b7a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b7e:	4790                	lw	a2,8(a5)
 b80:	02061593          	sll	a1,a2,0x20
 b84:	01c5d713          	srl	a4,a1,0x1c
 b88:	973e                	add	a4,a4,a5
 b8a:	fae68ae3          	beq	a3,a4,b3e <free+0x22>
    p->s.ptr = bp->s.ptr;
 b8e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b90:	00000717          	auipc	a4,0x0
 b94:	28f73c23          	sd	a5,664(a4) # e28 <freep>
}
 b98:	6422                	ld	s0,8(sp)
 b9a:	0141                	add	sp,sp,16
 b9c:	8082                	ret

0000000000000b9e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b9e:	7139                	add	sp,sp,-64
 ba0:	fc06                	sd	ra,56(sp)
 ba2:	f822                	sd	s0,48(sp)
 ba4:	f426                	sd	s1,40(sp)
 ba6:	f04a                	sd	s2,32(sp)
 ba8:	ec4e                	sd	s3,24(sp)
 baa:	e852                	sd	s4,16(sp)
 bac:	e456                	sd	s5,8(sp)
 bae:	e05a                	sd	s6,0(sp)
 bb0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bb2:	02051493          	sll	s1,a0,0x20
 bb6:	9081                	srl	s1,s1,0x20
 bb8:	04bd                	add	s1,s1,15
 bba:	8091                	srl	s1,s1,0x4
 bbc:	0014899b          	addw	s3,s1,1
 bc0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 bc2:	00000517          	auipc	a0,0x0
 bc6:	26653503          	ld	a0,614(a0) # e28 <freep>
 bca:	c515                	beqz	a0,bf6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bcc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bce:	4798                	lw	a4,8(a5)
 bd0:	02977f63          	bgeu	a4,s1,c0e <malloc+0x70>
  if(nu < 4096)
 bd4:	8a4e                	mv	s4,s3
 bd6:	0009871b          	sext.w	a4,s3
 bda:	6685                	lui	a3,0x1
 bdc:	00d77363          	bgeu	a4,a3,be2 <malloc+0x44>
 be0:	6a05                	lui	s4,0x1
 be2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 be6:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bea:	00000917          	auipc	s2,0x0
 bee:	23e90913          	add	s2,s2,574 # e28 <freep>
  if(p == (char*)-1)
 bf2:	5afd                	li	s5,-1
 bf4:	a895                	j	c68 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 bf6:	00030797          	auipc	a5,0x30
 bfa:	43a78793          	add	a5,a5,1082 # 31030 <base>
 bfe:	00000717          	auipc	a4,0x0
 c02:	22f73523          	sd	a5,554(a4) # e28 <freep>
 c06:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c08:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c0c:	b7e1                	j	bd4 <malloc+0x36>
      if(p->s.size == nunits)
 c0e:	02e48c63          	beq	s1,a4,c46 <malloc+0xa8>
        p->s.size -= nunits;
 c12:	4137073b          	subw	a4,a4,s3
 c16:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c18:	02071693          	sll	a3,a4,0x20
 c1c:	01c6d713          	srl	a4,a3,0x1c
 c20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c26:	00000717          	auipc	a4,0x0
 c2a:	20a73123          	sd	a0,514(a4) # e28 <freep>
      return (void*)(p + 1);
 c2e:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c32:	70e2                	ld	ra,56(sp)
 c34:	7442                	ld	s0,48(sp)
 c36:	74a2                	ld	s1,40(sp)
 c38:	7902                	ld	s2,32(sp)
 c3a:	69e2                	ld	s3,24(sp)
 c3c:	6a42                	ld	s4,16(sp)
 c3e:	6aa2                	ld	s5,8(sp)
 c40:	6b02                	ld	s6,0(sp)
 c42:	6121                	add	sp,sp,64
 c44:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c46:	6398                	ld	a4,0(a5)
 c48:	e118                	sd	a4,0(a0)
 c4a:	bff1                	j	c26 <malloc+0x88>
  hp->s.size = nu;
 c4c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c50:	0541                	add	a0,a0,16
 c52:	00000097          	auipc	ra,0x0
 c56:	eca080e7          	jalr	-310(ra) # b1c <free>
  return freep;
 c5a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c5e:	d971                	beqz	a0,c32 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c62:	4798                	lw	a4,8(a5)
 c64:	fa9775e3          	bgeu	a4,s1,c0e <malloc+0x70>
    if(p == freep)
 c68:	00093703          	ld	a4,0(s2)
 c6c:	853e                	mv	a0,a5
 c6e:	fef719e3          	bne	a4,a5,c60 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c72:	8552                	mv	a0,s4
 c74:	00000097          	auipc	ra,0x0
 c78:	b82080e7          	jalr	-1150(ra) # 7f6 <sbrk>
  if(p == (char*)-1)
 c7c:	fd5518e3          	bne	a0,s5,c4c <malloc+0xae>
        return 0;
 c80:	4501                	li	a0,0
 c82:	bf45                	j	c32 <malloc+0x94>
