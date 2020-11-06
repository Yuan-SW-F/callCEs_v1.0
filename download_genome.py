#!/share/app/python-2.7.10/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-04 09:11:28
# Example download_genome.py   
import sys, os, re

fopen = open(sys.argv[1],"r+")
path = ''
genome = ''
if len(sys.argv) > 2:
	genome = sys.argv[2]
else:
	genome = 'Genome'
wget = ''
for line in fopen:
	for_path = re.search(r'\"(\w+://\S+)\".*'+genome,line)	
	if for_path:
		
		path = for_path.group(1)
		print path,
	for_get = re.search('href=\"(\S+gz)\"',line)
	if for_get:
		os.system('echo \"'+line+'\" >> readme')
		os.system('wget '+path+'/'+for_get.group(1))

