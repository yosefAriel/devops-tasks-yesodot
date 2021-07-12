#!/bin/bash
if [$1 == ""]
then
   echo "the script must to get a path orgoments ."
   exit 3
fi
if [ -f $1 ] 
then 
	echo "the path given is a file"
	ls -l $1 
elif [ -d $1 ]
then 
	echo "the path given is a directory"
	ls -l $1
fi
