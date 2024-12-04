#!/bin/bash

# Define an array of subgraph IDs (separated by spaces)
subgraphs=("QmSVH1s3ekgPUK4ff7pQvAntY5ntQbBwYGf47JEBn6WJmS") # Replace with your actual subgraph IDs

# Loop through each subgraph ID
for subgraph in "${subgraphs[@]}"; do
    (
        echo "Processing subgraph ID: $subgraph"

        # Start the `kubectl exec` command
        kubectl exec -ti indexer-cli -- bash -c "
            graph indexer actions get --fields id,type,status,amount,deploymentID,failureReason,reason,protocolNetwork,transaction --network arbitrum-one | grep \"$subgraph\"
        "
    ) &
done

# Wait for all background processes to finish
wait

echo "All subgraph actions have been processed."
