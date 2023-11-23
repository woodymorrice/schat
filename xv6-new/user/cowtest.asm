
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
/* allocate more than half of physical memory, */
/* then fork. this will fail in the default */
/* kernel, which does not support copy-on-write. */
void
simpletest()
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	d2250513          	add	a0,a0,-734 # d30 <malloc+0xf0>
  16:	00001097          	auipc	ra,0x1
  1a:	b72080e7          	jalr	-1166(ra) # b88 <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	add	a0,a0,1364 # 5555554 <base+0x5550544>
  26:	00001097          	auipc	ra,0x1
  2a:	872080e7          	jalr	-1934(ra) # 898 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00001097          	auipc	ra,0x1
  42:	852080e7          	jalr	-1966(ra) # 890 <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	7ba080e7          	jalr	1978(ra) # 808 <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	7ba080e7          	jalr	1978(ra) # 818 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	add	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa5a9c>
  6e:	00001097          	auipc	ra,0x1
  72:	82a080e7          	jalr	-2006(ra) # 898 <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	d0450513          	add	a0,a0,-764 # d80 <malloc+0x140>
  84:	00001097          	auipc	ra,0x1
  88:	b04080e7          	jalr	-1276(ra) # b88 <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	add	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	add	a1,a1,1364 # 5555554 <base+0x5550544>
  a2:	00001517          	auipc	a0,0x1
  a6:	c9e50513          	add	a0,a0,-866 # d40 <malloc+0x100>
  aa:	00001097          	auipc	ra,0x1
  ae:	ade080e7          	jalr	-1314(ra) # b88 <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	75c080e7          	jalr	1884(ra) # 810 <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	c9c50513          	add	a0,a0,-868 # d58 <malloc+0x118>
  c4:	00001097          	auipc	ra,0x1
  c8:	ac4080e7          	jalr	-1340(ra) # b88 <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	742080e7          	jalr	1858(ra) # 810 <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	73a080e7          	jalr	1850(ra) # 810 <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	add	a1,a1,1364 # 5555554 <base+0x5550544>
  e6:	00001517          	auipc	a0,0x1
  ea:	c8250513          	add	a0,a0,-894 # d68 <malloc+0x128>
  ee:	00001097          	auipc	ra,0x1
  f2:	a9a080e7          	jalr	-1382(ra) # b88 <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	718080e7          	jalr	1816(ra) # 810 <exit>

