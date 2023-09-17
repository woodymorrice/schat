#!/bin/bash
#

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
                echo "executing Windows threads"
                ;;
                
            partA2)
                # UBC pthreads
                echo "executing UBC pthreads"
                ;;

            partA3)
                # Posix
                echo "executing Posix threads"
                ;;

            partA4)
                # UNIX
                echo "executing UNIX threads"
                ;;
        esac

        # echo "arguments:"
        # echo $arg1
        # echo $arg2
        # echo $arg3
    fi
done

