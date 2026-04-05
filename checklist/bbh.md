# **Complete Bug Bounty Reconnaissance Methodology**

## **Phase 1: Initial Recon & Scope Understanding**
```
☐ Review program scope carefully (in-scope vs out-of-scope)
☐ Identify root domains, subdomains, and IP ranges
☐ Note any acquisition/partner domains mentioned
☐ Check for mobile apps, APIs, and cloud assets in scope
☐ Understand rate limits and testing restrictions
☐ Document wildcard domains (*.target.com) handling
```

## **Phase 2: Passive Reconnaissance**

### **2.1 Subdomain Enumeration (Passive)**
```
☐ Certificate Transparency Logs:
  - crt.sh
  - censys.io
  - certspotter.com
  - facebook-certificate-transparency

☐ Search Engines:
  - Google dorks: site:*.target.com -www
  - Bing: domain:target.com
  - Baidu, Yandex

☐ DNS Datasets:
  - SecurityTrails
  - Virustotal
  - AlienVault OTX
  - ThreatCrowd
  - DNSDumpster

☐ GitHub & Code Repositories:
  - GitHub code search
  - GitLab public repos
  - Source code leaks
  - Gist search

☐ ASN Discovery:
  - Find ASN via whois
  - Enumerate all IPs in ASN
  - Reverse DNS on IP ranges
```

### **2.2 Related Root Domains**
```
☐ Reverse WHOIS Lookup:
  - Same registrant email
  - Same organization name
  - Same phone number
  - Same address

☐ Similar Domain Patterns:
  - Typosquatting variations
  - Different TLDs (.net, .org, .io)
  - Acquisition domains
  - Brand protection domains

☐ DNS Records Analysis:
  - Shared nameservers
  - Same MX servers
  - Same IP ranges
  - Same SSL certificates
```

### **2.3 Technology Fingerprinting**
```
☐ SSL/TLS Certificate Analysis
☐ HTTP Headers examination
☐ Framework detection
☐ WAF/CDN identification
☐ Cloud provider detection
☐ CMS detection
```

## **Phase 3: Active Reconnaissance**

### **3.1 Active Subdomain Discovery**
```
☐ DNS Bruteforcing:
  - Common subdomain wordlists
  - Custom wordlists based on patterns
  - Number-based enumeration
  - Environment-based (dev, stage, prod)

☐ DNS Permutations:
  - Alterations (admin, adm, admins)
  - Hyphen variations (web-dev, webdev)
  - Number patterns (app1, app2)
  - Short forms

☐ DNS Zone Transfers (AXFR)
☐ DNS Cache Snooping
☐ Reverse DNS Lookups
```

### **3.2 DNS Resolution & Validation**
```
☐ Resolve all discovered subdomains
☐ Filter by public/private IPs
☐ Check for DNS takeovers:
  - AWS S3 buckets
  - Azure cloud services
  - GitHub pages
  - Heroku, Shopify
  - Expired domains

☐ CNAME record analysis
☐ Multiple A records per domain
```

## **Phase 4: Network Reconnaissance**

### **4.1 Port Scanning Strategy**
```
☐ Common web ports (80,443,8080,8443)
☐ Admin panels (8080, 8443, 8888, 9090)
☐ Database ports (3306, 5432, 27017, 6379)
☐ Cache services (11211, 6379)
☐ Message queues (5672, 15672)
☐ Remote access (22, 3389, 5900)
☐ File sharing (21, 445, 2049)
☐ Development services (3000, 5000, 8000, 4200)
☐ API gateways (8000-9000 range)
☐ Kubernetes/Docker (2375, 2376, 10250)
```

### **4.2 Service Fingerprinting**
```
☐ Version detection
☐ Default credentials check
☐ Misconfiguration scanning
☐ SSL/TLS version and cipher analysis
☐ Service-specific vulnerabilities
```

## **Phase 5: Web Application Recon**

### **5.1 HTTP Probing & Analysis**
```
☐ Live host verification
☐ HTTP/HTTPS detection
☐ Response codes analysis
☐ Redirect chains
☐ Default pages detection

☐ Headers Analysis:
  - Security headers (HSTS, CSP, X-Frame)
  - Server headers
  - Cookies attributes
  - CORS policies

☐ Technology Detection:
  - Web servers
  - Programming languages
  - JavaScript frameworks
  - Analytics tools
  - CDN services
```

### **5.2 Content Discovery**
```
☐ Directory enumeration:
  - Admin panels
  - Backup files
  - Configuration files
  - Log files
  - Development endpoints

☐ File extensions:
  - .bak, .old, .txt, .pdf
  - .js, .json, .xml, .sql
  - .git, .env, .htaccess

☐ Parameter discovery:
  - GET parameters
  - POST parameters
  - JSON parameters
  - GraphQL queries
```

