#!/bin/bash

###############################################################################
# Kellan Anderson, Gabe Rodriguez
# 10/27/2022
#
# Create file for project 2 
# Gets user input for a shopping invoice script and makes sure that all of the
# passed values are valid. It then creates a file and passes it to valid.sh 
###############################################################################

#Exit status legend

STATUS_BAD_USAGE=1
STATUS_INVALID_ARG=2
STATUS_VALID_FAILED=3

#################################### Name ####################################
if [[ $# != 2 ]] ; then
    echo "usage: create.sh -i|-o filename"
    exit $STATUS_BAD_USAGE

# Fix hanging issue
#else 
 #   if [ $1 != "-i" ] | [  $1 != "-o" ]; then
  #      echo "usage: create.sh -i|-o filename"
   #     exit $STATUS_BAD_USAGE
    #fi
fi

# Get the customer name
echo -n "Please enter customer name > "
read name

# Make sure name is not empty
if [[ $name == "" ]]; then 
    echo "Cannot have an empty field"; 
    exit $STATUS_INVALID_ARG; 
fi

# Test to make sure there are no numbers in the customer name
test_name=`echo $name | grep -o -e "[0-9]*"`
if [[ $test_name != "" ]]; then 
    echo "Invalid name"; 
    exit $STATUS_INVALID_ARG; 
fi


################################### Address ###################################

# get the address
echo -n "Please enter the street address > "
read street_num street

# Make sure address is not empty
if [[ $street_num == "" ]]; then 
    echo "Cannot have an empty field"; 
    exit $STATUS_INVALID_ARG; 
fi

# Make sure the street number is a number
test_street_num=`echo $street_num | grep -o -e "[0-9]*"`
if [[ $test_street_num == "" ]]; then 
    echo "Invalid street number"; 
    exit $STATUS_INVALID_ARG; 
fi

# make sure that the street name and identifier are valid
test_string=`echo $street | grep -o -e "[0-9]*"`
if [[ $test_string != "" ]]; then 
    echo "Invalid street name"; 
    exit $STATUS_INVALID_ARG; 
fi

# Format the street address into one variable
address=`echo "$street_num $street"`

##################################### City ####################################

# Get the city
echo -n "Please enter city > "
read city

# Make sure that the city is not empty
if [[ $city == "" ]]; then 
    echo "Cannot have an empty field"; 
    exit $STATUS_INVALID_ARG; 
fi

# Test to make sure the city name is not an empty string and there are not 
# numbers in it
test_city=`echo $city | grep -o -e "[0-9]*"`
if [[ $test_city != "" ]] || [[ $city == "" ]]; then 
    echo "Invalid city name"; 
    exit $STATUS_INVALID_ARG; 
fi


#################################### State ####################################

# Check to see what mode we are running in 
if [[ $1 == "-i" ]] ; then
    # Set state to NC if mode is in state
    state="NC"
else
    # Get the state
    echo -n "Please enter state > "
    read state

    #Test the state
    test_state=`echo $state | grep -ox -e "[^0-9]*" | wc -c`
    if [[ $test_state != 3 ]]; then 
        echo "Invalid state"; 
        exit $STATUS_INVALID_ARG; 
    fi
fi

############################## Read Categories ################################

# Get the order fields
echo -n "Please enter the number of fields that compromise the order > "
read fields

# Make sure that the fields entered are not empty
if [[ $fields == "" ]]; then 
    echo "Cannot have an empty field"; 
    exit $STATUS_INVALID_ARG; 
fi

# String to to concatenate the output string
purchased=""

# Loop through the fields
for field in $fields; do

    echo -n "Please enter the number of \"$field\" items you want to purchace > "
    read num

    # Make sure that the number of the item purchased is not empty
    if [[ $num == "" ]]; then 
        echo "Cannot have an empty field"; 
        exit $STATUS_INVALID_ARG; 
    fi

    # Check to make sure the number of items purchaced is a number
    test_num=`echo -n $num | grep -oe "[a-zA-Z]"`
    if [[ $test_num != "" ]]; then 
        echo "Invalid argument given, must be a number"; 
        exit $STATUS_INVALID_ARG; 
    fi
    
    purchased=`echo -n "$purchased$num "`

done

################################# Formatting ##################################

# Remove the trailing comma and format
purchased=`echo $purchased | awk -F" " 'BEGIN{OFS=",";} {$1=$1; print $0;}'`
cats=`echo $fields | awk -F" " 'BEGIN{OFS=",";} {$1=$1; print $0;}'`

############################### Call Valid.sh #################################

# Get the correct extention
ext=""
if [[ $1 == "-i" ]] ; then
    ext=".iso"
else
    ext=".oso"
fi

# Get the filename
ext=`echo "$2$ext"`

# Populate the file
echo "customer:$name" > $ext
echo "address:$address, $city, $state" >> $ext
echo "categories:$cats" >> $ext
echo "items:$purchased" >> $ext 

# Call valid.sh
echo "Calling valid with $ext"
bash valid.sh $ext
if [[ $? != 0 ]] ; then
    # remove the file if invalid and exit
    rm $ext
    exit $STATUS_VALID_FAILED
fi

# Echo the success
echo ""
echo "\"$ext\" has been created for "
head -n2 $ext

#################################### EOF ######################################
