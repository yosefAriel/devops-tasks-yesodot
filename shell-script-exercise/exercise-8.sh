#!/bin/bash
if [ $# -eq 0 ]
then
   echo "the script must to get at least 1 path orgoments ."
   exit 3
fi
counter=1
for FILE in $@
  do
    if [ -f $FILE ] 
    then 
      echo "the path orguments number $counter $file is a file"
      ls -l $FILE 
    elif [ -d $FILE ]
    then 
      echo "the path orguments number $counter $file is a directory"
      ls -l $FILE
    fi
  counter=$((counter+1))
done
