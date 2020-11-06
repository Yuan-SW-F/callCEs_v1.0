#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-06-05 15:54:59
# Example mergebed.py   
import sys, os, re

fi = open(sys.argv[1])
dict = {}
sp_list = []
sp = {}
for line in fi:
		line = line.strip()
		list = re.split('\t',line)
		re_sp = re.search('\_(\w\w\w\w\w)$',list[0])
		if re_sp:
				if not sp.has_key(re_sp.group(1)):
						sp[re_sp.group(1)] = []
						sp[re_sp.group(1)].append(list[0])
				else:
						sp[re_sp.group(1)].append(list[0])
		if not dict.has_key(list[0]):
				dict[list[0]] = list
				sp_list.append(list[0])
		else:
				dict[list[0]][2] = list[2]

for i in sp.keys():
#		print sp[i]
		if len(sp[i]) > 1:
				ln = 0
				bed = []
				for j in sp[i]:
						if int(dict[j][2]) - int(dict[j][1]) > ln:
								bed = dict[j]
								ln = int(dict[j][2]) - int(dict[j][1])
				print '\t'.join(bed)
						
		else:
				print '\t'.join(dict[sp[i][0]])



