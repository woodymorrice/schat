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
    else
        exFile=partA1.exe
    fi
elif [[ "$1" =~ ^(partA2|partA3|partA4)$ ]]
then
    if [ $OS != Linux ]
    then
        exit
    else
        exFile=$1
    fi
else
    exit
fi

while read -r line;
do
	./$exFile $line
done

