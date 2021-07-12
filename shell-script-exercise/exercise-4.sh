#!/bin/sh

read -p "Enter file: " FILE
echo $1
if [ -f $FILE ]; then	
	echo "the file exist in the given path $FILE"
	if [ -x $FILE ]; then
		echo "you have a permission to execute this file $FILE"
	else 
		echo "you dont have a permission to execute this file $FILE"
	fi
else 
	echo "the file not exist in the given path $FILE"
fi


