#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-24 13:40:24
# Example get_chr_maf.py   
import sys, os, re
import getopt
def usage():
		print '''get_chr_maf.py msa.maf gff
'''

gff = ''
msa = ''
if len(sys.argv) == 1:
		fo0 = os.popen('ls')
		for file in fo0:
				re_f = re.search('(\S+.gff)',file)
				if re_f:
						gff = re_f.group(1)
				re_f = re.search('(\S+.maf)',file)
				if re_f:
						msa = re_f.group(1)
if len(sys.argv) == 3:
		msa = sys.argv[1]
		gff = sys.argv[2]
re_sp = re.search('(\w+)',gff)
sp = re_sp.group(1)

print "Start running..."
print "get CDS gff"
cmd = 'grep -P \"\\tCDS\" '+gff+'|sed s/^/'+sp+'./ > '+sp+'.cds.gff'
print cmd
os.system(cmd)
print "cmd: get_chr_maf.py "+ msa + ' ' + sp
cmd = 'maf_sort ' + msa + ' ' + sp
print cmd

fp = os.popen(cmd)
dict = {}
head = fp.readline()
lines = ''
ft = {}
chr = ''
print "splits by chrs"
fout = open('shell','w')
for line in fp:
		re_r = re.search(sp+'.(\S+)',line)
		if re_r:
				chr = re_r.group(1)
				if not dict.has_key(chr):
						ft[chr] = open(re_r.group(1)+".maf","w")
						dict[chr] = 1
						ft[chr].write(head)
						fout.write('source ~/.bashrc;phast.sh '+chr+'\n')
		lines += line
		if len(line) < 2:
				ft[chr].write(lines)
				lines = ''

for i in ft.keys():
		ft[i].write('##eof maf\n')

