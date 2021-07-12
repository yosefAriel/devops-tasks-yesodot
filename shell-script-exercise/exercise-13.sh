#!/bin/sh

file_count () { 
  FILENUM=`find $1 -type f | wc -l`
  echo "this is the folder name $1:"
  echo "number of file under given directory :$FILENUM\n" 
}

file_count "/etc"
file_count "/var"
file_count "/usr/bin"

