#!/bin/bash

# Input file containing the hashes
input_file="extract_source.txt" # Replace with your file name

# Output file for unique extracted hashes
output_file="extract_result.txt"

# Check if the input file exists
if [[ ! -f "$input_file" ]]; then
  echo "Error: $input_file not found!"
  exit 1
fi

# Extract hashes starting with 'Qm', ensure uniqueness, and save to the output file
grep -o '\bQm[1-9A-Za-z]\{44\}\b' "$input_file" | sort | uniq > "$output_file"

# Confirm completion
if [[ $? -eq 0 ]]; then
  echo "Unique hashes successfully extracted to $output_file"
else
  echo "An error occurred while extracting hashes."
fi
