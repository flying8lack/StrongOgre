#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Syntax: move.sh <target_dist>"
    exit 1
fi

cp -f -v -a ./lib/. $1/lib/.
cp -f -v -a ./metrics $1/metrics
if ["$#" -eq 0]; then
  echo "Copy is compelete!"
else
  echo "Copy error! $# was returned"
fi




