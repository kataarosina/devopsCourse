#!/bin/bash

sum=0

echo "Enter numbers one per line (enter 0 to finish):"

while read -r number; do
  if ! [[ "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Please enter a valid integer."
    continue
  fi

  if [ "$number" -eq 0 ]; then
    break
  fi

  sum=$((sum + number))
done

echo "Sum of all entered numbers: $sum"