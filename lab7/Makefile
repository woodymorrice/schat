# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
LIBS = -lm
NOEXEC = -z noexecstack


all: sim

sim: sim.o
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LIBS) $(NOEXEC) \
		-o sim sim.o

sim.o: sim.c
	$(CC) $(CFLAGS) $(CPPFLAGS) \
		-c sim.c -o sim.o


.PHONY: all clean

clean:
	rm -f *.o sim