0000000000000100 <threetest>:
/* this causes more than half of physical memory */
/* to be allocated, so it also checks whether */
/* copied pages are freed. */
void
threetest()
{
 100:	7179                	add	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	add	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	c7850513          	add	a0,a0,-904 # d88 <malloc+0x148>
 118:	00001097          	auipc	ra,0x1
 11c:	a70080e7          	jalr	-1424(ra) # b88 <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	774080e7          	jalr	1908(ra) # 898 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	6d4080e7          	jalr	1748(ra) # 808 <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	744080e7          	jalr	1860(ra) # 890 <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x5550ff0>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	6b8080e7          	jalr	1720(ra) # 818 <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	736080e7          	jalr	1846(ra) # 8a0 <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	718080e7          	jalr	1816(ra) # 890 <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	70a080e7          	jalr	1802(ra) # 898 <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	be450513          	add	a0,a0,-1052 # d80 <malloc+0x140>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	9e4080e7          	jalr	-1564(ra) # b88 <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	add	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	b8050513          	add	a0,a0,-1152 # d40 <malloc+0x100>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	9c0080e7          	jalr	-1600(ra) # b88 <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	63e080e7          	jalr	1598(ra) # 810 <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	bb650513          	add	a0,a0,-1098 # d90 <malloc+0x150>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	9a6080e7          	jalr	-1626(ra) # b88 <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	624080e7          	jalr	1572(ra) # 810 <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	614080e7          	jalr	1556(ra) # 808 <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	684080e7          	jalr	1668(ra) # 890 <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	66c080e7          	jalr	1644(ra) # 890 <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	5d8080e7          	jalr	1496(ra) # 810 <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	b6050513          	add	a0,a0,-1184 # da0 <malloc+0x160>
 248:	00001097          	auipc	ra,0x1
 24c:	940080e7          	jalr	-1728(ra) # b88 <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	5be080e7          	jalr	1470(ra) # 810 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	add	a5,a5,1807 # 270f <buf+0x6ff>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	59e080e7          	jalr	1438(ra) # 810 <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	b3650513          	add	a0,a0,-1226 # db0 <malloc+0x170>
 282:	00001097          	auipc	ra,0x1
 286:	906080e7          	jalr	-1786(ra) # b88 <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	584080e7          	jalr	1412(ra) # 810 <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	b1c50513          	add	a0,a0,-1252 # db0 <malloc+0x170>
 29c:	00001097          	auipc	ra,0x1
 2a0:	8ec080e7          	jalr	-1812(ra) # b88 <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	56a080e7          	jalr	1386(ra) # 810 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	ab650513          	add	a0,a0,-1354 # d68 <malloc+0x128>
 2ba:	00001097          	auipc	ra,0x1
 2be:	8ce080e7          	jalr	-1842(ra) # b88 <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	54c080e7          	jalr	1356(ra) # 810 <exit>

00000000000002cc <filetest>:
char junk3[4096];

/* test whether copyout() simulates COW faults. */
void
filetest()
{
 2cc:	7179                	add	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	add	s0,sp,48
  printf("file: ");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	ae850513          	add	a0,a0,-1304 # dc0 <malloc+0x180>
 2e0:	00001097          	auipc	ra,0x1
 2e4:	8a8080e7          	jalr	-1880(ra) # b88 <printf>
  
  buf[0] = 99;
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	d2f70223          	sb	a5,-732(a4) # 2010 <buf>

  for(int i = 0; i < 4; i++){
 2f4:	fc042c23          	sw	zero,-40(s0)
    if(pipe(fds) != 0){
 2f8:	00001497          	auipc	s1,0x1
 2fc:	d0848493          	add	s1,s1,-760 # 1000 <fds>
  for(int i = 0; i < 4; i++){
 300:	490d                	li	s2,3
    if(pipe(fds) != 0){
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	51c080e7          	jalr	1308(ra) # 820 <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 30e:	00000097          	auipc	ra,0x0
 312:	4fa080e7          	jalr	1274(ra) # 808 <fork>
    if(pid < 0){
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 31c:	4611                	li	a2,4
 31e:	fd840593          	add	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	50c080e7          	jalr	1292(ra) # 830 <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
  for(int i = 0; i < 4; i++){
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 34a:	fdc40513          	add	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	4ca080e7          	jalr	1226(ra) # 818 <wait>
    if(xstatus != 0) {
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
  for(int i = 0; i < 4; i++) {
 35e:	34fd                	addw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
      exit(1);
    }
  }

  if(buf[0] != 99){
 362:	00002717          	auipc	a4,0x2
 366:	cae74703          	lbu	a4,-850(a4) # 2010 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 372:	00001517          	auipc	a0,0x1
 376:	a0e50513          	add	a0,a0,-1522 # d80 <malloc+0x140>
 37a:	00001097          	auipc	ra,0x1
 37e:	80e080e7          	jalr	-2034(ra) # b88 <printf>
}
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	add	sp,sp,48
 38c:	8082                	ret
      printf("pipe() failed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	a3a50513          	add	a0,a0,-1478 # dc8 <malloc+0x188>
 396:	00000097          	auipc	ra,0x0
 39a:	7f2080e7          	jalr	2034(ra) # b88 <printf>
      exit(-1);
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	470080e7          	jalr	1136(ra) # 810 <exit>
      printf("fork failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	9e850513          	add	a0,a0,-1560 # d90 <malloc+0x150>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	7d8080e7          	jalr	2008(ra) # b88 <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	456080e7          	jalr	1110(ra) # 810 <exit>
      sleep(1);
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	4dc080e7          	jalr	1244(ra) # 8a0 <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	c4258593          	add	a1,a1,-958 # 2010 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	c2a52503          	lw	a0,-982(a0) # 1000 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	44a080e7          	jalr	1098(ra) # 828 <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
      sleep(1);
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	4b2080e7          	jalr	1202(ra) # 8a0 <sleep>
      if(j != i){
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	c167a783          	lw	a5,-1002(a5) # 2010 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
        printf("error: read the wrong value\n");
 406:	00001517          	auipc	a0,0x1
 40a:	9ea50513          	add	a0,a0,-1558 # df0 <malloc+0x1b0>
 40e:	00000097          	auipc	ra,0x0
 412:	77a080e7          	jalr	1914(ra) # b88 <printf>
        exit(1);
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	3f8080e7          	jalr	1016(ra) # 810 <exit>
        printf("error: read failed\n");
 420:	00001517          	auipc	a0,0x1
 424:	9b850513          	add	a0,a0,-1608 # dd8 <malloc+0x198>
 428:	00000097          	auipc	ra,0x0
 42c:	760080e7          	jalr	1888(ra) # b88 <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	3de080e7          	jalr	990(ra) # 810 <exit>
      exit(0);
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	3d4080e7          	jalr	980(ra) # 810 <exit>
      printf("error: write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	9cc50513          	add	a0,a0,-1588 # e10 <malloc+0x1d0>
 44c:	00000097          	auipc	ra,0x0
 450:	73c080e7          	jalr	1852(ra) # b88 <printf>
      exit(-1);
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	3ba080e7          	jalr	954(ra) # 810 <exit>
      exit(1);
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	3b0080e7          	jalr	944(ra) # 810 <exit>
    printf("error: child overwrote parent\n");
 468:	00001517          	auipc	a0,0x1
 46c:	9c050513          	add	a0,a0,-1600 # e28 <malloc+0x1e8>
 470:	00000097          	auipc	ra,0x0
 474:	718080e7          	jalr	1816(ra) # b88 <printf>
    exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	396080e7          	jalr	918(ra) # 810 <exit>

0000000000000482 <main>:

int
main(int argc, char *argv[])
{
 482:	1141                	add	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	add	s0,sp,16
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 48a:	00000097          	auipc	ra,0x0
 48e:	42e080e7          	jalr	1070(ra) # 8b8 <getNumFreePages>
 492:	85aa                	mv	a1,a0
 494:	00001517          	auipc	a0,0x1
 498:	9b450513          	add	a0,a0,-1612 # e48 <malloc+0x208>
 49c:	00000097          	auipc	ra,0x0
 4a0:	6ec080e7          	jalr	1772(ra) # b88 <printf>
  simpletest();
 4a4:	00000097          	auipc	ra,0x0
 4a8:	b5c080e7          	jalr	-1188(ra) # 0 <simpletest>
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 4ac:	00000097          	auipc	ra,0x0
 4b0:	40c080e7          	jalr	1036(ra) # 8b8 <getNumFreePages>
 4b4:	85aa                	mv	a1,a0
 4b6:	00001517          	auipc	a0,0x1
 4ba:	99250513          	add	a0,a0,-1646 # e48 <malloc+0x208>
 4be:	00000097          	auipc	ra,0x0
 4c2:	6ca080e7          	jalr	1738(ra) # b88 <printf>

  /* check that the first simpletest() freed the physical memory. */
  simpletest();
 4c6:	00000097          	auipc	ra,0x0
 4ca:	b3a080e7          	jalr	-1222(ra) # 0 <simpletest>
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 4ce:	00000097          	auipc	ra,0x0
 4d2:	3ea080e7          	jalr	1002(ra) # 8b8 <getNumFreePages>
 4d6:	85aa                	mv	a1,a0
 4d8:	00001517          	auipc	a0,0x1
 4dc:	97050513          	add	a0,a0,-1680 # e48 <malloc+0x208>
 4e0:	00000097          	auipc	ra,0x0
 4e4:	6a8080e7          	jalr	1704(ra) # b88 <printf>

  threetest();
 4e8:	00000097          	auipc	ra,0x0
 4ec:	c18080e7          	jalr	-1000(ra) # 100 <threetest>
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 4f0:	00000097          	auipc	ra,0x0
 4f4:	3c8080e7          	jalr	968(ra) # 8b8 <getNumFreePages>
 4f8:	85aa                	mv	a1,a0
 4fa:	00001517          	auipc	a0,0x1
 4fe:	94e50513          	add	a0,a0,-1714 # e48 <malloc+0x208>
 502:	00000097          	auipc	ra,0x0
 506:	686080e7          	jalr	1670(ra) # b88 <printf>
  threetest();
 50a:	00000097          	auipc	ra,0x0
 50e:	bf6080e7          	jalr	-1034(ra) # 100 <threetest>
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 512:	00000097          	auipc	ra,0x0
 516:	3a6080e7          	jalr	934(ra) # 8b8 <getNumFreePages>
 51a:	85aa                	mv	a1,a0
 51c:	00001517          	auipc	a0,0x1
 520:	92c50513          	add	a0,a0,-1748 # e48 <malloc+0x208>
 524:	00000097          	auipc	ra,0x0
 528:	664080e7          	jalr	1636(ra) # b88 <printf>
  threetest();
 52c:	00000097          	auipc	ra,0x0
 530:	bd4080e7          	jalr	-1068(ra) # 100 <threetest>
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 534:	00000097          	auipc	ra,0x0
 538:	384080e7          	jalr	900(ra) # 8b8 <getNumFreePages>
 53c:	85aa                	mv	a1,a0
 53e:	00001517          	auipc	a0,0x1
 542:	90a50513          	add	a0,a0,-1782 # e48 <malloc+0x208>
 546:	00000097          	auipc	ra,0x0
 54a:	642080e7          	jalr	1602(ra) # b88 <printf>

  filetest();
 54e:	00000097          	auipc	ra,0x0
 552:	d7e080e7          	jalr	-642(ra) # 2cc <filetest>
  printf("Free pages in phys. page table: %d\n", getNumFreePages());
 556:	00000097          	auipc	ra,0x0
 55a:	362080e7          	jalr	866(ra) # 8b8 <getNumFreePages>
 55e:	85aa                	mv	a1,a0
 560:	00001517          	auipc	a0,0x1
 564:	8e850513          	add	a0,a0,-1816 # e48 <malloc+0x208>
 568:	00000097          	auipc	ra,0x0
 56c:	620080e7          	jalr	1568(ra) # b88 <printf>

  printf("ALL COW TESTS PASSED\n");
 570:	00001517          	auipc	a0,0x1
 574:	90050513          	add	a0,a0,-1792 # e70 <malloc+0x230>
 578:	00000097          	auipc	ra,0x0
 57c:	610080e7          	jalr	1552(ra) # b88 <printf>

  exit(0);
 580:	4501                	li	a0,0
 582:	00000097          	auipc	ra,0x0
 586:	28e080e7          	jalr	654(ra) # 810 <exit>

000000000000058a <_main>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
_main()
{
 58a:	1141                	add	sp,sp,-16
 58c:	e406                	sd	ra,8(sp)
 58e:	e022                	sd	s0,0(sp)
 590:	0800                	add	s0,sp,16
  extern int main();
  main();
 592:	00000097          	auipc	ra,0x0
 596:	ef0080e7          	jalr	-272(ra) # 482 <main>
  exit(0);
 59a:	4501                	li	a0,0
 59c:	00000097          	auipc	ra,0x0
 5a0:	274080e7          	jalr	628(ra) # 810 <exit>

00000000000005a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 5a4:	1141                	add	sp,sp,-16
 5a6:	e422                	sd	s0,8(sp)
 5a8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5aa:	87aa                	mv	a5,a0
 5ac:	0585                	add	a1,a1,1
 5ae:	0785                	add	a5,a5,1
 5b0:	fff5c703          	lbu	a4,-1(a1)
 5b4:	fee78fa3          	sb	a4,-1(a5)
 5b8:	fb75                	bnez	a4,5ac <strcpy+0x8>
    ;
  return os;
}
 5ba:	6422                	ld	s0,8(sp)
 5bc:	0141                	add	sp,sp,16
 5be:	8082                	ret

00000000000005c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5c0:	1141                	add	sp,sp,-16
 5c2:	e422                	sd	s0,8(sp)
 5c4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 5c6:	00054783          	lbu	a5,0(a0)
 5ca:	cb91                	beqz	a5,5de <strcmp+0x1e>
 5cc:	0005c703          	lbu	a4,0(a1)
 5d0:	00f71763          	bne	a4,a5,5de <strcmp+0x1e>
    p++, q++;
 5d4:	0505                	add	a0,a0,1
 5d6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 5d8:	00054783          	lbu	a5,0(a0)
 5dc:	fbe5                	bnez	a5,5cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 5de:	0005c503          	lbu	a0,0(a1)
}
 5e2:	40a7853b          	subw	a0,a5,a0
 5e6:	6422                	ld	s0,8(sp)
 5e8:	0141                	add	sp,sp,16
 5ea:	8082                	ret

00000000000005ec <strlen>:

uint
strlen(const char *s)
{
 5ec:	1141                	add	sp,sp,-16
 5ee:	e422                	sd	s0,8(sp)
 5f0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5f2:	00054783          	lbu	a5,0(a0)
 5f6:	cf91                	beqz	a5,612 <strlen+0x26>
 5f8:	0505                	add	a0,a0,1
 5fa:	87aa                	mv	a5,a0
 5fc:	86be                	mv	a3,a5
 5fe:	0785                	add	a5,a5,1
 600:	fff7c703          	lbu	a4,-1(a5)
 604:	ff65                	bnez	a4,5fc <strlen+0x10>
 606:	40a6853b          	subw	a0,a3,a0
 60a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 60c:	6422                	ld	s0,8(sp)
 60e:	0141                	add	sp,sp,16
 610:	8082                	ret
  for(n = 0; s[n]; n++)
 612:	4501                	li	a0,0
 614:	bfe5                	j	60c <strlen+0x20>

0000000000000616 <memset>:

void*
memset(void *dst, int c, uint n)
{
 616:	1141                	add	sp,sp,-16
 618:	e422                	sd	s0,8(sp)
 61a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 61c:	ca19                	beqz	a2,632 <memset+0x1c>
 61e:	87aa                	mv	a5,a0
 620:	1602                	sll	a2,a2,0x20
 622:	9201                	srl	a2,a2,0x20
 624:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 628:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 62c:	0785                	add	a5,a5,1
 62e:	fee79de3          	bne	a5,a4,628 <memset+0x12>
  }
  return dst;
}
 632:	6422                	ld	s0,8(sp)
 634:	0141                	add	sp,sp,16
 636:	8082                	ret

0000000000000638 <strchr>:

char*
strchr(const char *s, char c)
{
 638:	1141                	add	sp,sp,-16
 63a:	e422                	sd	s0,8(sp)
 63c:	0800                	add	s0,sp,16
  for(; *s; s++)
 63e:	00054783          	lbu	a5,0(a0)
 642:	cb99                	beqz	a5,658 <strchr+0x20>
    if(*s == c)
 644:	00f58763          	beq	a1,a5,652 <strchr+0x1a>
  for(; *s; s++)
 648:	0505                	add	a0,a0,1
 64a:	00054783          	lbu	a5,0(a0)
 64e:	fbfd                	bnez	a5,644 <strchr+0xc>
      return (char*)s;
  return 0;
 650:	4501                	li	a0,0
}
 652:	6422                	ld	s0,8(sp)
 654:	0141                	add	sp,sp,16
 656:	8082                	ret
  return 0;
 658:	4501                	li	a0,0
 65a:	bfe5                	j	652 <strchr+0x1a>

000000000000065c <gets>:

char*
gets(char *buf, int max)
{
 65c:	711d                	add	sp,sp,-96
 65e:	ec86                	sd	ra,88(sp)
 660:	e8a2                	sd	s0,80(sp)
 662:	e4a6                	sd	s1,72(sp)
 664:	e0ca                	sd	s2,64(sp)
 666:	fc4e                	sd	s3,56(sp)
 668:	f852                	sd	s4,48(sp)
 66a:	f456                	sd	s5,40(sp)
 66c:	f05a                	sd	s6,32(sp)
 66e:	ec5e                	sd	s7,24(sp)
 670:	1080                	add	s0,sp,96
 672:	8baa                	mv	s7,a0
 674:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 676:	892a                	mv	s2,a0
 678:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 67a:	4aa9                	li	s5,10
 67c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 67e:	89a6                	mv	s3,s1
 680:	2485                	addw	s1,s1,1
 682:	0344d863          	bge	s1,s4,6b2 <gets+0x56>
    cc = read(0, &c, 1);
 686:	4605                	li	a2,1
 688:	faf40593          	add	a1,s0,-81
 68c:	4501                	li	a0,0
 68e:	00000097          	auipc	ra,0x0
 692:	19a080e7          	jalr	410(ra) # 828 <read>
    if(cc < 1)
 696:	00a05e63          	blez	a0,6b2 <gets+0x56>
    buf[i++] = c;
 69a:	faf44783          	lbu	a5,-81(s0)
 69e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 6a2:	01578763          	beq	a5,s5,6b0 <gets+0x54>
 6a6:	0905                	add	s2,s2,1
 6a8:	fd679be3          	bne	a5,s6,67e <gets+0x22>
  for(i=0; i+1 < max; ){
 6ac:	89a6                	mv	s3,s1
 6ae:	a011                	j	6b2 <gets+0x56>
 6b0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 6b2:	99de                	add	s3,s3,s7
 6b4:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1994ff0>
  return buf;
}
 6b8:	855e                	mv	a0,s7
 6ba:	60e6                	ld	ra,88(sp)
 6bc:	6446                	ld	s0,80(sp)
 6be:	64a6                	ld	s1,72(sp)
 6c0:	6906                	ld	s2,64(sp)
 6c2:	79e2                	ld	s3,56(sp)
 6c4:	7a42                	ld	s4,48(sp)
 6c6:	7aa2                	ld	s5,40(sp)
 6c8:	7b02                	ld	s6,32(sp)
 6ca:	6be2                	ld	s7,24(sp)
 6cc:	6125                	add	sp,sp,96
 6ce:	8082                	ret

00000000000006d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6d0:	1101                	add	sp,sp,-32
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	e426                	sd	s1,8(sp)
 6d8:	e04a                	sd	s2,0(sp)
 6da:	1000                	add	s0,sp,32
 6dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6de:	4581                	li	a1,0
 6e0:	00000097          	auipc	ra,0x0
 6e4:	170080e7          	jalr	368(ra) # 850 <open>
  if(fd < 0)
 6e8:	02054563          	bltz	a0,712 <stat+0x42>
 6ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6ee:	85ca                	mv	a1,s2
 6f0:	00000097          	auipc	ra,0x0
 6f4:	178080e7          	jalr	376(ra) # 868 <fstat>
 6f8:	892a                	mv	s2,a0
  close(fd);
 6fa:	8526                	mv	a0,s1
 6fc:	00000097          	auipc	ra,0x0
 700:	13c080e7          	jalr	316(ra) # 838 <close>
  return r;
}
 704:	854a                	mv	a0,s2
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	64a2                	ld	s1,8(sp)
 70c:	6902                	ld	s2,0(sp)
 70e:	6105                	add	sp,sp,32
 710:	8082                	ret
    return -1;
 712:	597d                	li	s2,-1
 714:	bfc5                	j	704 <stat+0x34>

0000000000000716 <atoi>:

int
atoi(const char *s)
{
 716:	1141                	add	sp,sp,-16
 718:	e422                	sd	s0,8(sp)
 71a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 71c:	00054683          	lbu	a3,0(a0)
 720:	fd06879b          	addw	a5,a3,-48 # fd0 <digits+0xe8>
 724:	0ff7f793          	zext.b	a5,a5
 728:	4625                	li	a2,9
 72a:	02f66863          	bltu	a2,a5,75a <atoi+0x44>
 72e:	872a                	mv	a4,a0
  n = 0;
 730:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 732:	0705                	add	a4,a4,1
 734:	0025179b          	sllw	a5,a0,0x2
 738:	9fa9                	addw	a5,a5,a0
 73a:	0017979b          	sllw	a5,a5,0x1
 73e:	9fb5                	addw	a5,a5,a3
 740:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 744:	00074683          	lbu	a3,0(a4)
 748:	fd06879b          	addw	a5,a3,-48
 74c:	0ff7f793          	zext.b	a5,a5
 750:	fef671e3          	bgeu	a2,a5,732 <atoi+0x1c>
  return n;
}
 754:	6422                	ld	s0,8(sp)
 756:	0141                	add	sp,sp,16
 758:	8082                	ret
  n = 0;
 75a:	4501                	li	a0,0
 75c:	bfe5                	j	754 <atoi+0x3e>

000000000000075e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 75e:	1141                	add	sp,sp,-16
 760:	e422                	sd	s0,8(sp)
 762:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 764:	02b57463          	bgeu	a0,a1,78c <memmove+0x2e>
    while(n-- > 0)
 768:	00c05f63          	blez	a2,786 <memmove+0x28>
 76c:	1602                	sll	a2,a2,0x20
 76e:	9201                	srl	a2,a2,0x20
 770:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 774:	872a                	mv	a4,a0
      *dst++ = *src++;
 776:	0585                	add	a1,a1,1
 778:	0705                	add	a4,a4,1
 77a:	fff5c683          	lbu	a3,-1(a1)
 77e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 782:	fee79ae3          	bne	a5,a4,776 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 786:	6422                	ld	s0,8(sp)
 788:	0141                	add	sp,sp,16
 78a:	8082                	ret
    dst += n;
 78c:	00c50733          	add	a4,a0,a2
    src += n;
 790:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 792:	fec05ae3          	blez	a2,786 <memmove+0x28>
 796:	fff6079b          	addw	a5,a2,-1
 79a:	1782                	sll	a5,a5,0x20
 79c:	9381                	srl	a5,a5,0x20
 79e:	fff7c793          	not	a5,a5
 7a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 7a4:	15fd                	add	a1,a1,-1
 7a6:	177d                	add	a4,a4,-1
 7a8:	0005c683          	lbu	a3,0(a1)
 7ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 7b0:	fee79ae3          	bne	a5,a4,7a4 <memmove+0x46>
 7b4:	bfc9                	j	786 <memmove+0x28>

00000000000007b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 7b6:	1141                	add	sp,sp,-16
 7b8:	e422                	sd	s0,8(sp)
 7ba:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 7bc:	ca05                	beqz	a2,7ec <memcmp+0x36>
 7be:	fff6069b          	addw	a3,a2,-1
 7c2:	1682                	sll	a3,a3,0x20
 7c4:	9281                	srl	a3,a3,0x20
 7c6:	0685                	add	a3,a3,1
 7c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 7ca:	00054783          	lbu	a5,0(a0)
 7ce:	0005c703          	lbu	a4,0(a1)
 7d2:	00e79863          	bne	a5,a4,7e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 7d6:	0505                	add	a0,a0,1
    p2++;
 7d8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 7da:	fed518e3          	bne	a0,a3,7ca <memcmp+0x14>
  }
  return 0;
 7de:	4501                	li	a0,0
 7e0:	a019                	j	7e6 <memcmp+0x30>
      return *p1 - *p2;
 7e2:	40e7853b          	subw	a0,a5,a4
}
 7e6:	6422                	ld	s0,8(sp)
 7e8:	0141                	add	sp,sp,16
 7ea:	8082                	ret
  return 0;
 7ec:	4501                	li	a0,0
 7ee:	bfe5                	j	7e6 <memcmp+0x30>

00000000000007f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7f0:	1141                	add	sp,sp,-16
 7f2:	e406                	sd	ra,8(sp)
 7f4:	e022                	sd	s0,0(sp)
 7f6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 7f8:	00000097          	auipc	ra,0x0
 7fc:	f66080e7          	jalr	-154(ra) # 75e <memmove>
}
 800:	60a2                	ld	ra,8(sp)
 802:	6402                	ld	s0,0(sp)
 804:	0141                	add	sp,sp,16
 806:	8082                	ret

0000000000000808 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 808:	4885                	li	a7,1
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <exit>:
.global exit
exit:
 li a7, SYS_exit
 810:	4889                	li	a7,2
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <wait>:
.global wait
wait:
 li a7, SYS_wait
 818:	488d                	li	a7,3
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 820:	4891                	li	a7,4
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <read>:
.global read
read:
 li a7, SYS_read
 828:	4895                	li	a7,5
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <write>:
.global write
write:
 li a7, SYS_write
 830:	48c1                	li	a7,16
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <close>:
.global close
close:
 li a7, SYS_close
 838:	48d5                	li	a7,21
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <kill>:
.global kill
kill:
 li a7, SYS_kill
 840:	4899                	li	a7,6
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <exec>:
.global exec
exec:
 li a7, SYS_exec
 848:	489d                	li	a7,7
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <open>:
.global open
open:
 li a7, SYS_open
 850:	48bd                	li	a7,15
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 858:	48c5                	li	a7,17
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 860:	48c9                	li	a7,18
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 868:	48a1                	li	a7,8
 ecall
 86a:	00000073          	ecall
 ret
 86e:	8082                	ret

0000000000000870 <link>:
.global link
link:
 li a7, SYS_link
 870:	48cd                	li	a7,19
 ecall
 872:	00000073          	ecall
 ret
 876:	8082                	ret

0000000000000878 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 878:	48d1                	li	a7,20
 ecall
 87a:	00000073          	ecall
 ret
 87e:	8082                	ret

0000000000000880 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 880:	48a5                	li	a7,9
 ecall
 882:	00000073          	ecall
 ret
 886:	8082                	ret

0000000000000888 <dup>:
.global dup
dup:
 li a7, SYS_dup
 888:	48a9                	li	a7,10
 ecall
 88a:	00000073          	ecall
 ret
 88e:	8082                	ret

0000000000000890 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 890:	48ad                	li	a7,11
 ecall
 892:	00000073          	ecall
 ret
 896:	8082                	ret

0000000000000898 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 898:	48b1                	li	a7,12
 ecall
 89a:	00000073          	ecall
 ret
 89e:	8082                	ret

00000000000008a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 8a0:	48b5                	li	a7,13
 ecall
 8a2:	00000073          	ecall
 ret
 8a6:	8082                	ret

00000000000008a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8a8:	48b9                	li	a7,14
 ecall
 8aa:	00000073          	ecall
 ret
 8ae:	8082                	ret

00000000000008b0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 8b0:	48d9                	li	a7,22
 ecall
 8b2:	00000073          	ecall
 ret
 8b6:	8082                	ret

00000000000008b8 <getNumFreePages>:
.global getNumFreePages
getNumFreePages:
 li a7, SYS_getNumFreePages
 8b8:	48dd                	li	a7,23
 ecall
 8ba:	00000073          	ecall
 ret
 8be:	8082                	ret

00000000000008c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8c0:	1101                	add	sp,sp,-32
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	e822                	sd	s0,16(sp)
 8c6:	1000                	add	s0,sp,32
 8c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8cc:	4605                	li	a2,1
 8ce:	fef40593          	add	a1,s0,-17
 8d2:	00000097          	auipc	ra,0x0
 8d6:	f5e080e7          	jalr	-162(ra) # 830 <write>
}
 8da:	60e2                	ld	ra,24(sp)
 8dc:	6442                	ld	s0,16(sp)
 8de:	6105                	add	sp,sp,32
 8e0:	8082                	ret

00000000000008e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8e2:	7139                	add	sp,sp,-64
 8e4:	fc06                	sd	ra,56(sp)
 8e6:	f822                	sd	s0,48(sp)
 8e8:	f426                	sd	s1,40(sp)
 8ea:	f04a                	sd	s2,32(sp)
 8ec:	ec4e                	sd	s3,24(sp)
 8ee:	0080                	add	s0,sp,64
 8f0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8f2:	c299                	beqz	a3,8f8 <printint+0x16>
 8f4:	0805c963          	bltz	a1,986 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8f8:	2581                	sext.w	a1,a1
  neg = 0;
 8fa:	4881                	li	a7,0
 8fc:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 900:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 902:	2601                	sext.w	a2,a2
 904:	00000517          	auipc	a0,0x0
 908:	5e450513          	add	a0,a0,1508 # ee8 <digits>
 90c:	883a                	mv	a6,a4
 90e:	2705                	addw	a4,a4,1
 910:	02c5f7bb          	remuw	a5,a1,a2
 914:	1782                	sll	a5,a5,0x20
 916:	9381                	srl	a5,a5,0x20
 918:	97aa                	add	a5,a5,a0
 91a:	0007c783          	lbu	a5,0(a5)
 91e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 922:	0005879b          	sext.w	a5,a1
 926:	02c5d5bb          	divuw	a1,a1,a2
 92a:	0685                	add	a3,a3,1
 92c:	fec7f0e3          	bgeu	a5,a2,90c <printint+0x2a>
  if(neg)
 930:	00088c63          	beqz	a7,948 <printint+0x66>
    buf[i++] = '-';
 934:	fd070793          	add	a5,a4,-48
 938:	00878733          	add	a4,a5,s0
 93c:	02d00793          	li	a5,45
 940:	fef70823          	sb	a5,-16(a4)
 944:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 948:	02e05863          	blez	a4,978 <printint+0x96>
 94c:	fc040793          	add	a5,s0,-64
 950:	00e78933          	add	s2,a5,a4
 954:	fff78993          	add	s3,a5,-1
 958:	99ba                	add	s3,s3,a4
 95a:	377d                	addw	a4,a4,-1
 95c:	1702                	sll	a4,a4,0x20
 95e:	9301                	srl	a4,a4,0x20
 960:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 964:	fff94583          	lbu	a1,-1(s2)
 968:	8526                	mv	a0,s1
 96a:	00000097          	auipc	ra,0x0
 96e:	f56080e7          	jalr	-170(ra) # 8c0 <putc>
  while(--i >= 0)
 972:	197d                	add	s2,s2,-1
 974:	ff3918e3          	bne	s2,s3,964 <printint+0x82>
}
 978:	70e2                	ld	ra,56(sp)
 97a:	7442                	ld	s0,48(sp)
 97c:	74a2                	ld	s1,40(sp)
 97e:	7902                	ld	s2,32(sp)
 980:	69e2                	ld	s3,24(sp)
 982:	6121                	add	sp,sp,64
 984:	8082                	ret
    x = -xx;
 986:	40b005bb          	negw	a1,a1
    neg = 1;
 98a:	4885                	li	a7,1
    x = -xx;
 98c:	bf85                	j	8fc <printint+0x1a>

000000000000098e <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 98e:	715d                	add	sp,sp,-80
 990:	e486                	sd	ra,72(sp)
 992:	e0a2                	sd	s0,64(sp)
 994:	fc26                	sd	s1,56(sp)
 996:	f84a                	sd	s2,48(sp)
 998:	f44e                	sd	s3,40(sp)
 99a:	f052                	sd	s4,32(sp)
 99c:	ec56                	sd	s5,24(sp)
 99e:	e85a                	sd	s6,16(sp)
 9a0:	e45e                	sd	s7,8(sp)
 9a2:	e062                	sd	s8,0(sp)
 9a4:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9a6:	0005c903          	lbu	s2,0(a1)
 9aa:	18090c63          	beqz	s2,b42 <vprintf+0x1b4>
 9ae:	8aaa                	mv	s5,a0
 9b0:	8bb2                	mv	s7,a2
 9b2:	00158493          	add	s1,a1,1
  state = 0;
 9b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 9b8:	02500a13          	li	s4,37
 9bc:	4b55                	li	s6,21
 9be:	a839                	j	9dc <vprintf+0x4e>
        putc(fd, c);
 9c0:	85ca                	mv	a1,s2
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	efc080e7          	jalr	-260(ra) # 8c0 <putc>
 9cc:	a019                	j	9d2 <vprintf+0x44>
    } else if(state == '%'){
 9ce:	01498d63          	beq	s3,s4,9e8 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 9d2:	0485                	add	s1,s1,1
 9d4:	fff4c903          	lbu	s2,-1(s1)
 9d8:	16090563          	beqz	s2,b42 <vprintf+0x1b4>
    if(state == 0){
 9dc:	fe0999e3          	bnez	s3,9ce <vprintf+0x40>
      if(c == '%'){
 9e0:	ff4910e3          	bne	s2,s4,9c0 <vprintf+0x32>
        state = '%';
 9e4:	89d2                	mv	s3,s4
 9e6:	b7f5                	j	9d2 <vprintf+0x44>
      if(c == 'd'){
 9e8:	13490263          	beq	s2,s4,b0c <vprintf+0x17e>
 9ec:	f9d9079b          	addw	a5,s2,-99
 9f0:	0ff7f793          	zext.b	a5,a5
 9f4:	12fb6563          	bltu	s6,a5,b1e <vprintf+0x190>
 9f8:	f9d9079b          	addw	a5,s2,-99
 9fc:	0ff7f713          	zext.b	a4,a5
 a00:	10eb6f63          	bltu	s6,a4,b1e <vprintf+0x190>
 a04:	00271793          	sll	a5,a4,0x2
 a08:	00000717          	auipc	a4,0x0
 a0c:	48870713          	add	a4,a4,1160 # e90 <malloc+0x250>
 a10:	97ba                	add	a5,a5,a4
 a12:	439c                	lw	a5,0(a5)
 a14:	97ba                	add	a5,a5,a4
 a16:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 a18:	008b8913          	add	s2,s7,8
 a1c:	4685                	li	a3,1
 a1e:	4629                	li	a2,10
 a20:	000ba583          	lw	a1,0(s7)
 a24:	8556                	mv	a0,s5
 a26:	00000097          	auipc	ra,0x0
 a2a:	ebc080e7          	jalr	-324(ra) # 8e2 <printint>
 a2e:	8bca                	mv	s7,s2
      } else {
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a30:	4981                	li	s3,0
 a32:	b745                	j	9d2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a34:	008b8913          	add	s2,s7,8
 a38:	4681                	li	a3,0
 a3a:	4629                	li	a2,10
 a3c:	000ba583          	lw	a1,0(s7)
 a40:	8556                	mv	a0,s5
 a42:	00000097          	auipc	ra,0x0
 a46:	ea0080e7          	jalr	-352(ra) # 8e2 <printint>
 a4a:	8bca                	mv	s7,s2
      state = 0;
 a4c:	4981                	li	s3,0
 a4e:	b751                	j	9d2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 a50:	008b8913          	add	s2,s7,8
 a54:	4681                	li	a3,0
 a56:	4641                	li	a2,16
 a58:	000ba583          	lw	a1,0(s7)
 a5c:	8556                	mv	a0,s5
 a5e:	00000097          	auipc	ra,0x0
 a62:	e84080e7          	jalr	-380(ra) # 8e2 <printint>
 a66:	8bca                	mv	s7,s2
      state = 0;
 a68:	4981                	li	s3,0
 a6a:	b7a5                	j	9d2 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 a6c:	008b8c13          	add	s8,s7,8
 a70:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a74:	03000593          	li	a1,48
 a78:	8556                	mv	a0,s5
 a7a:	00000097          	auipc	ra,0x0
 a7e:	e46080e7          	jalr	-442(ra) # 8c0 <putc>
  putc(fd, 'x');
 a82:	07800593          	li	a1,120
 a86:	8556                	mv	a0,s5
 a88:	00000097          	auipc	ra,0x0
 a8c:	e38080e7          	jalr	-456(ra) # 8c0 <putc>
 a90:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a92:	00000b97          	auipc	s7,0x0
 a96:	456b8b93          	add	s7,s7,1110 # ee8 <digits>
 a9a:	03c9d793          	srl	a5,s3,0x3c
 a9e:	97de                	add	a5,a5,s7
 aa0:	0007c583          	lbu	a1,0(a5)
 aa4:	8556                	mv	a0,s5
 aa6:	00000097          	auipc	ra,0x0
 aaa:	e1a080e7          	jalr	-486(ra) # 8c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 aae:	0992                	sll	s3,s3,0x4
 ab0:	397d                	addw	s2,s2,-1
 ab2:	fe0914e3          	bnez	s2,a9a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 ab6:	8be2                	mv	s7,s8
      state = 0;
 ab8:	4981                	li	s3,0
 aba:	bf21                	j	9d2 <vprintf+0x44>
        s = va_arg(ap, char*);
 abc:	008b8993          	add	s3,s7,8
 ac0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 ac4:	02090163          	beqz	s2,ae6 <vprintf+0x158>
        while(*s != 0){
 ac8:	00094583          	lbu	a1,0(s2)
 acc:	c9a5                	beqz	a1,b3c <vprintf+0x1ae>
          putc(fd, *s);
 ace:	8556                	mv	a0,s5
 ad0:	00000097          	auipc	ra,0x0
 ad4:	df0080e7          	jalr	-528(ra) # 8c0 <putc>
          s++;
 ad8:	0905                	add	s2,s2,1
        while(*s != 0){
 ada:	00094583          	lbu	a1,0(s2)
 ade:	f9e5                	bnez	a1,ace <vprintf+0x140>
        s = va_arg(ap, char*);
 ae0:	8bce                	mv	s7,s3
      state = 0;
 ae2:	4981                	li	s3,0
 ae4:	b5fd                	j	9d2 <vprintf+0x44>
          s = "(null)";
 ae6:	00000917          	auipc	s2,0x0
 aea:	3a290913          	add	s2,s2,930 # e88 <malloc+0x248>
        while(*s != 0){
 aee:	02800593          	li	a1,40
 af2:	bff1                	j	ace <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 af4:	008b8913          	add	s2,s7,8
 af8:	000bc583          	lbu	a1,0(s7)
 afc:	8556                	mv	a0,s5
 afe:	00000097          	auipc	ra,0x0
 b02:	dc2080e7          	jalr	-574(ra) # 8c0 <putc>
 b06:	8bca                	mv	s7,s2
      state = 0;
 b08:	4981                	li	s3,0
 b0a:	b5e1                	j	9d2 <vprintf+0x44>
        putc(fd, c);
 b0c:	02500593          	li	a1,37
 b10:	8556                	mv	a0,s5
 b12:	00000097          	auipc	ra,0x0
 b16:	dae080e7          	jalr	-594(ra) # 8c0 <putc>
      state = 0;
 b1a:	4981                	li	s3,0
 b1c:	bd5d                	j	9d2 <vprintf+0x44>
        putc(fd, '%');
 b1e:	02500593          	li	a1,37
 b22:	8556                	mv	a0,s5
 b24:	00000097          	auipc	ra,0x0
 b28:	d9c080e7          	jalr	-612(ra) # 8c0 <putc>
        putc(fd, c);
 b2c:	85ca                	mv	a1,s2
 b2e:	8556                	mv	a0,s5
 b30:	00000097          	auipc	ra,0x0
 b34:	d90080e7          	jalr	-624(ra) # 8c0 <putc>
      state = 0;
 b38:	4981                	li	s3,0
 b3a:	bd61                	j	9d2 <vprintf+0x44>
        s = va_arg(ap, char*);
 b3c:	8bce                	mv	s7,s3
      state = 0;
 b3e:	4981                	li	s3,0
 b40:	bd49                	j	9d2 <vprintf+0x44>
    }
  }
}
 b42:	60a6                	ld	ra,72(sp)
 b44:	6406                	ld	s0,64(sp)
 b46:	74e2                	ld	s1,56(sp)
 b48:	7942                	ld	s2,48(sp)
 b4a:	79a2                	ld	s3,40(sp)
 b4c:	7a02                	ld	s4,32(sp)
 b4e:	6ae2                	ld	s5,24(sp)
 b50:	6b42                	ld	s6,16(sp)
 b52:	6ba2                	ld	s7,8(sp)
 b54:	6c02                	ld	s8,0(sp)
 b56:	6161                	add	sp,sp,80
 b58:	8082                	ret

0000000000000b5a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b5a:	715d                	add	sp,sp,-80
 b5c:	ec06                	sd	ra,24(sp)
 b5e:	e822                	sd	s0,16(sp)
 b60:	1000                	add	s0,sp,32
 b62:	e010                	sd	a2,0(s0)
 b64:	e414                	sd	a3,8(s0)
 b66:	e818                	sd	a4,16(s0)
 b68:	ec1c                	sd	a5,24(s0)
 b6a:	03043023          	sd	a6,32(s0)
 b6e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b72:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b76:	8622                	mv	a2,s0
 b78:	00000097          	auipc	ra,0x0
 b7c:	e16080e7          	jalr	-490(ra) # 98e <vprintf>
}
 b80:	60e2                	ld	ra,24(sp)
 b82:	6442                	ld	s0,16(sp)
 b84:	6161                	add	sp,sp,80
 b86:	8082                	ret

0000000000000b88 <printf>:

void
printf(const char *fmt, ...)
{
 b88:	711d                	add	sp,sp,-96
 b8a:	ec06                	sd	ra,24(sp)
 b8c:	e822                	sd	s0,16(sp)
 b8e:	1000                	add	s0,sp,32
 b90:	e40c                	sd	a1,8(s0)
 b92:	e810                	sd	a2,16(s0)
 b94:	ec14                	sd	a3,24(s0)
 b96:	f018                	sd	a4,32(s0)
 b98:	f41c                	sd	a5,40(s0)
 b9a:	03043823          	sd	a6,48(s0)
 b9e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ba2:	00840613          	add	a2,s0,8
 ba6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 baa:	85aa                	mv	a1,a0
 bac:	4505                	li	a0,1
 bae:	00000097          	auipc	ra,0x0
 bb2:	de0080e7          	jalr	-544(ra) # 98e <vprintf>
}
 bb6:	60e2                	ld	ra,24(sp)
 bb8:	6442                	ld	s0,16(sp)
 bba:	6125                	add	sp,sp,96
 bbc:	8082                	ret

0000000000000bbe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bbe:	1141                	add	sp,sp,-16
 bc0:	e422                	sd	s0,8(sp)
 bc2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bc4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc8:	00000797          	auipc	a5,0x0
 bcc:	4407b783          	ld	a5,1088(a5) # 1008 <freep>
 bd0:	a02d                	j	bfa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 bd2:	4618                	lw	a4,8(a2)
 bd4:	9f2d                	addw	a4,a4,a1
 bd6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bda:	6398                	ld	a4,0(a5)
 bdc:	6310                	ld	a2,0(a4)
 bde:	a83d                	j	c1c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 be0:	ff852703          	lw	a4,-8(a0)
 be4:	9f31                	addw	a4,a4,a2
 be6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 be8:	ff053683          	ld	a3,-16(a0)
 bec:	a091                	j	c30 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bee:	6398                	ld	a4,0(a5)
 bf0:	00e7e463          	bltu	a5,a4,bf8 <free+0x3a>
 bf4:	00e6ea63          	bltu	a3,a4,c08 <free+0x4a>
{
 bf8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfa:	fed7fae3          	bgeu	a5,a3,bee <free+0x30>
 bfe:	6398                	ld	a4,0(a5)
 c00:	00e6e463          	bltu	a3,a4,c08 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c04:	fee7eae3          	bltu	a5,a4,bf8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c08:	ff852583          	lw	a1,-8(a0)
 c0c:	6390                	ld	a2,0(a5)
 c0e:	02059813          	sll	a6,a1,0x20
 c12:	01c85713          	srl	a4,a6,0x1c
 c16:	9736                	add	a4,a4,a3
 c18:	fae60de3          	beq	a2,a4,bd2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c1c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c20:	4790                	lw	a2,8(a5)
 c22:	02061593          	sll	a1,a2,0x20
 c26:	01c5d713          	srl	a4,a1,0x1c
 c2a:	973e                	add	a4,a4,a5
 c2c:	fae68ae3          	beq	a3,a4,be0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c30:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c32:	00000717          	auipc	a4,0x0
 c36:	3cf73b23          	sd	a5,982(a4) # 1008 <freep>
}
 c3a:	6422                	ld	s0,8(sp)
 c3c:	0141                	add	sp,sp,16
 c3e:	8082                	ret

0000000000000c40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c40:	7139                	add	sp,sp,-64
 c42:	fc06                	sd	ra,56(sp)
 c44:	f822                	sd	s0,48(sp)
 c46:	f426                	sd	s1,40(sp)
 c48:	f04a                	sd	s2,32(sp)
 c4a:	ec4e                	sd	s3,24(sp)
 c4c:	e852                	sd	s4,16(sp)
 c4e:	e456                	sd	s5,8(sp)
 c50:	e05a                	sd	s6,0(sp)
 c52:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c54:	02051493          	sll	s1,a0,0x20
 c58:	9081                	srl	s1,s1,0x20
 c5a:	04bd                	add	s1,s1,15
 c5c:	8091                	srl	s1,s1,0x4
 c5e:	0014899b          	addw	s3,s1,1
 c62:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c64:	00000517          	auipc	a0,0x0
 c68:	3a453503          	ld	a0,932(a0) # 1008 <freep>
 c6c:	c515                	beqz	a0,c98 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c70:	4798                	lw	a4,8(a5)
 c72:	02977f63          	bgeu	a4,s1,cb0 <malloc+0x70>
  if(nu < 4096)
 c76:	8a4e                	mv	s4,s3
 c78:	0009871b          	sext.w	a4,s3
 c7c:	6685                	lui	a3,0x1
 c7e:	00d77363          	bgeu	a4,a3,c84 <malloc+0x44>
 c82:	6a05                	lui	s4,0x1
 c84:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c88:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c8c:	00000917          	auipc	s2,0x0
 c90:	37c90913          	add	s2,s2,892 # 1008 <freep>
  if(p == (char*)-1)
 c94:	5afd                	li	s5,-1
 c96:	a895                	j	d0a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c98:	00004797          	auipc	a5,0x4
 c9c:	37878793          	add	a5,a5,888 # 5010 <base>
 ca0:	00000717          	auipc	a4,0x0
 ca4:	36f73423          	sd	a5,872(a4) # 1008 <freep>
 ca8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 caa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cae:	b7e1                	j	c76 <malloc+0x36>
      if(p->s.size == nunits)
 cb0:	02e48c63          	beq	s1,a4,ce8 <malloc+0xa8>
        p->s.size -= nunits;
 cb4:	4137073b          	subw	a4,a4,s3
 cb8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cba:	02071693          	sll	a3,a4,0x20
 cbe:	01c6d713          	srl	a4,a3,0x1c
 cc2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cc4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cc8:	00000717          	auipc	a4,0x0
 ccc:	34a73023          	sd	a0,832(a4) # 1008 <freep>
      return (void*)(p + 1);
 cd0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cd4:	70e2                	ld	ra,56(sp)
 cd6:	7442                	ld	s0,48(sp)
 cd8:	74a2                	ld	s1,40(sp)
 cda:	7902                	ld	s2,32(sp)
 cdc:	69e2                	ld	s3,24(sp)
 cde:	6a42                	ld	s4,16(sp)
 ce0:	6aa2                	ld	s5,8(sp)
 ce2:	6b02                	ld	s6,0(sp)
 ce4:	6121                	add	sp,sp,64
 ce6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ce8:	6398                	ld	a4,0(a5)
 cea:	e118                	sd	a4,0(a0)
 cec:	bff1                	j	cc8 <malloc+0x88>
  hp->s.size = nu;
 cee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cf2:	0541                	add	a0,a0,16
 cf4:	00000097          	auipc	ra,0x0
 cf8:	eca080e7          	jalr	-310(ra) # bbe <free>
  return freep;
 cfc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d00:	d971                	beqz	a0,cd4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d02:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d04:	4798                	lw	a4,8(a5)
 d06:	fa9775e3          	bgeu	a4,s1,cb0 <malloc+0x70>
    if(p == freep)
 d0a:	00093703          	ld	a4,0(s2)
 d0e:	853e                	mv	a0,a5
 d10:	fef719e3          	bne	a4,a5,d02 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 d14:	8552                	mv	a0,s4
 d16:	00000097          	auipc	ra,0x0
 d1a:	b82080e7          	jalr	-1150(ra) # 898 <sbrk>
  if(p == (char*)-1)
 d1e:	fd5518e3          	bne	a0,s5,cee <malloc+0xae>
        return 0;
 d22:	4501                	li	a0,0
 d24:	bf45                	j	cd4 <malloc+0x94>
