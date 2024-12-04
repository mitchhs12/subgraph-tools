#!/bin/bash

# Define an array of subgraph IDs (separated by space)
subgraphs=()
while IFS= read -r line; do
    subgraphs+=("$line")
done < "subgraphs.txt"

# Loop through each subgraph ID
for subgraph in "${subgraphs[@]}"; do
    echo "Rewinding subgraph with id: $subgraph"
    # Run the command in the background
    kubectl exec index-node-community-quarantine-0 -- /bin/sh -c "graphman rewind \"$subgraph\" --block-hash 0x79304405e29203df523f7b8746ded1338799d64630cae161c79aa7b3fa0bab93 --block-number 43775109" &
done

# Wait for all background processes to finish
wait

echo "All subgraphs have been rewinded."