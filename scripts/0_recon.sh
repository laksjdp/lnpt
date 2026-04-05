#!/bin/bash

# ============================================
# INDEPENDENT SUBDOMAIN ENUMERATION COMMANDS
# ============================================

# USAGE: Run any command independently with your specific values
# Replace placeholders: <domain.com>, <output_file.txt>, <domains_file.txt>

# ============================================
# PHASE 1: SUBDOMAIN DISCOVERY (Individual Tools)
# ============================================

# 1.1 Subfinder - Fast passive subdomain enumeration
subfinder -d <domain.com> -all -silent -o subfinder_results.txt

# 1.2 Assetfinder - Find subdomains using various sources
assetfinder --subs-only <domain.com> > assetfinder_results.txt

# 1.3 Chaos - Project Discovery's chaos dataset
chaos -d <domain.com> -silent -o chaos_results.txt

# 1.4 crt.sh - Certificate transparency logs
curl -s "https://crt.sh/?q=%25.<domain.com>&output=json" | jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g' | sort -u > crtsh_results.txt

# 1.5 Bufferover - DNS bufferover API
curl -s "https://dns.bufferover.run/dns?q=.<domain.com>" | jq -r '.FDNS_A[],.RDNS[]' 2>/dev/null | cut -d',' -f2 | sort -u > bufferover_results.txt

# 1.6 Findomain - Fast subdomain enumeration
findomain -t <domain.com> -u findomain_results.txt

# 1.7 Combine all discovered subdomains
cat subfinder_results.txt assetfinder_results.txt chaos_results.txt crtsh_results.txt bufferover_results.txt findomain_results.txt 2>/dev/null | grep -v "^\*\." | grep -E '^[a-zA-Z0-9][a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+$' | sort -u > all_discovered.txt

# ============================================
# PHASE 2: SUBDOMAIN BRUTEFORCE
# ============================================

# 2.1 PureDNS bruteforce (requires resolvers.txt)
puredns bruteforce /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt <domain.com> -r /usr/share/massdns/lists/resolvers.txt -o puredns_results.txt

# 2.2 MassDNS bruteforce (alternative)
cat /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt | sed "s/$/.<domain.com>/" | massdns -r /usr/share/massdns/lists/resolvers.txt -t A -o S -w massdns_results.txt
cat massdns_results.txt | grep " A " | awk '{print $1}' | sed 's/\.$//' | sort -u > bruteforce_subdomains.txt

# 2.3 Combine discovery + bruteforce results
cat all_discovered.txt bruteforce_subdomains.txt 2>/dev/null | grep -v "^\*\." | grep -E '^[a-zA-Z0-9][a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+$' | sort -u > all_subdomains.txt

# ============================================
# PHASE 3: DNS RESOLUTION
# ============================================

# 3.1 MassDNS resolution of subdomains
massdns -r /usr/share/massdns/lists/resolvers.txt -t A -o S -w massdns_raw.txt all_subdomains.txt

# Parse different record types
grep " A " massdns_raw.txt | awk '{print $1" "$3}' | sed 's/\.$//' | sort -u > a_records.txt
grep " CNAME " massdns_raw.txt | awk '{print $1" "$3}' | sed 's/\.$//' | sort -u > cname_records.txt
grep " AAAA " massdns_raw.txt | awk '{print $1" "$3}' | sed 's/\.$//' | sort -u > aaaa_records.txt

# Extract unique IPs
awk '{print $2}' a_records.txt 2>/dev/null | sort -u > resolved_ips.txt

# 3.2 PureDNS resolution (alternative)
puredns resolve all_subdomains.txt -r /usr/share/massdns/lists/resolvers.txt --write resolved_subdomains.txt

# ============================================
# PHASE 4: LIVE HOSTS DETECTION
# ============================================

# 4.1 HTTPX - Probe for live web servers
httpx -l all_subdomains.txt -silent -sc -title -tech-detect -threads 50 -timeout 5 -ports 80,443,8080,8443,3000,8000,8888,9000,9001 -json -o httpx_scan.json

