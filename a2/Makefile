# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
ARM = arm-linux-gnueabihf-
PPC = powerpc-linux-gnu-
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra

INC = -I.
LISTLIB = -L. -llist
UBCINC = -I/student/cmpt332/pthreads/
UBCLIB = -lpthreads \
		 -L/student/cmpt332/pthreads/lib/Linux
RTTINC = -I/student/cmpt332/rtt/include \
		 -I/usr/include/tirpc
RTTLIB1 = -L/student/cmpt332/rtt/lib/Linuxx86_64 \
		 -ltirpc
RTTLIB2 = -lRtt -lRttUtils -L. -lMonitor \
		  -llist


# Main Target
all: reader_writer_test s-chat liblist.a

s-chat: s-chat-x86_64 s-chat-ppc s-chat-arm


# Part B
# reader_writer_test using
# libMonitor.a and liblist.a
reader_writer_test: readers_writers.o reader_writer_monitor.o \
	liblist.a libMonitor.a
	$(CC) $(RTTLIB1) -o reader_writer_test readers_writers.o \
		reader_writer_monitor.o $(RTTLIB2)

readers_writers.o: readers_writers.c reader_writer_monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(RTTINC) \
		-c readers_writers.c -o readers_writers.o

reader_writer_monitor.o: reader_writer_monitor.c \
	reader_writer_monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(RTTINC) \
		-c reader_writer_monitor.c -o reader_writer_monitor.o

libMonitor.a: Monitor.o
	ar -rs libMonitor.a Monitor.o
	ranlib libMonitor.a

Monitor.o: Monitor.c Monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(RTTINC) \
		-c Monitor.c -o Monitor.o


# Part C
# s-chat for three different architectures:
# 	x86_64, ppc, arm
s-chat-x86_64: s-chat-x86_64.o liblist.a
	$(CC) $(UBCLIB)x86_64 -o s-chat-x86_64 \
		s-chat-x86_64.o $(LISTLIB)

s-chat-ppc: s-chat-ppc.o liblist-ppc.a
	$(PPC)gcc-10 $(UBCLIB)ppc64 -o s-chat-ppc \
		s-chat-ppc.o $(LISTLIB)-ppc

s-chat-arm: s-chat-arm.o liblist-arm.a
	$(ARM)gcc-10 $(UBCLIB)armv7l -o s-chat-arm \
		s-chat-arm.o $(LISTLIB)-arm


s-chat-x86_64.o: s-chat.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) $(UBCINC) \
		-o s-chat-x86_64.o -c s-chat.c

s-chat-ppc.o: s-chat.c
	$(PPC)gcc-10 $(CPPFLAGS) $(CFLAGS) $(INC) $(UBCINC) \
		-o s-chat-ppc.o -c s-chat.c

s-chat-arm.o: s-chat.c
	$(ARM)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) $(UBCINC) \
		-o s-chat-arm.o -c s-chat.c


# Other
# liblist.a for x86_64
#liblist.a: list_adders.o list_movers.o \
	list_removers.o
#	ar -rs liblist.a list_adders.o \
#		list_movers.o list_removers.o
#	ranlib liblist.a

list_adders.o: list_adders.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_adders.c -o list_adders.o

list_movers.o: list_movers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_movers.c -o list_movers.o

list_removers.o: list_removers.c list.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_removers.c -o list_removers.o

# liblist.a for ppc
liblist-ppc.a: list_adders_ppc.o list_movers_ppc.o \
	list_removers_ppc.o
	$(PPC)ar -rs liblist-ppc.a list_adders_ppc.o \
		list_movers_ppc.o list_removers_ppc.o
	$(PPC)ranlib liblist-ppc.a

list_adders_ppc.o: list_adders.c list.h
	$(PPC)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_adders.c -o list_adders_ppc.o

list_movers_ppc.o: list_movers.c list.h
	$(PPC)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_movers.c -o list_movers_ppc.o

list_removers_ppc.o: list_removers.c list.h
	$(PPC)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_removers.c -o list_removers_ppc.o

# liblist.a for arm
liblist-arm.a: list_adders_arm.o list_movers_arm.o \
	list_removers_arm.o
	$(ARM)ar -rs liblist-arm.a list_adders_arm.o \
		list_movers_arm.o list_removers_arm.o
	$(ARM)ranlib liblist-arm.a

list_adders_arm.o: list_adders.c list.h
	$(ARM)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_adders.c -o list_adders_arm.o

list_movers_arm.o: list_movers.c list.h
	$(ARM)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_movers.c -o list_movers_arm.o

list_removers_arm.o: list_removers.c list.h
	$(ARM)gcc-10 $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c list_removers.c -o list_removers_arm.o

# Misc
.PHONY: clean all s-chat

clean:
	rm -f *.o libMonitor.a s-chat-x86_64 s-chat-ppc \
		  s-chat-arm reader_writer_test 

