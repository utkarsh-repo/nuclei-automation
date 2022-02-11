#!/usr/bin/env bash
echo -e "\n\033[36m>>>\033[35m Bug Bounty Hunting Automation By ==> Utkarsh Yadav \033[m\n";
nuclei --update-templates --silent
echo -e "\033[33m[!] Enter domain names seperated by 'space' \033[m" 
read -p " ----->>>>>>>> " input
for i in ${input[@]}
do

echo -e "\n\033[36m>>>\033[35m Scan started for ~/Desktop/recon/$i \033[m\n"
 
mkdir ~/Desktop/recon/$i  

echo -e "\n\033[33m[!] Subfinder Running..................\033[m"
subfinder -d $i -o ~/Desktop/recon/$i/sub.txt
echo -e "\n\033[33m[!] Total no. of subdomains found by Subfinder -->>\033[m"
cat ~/Desktop/recon/$i/sub.txt | wc -l
echo -e "\n\033[36m>>>\033[35m Assetfinder Start Running..............\033[m\n"
assetfinder -subs-only $i | tee -a ~/Desktop/recon/$i/sub.txt
echo -e "\n\033[33m[!] Total no. of subdomains found by Assetfinder -->>\033[m"
cat ~/Desktop/recon/$i/sub.txt | wc -l
echo -e "\n\033[36m Total no. of unique subdomain Found -->>\033[m"
sort -u ~/Desktop/recon/$i/sub.txt -o ~/Desktop/recon/$i/sub.txt
cat ~/Desktop/recon/$i/sub.txt | wc -l
echo -e "\n\033[33m[!] Subdomains saved at ~/Desktop/recon/$i/sub.txt\033[m"
echo -e "\n\033[36m>>>\033[35m Subjack Start......................\033[m\n"
subjack -w ~/Desktop/recon/$i/sub.txt -o ~/Desktop/recon/$i/subjack.txt
echo -e "\n\033[36m>>>\033[35m Vulnerable Subdomain Takeover output by subjack \033[m\n"
cat ~/Desktop/recon/$i/subjack.txt
echo -e "\n\033[33m[!] Subjack completed output stored ~/Desktop/recon/$i/subjack.txt\033[m"
cat ~/Desktop/recon/$i/sub.txt | httpx -rate-limit 20 >> ~/Desktop/recon/$i/subdomains.txt 
echo -e "\n\033[33m[!] Live subdomains saved at ~/Desktop/recon/$i/subdomains.txt\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for CVES started\033[m\n"
nuclei -l ~/Desktop/recon/$i/subdomains.txt -t cves/ -o ~/Desktop/recon/$i/cves.txt
echo -e "\n\033[33m[!] Scan for CVES completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for default-login started\033[m\n"
nuclei -l ~/Desktop/recon/$i/subdomains.txt -t default-logins/ -o ~/Desktop/recon/$i/default-logins.txt
echo -e "\n\033[33m[!] Scan for default-login completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for exposures started\033[m\n"
nuclei -l ~/Desktop/recon/$i/subdomains.txt -t exposures/ -o ~/Desktop/recon/$i/exposures.txt
echo -e "\n\033[33m[!] Scan for exposures completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for misconfigurations started\033[m\n"
nuclei -l ~/Desktop/recon/$i/subdomains.txt -t misconfiguration/ -o ~/Desktop/recon/$i/misconfigurations.txt
echo -e "\n\033[33m[!] Scan for misconfigurations completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for takeovers started\033[m\n"
nuclei -l ~/Desktop/recon/$i/subdomains.txt -t takeovers/ -o ~/Desktop/recon/$i/takeovers.txt
echo -e "\n\033[33m[!] Scan for takeovers completed\033[m"
echo -e "\n\033[36m>>>\033[35m Scan for vulnerabilities started\033[m\n"
nuclei -l ~/Desktop/recon/$i/subdomains.txt -t vulnerabilities/ -o ~/Desktop/recon/$i/vulnerabilities.txt
echo -e "\n\033[33m[!] Scan for vulnerabilities completed\033[m"
echo -e "\n\033[36m>>>\033[35m
'
'
'
Scan finished for $i
\033[m\n"
done
