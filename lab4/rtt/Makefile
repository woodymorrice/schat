.PHONY: clean

CC = gcc
CFLAGS = -g -I.
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra
LILIB = -L/student/cmpt332/rtt/lib/Linuxx86_64 -ltirpc
CINCLUDE = -I$(THREADINCIR) -I/usr/include/tirpc
THREADINCIR = /student/cmpt332/rtt/include

all: lab4

lab4: reader-writer-monitor.o monitor.o reader-writer.o liblist.a 
	$(CC) $(LILIB) -o lab4 monitor.o reader-writer.o reader-writer-monitor.o \
		-lRtt -lRttUtils -L. -llist liblist.a  

reader-writer-monitor.o: reader-writer-monitor.c reader-writer-monitor.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c reader-writer-monitor.c -o \
		reader-writer-monitor.o
	
reader-writer.o: reader-writer.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(CINCLUDE) -c reader-writer.c -o \
		reader-writer.o 

monitor.o: monitor.h monitor.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(CINCLUDE) -c monitor.c -o monitor.o
 
clean: 
	rm -f *.o
	
