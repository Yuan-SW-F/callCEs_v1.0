#!/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-11 10:06:16
# Example change_gff_ID.py   
import sys, os, re

file = sys.argv[1]
name = re.search('(\w\w)[^\_\/]+\_(\w\w\w)[^\/]+$',file)
name = name.group(1)+name.group(2)
fo = open(file,"r")
for line in fo:
		re_head = re.match('^#', line)
		if re_head:
			continue
		text = line.split("\t")
		text[0]+='_'+name
		#txt = re.sub(';','',text[8])
		re_nm = re.search('([^\;]+)', text[8])
		if re_nm:
			text[8] = re_nm.group(1)
		text[8] = re.sub('[\;\s]+','',text[8])
		text[8]+='_'+name 
		print '\t'.join(text)
