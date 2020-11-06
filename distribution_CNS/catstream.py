#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-10-10 14:52:29
# Example python.py   
import sys, os, re

prefix2 = ".bed.cns.bed.downstream"
prefix1 = ".bed.cns.bed.upstream"
prefix  = sys.argv[1]

fp1 = os.popen('sort -k 2 -n ' + prefix + prefix1)
fp2 = os.popen('sort -k 2 -n ' + prefix + prefix2)

list1 = []
list2 = []
for line in fp1:
	list1.append(line.strip())

for line in fp2:
	list2.append(line.strip())

ft = open(prefix + '.stream', 'w')
tmp1 = 1000000000
tmp2 = 1000000000
for i in range(len(list1)):
	list3 = list1[i].split()
	list4 = list2[i].split()
	re_1 = re.search('\d', list3[-1])
	re_2 = re.search('\d', list4[-1])
	if re_1:
		tmp1 = abs(int(list3[-1]))
	if re_2:
		tmp2 = abs(int(list4[-1]))
	print tmp1
	print tmp2
#	if abs(int(list4[-1])) > 0:
#		tmp = abs(int(list4[-1]))

#	if abs(int(list3[-1])) > tmp:
	if tmp1 >= tmp2:
		ft.write(list2[i] + "\t" + str(abs(int(list4[-1]))) + '\n')
	else:
		ft.write(list1[i] + "\t" + str(abs(int(list3[-1]))) + '\n')


