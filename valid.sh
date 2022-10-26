#!/bin/bash
#This script is used to validate invoices by making sure they have the
#correct permissions,correct extensions,correct headers and the correct,
#number of items in each category
#EXIT LEGEND
#exit 0 - successful
#exit 1 - invalid permissions
#exit 2 - file does not exist
file=$1
#checking correct number of args
if [ $# -eq 1 ]; then
        echo correct number of args
        #checking if file exists
        if [ -f $file ]; then
                echo file exists
                #checking if file is readable
                if [ -r $file ]; then
                        echo readable
                        #checking for correct file extension
                        if [[ $file = *.iso ]];then
                                echo correct extension

                        elif [[ $file = *.oso ]]; then
                                echo correct extension
                                #write separate script to check headings,items and itemcounts.


                        else
                                echo Error: "${file##*.}" is not a valid extension
                        fi

                else
                        echo Error: $file is not readable.
                fi

        else
                echo Error: $file is not accessable.
        fi

else
        echo Usage valid.sh '<filename>'
fi