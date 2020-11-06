#!/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-11 11:05:28
# Example format_gff.py   
import sys, os, re

fo = open(sys.argv[1],"r")
for line in fo:
		fail = re.match('#',line)
		text = line.split('\t')
		if fail:
				continue
		elif text[2] == 'mRNA':
				id = re.search('(ID=[^\;\s]+)',text[8])
				if id:
						text[8] = id.group(1)
				ck_id = re.search('[^\w\d\.]*([\w\d\.]+)$',text[8])
				if ck_id:
						text[8] = 'ID='+ck_id.group(1)
				print '\t'.join(text)
		elif text[2] == 'CDS':
				id = re.search('(Parent=[^\;\s]+)',text[8])
				if id:
						text[8] = id.group(1)
				ck_id = re.search('[^\w\d\.]*([\w\d\.]+)$',text[8])
				if ck_id:
						text[8] = 'Parent='+ck_id.group(1)
				print '\t'.join(text)
