mkdir -p {init,subs,dns,ports,web,urls,vuls,loot,notes}

subfinder -stats -dL init/wc -all -silent -o recon/dml/subfinder

cat init/wc | tr -d '\r' | xargs -I DM curl -s "https://crt.sh/?q=%25.DM&output=json" | jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g' | tr '\n' '\n' | sort -u > recon/dml/crtsh

cat init/wc | tr -d '\r' | xargs -I DM curl -s "https://api.certspotter.com/v1/issuances?domain=DM&recon/dnsx/resolvedinclude_subdomains=true&expand=dns_names" | jq -r '.[].dns_names[]' 2>/dev/null | sed 's/\*\.//g' | tr '\n' '\n' | sort -u > recon/dml/certspotter

cat recon/dml/subfinder recon/dml/crtsh recon/dml/certspotter | sort -u > recon/dml/sorted

# grep -vEf init/exclude | grep -vxEf init/exclude
cat recon/dml/sorted | grep -vEf init/exclude | tee recon/dml/all

alterx -l recon/dml/all -stats -o recon/dnsx/alterx

dnsx -l recon/dml/all -any -stats -o recon/dnsx/any
dnsx -l recon/dnsx/alterx -stats -o recon/dnsx/resolved

naabu -l recon/dnsx/resolved -tp 1000 -stats -o recon/probing/naabu.top-ports
naabu -l recon/dnsx/resolved -p - -stats -o recon/probing/naabu.ports

httpx -l naabu.ports -stats -sc -method -td -cl -title -probe -o recon/probing/httpx
httpx -l naabu.ports -stats -sc -probe -o recon/probing/httpx.status
httpx -l naabu.ports -stats -sc -probe -tls-probe -o recon/probing/httpx.tls




