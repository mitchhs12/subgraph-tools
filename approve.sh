#!/bin/bash

# Define an array of subgraph IDs (separated by spaces)
allocationId=("60402")

# Loop through each subgraph ID
for subgraph in "${subgraphs[@]}"; do
    (
        echo "Processing subgraph ID: $subgraph"

        # Start the `kubectl exec` command
        kubectl exec -ti indexer-cli -- bash -c "
            graph indexer actions approve \"$allocationId\"
        "
    ) &
done

# Wait for all background processes to finish
wait

echo "All subgraph actions have been approved."
