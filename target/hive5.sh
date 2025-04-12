#!/bin/bash

# Check if required arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <input_dir3> <input_dir4> <output_dir6>"
  exit 1
fi

input_dir3=$1   # Input directory with MapReduce results (first dataset)
input_dir4=$2   # Input directory for the second dataset
output_dir6=$3  # Output directory for the final JSON result

# Execute Hive query with parameters
hive -hiveconf input_dir3=$input_dir3 \
     -hiveconf input_dir4=$input_dir4 \
     -hiveconf output_dir6=$output_dir6 \
     -f taxi_analysis.hql