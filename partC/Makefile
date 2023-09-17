.PHONY: clean

all: list_adders.o list_movers.o list_removers.o mytestlist.o
	gcc -c -g -o all list_adders.o list_movers.o list_removers.o mytestlist.o

list_adders.o: list_adders.c list.h
	gcc -I. -g -c -O -Wall -Wextra list_adders.c

list_movers.o: list_movers.c list.h
	gcc -I. -g -c -O -Wall -Wextra list_movers.c

list_removers.o: list_removers.c list.h
	gcc -I. -g -c -O -Wall -Wextra list_removers.c

mytestlist.o: mytestlist.c list.h
	gcc -I. -g -c -O -Wall -Wextra mytestlist.c

clean:
	rm -f all *.o
    
