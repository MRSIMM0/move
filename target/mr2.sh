#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input_dir> <output_dir>"
  exit 1
fi

input_dir=$1
output_dir=$2

hadoop jar taxis.jar Taxis $input_dir $output_dir