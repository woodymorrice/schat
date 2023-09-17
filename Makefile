# Group 14 - CMPT 332
# Woody Morrice - wam553 - 11071060
# Phong Thanh Nguyen (David) - wdz468 - 11310824i

# Variables
CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra

# Main Target
all: windows_main.exe	


# Windows

# Linking
windows_main.exe: windows_main.o square.o
	$(CC) $(CFLAGS) $(CPPFLAGS) -o windows_main.exe windows_main.o square.o

# Compiling
windows_main.o: windows_main.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -o windows_main.o -c windows_main.c

square.o: square.c square.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -o square.o -c square.c


.PHONY: clean

clean:
	rm -f *.o *.exe
