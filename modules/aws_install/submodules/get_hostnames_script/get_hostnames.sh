#!/bin/bash

# Check if at least one IP address is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <IP_ADDRESS1> [<IP_ADDRESS2> ...]"
  exit 1
fi

# Loop through the provided IP addresses and get the hostnames
for IP_ADDRESS in "$@"; do
  HOSTNAME=$(nslookup $IP_ADDRESS | grep 'name =' | awk '{print $4}')
  
  # Check if a hostname was found
  if [ -z "$HOSTNAME" ]; then
    HOSTNAME="$IP_ADDRESS"
  fi
  
  echo "$HOSTNAME"
done
