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
POSINC = -pthread

# Main Target
ifeq ($(PLATFORM),Linux)
all: mytestlist partA2 partA3 partA4

else ifeq (MSYS,$(findstring MSYS,$(PLATFORM)))
all: partA1.exe

else ifeq (MINGW32,$(findstring MINGW32,$(PLATFORM)))
all: partA1.exe

else ifeq (MINGW64,$(findstring MINGW64,$(PLATFORM)))	
all: partA1.exe

else
	@echo makefile: $(PLATFORM) not supported
endif


# Part A

# Windows
# Linking
partA1.exe: partA1.o square.o
	$(CC) -o partA1.exe partA1.o square.o

# Compiling
partA1.o: partA1.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c partA1.c -o partA1.o
	
# Pthreads
# Linking
partA2: partA2.o square.o
	$(CC) $(PTLIB) -o partA2 partA2.o square.o

# Compiling
partA2.o: partA2.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(PTINC) -c partA2.c -o partA2.o

# Posix
# Linking
partA3: partA3.o square.o
	$(CC) -o partA3 partA3.o square.o

# Compiling
partA3.o: partA3.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c partA3.c -o partA3.o

# UNIX
# Linking
partA4: partA4.o square.o
	$(CC) -o partA4 partA4.o square.o

# Compiling
partA4.o: partA4.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c partA4.c -o partA4.o

# All
# Linking
square.o: square.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c square.c -o square.o



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
	rm -f *.o partA1.exe partA2 partA3 partA4
	rm -f liblist.a mytestlist
