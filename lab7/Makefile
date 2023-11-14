CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
NOEXEC = -z noexecstack

INC = -I.
LIB = -lm

pagerep-sim: pagerep-sim.o
	$(CC) -o pagerep-sim pagerep-sim.o $(LIB)

pagerep-sim.o: pagerep-sim.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -o pagerep-sim.o -c pagerep-sim.c 

.PHONY: clean

clean: 
	rm -f pagerep-sim.o pagerep-sim
