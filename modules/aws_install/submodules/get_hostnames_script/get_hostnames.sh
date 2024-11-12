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
  # Check if the hostname ends with a dot
  SANITIZED_HOSTNAME=$(echo "$HOSTNAME" | awk '{if (length($0) > 0 && substr($0, length($0), 1) == ".") {print substr($0, 1, length($0) - 1)} else {print $0}}')
  echo "$SANITIZED_HOSTNAME"
done
