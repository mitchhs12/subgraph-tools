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
        output=$(kubectl exec -it index-node-community-quarantine-0 -- /bin/sh -c "graphman info -s \"$subgraph\"")

        # Extract block numbers using grep, cut, and xargs for consistent trimming
        earliest_block=$(echo "$output" | grep 'Earliest Block' | head -n 1 | cut -d '|' -f 2 | xargs)
        latest_block=$(echo "$output" | grep 'Latest Block' | head -n 1 | cut -d '|' -f 2 | xargs)
        chain_head_block=$(echo "$output" | grep 'Chain Head Block' | head -n 1 | cut -d '|' -f 2 | xargs)

        # Debug output to ensure block numbers are captured correctly
        # echo "Earliest Block: $earliest_block, Latest Block: $latest_block, Chain Head Block: $chain_head_block"

        # Check if we successfully extracted all three values
        if [[ "$earliest_block" =~ ^[0-9]+$ ]] && [[ "$latest_block" =~ ^[0-9]+$ ]] && [[ "$chain_head_block" =~ ^[0-9]+$ ]] && [ "$chain_head_block" -ne "$earliest_block" ]; then
            # Calculate the sync percentage
            sync_percentage=$(echo "scale=4; (($latest_block - $earliest_block) / ($chain_head_block - $earliest_block)) * 100" | bc)
            echo "$subgraph: $sync_percentage% | (Blocks behind: $(($chain_head_block - $latest_block)))"
        else
            echo "Failed to retrieve block data for subgraph: $subgraph"
        fi
    ) &
done

# Wait for all background processes to finish
wait

echo "All subgraphs have been processed."
