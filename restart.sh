#!/bin/bash

# Define an array of subgraph IDs (separated by space)
subgraphs=()
while IFS= read -r line; do
    subgraphs+=("$line")
done < "subgraphs.txt"

# Loop through each subgraph ID
for subgraph in "${subgraphs[@]}"; do
    echo "Restarting subgraph with id: $subgraph"
    # Run the command in the background
    kubectl exec index-node-community-quarantine-0 -- /bin/sh -c "graphman restart \"$subgraph\"" &
done

# Wait for all background processes to finish
wait

echo "All subgraphs have been restarted."
