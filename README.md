Title: 
Reconz.sh

Description:
This is my take on a simple bashscript for network recon offered by 
Null Byte. I did my best to make it my own. It takes an IP address or
hostname and uses log4J-scan to look for potential log4j vulnerability.
It then uses nmap vuln scans to look for both EternalBlue and
HeartBleed if conditions are met. The last part of the script uses a
basic nmap scan and pipes the out put to gobuster and whatweb for
directory enumeration and then gives the results. Hope you all enjoy.

Dependencies:

go:

Gobuster:

	go install github.com/OJ/gobuster/v3@latest

WhatWeb:

	git clone https://github.com/urbanadventurer/WhatWeb.git

	cd WhatWeb/

log4j-scan:

	git clone https://github.com/fullhunt/log4j-scan.git
	cd log4j-scan
	pip3 install -r requirements.txt

nmap:

	git clone https://github.com/nmap/nmap.git
	cd nmap
	./configure
	make
	make install

Installation:

I may or may not include a setup script later but for now make sure you
the needed dependencies and then just git clone the script and adjust the
user information on line 10. Take a look at the code and make sure the 
pathing is set properly to where you have the dependcies and you should
be off to the racees. Enjoy. More functionallity will be added later
and I plan to update this so feel free to let me know if you find any
issues.
should be off to the races

 
