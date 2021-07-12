#!/bin/bash

read -p "Enter file or directory path: " PATH_GIVEN

if [ -f $PATH_GIVEN ] 
then 
	echo "the path given is a file"
	ls -l $PATH_GIVEN 
elif [ -d $PATH_GIVEN ]
then 
	echo "the path given is a directory"
	ls -l $PATH_GIVEN
fi
