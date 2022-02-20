#!/bin/bash

if [ -z "$1" ]
then
        echo "Usage: ./recon.sh <IP>"
        exit 1
fi

printf "\n----- Log4J -----\n\n"

echo "Running Log4J scan..."
sudo -u shade ~shade/scanners/log4j-scan/log4j-scan.py -u https://$1 --run-all-tests

printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap for HeartBleed..."
nmap $1 | tail -n +5 | head -n -1 > results

while read line
do

	if [[ $line == *open* ]] && [[ $line == *443/tcp* ]] && [[ $line == *https* ]]
        then
        	echo "Running HeartBleed Scan..."
        	nmap --script=ssl-heartbleed -p 443 $1 > H1
	fi

	if [[ $line == *closed* ]] && [[ $line == *443/tcp* ]] && [[ $line == *https* ]]
	then
		echo "Not vulnerable to HeartBleed or Port is forwarded..."
	fi

done < results

	if [ -e H1 ]
	then
        	printf "\n----- HeartBleed -----\n\n" > results
        	cat H1 > results
        	rm H1
	fi

cat results

printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap for EternalBlue..."
nmap $1 | tail -n +5 | head -n -1 > results

while read line
do
	if [[ $line == *open* ]] && [[ $line == *445/tcp* ]] && [[ $line == *microsoft-ds* ]]
        then
                echo "Running EternalBlue Scan..."
                nmap -p 445 --script=smb-vuln-ms17-010 $1 > E1
	fi
	if [[ $line == *closed* ]] && [[ $line == *445/tcp* ]] && [[ $line == *microsoft-ds* ]]
	then
		echo "Not Vulnerable to EternalBlue or Port is forwarded..."
	fi

done < results

	if [ -e E1 ]
	then
    		printf "\n----- EternalBlue -----\n\n" > results
        	cat E1 > results
        	rm E1
	fi

cat results

printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap for Directory Enumeration..."
nmap $1 | tail -n +5 | head -n -1 > results

while read line
do
	if [[ $line == *open* ]] && [[ $line == *http* ]]
        then
               	echo "Running Gobuster..."
               	gobuster dir -u $1 -w /usr/share/wordlists/dirb/common.txt -qz > temp1
       	echo "Running WhatWeb..."
       	whatweb $1 -v > temp2
	fi

done < results

	if [ -e temp1 ]
	then
    		printf "\n----- DIRS  -----\n\n" >> results
        	cat temp1 >> results
        	rm temp1
	fi

	if [ -e temp2 ]
	then
        	printf "\n----- WEB -----\n\n" >> results
        	cat temp2 >> results
        	rm temp2
	fi

cat results
