#!/bin/bash

# check in/out state -> set global var
# ask for name
# check name for non-numbers
# ask for street address
# check the street address
# ask for city
# check the city for non-numbers
# if out of state -> ask for state
#   check to see if state is non-num and is 2 characters long
# ask for fields
# loop through entered feilds and ask how many of each item they want to purchace -> must be a num
# call valid -> print to std out
# if vaild suceeds
#   print file creation message
#   loop through the first two lines of the file and echo to stdout

#Exit status refrences
STATUS_BAD_USAGE=1
STATUS_INVALID_ARG=2


##################################### Name ####################################
if [[ $# != 2 ]] ; then
    echo "usage: create.sh -i|-o filename"
    exit $STATUS_BAD_UASGE
fi

# Get the customer name
echo -n "Please enter customer name > "
read name

# Test to make sure there are no numbers in the customer name
test_name=`echo $name | grep -o -e "[0-9]*"`
if [[ $test_name != "" ]]; then echo "Invalid name"; exit $STATUS_INVALID_ARG; fi


################################### Address ###################################

# get the address
echo -n "Please enter the street address > "
read street_num street_name_1 street_name_2 street_id

# look to see if the the street has more than one name, if not then reassign the
# street identifier
if [[ $street_id == "" ]]; then street_id=$street_name_2; street_name_2=""; fi 

# Make sure the street number is a number
test_street_num=`echo $street_num | grep -o -e "[0-9]*"`
if [[ $test_street_num == "" ]]; then echo "invalid street number"; exit $STATUS_INVALID_ARG; fi

# make sure that the street name and identifier are valid
test_string=`echo $street_name_1$street_name_2$street_id | grep -o -e "[0-9]*"`
if [[ $test_string != "" ]]; then echo "Invalid street name or identifier"; exit $STATUS_INVALID_ARG; fi

# Format the street address into one variable
address=`echo "$street_num $street_name_1 $street_name_2 $street_id"`

##################################### City ####################################

# Get the city
echo -n "Please enter city > "
read city

# Test to make sure the city name is not an empty string and there are not numbers in it
test_city=`echo $city | grep -o -e "[0-9]*"`
if [[ $test_city != "" ]] || [[ $city == "" ]]; then echo "Invlid city name"; exit $STATUS_INVALID_ARG; fi


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
    if [[ $test_state != 3 ]]; then echo "Invalid state"; exit $STATUS_INVALID_ARG; fi
fi

############################## Read Categories ################################

# Get the order fields
echo -n "Please enter the number of fields that compromise the order > "
read fields

# String to to concatenate the output string
purchased=""

# Loop through the fields
for field in $fields; do

    echo -n "Please enter the number of \"$field\" items you want to purchace > "
    read num

    # Check to make sure the number of items purchaced is a number
    test_num=`echo $num | grep -o -e "[0-9]*"`
    if [[ $num == "" ]]; then echo "Invalid argument given, must be a number"; exit $STATUS_INVALID_ARG; fi
    
    purchased=`echo -n "$purchased$num "`

done

########## Formatting ################

# Remove the trailing comma and format the items purchased
purchased=`echo $purchased | awk -F" " 'BEGIN{OFS=",";} {$1=$1; print $0;}'`

cats=`echo $fields | awk -F" " 'BEGIN{OFS=",";} {$1=$1; print $0;}'`

################################## Testing ####################################
echo "customer:$name"
echo "address:$address, $city, $state"
echo "categories:$cats"
echo "Items:$purchased"
