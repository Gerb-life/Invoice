#!/bin/bash
#This script is used to check the headers , and their categories
#Gabriel ROdriguez Kellan Anderson
# EXIT LEGEND
# exit 0 - successful
# exit 1 - misssing header
# exit 2 - instate , but NC is not the state
# exit 3 - number of items and categories does not match


inOutState=$1
file=$2

#list of headers cut from the first line in the file
header=$(cut -d ":" -f 1 $file)
#removing blank lines from inputfile and storing result in temp.txt
grep . $file > temp.txt

customer=$(awk 'NR==1' temp.txt) #first line of inputfile
address=$(awk 'NR==2' temp.txt) #second line of inputfile
categories=$(awk 'NR==3' temp.txt) #third line of inputfile
items=$(awk 'NR==4' temp.txt) #last line of inputfile

headerArray=($header) #array created from header

#Creating arrays for each of the lines in the file
(IFS=,
read customerLine <<<$customer
customerArray=($customerLine)

read addressLine <<<$address
addressArray=($addressLine)

read categoriesLine <<<$categories
categoryArray=($categoriesLine)

read itemLine <<<$items
itemArray=($itemLine)

##################################### Customer ####################################

if [ ${headerArray[0]} == "customer" ]; then
        #continue
        echo customer
else
        echo Error: Missings Header Line
        exit 1
fi

##################################### Address ####################################
if [ ${headerArray[1]} == "address" ]; then
                #check to see if instate or out of state
                if [ $inOutState = "-i" ];then
                                #check to see if state is NC
                                if [[ ${addressArray[2]} == *"NC"* ]]; then
                                                #continue
                                                echo instate
                                else
                                        echo Error: Invoice is instate , but state is not NC
                                        exit 2
                                fi
                fi
else
        echo Error: Missing Header Line
        echo Last Header line $customer
        exit 1
fi
##################################### Customer ####################################
if [ ${headerArray[2]} == "categories" ]; then
                #continue
                echo categories
else
        echo Error: Missing Header Line
        echo Last Header Line $address
        exit 1
fi

##################################### Items ####################################
if [ ${headerArray[3]} == "items" ]; then
                #continue
                echo items
else
        echo Error: Missing header Line
        echo Last header Line
        exit 1
fi

#Check to see if number of items matches number of categories
if [ ${#categoryArray[@]} -eq ${#itemArray[@]} ];then
                echo success
                exit 0
else
        echo Error invalid item quantities: ${#categoryArray[@]} Categories but ${#itemArray[@]} items
        exit 3
fi

)
rm temp.txt