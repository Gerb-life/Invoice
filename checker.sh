#!/bin/bash
#This script is used to check the headers , and their categories
#Gabriel Rodriguez Kellan Anderson
# EXIT LEGEND
# exit 0 - successful
# exit 1 - missing header
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

#remove temp file because its not used anymore
rm temp.txt


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

################################ Customer ####################################
#checking to see if first header is customer
if [ ${headerArray[0]} != "customer" ]; then
    echo Error: Missings Header Line
    exit 1
fi

################################# Address ####################################
#checking to see if second header is address
if [ ${headerArray[1]} == "address" ]; then
    #check to see if instate or out of state
       if [ $inOutState = "-i" ];then

            # if instate check if state is not NC
            if [[ ${addressArray[2]} != *"NC"* ]]; then
                echo Error: Invoice is instate , but state is not NC
                exit 2
            fi

            # if out of state check if state is NC
       elif [ $inOutState = "-o" ];then
            if [[ ${addressArray[2]} == *"NC"* ]];then
                echo Error: Invoice is out of state , but state is NC
                exit 2
            fi
       fi

else
    echo Error: Missing Header Line
    echo Last Header line $customer
    exit 1
fi
################################ Customer ####################################
#checking to see if thrid header is categories
if [ ${headerArray[2]} != "categories" ]; then
    echo Error: Missing Header Line
    echo Last Header Line $address
    exit 1
fi

################################# Items ######################################
#checking to see if final header is items
if [ ${headerArray[3]} != "items" ]; then
    echo Error: Missing header Line
    echo Last header Line
    exit 1
fi

#Check to see if number of items matches number of categories
if [ ${#categoryArray[@]} -eq ${#itemArray[@]} ];then
    #successful
    exit 0
else
    catlen=${#categoryArray[@]}
    itemlen=${#itemArray[@]}
    echo Error invalid item quantities: $catlen Categories but $itemlen  items
    exit 3
fi

)