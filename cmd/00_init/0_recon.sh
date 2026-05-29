# Asset Discovery
# :><: Domains :><: Subdomians :><: Permutations :><: DNS Resolutions 
# :><: Port Scans :><: Probing :><: URLS :><: Directories :><: Files 

# Content Discovery
# :><: 

# Commands
awk -F':' '{print $2}' file | sort -nu # split by :
mkdir -p {dir1,dir2,dir3,dir4,dir5,dir6}


# Get Subdomains
subfinder -dL init/wc -stats -all -silent -o pre-recon/subs.subfinder

# Bruteforce Domains
# wget https://github.com/trickest/resolvers/blob/main/resolvers.txt
# shuffledns

cat init/wc | tr -d '\r' | xargs -I DM curl -s "https://crt.sh/?q=%25.DM&output=json" | jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g' | tr '\n' '\n' | sort -u > pre-recon/subs.crtsh

cat init/wc | tr -d '\r' | xargs -I DM curl -s "https://api.certspotter.com/v1/issuances?domain=DM&recon/dnsx/resolvedinclude_subdomains=true&expand=dns_names" | jq -r '.[].dns_names[]' 2>/dev/null | sed 's/\*\.//g' | tr '\n' '\n' | sort -u > pre-recon/subs.certspotter

cat pre-recon/subs.* | sort -u > recon/subs

alterx -l recon/subs -o pre-recon/alterx.perm

# grep -vEf init/exclude | grep -vxEf init/exclude
# cat subs/sorted | grep -vEf init/exclude | tee subs/all

# resolve sub-domains
# dnsx -l subs/all -any -stats -o dns/any
# dnsx -l dns/alterx -stats -o dns/resolved
cat pre-recon/alterx.perm | grep -vxEf recon/subs | sort -u > pre-recon/alterx.sorted
dnsx -l pre-recon/alterx.sorted -stats -o pre-recon/dnsx.alterx

dnsx -l recon/subs -stats -o pre-recon/dnsx.sorted

cat pre-recon/dnsx.* | sort -u > recon/dnsx

# Fetch top TCP/UDP ports for Naabu scan
# grep '/tcp' /usr/share/nmap/nmap-services | sort -r -k3 | head -n 1000 | awk -F'[/ \t]+' '{print $2}'

# Naabu Ports | Check Top Ports
# naabu -l recon/dnsx -tp 1000 -stats -o ports/naabu.tp
# naabu -l recon/dnsx -p - -stats -o ports/naabu.allports
naabu -l recon/dnsx -pf init/tcp-ports -stats -o pre-recon/port.tcp
naabu -l recon/dnsx -pf init/udp-ports -stats -o pre-recon/port.udp

cat port.* | sort -u > recon/port

cat subs | grep -vEf dnsx | sort -u > non-dnsx
cat dnsx | grep -vEf naabu-ports | sort -u > non-port

wc -l ./*

# 
httpx -l port -o web/httpx
httpx -l httpx -sc -method -td -cl -title -probe -o web/httpx.1
httpx -l port -sc -probe -o web/httpx.status
httpx -l port -sc -probe -tls-probe -o web/httpx.tls

httpx -l port -sc -cl -ct -title -location -o httpx-port

cat data.port/httpx.txt | grep -E "\[[23][0-9]{2}\]" | grep "\[text/html\]"

cat data.port/httpx.txt | awk -F'[' '{print $4}' | sed 's/]//g'

cat httpx-port | awk -F'[][]' '{print $4}' | sort -u # 1,2,4,6,8,10,..etc

cat data.port/httpx.json | jq -c 'select(.status_code < 400 and .status_code >= 300)' | tee data.port/sc300

# Crwal - Try to get as much as can here files directories
cat web/http | Katana -jsl -d 5 
# Katana with Cookie
Katana -u http://dm.com.Cookie=SupportedCookie=fvzcscs -xhr -jsl -aff  

Katana -u http://dm.com.Cookie=SupportedCookie=fvzcscs -xhr -jsl -aff | httpx -ct -cl -sc

katana -u https://www.anduril.com/ -H "X-HackerOne-Research: H1 laksjdp" -d 5 -jc -jsl -kf all -o katana/dml-443

katana -u https://www.anduril.com/ -H "X-HackerOne-Research: H1 laksjdp" -d 5 -jc -jsl -kf all -o katana/dml-443

cat recon/port | tr -d '\r' | xargs -I URL katana -u URL -H "X-HackerOne-Research: H1 laksjdp" -d 5 -jc -jsl -kf all -o katana/port