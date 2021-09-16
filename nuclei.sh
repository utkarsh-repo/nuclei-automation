#!/usr/bin/env bash
echo "
NUCLEI TEMPALTE
BY Utkarsh Yadav
";
nuclei --update-templates --silent
read -p "Enter domains names seperated by 'space' : " input
for i in ${input[@]}
do
echo "
.
.
.
Scan started for $i
" | notify --silent
mkdir $i
subfinder -d $i | httpx >> $i/subdomains.txt
echo "Subdomains saved at $i/subdomains.txt." | notify
echo " Scan for CVES started." | notify
nuclei -l $i/subdomains.txt -t cves/ -o $i/cves.txt | notify
echo " Scan for CVES completed." | notify
echo " Scan for default-login started." | notify
nuclei -l $i/subdomains.txt -t default-logins/ -o $i/default-logins.txt | nofity
echo " Scan for default-login completed." | notify
echo " Scan for exposures started." | notify
nuclei -l $i/subdomains.txt -t exposures/ -o $i/exposures.txt | notify
echo " Scan for exposures completed." | notify
echo " Scan for misconfigurations started." | notify
nuclei -l $i/subdomains.txt -t misconfigurations/ -o $i/misconfigurations.txt | notify
echo " Scan for misconfigurations completed." | notify
echo " Scan for takeovers started." | notify
nuclei -l $i/subdomains.txt -t takeovers/ -o $i/takeovers.txt | notify
echo " Scan for takeovers completed." | notify
echo " Scan for vulnerabilities started." | notify
nuclei -l $i/subdomains.txt -t vulnerabilities/ -o $i/vulnerabilities.txt | notify
echo " Scan for vulnerabilities completed." | notify
echo "
'
'
'
Scan finished for $i
" | notify --silent
done