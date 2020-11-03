#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: fuyuan (907569282@qq.com)
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
score_cut = 0.5
if len(sys.argv) >= 4:
		if float(sys.argv[3]) > 1:
				cut = int(sys.argv[3])
		else:
				cut_off = float(sys.argv[3])
				cut = int(num_sp)*cut_off
if len(sys.argv) >= 5:
		score_cut = float(sys.argv[4])

s_type = 'score'
if len(sys.argv) == 6:
	s_type = sys.argv[5]


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
deno = 0
for i in range(1,num_sp):
		deno += i
list_fp = fp.read().split('\n\n')
for line in range(len(list_fp)-1):
		list = list_fp[line].split('\n')
		list_ref = re.split('\s+',list[1])
		chr = list_ref[1]
		start = int(list_ref[2])
		seq = list_ref[6]
		for i in range(len(seq)):
				num_c = -1
				num = -1
				loci=[]
				if seq[i] != '-':
						start += 1
						for j in list[1:]:
								j = re.split('\s+',j)
								if j:
										if j[6][i] == '-':
											continue
										if j[6][i] == 'N':
											continue
										num_c += 1
										loci.append(j[6][i].upper())
										num += 1
						base = 0
						for m in range(1,len(loci)):
								for n in range(m+1,len(loci)):
										if loci[m] == loci[n]:
												if loci[m] != '-':# and loci[m] != 'N':
														base += 1
						pi = base/deno
						if len(loci) < cut:
								score = 0
						else:
								score = (pi + num/int(num_sp))/2
						score_line = '\t'.join([chr, str(start-1), str(start), ('%.4f' % score), ('%.4f' % pi), ('%.4f' % (num/int(num_sp))), str(num_c), "".join(loci)]) + '\n'
						ft.write(score_line)
						if s_type == 'score':
							score_c = score
						elif s_type == 'nump':
							score_c = (num/int(num_sp))

						if score_c >= score_cut:
								ft1.write(score_line)
ft.close()
ft1.close()
cmd = 'sortBed -i ' + f_score + ' > ' + f_score + '.sorted'
os.system(cmd)
cmd ='bedtools merge -d 3 -i ' + f_score + '.sorted' + '| awk \'{if ($3-$2>=5){print}}\' | sed s/Medicago_truncatula.// > ' + prefix + '.cons.bed'
os.system(cmd)
os.system('choice_CNS4maf.py '+ prefix + '.cons.bed ' + maf + ' > ' + prefix + '.cons.bed.loc')
bed = prefix + '.cons.bed'
os.system('sortBed -i ' + bed +' > '+ bed + '.sorted')
os.system('mergeBed -i '+bed+'.sorted -d 3 > '+bed+'.sorted.merged.bed')
cmd = 'annotation_cns.py ../../Medicago_truncatula.gff '+bed+'.sorted.merged.bed > '+bed+'.sorted.merged.gff' + '\n'
cmd +='cns_stat.sh '+bed+'.sorted.merged.gff > '+bed+'.sorted.merged.gff.xls' + '\n'
cmd +="mkdir " + prefix + '\n'
cmd +='cd ' + prefix + '\n'
cmd +="getque4mref.py ../" + bed + ".loc" + '\n'

#os.system('annotation_cns.py ../../Medicago_truncatula.gff '+bed+'.sorted.merged.bed > '+bed+'.sorted.merged.gff')
#os.system('cns_stat.sh '+bed+'.sorted.merged.gff > '+bed+'.sorted.merged.gff.xls')

#os.system("mkdir " + prefix )
#os.chdir(prefix)
#os.system("getque4mref.py ../" + bed + ".loc")
for root, dirs, files in os.walk('.'):
	for i in files:
		#os.system('sortBed -i {} > {}.sorted; mergeBed -i {}.sorted -d 5 > {}.sorted.merged; annotation_cns.py ../../../Medicago_truncatula.gff {}.sorted.merged > {}.sorted.merged.gff; cns_stat.sh {}.sorted.merged.gff > {}.sorted.merged.gff.xls'.format(i,i,i,i,i,i,i,i))
		cmd += 'sortBed -i {} > {}.sorted; mergeBed -i {}.sorted -d 3 > {}.sorted.merged; annotation_cns.py ../../../Medicago_truncatula.gff {}.sorted.merged > {}.sorted.merged.gff; cns_stat.sh {}.sorted.merged.gff > {}.sorted.merged.gff.xls'.format(i,i,i,i,i,i,i,i) + '\n'

ft = open(bed + '.ann.sh', 'w')
ft.write(cmd)
