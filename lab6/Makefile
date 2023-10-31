# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
INC = -I. -I/student/cmpt332/rtt/include -I/usr/include/tirpc
LIB1 = -L/student/cmpt332/rtt/lib/Linuxx86_64 -ltirpc
LIB2 = -lRtt -lRttUtils -L. -llist liblist.a


all: reader-writer-test

reader-writer-test: reader-writer-monitor.o monitor.o reader-writer.o liblist.a 
	$(CC) $(LIB1) -o reader-writer-test \
		monitor.o reader-writer.o reader-writer-monitor.o $(LIB2)

reader-writer-monitor.o: reader-writer-monitor.c reader-writer-monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -c reader-writer-monitor.c \
	    -o reader-writer-monitor.o
	
reader-writer.o: reader-writer.c reader-writer-monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -c reader-writer.c \
		-o reader-writer.o 

monitor.o: monitor.h monitor.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -c monitor.c -o monitor.o


.PHONY: clean all

clean: 
	rm -f *.o reader-writer-test
	
