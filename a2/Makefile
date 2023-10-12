# CMPT332 - Group 14`
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
ARM = arm-linux-gnueabihf-gcc
PPC = ppc64-linux-gnu-gcc #powerpc-linux-gnu-gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
INC = -I.
LIB = -L.
UBCINC = -I/student/cmpt332/pthreads/
UBCLIB = -lpthreads \
		 -L/student/cmpt332/pthreads/lib/Linux
RTTINC = -I/student/cmpt332/rtt/include \
		 -I/usr/include/tirpc
RTTLIB1 = -L/student/cmpt332/rtt/lib/Linuxx86_64 \
		 -ltirpc
RTTLIB2 = -lRtt -lRttUtils -L. -llist liblist.a \
		  -lMonitor libMonitor.a
ARCH = $(shell uname -m)


all: s-chat liblist.a reader-writer-test

s-chat: s-chat-x86_64 s-chat-ppc s-chat-arm

# Part B
#
# reader_writer_test using libMonitor.a and
# liblist.a with -l<<libraryname>> 
reader-writer-test: reader-writer.o reader-writer-monitor.o \
	liblist.a libMonitor.a
	$(CC) $(RTTLIB1) -o reader-writer-test reader-writer.o \
		reader-writer-monitor.o $(RTTLIB2)

reader-writer.o: reader-writer.c reader-writer-monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(RTTINC) \
		-c reader-writer.c -o reader-writer.o

reader-writer-monitor.o: reader-writer-monitor.c reader-writer-monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(RTTINC) \
		-c reader-writer-monitor.c -o reader-writer-monitor.o

libMonitor.a: monitor.o
	ar -rs libMonitor.a monitor.o
	ranlib libMonitor.a

monitor.o: monitor.c monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(RTTINC) \
		-c monitor.c -o monitor.o


# Part C
#
# s-chat for three different architectures:
# 	x86_64, ppc, arm

s-chat-x86_64: s-chat-x86_64.o
	$(CC) $(UBCLIB)x86_64 \
		-o s-chat-x86_64 s-chat-x86_64.o

s-chat-ppc: s-chat-ppc.o
	$(PCC) $(UBCLIB)ppc64 \
		-o s-chat-ppc s-chat-ppc.o

s-chat-arm: s-chat-arm.o
	$(ARM) $(UBCLIB)arm \
		-o s-chat-arm s-chat-arm.o


s-chat-x86_64.o: s-chat.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(UBCINC) \
		-o s-chat-x86_64.o -c s-chat.c

s-chat-ppc.o: s-chat.c
	$(PPC) $(CPPFLAGS) $(CFLAGS) $(UBCINC) \
		-o s-chat-ppc.o -c s-chat.c

s-chat-arm.o: s-chat.c
	$(ARM) $(CPPFLAGS) $(CFLAGS) $(UBCINC) \
		-o s-chat-arm.o -c s-chat.c


# Other
# liblist.a compiled from source
liblist.a: list_adders.o list_movers.o list_removers.o
	ar -rs liblist.a list_adders.o \
		list_movers.o list_removers.o
	ranlib liblist.a

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
.PHONY: clean all s-chat

clean:
	rm -f *.o liblist.a \
		  s-chat-x86_64 s-chat-ppc \
		  s-chat-arm reader-writer-test

