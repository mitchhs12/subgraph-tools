#!/bin/bash

# Open a shell inside the graphman environment on the Kubernetes pod
kubectl exec -it index-node-community-quarantine-0 -- /bin/sh
