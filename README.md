🔎**Subdomain Enumeration Tool by 0xNehru**

📌**Overview**

This is an automated subdomain enumeration tool that gathers subdomains from multiple OSINT sources and APIs. It is designed for penetration testers, bug bounty hunters, and cybersecurity professionals to efficiently discover subdomains.

📖 **Data Sources Used**

**This tool collects subdomains from:**

    🔹 VirusTotal (API required)
    🔹 SecurityTrails (API required)
    🔹 crt.sh (Certificate Transparency Logs)
    🔹 HackerTarget (Public API)
    🔹 Sublist3r (Python-based subdomain finder)
    🔹 Subfinder (Passive subdomain enumeration)
    🔹 Assetfinder (Fast passive discovery)
    🔹 Findomain (Efficient domain search tool)
    🔹 Wayback Machine (Historical subdomain discovery)

🔹 **Install Required Tools**

sudo apt update && sudo apt install jq curl -y

**For Sublist3r:**

pip install sublist3r

For Subfinder, Amass, Assetfinder, Findomain

sudo apt install subfinder amass assetfinder findomain -y

⚡ **Usage**

**Run the script with a target domain:**

chmod +x subdomain.sh
./subdomain.sh -u example.com

**Example Output:**

[+] Collecting subdomains for: example.com

[+] Fetching from VirusTotal...

[+] Fetching from crt.sh...

[+] Fetching from SecurityTrails...
...

[+] Merging results and removing duplicates...

[+] Subdomains saved to: all_subdomains.txt

The final list of subdomains will be stored in:

📂 all_subdomains.txt

🔑 **API Configuration**

For better results, set up API keys for VirusTotal, SecurityTrails.

   **Add your API keys as environment variables:**

    export VIRUSTOTAL_API="your_api_key"
    export SECURITYTRAILS_API="your_api_key"

    Or modify the script directly and replace "your_api_key" with your actual keys.

🏴‍☠️ **Why Use This Tool?**

✔️ Combines multiple OSINT sources for maximum subdomain discovery
✔️ Fast & automated, saving time in recon
✔️ Customizable, allowing easy modification and expansion

🤝 **Contributing**

Pull requests are welcome! If you have suggestions or want to add more sources, feel free to contribute.

📜 **License**

This project is open-source under the MIT License.

👤 **Author** **0xNehru - Cybersecurity Enthusiast & Pentester**
