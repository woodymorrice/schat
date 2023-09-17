# Group 14 - CMPT 332
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

# Variables
CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
LIBS = ./


# Main Target
all: windows_main.exe

# Part A

# Windows

# Linking
windows_main.exe: windows_main.o square.o
	$(CC) $(CFLAGS) $(CPPFLAGS) -o windows_main.exe windows_main.o square.o

# Compiling
windows_main.o: windows_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o windows_main.o windows_main.c

square.o: square.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o square.o square.c


# Part C

mytestlist: mytestlist.o liblist.a
	$(CC) $(CFLAGS) $(CPPFLAGS) -L$(LIBS) -llist -o mytestlist mytestlist.o liblist.a

liblist.a : list_adders.o list_movers.o list_removers.o
	ar -rs liblist.a list_adders.o list_movers.o list_removers.o

list_adders.o: list_adders.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -I. -O list_adders.c

list_movers.o: list_movers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -I. -O list_movers.c

list_removers.o: list_removers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -I. -O list_removers.c

mytestlist.o: mytestlist.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -I. -O mytestlist.c


.PHONY: clean

clean:
	rm -f *.o windows_main.exe
	rm -f liblist.a mytestlist
