#!/bin/bash

# OpenAPI Diff Script
# Compares current OpenAPI spec with the previous version and highlights changes.

# Default folder for storing OpenAPI specs
DEFAULT_FOLDER="${HOME}/.openapi-diff"
FOLDER_NAME="${OPENAPI_DIFF_FOLDER:-$DEFAULT_FOLDER}"


# Check if required tools are installed
if ! command -v jq &> /dev/null || ! command -v diff &> /dev/null; then
    echo "Error: jq and diff are required."
    exit 1
fi

# Show help message
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [spec-file]"
    echo "       spec-file: Path to the OpenAPI spec file. Reads from stdin if not provided."
    exit 0
fi

# Read from file or stdin
if [ -z "$1" ]; then
    openapi_spec=$(cat -)
else
    if [ ! -f "$1" ]; then
        echo "Error: Specified file does not exist."
        exit 1
    fi
    openapi_spec=$(cat "$1")
fi

# Validate JSON input
if ! echo "$openapi_spec" | jq empty; then
    echo "Error: Invalid JSON input."
    exit 1
fi

# Create the folder if it doesn't exist
mkdir -p "$FOLDER_NAME"

# Extract the spec name
spec_name=$(echo "$openapi_spec" | jq -r '.info.title' | sed 's/[^a-zA-Z0-9]/_/g')

# Check if the name was successfully extracted
if [ -z "$spec_name" ] || [ "$spec_name" = "null" ]; then
    echo "Error: Unable to extract the name from the OpenAPI spec."
    exit 1
fi

# Define the file name for storing the OpenAPI spec
spec_file="${FOLDER_NAME}/${spec_name}_spec.json"

# Compare and update spec
if [ -f "$spec_file" ]; then
    if diff -u "$spec_file" <(echo "$openapi_spec") > /dev/null; then
        echo "No changes detected in the OpenAPI spec for $spec_name."
    else
        echo "Changes detected in the OpenAPI spec for $spec_name:"
        diff -u "$spec_file" <(echo "$openapi_spec")
    fi
    echo "$openapi_spec" > "$spec_file"
else
    echo "First run for $spec_name. Storing the OpenAPI spec."
    echo "$openapi_spec" > "$spec_file"
fi
