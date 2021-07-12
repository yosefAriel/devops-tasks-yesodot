#!/bin/sh
for FILENAME in *.jpg ; do 
	mv $FILENAME  "`date '+%Y-%m-%d'`-$FILENAME"

done
