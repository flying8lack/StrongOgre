#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Syntax: move.sh <target_dist>"
fi

cp -a ./lib/. $1
if ["$#" -eq 0]; then
  echo "Copy compelete!"
else
  echo "Copy error! $# was returned"
fi

