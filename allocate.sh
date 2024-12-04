#!/bin/bash

# Define an array of subgraph IDs (separated by spaces)
subgraphs=("QmYWxWtCAhUiNMAd6GQYXi7V2W2FGaWZrZufQEcTnMMYpP") # Replace with your actual subgraph IDs

# Loop through each subgraph ID
for subgraph in "${subgraphs[@]}"; do
    (
        echo "Processing subgraph ID: $subgraph"

        # Start the `kubectl exec` command
        kubectl exec -ti indexer-cli -- bash -c "
            graph indexer actions queue allocate \"$subgraph\" 1 --network arbitrum-one
        "
    ) &
done

# Wait for all background processes to finish
wait

echo "All subgraph actions have been processed."
