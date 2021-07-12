#!/bin/sh

read -p "Enter file or folder path: " FILE_FOLDER

if [ -f $FILE_FOLDER ] 
then 
	echo this path $FILE_FOLDER is a regular file
	exit 0 
elif [ -d $FILE_FOLDER ]
then 
	echo "this path $FILE_FOLDER is a directory"
	exit 1
else
	echo "this is a special file"
	exit 2
fi
