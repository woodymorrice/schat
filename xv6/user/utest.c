#include "kernel/types.h"                                                       
#include "kernel/param.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"

#include "kernel/stat.h"                                                        
#include "user/user.h"
#include "user/grind.h"                                                         
#include "user/square.h"                                                        
#include <stddef.h>

#define MX_SLP 5
#define MX_CHLD 10
#define MX_SQ 100
#define MX_LVL 12

int forktest(int lvl) {
  int i, j, chld, pid, slp, sq, nulvl;

  /* wont spawn more children so print output */
  if (lvl < 1) {
    return(0);
  }

  /* create a random number of children */
  chld = rand() % MX_CHLD;
  for (i = 0; i < chld; i++) {
    pid = fork();

    /* error in fork */
    if (pid < 0) {
        return(-1);
    } 
    /* child code */
    else if (pid == 0) {
      /* sleep for some time */
      slp = rand() % MX_SLP;
      sleep(slp);

      /* compute some squares */
      sq = rand() % MX_SQ;
      for (j = 1; j < sq; j++) {
        square(j);
      }
      /* randomly choose depth of subtree */
      nulvl = rand() % (lvl - 1);
      forktest(nulvl-1);
    }
    /* parent code */
    else {
      /* print output */
    }
  }

  return(0);
}


int pmain() {
  if (forktest(MX_LVL) != 0) {
    printf("utest: error");
    exit(-1);
  }
  exit(0);
}

