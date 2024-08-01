#!/bin/bash

# Colors
green="\033[0;32m"
gray="\033[0;37m"
blue="\033[0;34m"
red="\033[0;31m"
no_color="\033[0m"

# Banner
echo -e "${blue}  ______   ______  ___                      ${no_color}"
echo -e "${blue} / ___/ | / / __/ / _ \___ ________ ___ ____${no_color}"
echo -e "${blue}/ /__ | |/ / _/  / ___/ _ \`/ __(_-</ -_) __/${no_color}"
echo -e "${blue}\___/ |___/___/ /_/   \_,_/_/ /___/\__/_/   ${no_color}"
echo -e "                                            "
echo -e "${red}              By E-nzym3${no_color}"
echo -e "${red}    (https://github.com/e-nzym3)${no_color}\n"


# Function to display usage
usage() {
    echo -e "Usage: $0 [-c] filename"
    echo -e "  -c  Cleanup chunk files after processing"
    exit 1
}

# Check for cleanup option
cleanup=false
while getopts "c" opt; do
    case $opt in
        c) cleanup=true ;;
        *) usage ;;
    esac
done
shift $((OPTIND -1))

# Check if the filename is provided as an argument
if [ "$#" -ne 1 ]; then
    usage
fi

filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo -e "${red}File not found!${no_color}"
    exit 1
fi

# Get the total number of lines in the file
total_lines=$(wc -l < "$filename")

# Calculate the number of chunks
chunk_size=100
num_chunks=$(( (total_lines + chunk_size - 1) / chunk_size ))

# Split the file into chunks and process each chunk
for ((i=0; i<num_chunks; i++)); do
    start_line=$(( i * chunk_size + 1 ))
    end_line=$(( start_line + chunk_size - 1 ))
    
    # Ensure the end_line does not exceed the total lines
    if [ "$end_line" -gt "$total_lines" ]; then
        end_line=$total_lines
    fi
    
    # Extract the chunk and save it to a new file
    chunk_filename="${filename}_chunk_$((i + 1))"
    sed -n "${start_line},${end_line}p" "$filename" > "$chunk_filename"
    
    echo -e "${green}[*] Created chunk $((i + 1)): lines $start_line to $end_line${no_color}"
    
    # Pass the chunk file as an argument to the cvemap script
    cvemap -silent -id "$chunk_filename" -f kev,poc -fe epss,age,template -o "${chunk_filename}_cvemap.out" > /dev/null
        
    # Check the exit status of cvemap
    if [ $? -ne 0 ]; then
        echo -e "${red}[!] Error processing $chunk_filename with cvemap${no_color}"
        exit 1
    fi
    
    # Remove chunk file if cleanup is enabled
    if [ "$cleanup" = true ]; then
        rm "$chunk_filename"
        echo -e "${green}[*] Removed chunk file: $chunk_filename${no_color}"
    fi

    python3 cve_json_parse.py "${chunk_filename}_cvemap.out"
done

echo -e "${blue}[-] File split into $num_chunks chunks and processed with cvemap!\n[-] Check file ending in _parsed.csv for output!${no_color}"