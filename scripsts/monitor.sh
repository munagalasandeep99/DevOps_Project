#!/bin/bash

# Define variables for the pod and namespace
POD_NAME="your-pod-name" # <--- IMPORTANT: Replace with your pod's name
NAMESPACE="default"      # <--- IMPORTANT: Replace if your pod is in a different namespace

# Define threshold values
CPU_THRESHOLD=0.5       # in cores
MEMORY_THRESHOLD=0.5    # in GB

# Function to handle errors and exit
errorExit () {
    echo "ERROR: $1"
    exit 1
}

# Test connection to a cluster and check if the pod exists
kubectl cluster-info > /dev/null 2>&1 || errorExit "Connection to Kubernetes cluster failed. Ensure kubectl is configured."
kubectl get pod "${POD_NAME}" --namespace "${NAMESPACE}" > /dev/null 2>&1 || errorExit "Pod '${POD_NAME}' not found in namespace '${NAMESPACE}'. Check pod name and namespace."

# Get the raw output from kubectl top pod
TOP_OUTPUT=$(kubectl top pod "${POD_NAME}" --namespace "${NAMESPACE}" --no-headers --use-protocol-buffers)

# Check if TOP_OUTPUT is empty
if [ -z "${TOP_OUTPUT}" ]; then
    errorExit "Could not retrieve metrics for pod '${POD_NAME}'. Ensure Kubernetes Metrics Server is running and accessible."
fi

# Extract CPU and Memory values
RAW_CPU=$(echo "${TOP_OUTPUT}" | awk '{print $2}')
RAW_MEMORY=$(echo "${TOP_OUTPUT}" | awk '{print $3}')

# --- Format CPU ---
CPU_CORES=$(echo "${RAW_CPU}" | tr -d 'm')
if [[ "${RAW_CPU}" =~ m$ ]]; then
    CPU_CORES=$(awk "BEGIN {print ${CPU_CORES}/1000}")
fi

# --- Format Memory ---
MEMORY_GB=$(echo "${RAW_MEMORY}" | tr -d 'MiGi')
if [[ "${RAW_MEMORY}" =~ Mi ]]; then
    MEMORY_GB=$(awk "BEGIN {print ${MEMORY_GB}/1024}")
elif [[ "${RAW_MEMORY}" =~ Gi ]]; then
    MEMORY_GB="${MEMORY_GB}"
elif [[ "${RAW_MEMORY}" =~ m ]]; then
    MEMORY_GB=$(awk "BEGIN {print ${MEMORY_GB}/1000000000}")
fi

# Output the usage
echo "Pod: ${POD_NAME}"
echo "CPU Usage: ${CPU_CORES} cores"
echo "Memory Usage: ${MEMORY_GB} GB"

# --- Alert Logic ---
CPU_ALERT=$(awk "BEGIN {print (${CPU_CORES} > ${CPU_THRESHOLD})}")
MEMORY_ALERT=$(awk "BEGIN {print (${MEMORY_GB} > ${MEMORY_THRESHOLD})}")

if [ "${CPU_ALERT}" -eq 1 ]; then
    echo " ALERT: CPU usage (${CPU_CORES} cores) exceeds threshold (${CPU_THRESHOLD} cores)"
fi

if [ "${MEMORY_ALERT}" -eq 1 ]; then
    echo "ALERT: Memory usage (${MEMORY_GB} GB) exceeds threshold (${MEMORY_THRESHOLD} GB)"
fi
