#!/bin/bash
#This script is used to validate invoices by makign sure they have the 
#correct permissions , correct extension and calls checker.sh to make sure
#that the file has the correct headers and correct number of items in each 
#category
#Authors: Gabriel Rodriguez , Kellan Anderson

#EXIT LEGEND
#exit 0 - successful
#exit 1 - invalid permissions
#exit 2 - file does not exist
file=$1
#checking correct number of args
if [ $# -eq 1 ]; then
    #checking if file exists
    if [ -f $file ]; then
            #checking if file is readable
            if [ -r $file ]; then

                #checking for correct file extension
                if [[ $file = *.iso ]];then

                    #calling checker.sh to make sure headers are correct
                    bash checker.sh -i $file
                    exit $?
                elif [[ $file = *.oso ]]; then
                    bash checker.sh -o $file
                    exit $?
                    

                else
                    echo Error: "${file##*.}" is not a valid extension
                    exit 1
                fi

            else
                echo Error: $file is not readable.
                exit 1
            fi

    else
        echo Error: $file is not accessable.
        exit 1
    fi

else
        echo Usage valid.sh '<filename>'
        exit 1
fi
