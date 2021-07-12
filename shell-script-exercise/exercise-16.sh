#!/bin/sh

ls | wc -l
echo "1 status code of the last command $?"
ls | wc -ddddd
echo "2 status code of the last command $?" && exit $? 
ls | wc -l
echo "3 status code of the last command $?"
