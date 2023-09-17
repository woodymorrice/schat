.PHONY: clean

all: list_adders.o list_movers.o list_removers.o mytestlist.o list_type.o node_type.o
	gcc -c -g -o all list_adders.o list_movers.o list_removers.o mytestlist.o list_type.o node_type.o

list_adders.o: list_adders.c list.h
	gcc -I. -g -c -O -Wall -Wextra list_adders.c

list_movers.o: list_movers.c list.h
	gcc -I. -g -c -O -Wall -Wextra list_movers.c

list_removers.o: list_removers.c list.h
	gcc -I. -g -c -O -Wall -Wextra list_removers.c

mytestlist.o: mytestlist.c list.h
	gcc -I. -g -c -O -Wall -Wextra mytestlist.c

list_type.o: list_type.c
	gcc -g -c -O -Wall -Wextra list_type.o

node_type.o: node_type.c
	gcc -g -c -O -Wall -Wextra node_type.o

clean:
	rm -f all *.o
    
