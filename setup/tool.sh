# Check tools installed status
dpkg -l jq python3 python3-pip build-essential libpcap-dev golang-go

# Install neccessory tools
sudo apt update && sudo apt install -y jq python3 python3-pip build-essential libpcap-dev golang-go

# export GOPATH="$HOME/go"
# export PATH="$PATH:$GOPATH/bin"

# Check Installed Installed Tools
ti=""; tu=""; for t in subfinder assetfinder chaos httpx naabu waybackurls katana urlfinder gospider ffuf gobuster nuclei dalfox subjack alterx massdns dnsx shuffledns gowitness anew unfurl firefox gau qsreplace gf; do command -v "$t" >/dev/null && ti+="$t, " || tu+="$t, "; done; echo -e "\n\e[32m[+]: ${ti%, }\n\e[31m[-]: ${tu%, }\e[0m"


# ========== RECONNAISSANCE ==========
# subfinder - Passive subdomain enumeration
command -v subfinder &>/dev/null || go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# assetfinder - Find subdomains for a target domain
command -v assetfinder &>/dev/null || go install github.com/tomnomnom/assetfinder@latest

# chaos - Client for Chaos dataset of DNS records
command -v chaos &>/dev/null || go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest

# ========== PROBING & LIVE HOSTS ==========
# httpx - HTTP toolkit for probing live web servers
command -v httpx &>/dev/null || go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# ========== PORT SCANNING ==========
# naabu - Fast port scanner
command -v naabu &>/dev/null || go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# ========== URL & ENDPOINT DISCOVERY ==========
# waybackurls - Fetch URLs from Wayback Machine archive
command -v waybackurls &>/dev/null || go install github.com/tomnomnom/waybackurls@latest

# katana - Fast crawler for URL discovery
command -v katana &>/dev/null || CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest

# urlfinder - URL discovery tool
command -v urlfinder &>/dev/null || go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest

# gospider - Crawler for web archives and JS files
command -v gospider &>/dev/null || go install github.com/jaeles-project/gospider@latest

# ========== PARAMETER DISCOVERY ==========
# arjun - HTTP parameter discovery
pipx list | grep -qw "arjun" || pipx install arjun

# ========== CONTENT DISCOVERY & FUZZING ==========
# ffuf - Fast web fuzzer for directory/file discovery
command -v ffuf &>/dev/null || go install github.com/ffuf/ffuf@latest

# gobuster - Directory/file bruteforcing
command -v gobuster &>/dev/null || go install github.com/OJ/gobuster/v3@latest

# ========== VULNERABILITY SCANNING ==========
# nuclei - Fast vulnerability scanner with templates
command -v nuclei &>/dev/null || go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# dalfox - XSS scanning and parameter analysis
command -v dalfox &>/dev/null || go install github.com/hahwul/dalfox/v2@latest

# subjack - Subdomain takeover detection
command -v subjack &>/dev/null || go install github.com/haccer/subjack@latest

# ========== SUBDOMAIN PERMUTATIONS ==========
# alterx - Subdomain permutation generator
command -v alterx &>/dev/null || go install github.com/projectdiscovery/alterx/cmd/alterx@latest

# ========== DNS UTILITIES ==========
# massdns - High-performance DNS resolver
command -v massdns &>/dev/null || sudo apt install -y massdns

# dnsx - Fast DNS toolkit for DNS queries
command -v dnsx &>/dev/null || go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

# shuffledns - MassDNS wrapper for DNS enumeration
command -v shuffledns &>/dev/null || go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest

# ========== SCREENSHOTTING ==========
# gowitness - Take screenshots of websites
command -v gowitness &>/dev/null || sudo apt install -y gowitness

# ========== UTILITIES ==========
# anew - Append unique lines to files (filter duplicates)
command -v anew &>/dev/null || go install github.com/tomnomnom/anew@latest

# unfurl - Extract and manipulate URLs
command -v unfurl &>/dev/null || go install github.com/tomnomnom/unfurl@latest

# ========== WORDLISTS ==========
# seclists - Collection of wordlists for security testing
[ -d "/usr/share/seclists" ] || sudo apt install -y seclists

# ========== BROWSER FOR MANUAL TESTING ==========
# firefox-esr - Browser for manual testing
command -v firefox &>/dev/null || sudo apt install -y firefox-esr

# ========== ADDITIONAL ESSENTIAL TOOLS ==========
# gau - Get All URLs from multiple sources
command -v gau &>/dev/null || go install github.com/lc/gau/v2/cmd/gau@latest

# qsreplace - Replace query strings for testing
command -v qsreplace &>/dev/null || go install github.com/tomnomnom/qsreplace@latest

# gf - Grep wrapper for pattern matching
command -v gf &>/dev/null || go install github.com/tomnomnom/gf@latest

