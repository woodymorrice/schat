# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
INC = -I. -I/student/cmpt332/rtt/include -I/usr/include/tirpc
LIB1 = -L/student/cmpt332/rtt/lib/Linuxx86_64 -ltirpc
LIB2 = -lRtt -lRttUtils -L. -llist liblist.a


all: best-fit

best-fit: monitor.o liblist.a 
	$(CC) $(LIB1) -o best-fit \
		monitor.o $(LIB2) 

monitor.o: monitor.h monitor.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC) -c monitor.c -o monitor.o


.PHONY: clean all

clean: 
	rm -f *.o reader-writer-test
	