### **5.3 JavaScript Analysis**
```
☐ Extract all JS files
☐ Find API endpoints
☐ Discover hidden parameters
☐ Find hardcoded secrets:
  - API keys
  - AWS tokens
  - JWT tokens
  - OAuth credentials

☐ Analyze JS for business logic
☐ Check for debug endpoints
☐ Source map files
```

### **5.4 Archive Analysis**
```
☐ Wayback Machine historical data
☐ CommonCrawl data
☐ Old versions of pages
☐ Removed endpoints
☐ Parameter changes over time
☐ Technology evolution
```

## **Phase 6: Cloud & Infrastructure**

### **6.1 Cloud Asset Discovery**
```
☐ Cloud buckets:
  - AWS S3
  - Azure Blob
  - Google Cloud Storage
  - DigitalOcean Spaces

☐ Cloud functions/lambdas
☐ Cloud databases
☐ CDN origins
☐ Load balancers
```

### **6.2 IP Space Analysis**
```
☐ IP ranges owned by target
☐ Cloud provider IP ranges
☐ Hosting provider IPs
☐ BGP announcements
☐ Anycast networks
```

## **Phase 7: API Reconnaissance**

```
☐ Discover API endpoints:
  - /api, /v1, /graphql
  - /swagger, /docs
  - /rest, /service

☐ Analyze API documentation:
  - Swagger UI
  - Postman collections
  - OpenAPI specs

☐ API versioning discovery
☐ API key patterns
☐ Rate limiting analysis
☐ Authentication mechanisms
```

## **Phase 8: Mobile & Third-Party**

### **8.1 Mobile Applications**
```
☐ Android APK analysis
☐ iOS IPA analysis
☐ API endpoints in mobile apps
☐ Hardcoded credentials
☐ Deep links
☐ Push notification endpoints
```

### **8.2 Third-Party Integrations**
```
☐ Social media logins
☐ Payment gateways
☐ Analytics services
☐ Marketing pixels
☐ Customer support widgets
☐ Chat integrations
```

## **Phase 9: Data Organization & Analysis**

### **9.1 Data Correlation**
```
☐ Map subdomains to IPs
☐ Group by technology stacks
☐ Identify patterns
☐ Create attack trees
☐ Prioritize targets by:
  - Bug bounty history
  - Recent changes
  - Technology stack
  - Complexity
```

### **9.2 Visualization**
```
☐ DNS map creation
☐ Network diagrams
☐ Dependency mapping
☐ Authentication flow charts
☐ Data flow diagrams
```

## **Phase 10: Continuous Monitoring**

```
☐ Daily subdomain monitoring
☐ Certificate transparency alerts
☐ GitHub alerts for new repos
☐ RSS feeds for security blogs
☐ Wayback machine daily updates
☐ DNS record changes
☐ New technology adoption
☐ IP range changes
```

## **Phase 11: Vulnerability-Specific Recon**

### **11.1 Common Vulnerability Patterns**
```
☐ Subdomain takeover checks
☐ Open S3 buckets
☐ Directory listing enabled
☐ Default credentials
☐ Information disclosure
☐ Debug pages enabled
☐ Exposed .git folders
☐ Exposed environment files
```

### **11.2 Authentication Testing**
```
☐ OAuth implementations
☐ JWT tokens handling
☐ Session management
☐ Password reset flows
☐ Registration processes
☐ Multi-factor authentication
```

### **11.3 Business Logic Discovery**
```
☐ User workflows
☐ Payment processes
☐ Admin functionalities
☐ File upload features
☐ User interaction points
☐ Data export/import
```

## **Phase 12: Documentation & Reporting**

```
☐ Create asset inventory
☐ Document all findings
☐ Screenshot important pages
☐ Record response patterns
☐ Note interesting behaviors
☐ Map out application structure
☐ Create test cases
☐ Prioritize vulnerabilities
```

## **Essential Tools Reference**

```
Passive Recon:
- Subfinder, Amass, Assetfinder
- GAU, Waybackurls
- CTFR, Certspotter
- SecurityTrails CLI

Active Recon:
- PureDNS, MassDNS
- HTTPx, HTTPprobe
- Nuclei, Naabu
- FFUF, GoBuster
- Katana, Haktrails

Analysis Tools:
- Wappalyzer, WhatWeb
- LinkFinder, SecretFinder
- JSParser, RelativeURL
- Aquatone, Gowitness

Wordlists:
- Assetnote wordlists
- Seclists
- Commonspeak2
- OneForAll
```

## **Critical Checks Before Starting**

```
☐ VPN/proxy configured properly
☐ Burp Collaborator accessible
☐ Resolvers file prepared
☐ Wordlists downloaded
☐ Tools updated
☐ Scope document handy
☐ Out-of-scope list ready
☐ Rate limiting strategy
☐ Burp scope configured
```
