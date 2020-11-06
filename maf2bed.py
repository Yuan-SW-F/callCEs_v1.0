#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-05-31 11:43:58
# Example maf2bed.py   
import sys, os, re

sp = 'Medicago_truncatula'
fp = os.popen('grep ' + sp + ' ' + sys.argv[1])

for line in fp:
		list = re.split('\s+',line)
		re_id = re.search('\.(\S+)', list[1])
		print '{}\t{}\t{}'.format(re_id.group(1), list[2], int(list[2]) + int(list[3]))

