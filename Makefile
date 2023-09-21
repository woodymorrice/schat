# Group 14 - CMPT 332
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

# Variables
CC = gcc
CFLAGS = -g -I.
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
LILIB = -L.
PLATFORM = $(shell uname -s)
PTLIB = -L/student/cmpt332/pthreads/lib/Linuxx86_64 -lpthreads
PTINC = -I/student/cmpt332/pthreads/
POSINC = -lpthread

# Main Target
ifeq ($(PLATFORM),Linux)
all: mytestlist pthreads_main posix_main unix_main

else ifeq (MSYS,$(findstring MSYS,$(PLATFORM)))
all: windows_main.exe

else ifeq (MINGW32,$(findstring MINGW32,$(PLATFORM)))
all: windows_main.exe

else ifeq (MINGW64,$(findstring MINGW64,$(PLATFORM)))	
all: windows_main.exe

else
	@echo makefile: $(PLATFORM) not supported
endif


# Part A

# Windows

# Linking
windows_main.exe: windows_main.o square.o htable.o
	$(CC) -o windows_main.exe windows_main.o square.o htable.o

# Compiling
windows_main.o: windows_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c windows_main.c -o windows_main.o

# Pthreads

# Linking
pthreads_main: pthreads_main.o square.o htable.o
	$(CC) $(PTLIB) -o pthreads_main pthreads_main.o square.o htable.o

# Compiling
pthreads_main.o: pthreads_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(PTINC) -c pthreads_main.c -o pthreads_main.o

# Posix

# Linking
posix_main: posix_main.o square.o htable.o
	$(CC) -o posix_main posix_main.o square.o htable.o

# Compiling
posix_main.o: posix_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c posix_main.c -o posix_main.o

# UNIX

# Linking
unix_main: unix_main.o square.o htable.o
	$(CC) -o unix_main unix_main.o square.o htable.o

# Compiling
unix_main.o: unix_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c unix_main.c -o unix_main.o

# Universal Dependencies
square.o: square.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c square.c -o square.o

htable.o: htable.c htable.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c htable.c -o htable.o


# Part C

# List Library

# Linking
mytestlist: mytestlist.o liblist.a
	$(CC) $(LILIB) -llist -o mytestlist mytestlist.o liblist.a

# Archiving
liblist.a : list_adders.o list_movers.o list_removers.o
	ar -rs liblist.a list_adders.o list_movers.o list_removers.o
	ranlib liblist.a

# Compiling
list_adders.o: list_adders.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c list_adders.c -o list_adders.o

list_movers.o: list_movers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c list_movers.c -o list_movers.o

list_removers.o: list_removers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c list_removers.c -o list_removers.o

mytestlist.o: mytestlist.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c mytestlist.c -o mytestlist.o


# Misc
.PHONY: clean all

clean:
	rm -f *.o windows_main.exe pthreads_main posix_main unix_main
	rm -f liblist.a mytestlist
