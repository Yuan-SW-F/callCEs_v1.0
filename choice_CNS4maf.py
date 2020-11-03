#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: fuyuan (907569282@qq.com)
# Created Time: 2019-05-30 15:49:06
# Example choice_CNS4maf.py   
import sys, os, re

bed = sys.argv[1]
maf = sys.argv[2]
if len(sys.argv) < 2:
		exit('choice_CNS4maf.py bedfile maffile species')

dict_bed = {}
sp = 'Medicago_truncatula'
#sp = 'Physcomitrella_patens'
if len(sys.argv) == 4:
	sp = sys.argv[3]
fp = os.popen('grep ' + sp + ' ' + maf  + ' | grep -v \#')
ft = open(maf + '.tmp','w')
for line in fp:
		list = re.split('\s+',line)
		re_id = re.search('\.(\S+)', list[1])
		ft.write('{}\t{}\t{}\n'.format(re_id.group(1), list[2], int(list[2]) + int(list[3])))

ft.close()
fp = os.popen('bedtools intersect -a '+maf+'.tmp -b ' + bed + '| sort -k 2 -n | uniq')
for line in fp:
		line = line.strip()
		list = line.split('\t')
		if not dict_bed.has_key(list[0]):
				dict_bed[list[0]] = []
				dict_bed[list[0]].append(int(list[1]))
				dict_bed[list[0]].append(int(list[2]))
#		if dict_bed.has_key(list[0]):
		dict_bed[list[0]].append(int(list[1]))
		dict_bed[list[0]].append(int(list[2]))
#		else:
#				dict_bed[list[0]] = [int(list[1])]
#				dict_bed[list[0]].append(int(list[2]))
fp.close()
for i in dict_bed.keys():
		del dict_bed[i][0]
		del dict_bed[i][0]

ps = 0
ref_s = 0
ref_e = 0
rel_s = 0
rel_e = 0
loc_s = 0
loc_ss = 0
loc_e = 0
start = 0
end = 0
cons = 0
check = 0
fp = os.popen('grep -v "#" ' + maf)
list_maf = fp.read().split('\n\n')
for line in list_maf:
	re_line = re.search('^a',line)
	if re_line:
		list = line.split('\n')
		l_ref = re.split('\s+',list[1])
		s_ref = int(l_ref[2])
		e_ref = s_ref + int(l_ref[3])
		seq_r = l_ref[6]
		len_r = int(l_ref[5])
		ord_r = l_ref[4]
		if ord_r == '-':
#				s_ref = len_r - s_ref
				print 'error'
		re_ref = re.search('(\w+)$',l_ref[1])
		loc_ss = s_ref -1
		rel_s = 0
		if ref_s == 0 or (s_ref >= ref_e):
				check = ref_s - int(l_ref[3])
				if len(dict_bed[re_ref.group(1)]) > 0:
						ref_s = dict_bed[re_ref.group(1)][0]
						del dict_bed[re_ref.group(1)][0]
						ref_e = dict_bed[re_ref.group(1)][0]
						del dict_bed[re_ref.group(1)][0]
						cons += 1
		while s_ref <= ref_s and e_ref >= ref_e:
				print '{}\t{}\t{}\tcons{}\t0\t{}'.format(re_ref.group(1) , ref_s, ref_e, cons, ord_r)
				rel_s = 0
				loc_s = loc_ss
				for i in seq_r:
						if i != '-':
								loc_s += 1
						rel_s += 1
						if loc_s == ref_s:
								start = rel_s
						if loc_s == ref_e-1:
								end = rel_s
				for i in list[2:]:
						l_que = re.split('\s+',i)
						s_que = int(l_que[2])
						e_que = s_que + int(l_que[3])
						seq_q = l_que[6]
						len_q = int(l_que[5])
						ord_q = l_que[4]
#						if ord_q == '-':
#								s_que = len_q - s_que - int(l_que[3])
						re_que = re.search('\.(\S+)$',l_que[1])
						que = re_que.group(1)
						loc_sq = s_que -1
						loc_s = loc_sq
						rel_s = 0
						for j in seq_q:
								if j != '-':
										loc_s += 1
								rel_s += 1
								if rel_s == start:
										ps = loc_s
								if rel_s == end:
										break
						que_s = ps
						que_e = loc_s + 1
						if ord_q == '-':
								que_e = len_q - ps
								que_s = len_q - loc_s -1 
						print '{}\t{}\t{}\tcons{}\t0\t{}'.format(que, que_s, que_e, cons, ord_q)
#						print '{}\t{}\t{}\tcons{}\t0\t{}'.format(que,ps,loc_s + 1, cons, ord_q)
				if e_ref > ref_e-1:
						s_ref = ref_e
				if s_ref >= ref_s:
						check = ref_s
						if len(dict_bed[re_ref.group(1)]) > 0:
								ref_s = dict_bed[re_ref.group(1)][0]
								del dict_bed[re_ref.group(1)][0]
								ref_e = dict_bed[re_ref.group(1)][0]
								del dict_bed[re_ref.group(1)][0]
								cons += 1
