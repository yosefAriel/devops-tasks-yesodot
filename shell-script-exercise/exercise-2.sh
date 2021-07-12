#!/bin/sh

var1="shell Scripting Is Fun! "
echo $var1
## loop on all given argoments
for var in "$@"
do 
       echo "$var"
done
