#!/bin/bash

REPO="pandora-next/deploy"
API_URL="https://api.github.com/repos/$REPO/releases"

latest_release=$(curl -s "$API_URL" | grep -m 1 "browser_download_url.*amd64" | cut -d '"' -f 4)

if [ -z "$latest_release" ]; then
    echo "Error: Failed to fetch the latest release URL"
    exit 1
fi

file_name=$(basename "$latest_release")

curl -LO "$latest_release"

if [ ! -f "$file_name" ]; then
    echo "Error: Failed to download the file"
    exit 1
fi

# Extracting the contents to a temp directory
temp_dir=$(mktemp -d)
tar -zxvf "$file_name" -C "$temp_dir" --strip-components=1

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract the file"
    exit 1
fi

# Renaming the directory to 'p'
mv -f "$temp_dir" "p"

if [ $? -ne 0 ]; then
    echo "Error: Failed to rename directory"
    exit 1
fi

# Removing the downloaded file
rm -f "$file_name"

echo "Script execution completed successfully"
