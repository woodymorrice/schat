
CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
INC = -I. -I/student/cmpt332/pthreads
LIB1 = -L. -llist liblist.a
LIB2 = -L/student/cmpt332/pthreads/lib/Linuxx86_64 -lpthreads

all: lab5 

lab5: sim.o liblist.a
	$(CC) $(LIB2) -o lab5 sim.o $(LIB1)

sim.o: sim.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -c sim.c -o sim.o

.PHONY: clean lab5

clean: 
	rm -f *.o lab5
