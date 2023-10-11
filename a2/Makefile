# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
ARMCC = arm-linux-gnueabihf-gcc-10
PPCCC = powerpc-linux-gnu-gcc-10
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
INC = -I.
LIB = -L.
UBCINC = -I/student/cmpt332/pthreads/
UBCLIB = -lpthreads \
		 -L/student/cmpt332/pthreads/lib/Linux


all: #reader_writer_test #s-chat
		 

# Part B
#
# reader_writer_test using libMonitor.a and
# liblist.a with -l<<libraryname>>
#
# libMonitor.a



# Part C
#
# s-chat for three different architectures:
# 	x86_64, ppc, arm


# Other
# liblist.a compiled from source

# Archiving
liblist.a: list_adders.o list_movers.o list_removers.o
	ar -rs liblist.a list_adders.o \
		list_movers.o list_removers.o
	ranlib liblist.a

# Compiling
list_adders.o: list_adders.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_adders.c -o list_adders.o

list_movers.o: list_movers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_movers.c -o list_movers.o

list_removers.o: list_removers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_removers.c -o list_removers.o


# Misc
.PHONY: clean all

clean:
	rm -f *.o liblist.a \
		  s-chat reader_writer_test

