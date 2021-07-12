#!/bin/sh

cat /etc/shadow

if [ "$?" -eq "0" ] ; then
	echo "command succeeded .this is the exit code $? "
	exit 0
else 
	echo "Command failed .this is the exit code $? "
	exit 1
fi
