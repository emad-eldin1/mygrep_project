#!/bin/bash

# Display help message
function display_help() {
    echo "Usage: $0 [options] pattern file"
    echo
    echo "Options:"
    echo "  -n    Show line numbers for matching lines"
    echo "  -v    Invert the match (show lines that do not match)"
    echo "  --help   Show this help message"
    echo
    echo "Search for 'pattern' in 'file' (case-insensitive)."
    echo "Example: $0 -n hello testfile.txt"
    exit 0
}

# Check for --help flag first
if [[ "$1" == "--help" ]]; then
    display_help
fi

# Initialize options
line_number=0
invert_match=0

# Parse options using getopts
while getopts ":nv" option; do
    case "${option}" in
        n)
            line_number=1
            ;;
        v)
            invert_match=1
            ;;
        *)
            display_help
            ;;
    esac
done

# Remove options from positional parameters
shift $((OPTIND - 1))

# Validate inputs
if [ $# -lt 2 ]; then
    echo "Error: Missing pattern or file."
    display_help
fi

pattern=$1
file=$2

# Ensure file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist."
    exit 1
fi

# Perform the search with options
if [[ $invert_match -eq 1 && $line_number -eq 1 ]]; then
    grep -inv "$pattern" "$file"
elif [[ $invert_match -eq 1 ]]; then
    grep -vi "$pattern" "$file"
elif [[ $line_number -eq 1 ]]; then
    grep -in "$pattern" "$file"
else
    grep -i "$pattern" "$file"
fi

