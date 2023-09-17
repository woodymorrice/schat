.PHONY: clean

all: mytestlist.o liblist.a
	gcc -g -I. -o all -L/student/wdz468/cmpt332-2023-group14/partC/ -llist mytestlist.c

liblist.a : list_adders.o list_movers.o list_removers.o
	ar -rs liblist.a list_adders.o list_movers.o list_removers.o

list_adders.o: list_adders.c list.h
	gcc -I. -g -O -Wall -Wextra list_adders.c

list_movers.o: list_movers.c list.h
	gcc -I. -g -O -Wall -Wextra list_movers.c

list_removers.o: list_removers.c list.h
	gcc -I. -g -O -Wall -Wextra list_removers.c

mytestlist.o: mytestlist.c list.h
	gcc -I. -g -O -Wall -Wextra mytestlist.c

clean:
	rm -f all *.o
    
