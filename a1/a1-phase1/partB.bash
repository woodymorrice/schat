#!/bin/bash
# CMPT332 - Group 14
# Phong Thanh Nguyen (David) - wdz468 - 11310824
# Woody Morrice - wam553 - 11071060

OS=$(uname -s)


# read each line from stdin one by one
while read -r line;
do
    argNum=1
    arg1=0
    arg2=0
    arg3=0

    invalidLine=0

    # iterate through the arguments
    for arg in $line
    do
        
        # after three arguments stop reading
        if [ $argNum -lt 4 ]
        then

            # if the argument is an integer, assign it
            if [[ $arg =~ ^[0-9]+$ ]]
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

        case $1 in
            partA1)
                # Windows
                if [ $OS = Linux ]
                then
                    echo "OS not compatible"
                    exit 1
                fi
                echo "executing Windows threads"
                ./windows_main.exe $arg1 $arg2 $arg3
                ;;
                
            partA2)
                # UBC pthreads
                echo "executing UBC pthreads"
                echo "... not yet implemented"
                ;;

            partA3)
                # Posix
                echo "executing Posix threads"
                echo "... not yet implemented"
                ;;

            partA4)
                # UNIX
                echo "executing UNIX threads"
                echo "...not yet implemented"
                ;;
        esac
    fi
done

