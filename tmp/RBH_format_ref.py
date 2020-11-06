#!/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-16 14:37:46
# Example RBH_format.py   
import sys, os, re

fp = open(sys.argv[1])
text = fp.readline()
text = text.strip('\n')
sps = re.split('\s+',text)

sp_path = './'
sp_hyphen = '-'
sp_postfix= '.blast'
ref = "Medicago_truncatula"
if len(sys.argv) >= 3:
		sp_path = sys.argv[2]
if len(sys.argv) >= 4:
		sp_hyphen = sys.argv[3]
if len(sys.argv) >= 5:
		sp_postfix =sys.argv[4]
if len(sys.argv) >= 6:
		ref = sys.argv[5]

sps_len = len(sps)
for i in range(1,sps_len):
		file1 = sp_path + '' + ref + sp_hyphen + sps[i] + sp_postfix
		file2 = sp_path + '' + sps[i] + sp_hyphen + ref + sp_postfix
		fp1 = os.popen('ls ' + file1 + ' 2>/dev/null','r')
		fp2 = os.popen('ls ' + file2 + ' 2>/dev/null')
		if fp1:
				file1 = fp1.readline()
				file1 = file1.strip('\n')
		else:
				print '#',
		if fp2:
				file2 = fp2.readline()
				file2 = file2.strip('\n')
		else:
				print '#',
		
		print "{}\t{}\t{}\t{}".format(ref, sps[i], file1, file2)

