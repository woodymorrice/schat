# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
NOEXEC = -z noexecstack

INC = -I.
LIB = -lm

sim: sim.o
	$(CC) $(NOEXEC) -o sim sim.o $(LIB)

sim.o: sim.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -o sim.o -c sim.c 

.PHONY: clean

clean: 
	rm -f sim.o sim