# Extract live URLs (status codes 2xx,3xx,4xx,5xx)
jq -r 'select(.status_code|tostring|match("^[2345]")) | .url' httpx_scan.json 2>/dev/null | sort -u > live_urls.txt

# Extract status codes
jq -r 'select(.status_code) | "\(.url) \(.status_code)"' httpx_scan.json 2>/dev/null | sort > status_codes.txt

# Extract technologies detected
jq -r 'select(.tech) | "\(.url) : \(.tech | join(\", \"))"' httpx_scan.json 2>/dev/null > technologies.txt

# 4.2 Httprobe (simpler alternative)
cat all_subdomains.txt | httprobe -c 50 -t 3000 > live_hosts.txt

# ============================================
# PHASE 5: PORT SCANNING
# ============================================

# 5.1 Naabu - Fast port scanner
naabu -list resolved_ips.txt -silent -top-ports 100 -rate 1000 -o naabu_top100.txt
naabu -list resolved_ips.txt -silent -p 80,443,8080,8443,8888 -rate 2000 -o naabu_web.txt

# 5.2 Nmap - Quick common port scan
nmap -iL resolved_ips.txt -T4 --open -p 21-23,25,53,80,110,111,135,139,143,443,445,993,995,1723,3306,3389,5432,5900,6379,8080,8443,27017 -oG nmap_quick.gnmap

# Parse open ports from Nmap
grep "Ports:" nmap_quick.gnmap 2>/dev/null | awk '{ip=$2; ports=$4; gsub(/Ports:/,"",ports); print ip ":" ports}' > open_ports.txt

# 5.3 Masscan (ultra-fast, requires sudo)
sudo masscan -iL resolved_ips.txt -p1-65535 --rate=1000 -oG masscan_results.gnmap

# ============================================
# PHASE 6: URL DISCOVERY
# ============================================

# 6.1 WaybackURLs - Get URLs from Wayback Machine
cat live_urls.txt | waybackurls 2>/dev/null | sort -u > wayback_urls.txt

# 6.2 Gau - Get all URLs from AlienVault, Wayback, CommonCrawl
cat live_urls.txt | gau --threads 20 2>/dev/null | sort -u > gau_urls.txt

# 6.3 Gospider - Fast web spider
gospider -S live_urls.txt -c 10 -d 1 -o gospider_output 2>/dev/null

# 6.4 Hakrawler - Web crawler
cat live_urls.txt | hakrawler -d 1 -subs -u 2>/dev/null > hakrawler_urls.txt

