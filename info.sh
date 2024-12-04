#!/bin/bash

# Define an array of subgraph IDs (separated by spaces)
subgraphs=()
while IFS= read -r line; do
    subgraphs+=("$line")
done < "subgraphs.txt"

# Loop through each subgraph ID
for subgraph in "${subgraphs[@]}"; do
    (
        echo "Fetching block info for subgraph: $subgraph"
        
        # Get the output of the graphman info command
        output=$(kubectl exec index-node-community-quarantine-0 -- /bin/sh -c "graphman info -s \"$subgraph\"")

       echo "$output"
    ) &
done

# Wait for all background processes to finish
wait

echo "All subgraphs have been processed."
