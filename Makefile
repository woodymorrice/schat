# Group 14 - CMPT 332
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

# Variables
CC = gcc
CFLAGS = -g -I.
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
LIBS = ./
PLATFORM = $(shell uname -s)


# Main Target
ifeq ($(PLATFORM),Linux)
all: mytestlist

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
windows_main.exe: windows_main.o square.o
	$(CC) -o windows_main.exe windows_main.o square.o

# Compiling
windows_main.o: windows_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c windows_main.c -o windows_main.o

square.o: square.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c square.c -o square.o


# Part C

mytestlist: mytestlist.o liblist.a
	$(CC) $(CFLAGS) $(CPPFLAGS) -L$(LIBS) -llist -o mytestlist mytestlist.o liblist.a

liblist.a : list_adders.o list_movers.o list_removers.o
	ar -rs liblist.a list_adders.o list_movers.o list_removers.o

list_adders.o: list_adders.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c list_adders.c -o list_adders.o

list_movers.o: list_movers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c list_movers.c -o list_movers.o

list_removers.o: list_removers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c list_removers.c -o list_removers.o

mytestlist.o: mytestlist.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c mytestlist.c -o mytestlist.o


.PHONY: clean

clean:
	rm -f *.o windows_main.exe
	rm -f liblist.a mytestlist
