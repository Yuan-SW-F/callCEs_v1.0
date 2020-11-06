#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-05-28 13:06:02
# Example callCons.py   
from __future__ import division
import sys, os, re

if len(sys.argv) < 3:
		exit('callCons.py maf-file species-number cut-off score-cut')
maf = sys.argv[1]
num_sp = int(sys.argv[2])
cut_off = 0
cut = int(num_sp)*cut_off
score_cut = 0.72
if len(sys.argv) == 4:
		if float(sys.argv[3]) > 1:
				cut = int(sys.argv[3])
		else:
				cut_off = float(sys.argv[3])
				cut = int(num_sp)*cut_off
if len(sys.argv) == 5:
		score_cut = float(sys.argv[4])

prefix = ''
re_maf = re.search('(\w+).maf$',maf)
if re_maf:
		prefix = re_maf.group(1)
else:
		exit('please check prefix of maf file')

cmd = 'maf-sort {}.maf | grep -v "#"'.format(prefix)
fp = os.popen(cmd)
ft = open(prefix + '.score','w')
f_score = prefix + '.score-' + str(score_cut)
ft1 = open(f_score,'w')
list_fp = fp.read().split('\n\n')
for line in range(len(list_fp)-1):
		list = list_fp[line].split('\n')
		list_ref = re.split('\s+',list[1])
		chr = list_ref[1]
		start = int(list_ref[2])
		seq = list_ref[6]
		for i in range(len(seq)):
				num_c = 0
				num=0
				loci=[]
				if seq[i] != '-':
						start += 1
						for j in list[1:]:
								j = re.split('\s+',j)
								if j:
										num_c += 1
										loci.append(j[6][i].upper())
										re_N = re.match('[ATCG]',loci[-1])
										if re_N:
												num += 1
										else:
												num += 0.5
						base = 0
						pair = 0
						for m in range(len(loci)):
								for n in range(len(loci)):
										pair += 1
										if loci[m] == loci[n]:
												re_N1 = re.match('[ATCG]',loci[m])
												re_N2 = re.match('[ATCG]',loci[n])
												if re_N1 and re_N2:
														base += 1
						pi = 0
						if pair > 0:
								pi = base/pair
						if len(loci) < cut:
								score = 0
						else:
								score = pi*0.3 + 0.7*num/int(num_sp)
						score_line = '\t'.join([chr, str(start-1), str(start), ('%.4f' % score), ('%.4f' % pi), ('%.4f' % (num/int(num_sp))), str(num_c), "".join(loci)]) + '\n'
						ft.write(score_line)
						if score >= score_cut:
								ft1.write(score_line)
"""						
						list_s = re.split('\s+',score_line)
						score_s.append(list_s[3])
						bed.append(score_line)
#						if (len(score_s) >= 5):
						check = 0
						if float(list_s[3]) < score_cut and len(bed) < 4:
								bed = []
								check = 0
						for k in (score_s[-5:]):
								if ( float(k) < score_cut ):
										check += 1
										if check > 1:
												if len(bed) >= 4:
														if (float(re.split('\s+',bed[-2])[3]) < score_cut):
																ft1.write(''.join(bed[0:len(bed)-2]))
														else:
																ft1.write(''.join(bed[0:len(bed)-1]))
														bed = []
"""
ft.close()
ft1.close()
cmd = 'sortBed -i ' + f_score + ' > ' + f_score + '.sorted'
os.system(cmd)
cmd ='bedtools merge -d 3 -i ' + f_score + '.sorted' + '| awk \'{if ($3-$2>5){print}}\' | sed s/Medicago_truncatula.// > ' + prefix + '.cons.bed'
os.system(cmd)
os.system('choice_CNS4maf.py '+ prefix + '.cons.bed ' + maf + ' > ' + prefix + '.cons.bed.loc')
