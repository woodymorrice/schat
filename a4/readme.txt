# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

Usage:
memsim.c takes up to four command line arguments.
The first command line argument is the number of requests that each thread
should run. Can range from 1-10000. Note that if many threads are performing
many requests, the chance of deadlock is very high.
The second command line argument is the algorithm to use. 0 indicates the
best fit algorithm. 1 indicates the first fit algorithm. If only the first
argument is provided, the algorithm will run best fit by default.
The third argument tells memsim.c whether or not to generate new random #s.
0 is no, 1 is yes. This value is set to 1 by default, so if less than three
arguments are provided, it will always generate new random numbers.
The fourth argument is the number of threads to use for the tests.

So if you wanted to test 1000 requests with 4 threads and then 8 threads using
the same set of random numbers, you would run memsim 4 times with the
following arguments:

./memsim 1000 0 1 4
./memsim 1000 1 0 4
./memsim 1000 0 0 8
./memsim 1000 1 0 8

NOTE: these same values will be in a text file in the configurations folder.
