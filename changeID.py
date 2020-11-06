#!/public/agis/chengshifeng_group/fuyuan/pip-fuyuan/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-09 17:26:53
# Example changeID.py   
import sys, os, re

fa = sys.argv[1]
new_id = ''
id_re = re.search('(\w\w)[^\_\/]+\_(\w\w\w)[^\/]+$',fa)
new_id = id_re.group(1)+id_re.group(2)
file_o = open(fa,"r")
length = 0
seq = ''
new_name = ''
mylen = 0
for line in file_o:
	id_name = re.match('\>([^\|\s]+)',line)
	if id_name:
		if length > mylen:
			print ">"+new_name
			print seq,
		length = 0
		seq = ''
		new_name = id_name.group(1)+"_"+new_id
	else:
		length += len(line) -1
		seq += line
if length > mylen:
	print ">"+new_name
	print seq,