# 6.5 Combine all URLs
cat wayback_urls.txt gau_urls.txt gospider_output/* 2>/dev/null | sort -u > all_urls.txt

# ============================================
# PHASE 7: SUBDIRECTORY BRUTEFORCE
# ============================================

# 7.1 FFUF - Directory bruteforce on a single domain
ffuf -u "https://<domain.com>/FUZZ" -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt -t 20 -ac -c -mc 200,301,302,307,401,403 -o ffuf_results.csv -of csv

# 7.2 Dirb - Classic directory scanner
dirb https://<domain.com> /usr/share/wordlists/dirb/common.txt -o dirb_results.txt

# 7.3 Gobuster - Directory/file bruteforce
gobuster dir -u https://<domain.com> -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt -t 50 -o gobuster_results.txt

# 7.4 Feroxbuster - Rust-based directory scanner
feroxbuster -u https://<domain.com> -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt -t 50 -o feroxbuster_results.txt

# ============================================
# PHASE 8: REVERSE DNS LOOKUP
# ============================================

# 8.1 Dig reverse DNS lookup on IP list
xargs -P 50 -a resolved_ips.txt -I{} bash -c 'ptr=$(dig +short -x {} 2>/dev/null); [[ -n "$ptr" ]] && echo "{} -> $ptr"' > reverse_dns.txt

# 8.2 Nmap reverse DNS
nmap -sL -n -iL resolved_ips.txt | grep "domain name pointer" > nmap_reverse_dns.txt

# 8.3 Host command reverse lookup
while read ip; do host "$ip" 2>/dev/null | grep "pointer" | sed "s/^/$ip -> /"; done < resolved_ips.txt > host_reverse.txt

# ============================================
# PHASE 9: DNS ZONE TRANSFER
# ============================================

# 9.1 Get nameservers for domain
dig +short NS <domain.com> > nameservers.txt

# 9.2 Attempt zone transfer on each nameserver
while read ns; do
    dig @"$ns" <domain.com> AXFR +noall +answer >> zone_transfer_results.txt
done < nameservers.txt

# 9.3 Single command zone transfer attempt
for ns in $(dig +short NS <domain.com>); do dig @"$ns" <domain.com> AXFR; done

# ============================================
# PHASE 10: DATA PROCESSING & ANALYSIS
# ============================================

# 10.1 Extract unique domains from URLs
cat all_urls.txt | unfurl -u domains | sort -u > extracted_domains.txt

# 10.2 Extract unique paths from URLs
cat all_urls.txt | unfurl -u paths | sort -u > unique_paths.txt

# 10.3 Filter URLs by extension (e.g., JS files)
cat all_urls.txt | grep -E "\.js$" > javascript_files.txt
cat all_urls.txt | grep -E "\.php$" > php_files.txt
cat all_urls.txt | grep -E "\.asp$|\.aspx$" > asp_files.txt
cat all_urls.txt | grep -E "\.jsp$" > jsp_files.txt
cat all_urls.txt | grep -E "\.json$" > json_endpoints.txt

# 10.4 Filter URLs by parameter presence
cat all_urls.txt | grep -E "\?.*=" > parameterized_urls.txt

# 10.5 Extract IP:Port combinations for service scanning
cat open_ports.txt | sed 's/:/:/' > ip_port_list.txt

# ============================================
# PHASE 11: SCREENSHOT CAPTURE
# ============================================

# 11.1 Gowitness - Take screenshots of live websites
gowitness file -f live_urls.txt --destination screenshots/

# 11.2 Aquatone - Visual inspection
cat live_urls.txt | aquatone -out aquatone_output/

# 11.3 Eyewitness - Another screenshot tool
eyewitness -f live_urls.txt -d eyewitness_report --no-prompt

# ============================================
# PHASE 12: TECHNOLOGY DETECTION
# ============================================

# 12.1 Wappalyzer - Detect technologies
while read url; do
    wappalyzer "$url" 2>/dev/null | jq '.' >> wappalyzer_results.json
done < live_urls.txt

# 12.2 WhatWeb - Another tech detector
whatweb -i live_urls.txt --log-json=whatweb_results.json

# 12.3 Nuclei template scanning (requires nuclei templates)
nuclei -l live_urls.txt -t ~/nuclei-templates/ -o nuclei_results.txt

# ============================================
# HELPER COMMANDS
# ============================================

# Count lines in file
wc -l < filename.txt

# Sort and deduplicate file
sort -u input.txt -o output.txt

# Remove wildcard subdomains (e.g., *.domain.com)
grep -v "^\*\." input.txt > cleaned.txt

# Filter valid domain names
grep -E '^[a-zA-Z0-9][a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+$' input.txt > valid_domains.txt

# Split file into chunks for parallel processing
split -l 1000 large_file.txt chunk_

# Convert Windows line endings to Unix
dos2unix filename.txt

# Run multiple commands in parallel (requires GNU parallel)
cat domains.txt | parallel -j 10 'subfinder -d {} -silent >> all_subdomains.txt'

# Monitor tool execution with timeout
timeout 300 command_here

# ============================================
# ONE-LINERS FOR QUICK ENUMERATION
# ============================================

# Complete subdomain enumeration oneliner
subfinder -d <domain.com> -silent && assetfinder --subs-only <domain.com> && curl -s "https://crt.sh/?q=%25.<domain.com>&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u

# Live host probing oneliner
cat subdomains.txt | httpx -silent -mc 200,301,302,403 -o live.txt

# URL extraction oneliner
cat live.txt | waybackurls | gau | sort -u

# Quick port scan oneliner
naabu -list ips.txt -silent -top-ports 100 | awk '{print $1":"$2}' > open_ports.txt

# Zone transfer tester oneliner
for ns in $(dig +short NS <domain.com>); do dig @"$ns" <domain.com> AXFR +short; done