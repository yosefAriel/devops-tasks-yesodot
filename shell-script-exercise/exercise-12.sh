#!/bin/sh

file_count () {
  FILENUM=`find -type f | wc -l`
  return $FILENUM
}

file_count
echo $?

