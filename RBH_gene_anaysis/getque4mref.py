#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: fuyuan (907569282@qq.com)
# Created Time: 2019-06-06 17:00:45
# Example getque4mref.py   
import sys, os, re

loc = open(sys.argv[1])
dict = {}
bed = ''
for line in loc:
		re_id = re.search('\_(\w\w\w\w\w)\s',line)
		if re_id:
				id = re_id.group(1)
				if id == 'Metru':
						bed = line
				if not dict.has_key(id):
						dict[id] = bed
				else:
						dict[id] += bed
for i in dict.keys():
		ft = open (i+'.bed','w')
		ft.write(dict[i])
