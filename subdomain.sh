#!/bin/bash

# Subdomain Enumeration Script by 0xNehru

# Usage function
usage() {
    echo "Usage: $0 -u <domain>"
    exit 1
}

# Parse command-line arguments
while getopts "u:" opt; do
  case $opt in
    u) DOMAIN="$OPTARG" ;;
    *) usage ;;
  esac
done

# Check if domain is provided
if [ -z "$DOMAIN" ]; then
    usage
fi

# Set API Keys (Replace these with environment variables or a .env file for security)
VIRUSTOTAL_API=${VIRUSTOTAL_API:-"your_virustotal_api_key"}
SECURITYTRAILS_API=${SECURITYTRAILS_API:-"your_securitytrails_api_key"}

# Output file
OUTPUT_FILE="all_subdomains.txt"

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "[-] jq is not installed. Install it to process JSON responses."
    exit 1
fi

echo "[+] Collecting subdomains for: $DOMAIN"

# Run enumeration tools in parallel
{
    # VirusTotal
    if [ -n "$VIRUSTOTAL_API" ]; then
        echo "[+] Fetching from VirusTotal..."
        curl -s --request GET \n             --url "https://www.virustotal.com/api/v3/domains/$DOMAIN/subdomains" \n             --header "x-apikey: $VIRUSTOTAL_API" | jq -r '.data[].id' > virustotal_subs.txt
    fi

    # SecurityTrails
    if [ -n "$SECURITYTRAILS_API" ]; then
        echo "[+] Fetching from SecurityTrails..."
        curl -s "https://api.securitytrails.com/v1/domain/$DOMAIN/subdomains" \n             -H "APIKEY: $SECURITYTRAILS_API" | jq -r '.subdomains[]' | sed "s/$/.$DOMAIN/" > securitytrails_subs.txt
    fi

    # crt.sh (Certificate Transparency Logs)
    echo "[+] Fetching from crt.sh..."
    curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > crtsh_subs.txt

    # HackerTarget
    echo "[+] Fetching from HackerTarget..."
    curl -s "https://api.hackertarget.com/hostsearch/?q=$DOMAIN" | cut -d, -f1 > hackertarget_subs.txt

    # Sublist3r
    if command -v sublist3r >/dev/null 2>&1; then
        echo "[+] Fetching from Sublist3r..."
        sublist3r -d $DOMAIN -o sublist3r_subs.txt
    fi

    # Subfinder
    if command -v subfinder >/dev/null 2>&1; then
        echo "[+] Fetching from Subfinder..."
        subfinder -d $DOMAIN -o subfinder_subs.txt
    fi

    # Amass
    if command -v amass >/dev/null 2>&1; then
        echo "[+] Fetching from Amass..."
        amass enum -passive -d $DOMAIN -o amass_subs.txt
    fi

    # Assetfinder
    if command -v assetfinder >/dev/null 2>&1; then
        echo "[+] Fetching from Assetfinder..."
        assetfinder --subs-only $DOMAIN > assetfinder_subs.txt
    fi

    # Findomain
    if command -v findomain >/dev/null 2>&1; then
        echo "[+] Fetching from Findomain..."
        findomain -t $DOMAIN -q > findomain_subs.txt
    fi

    # Wayback Machine
    echo "[+] Fetching from Wayback Machine..."
    curl -s "http://web.archive.org/cdx/search/cdx?url=*.$DOMAIN/*&output=json&fl=original" | jq -r '.[].original' | awk -F/ '{print $3}' | sort -u > wayback_subs.txt
} &  # Run in parallel

wait  # Wait for all background processes to finish

# Merge and Remove Duplicates
echo "[+] Merging results and removing duplicates..."
cat virustotal_subs.txt securitytrails_subs.txt crtsh_subs.txt hackertarget_subs.txt \
    sublist3r_subs.txt subfinder_subs.txt amass_subs.txt assetfinder_subs.txt findomain_subs.txt wayback_subs.txt | sort -u > $OUTPUT_FILE

# Final Output
echo "[+] Subdomains saved to: $OUTPUT_FILE"
wc -l $OUTPUT_FILE
