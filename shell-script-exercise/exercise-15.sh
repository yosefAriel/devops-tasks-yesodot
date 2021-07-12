#!/bin/sh

read -p "enter the extension: " EXTENSION
exist=`ls *.$EXTENSION | wc -l`
echo "number of file with the extension entered in $exist"

if [ $exist -gt 0 ] ;then 
for FILENAME in *.$EXTENSION ; do 
    echo $FILENAME

    read -p "enter the new name you wanted: " NEWNAME
    if [ -z $NEWNAME ] ; then 
	echo "this is the old name $FILENAME , and this is the new name `date '+%Y-%m-%d'`${FILENAME##*.}"
        mv $FILENAME "`date '+%Y-%m-%d'`.${FILENAME##*.}"
    else 
	echo "this is the old name $FILENAME , and this is the new name $NEWNAME.${FILENAME##*.}"
	mv $FILENAME  "$NEWNAME.${FILENAME##*.}"
    fi
done
else 
	echo "There is no file with the extension entered "
fi
