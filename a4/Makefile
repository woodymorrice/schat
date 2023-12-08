# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
INC = -I. -I/student/cmpt332/rtt/include -I/usr/include/tirpc
LIB1 = -L/student/cmpt332/rtt/lib/Linuxx86_64 -ltirpc
LIB2 = -lRtt -lRttUtils
LIST = -L. -llist


all: memsim

memsim: memsim.o random.o memmonitor.o \
	monitor.o liblist.a
	$(CC) $(LIB1) -z noexecstack -o memsim \
		memmonitor.o memsim.o monitor.o \
		random.o $(LIB2) $(LIST) -lm

memsim.o: memsim.c memmonitor.h list.h \
	random.h defs.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
        -c memsim.c -o memsim.o

random.o: random.c random.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -I. \
        -c random.c -o random.o

memmonitor.o: memmonitor.c memmonitor.h \
	list.h monitor.h random.h defs.h	
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c memmonitor.c -o memmonitor.o

monitor.o: monitor.h monitor.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) \
		-c monitor.c -o monitor.o

liblist.a: list_adders.o list_movers.o \
	list_removers.o
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


.PHONY: clean all

clean: 
	rm -f *.o *.a memsim \
		  random tmp/*
	
