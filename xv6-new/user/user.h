struct stat;

/* system calls */
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

/* Begin CMPT 332 group14 change Fall 2023 */
/* Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

int trace(int);
int getNumFreePages();

/* End CMPT 332 group14 change Fall 2023 */

/*CMPT332 GROUP 14 Change, Fall 2023*/
int mtx_create(int locked);
int mtx_lock(int lock_id);
int mtx_unlock(int lock_id);
void thread_create(void (*func)());
void thread_schedule(void);
void thread_yield(void);
void thread_init(void);



/* ulib.c */
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...);
void printf(const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);