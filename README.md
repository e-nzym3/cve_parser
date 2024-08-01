# CVE Parser
Utility to ingest a list of CVEs and return a CSV that contains details on whether the CVE is a remote exploit, has POCs available, and links to the individual POCs.
<br><br>
This tool is a wrapper to (CVEMap)[https://github.com/projectdiscovery/cvemap].
<br><br>
## Initial Config
1. Download the most recent compiled binaries from the CVEMap repo releases page: https://github.com/projectdiscovery/cvemap/releases
2. Place the `cvemap` in your PATH. Run `echo $PATH` and put it in one of the folders that are returned.
3. Get yourself a ProjectDiscovery Cloud Platform API key (it's free, just log in): https://cloud.projectdiscovery.io/?ref=api_key
4. Run `cvemap -auth` and enter your API key. This will configure CVEMap with the key for future use, no need to re-run this command.
## Usage
```
./cve_parser.sh [-c] filename
  -c  Cleanup chunk files after processing
```
### Example
```
$ git clone https://github.com/e-nzym3/cve_parser.git
$ cd https://github.com/e-nzym3/cve_parser
$ ls
README.md  cve_json_parse.py  cve_parser.sh
$ vi cves.txt
$ wc -l cves.txt
448 cves.txt
$ ./cve_parser.sh -c cves.txt
  ______   ______  ___
 / ___/ | / / __/ / _ \___ ________ ___ ____
/ /__ | |/ / _/  / ___/ _ `/ __(_-</ -_) __/
\___/ |___/___/ /_/   \_,_/_/ /___/\__/_/

              By E-nzym3
    (https://github.com/e-nzym3)

[*] Created chunk 1: lines 1 to 100
[*] Removed chunk file: cves.txt_chunk_1
CSV Output File cves.txt_chunk_parsed.csv does not exist. Creating it.

[*] Created chunk 2: lines 101 to 200
[*] Removed chunk file: cves.txt_chunk_2
CSV Output File cves.txt_chunk_parsed.csv exists, appending results to it.

[*] Created chunk 3: lines 201 to 300
[*] Removed chunk file: cves.txt_chunk_3
CSV Output File cves.txt_chunk_parsed.csv exists, appending results to it.

[*] Created chunk 4: lines 301 to 400
[*] Removed chunk file: cves.txt_chunk_4
CSV Output File cves.txt_chunk_parsed.csv exists, appending results to it.

[*] Created chunk 5: lines 401 to 448
[*] Removed chunk file: cves.txt_chunk_5
CSV Output File cves.txt_chunk_parsed.csv exists, appending results to it.

[-] File split into 5 chunks and processed with cvemap!
[-] Check file ending in _parsed.csv for output!
```