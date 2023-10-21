# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
NOEXEC = -z noexecstack

INC = -I.
LIB = -L. -llist
UBCINC = -I/student/cmpt332/pthreads/
UBCLIB = -lpthreads \
		 -L/student/cmpt332/pthreads/lib/Linuxx86_64

sim: sim.o liblist.a
	$(CC) $(NOEXEC) $(UBCLIB) -o sim sim.o $(LIB)


sim.o: sim.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(UBCINC) \
		-o sim.o -c sim.c

.PHONY: clean

clean:
	rm -f sim.o sim

