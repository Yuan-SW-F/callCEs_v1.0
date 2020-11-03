#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: fuyuan (907569282@qq.com)
# Created Time: 2019-06-13 09:34:15
# Example distribution_CES_species.py   
import sys, os, re
cmd = "*/*xls"
if len(sys.argv) == 2:
	if sys.argv[1] == '-h':
		exit('distribution_CES_species.py "*/*xls"')
	else:
		cmd = sys.argv[1]
fp = os.popen('ls '+cmd) #('ls Medicago_truncatula-MtrunA17Chr0c*/*stat')
ids = []
dict = {}
for line in fp:
    re_id = re.search('(\w+).bed.sorted.merged.',line)
    if not re_id:
        continue
    id = re_id.group(1)
    if not dict.has_key(id):
        dict[id] = {}
        ids.append(id)
    line = line.strip()
    fp1 = open(line)
    fp1.readline()
    for line in fp1:
        line = line.strip()
        list = re.split('\s+',line)
        if not dict[id].has_key(list[0]):
            dict[id][list[0]] = int(list[1])
        else:
            dict[id][list[0]] += int(list[1])

if os.path.exists('sp.list'):
    fp = open('sp.list')
    ids = []
    for i in fp:
        re_id = re.search('(\w\w)[a-z]+\_(\w\w\w)\w*',i)
        ids.append(re_id.group(1) + re_id.group(2))
head = 'head'
elem = {}
for i in ids:
    head += '\t' + i
    for j in dict['Metru'].keys():
        if not elem.has_key(j):
            elem[j] = j
        elem[j] += '\t' + str(dict[i][j])

print head
elems = ['mRNA', 'exon', 'CDS', 'intron', 'five_prime_UTR', 'three_prime_UTR', 'upstream', 'downstream', 'distal']
for i in elems:
    if elem.has_key(i):
        print elem[i]

