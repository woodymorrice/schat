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
        $1=partA1.exe
    fi
elif [[ "$1" =~ ^(partA2|partA3|partA4)$ ]]
then
    if [ $OS != Linux ]
    then
        exit
    fi
fi

while read -r line;
do
    argNum=1
    invalidLine=0
    # iterate through the arguments
    for arg in $line
    do
        # after three arguments stop reading
        if [ $argNum -lt 4 ]
        then
            # if the argument is an integer, assign it
            if [[ $arg =~ ^\d*[1-9]\d*$ ]]
            then
                if [ $argNum = 1 ]
                then
                    arg1=$arg    
                elif [ $argNum = 2 ]
                then
                    arg2=$arg
                elif [ $argNum = 3 ]
                then
                    arg3=$arg
                fi
            # else the line is not valid
            else
                invalidLine=1
                break
            fi
        fi
        argNum=$((argNum + 1))
    done

    # if the line is valid, execute it
    if [ $invalidLine = 0 ]
    then
        ./$1 $arg1 $arg2 $arg3
    fi
done

