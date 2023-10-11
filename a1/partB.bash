#!/bin/bash
# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

OS=$(uname -s)

if [ $1 = partA1 ]
then
    if [[ ! "$OS" =~ ^(MSYS|MINGW).*$ ]]
    then
        exit
    fi
elif [[ "$1" =~ ^(partA2|partA3|partA4)$ ]]
then
    if [ $OS != Linux ]
    then
        exit
    fi
else
    exit
fi

# positive non-zero integer
# with possible leading zeros
ex="[0]*[1-9]\d*"

testNum=1

while read -r line;
do
    echo "# Test" $testNum
    ((testNum+=1))

    IFS=' ' read a1 a2 a3 garbage <<< $line

    if [[ "$a1" =~ $ex ]] && [[ "$a1" -le 64    ]] &&
       [[ "$a2" =~ $ex ]] && [[ "$a2" -le 300   ]] &&
       [[ "$a3" =~ $ex ]] && [[ "$a3" -le 20000 ]]
       then
           ./$1 $a1 $a2 $a3
    fi
    echo 
done

