#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: fuyuan, 907569282@qq.com
# Created Time: 2019-04-03 14:36:23
# Example splitbyNs.py   
import sys, os, re

file = sys.argv[1]
sp_re = re.search('(\w+[^\/]+$)',file)
sp = sp_re.group(1)
fo = open(file,"r")
line = fo.readline()
id = re.match(r'>(\S+)',line)
ofile=id.group(1)
dict = {}
name = ""
seq = ""
i = 1
if id:
	name = id.group(1)
while  (line):
	id = re.match(r'>(\S+)',line)
	if id:
		dict[name]=seq
		seq = ""
		name = id.group(1)
	else:
		line = line.strip('\n')
		seq += line
	line = fo.readline()
dict[name]=seq

txt = "N" * 1000
cut_lent = 100000000

for key in dict.keys():
	lenth = re.split(txt,dict[key])
	i = 1
	lent = 1
	cut_str = ""
	cut_len = 1
	for str in lenth:
		if lent > cut_lent:
			print ">{}_{}_{} {}".format(key,sp,i,cut_len)
			mini_str = re.match('^N*(\S+)',cut_str)
			print mini_str.group(1)
			i += 1
			cut_len = cut_len + lent + len(txt)
			lent = len(str)
			cut_str = str
		else:
			lent = lent + len(str) + len(txt)
			cut_str = cut_str + txt + str
	print ">{}_{}_{} {}".format(key,sp,i,cut_len)
	mini_str = re.match('^N*(\S+)',cut_str)
	print mini_str.group(1)

		
