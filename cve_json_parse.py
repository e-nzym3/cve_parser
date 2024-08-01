#!/bin/python3

import sys
import json
import os
import re

def main():
    # Check if a file argument was provided
    if len(sys.argv) != 2:
        print("Usage: python cve_json_parse.py <FILE>")
        sys.exit(1)

    filename = sys.argv[1]

    # Check if the file exists
    if not os.path.isfile(filename):
        print(f"File '{filename}' not found!")
        sys.exit(1)

    # Read json data from file
    json_data = {}
    with open(filename, "r") as rf:
        json_data = json.load(rf)

    ### Construct CSV ###
    output_filename = re.sub(r"_\d_cvemap.out", "_parsed.csv", filename)
    output_append = "w"
    
    # Check if the output file exists
    if os.path.isfile(output_filename):
        print(f"CSV output file {output_filename} exists, appending results to it.\n")
        output_append = "a"
    else:
        print(f"CSV output file {output_filename} does not exist. Creating it.\n")

    with open(output_filename,output_append) as wf:
        # Write the header for the csv if creating the file. CSV will have 4 columns:
        # CVE | Remote Exploit? | POC Available | POCs
        if output_append == "w":
            wf.write("CVE;Remote Exploit?;POC Available;POCs\n")

        for x in range(len(json_data)):
            cve_id = json_data[x]['cve_id']
            cve_remote = json_data[x]['is_remote']
            cve_poc_check = json_data[x]['is_poc']
            cve_pocs = []
            
            # check if there are POCs available for the CVE
            if cve_poc_check == True:
                for p in range(len(json_data[x]['poc'])):
                    cve_pocs.append(json_data[x]['poc'][p]['url'])
            else:
                cve_pocs = ["N/A"]
            
            # Write the CSV row for the CVE
            wf.write(f"{cve_id};{cve_remote};{cve_poc_check};{' '.join(cve_pocs)}\n")

if __name__ == "__main__":
    main()
