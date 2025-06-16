#!/bin/bash

# Prompt user for directory if no argument provided
if [ -z "$1" ]; then
  read -p "Please enter directory path (default is current directory): " input_dir
  if [ -z "$input_dir" ]; then
    dir="."
  else
    dir="$input_dir"
  fi
else
  dir="$1"
fi

# Check if directory exists
if [ ! -d "$dir" ]; then
  echo "Error: Directory '$dir' does not exist."
  exit 1
fi

echo "Loading..."

# Use find to list files, du to get sizes, sort output by size
find "$dir" -type f 2>/dev/null -exec du -h "{}" + | sort -hr