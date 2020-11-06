#!/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-24 15:42:45
# Example annotation_cns.py   
import sys, os, re

gff = sys.argv[1]
bed = sys.argv[2]

gene_type = 'mRNA' #'gene'
exon_type = 'CDS'  #'exon'
if len(sys.argv) == 4:
		gene_type = sys.argv[3]
		if len(sys.argv) == 5:
				exon_type = sys.argv[4]

fp1 = open(gff)
fp2 = open(bed)

chrs = []
charas = []
character = {}
count = {}
cns = {}
ann = {}
c_cns = 0
ori = {}
type = {}
stream = 10000
re_bed = re.search('\.(\w+)$',bed)

for line in fp2:
		line = line.strip('\n')
		list = re.split('\t',line)
		id = list[0]
		start = 0
		end = 0
		if re_bed.group(1) == 'bed':
				start = int(list[1])
				start += 1
				end = int(list[2])
		elif re_bed.group(1) == 'gff':
				start = int(list[3])
				end = int(list[4])
		else:
				start = int(list[1])
				start += 1
				end = int(list[2])
		c_cns += 1
		for i in range(int(start), int(end+1)):
				if not cns.has_key(id):
						cns[id] = {}
				if not cns[id].has_key(i):
						cns[id][i] = 'cns' + str(c_cns) + ';Class='
				if not ann.has_key(id):
						ann[id] = {}
				if not ann[id].has_key(i):
						ann[id][i] = 'cns' + str(c_cns) + ';ID='
				if not ori.has_key(id):
						ori[id] = {}
				if not ori[id].has_key(i):
						ori[id][i] = '.'


intron = []
c_i = 0
s_i = []
i_ann = ''
sss = ''
eee = ''
ft = open(bed+'.testss','w')
for line in fp1:
		ignore = re.match('#',line)
		if ignore:
				continue
		line = line.strip('\n')
		list = re.split('\t',line)
		chr = list[0]
		chara = list[2]
		list[3] = int(list[3])
		list[4] = int(list[4])

		if list[3] > list[4]:
				list[3,4] = list[4,3]

		ann_re = re.search('ID=([^\;\s]+)|Parent=([^\;\s]+)',list[8])
### intron
		start_i = 0
		end_i = 0
		if chara == 'mRNA':
				c_i = 0
		if chara == exon_type:  #'exon':
				c_i += 1
		if c_i == 2:
				if list[6] == '+':
						start_i = s_i[4]
						end_i = list[3]
				else:
						start_i = s_i[4]
						end_i = list[3]
				c_i = 1
### annotation
				for n in range(start_i+1,end_i+1):
						if cns.has_key(chr):
								if cns[chr].has_key(n):
										cns[chr][n] += "intron,"
										ann[chr][n] += "intron:" + i_ann + ann_re.group(1) + ";"
										if not type.has_key('intron'):
												type['intron'] = 1
										else:
												type['intron'] += 1
		if chara == exon_type:  #'exon':
				s_i = list
				i_ann = ann_re.group(1)
		if chara == gene_type:
				if list[6] == "+":
						sss = "upstream"
						eee = "downstream"
						if cns.has_key(chr):
								if cns[chr].has_key(list[3]):
										ft.write('{}\tTSS\t{}\t{}\t{}\n'.format(chr, list[3], list[6], ann_re.group(1)))
								if cns[chr].has_key(list[4]):
										ft.write('{}\tTES\t{}\t{}\t{}\n'.format(chr, list[4], list[6], ann_re.group(1)))

				else:
						sss = "downstream"
						eee = "upstream"
						if cns.has_key(chr):
								if cns[chr].has_key(list[3]):
										ft.write('{}\tTES\t{}\t{}\t{}\n'.format(chr, list[3], list[6], ann_re.group(1)))
								if cns[chr].has_key(list[4]):
										ft.write('{}\tTSS\t{}\t{}\t{}\n'.format(chr, list[4], list[6], ann_re.group(1)))

				if list[3]-stream > 0:
						for ss in range(list[3]-stream,list[3]+1):
								if cns.has_key(chr):
										if cns[chr].has_key(ss):
												cns[chr][ss] += sss + ","
												ann[chr][ss] += sss + ":" + ann_re.group(1) + ";"
												ori[chr][ss] = list[6]
												if not type.has_key(sss):
														type[sss] = 1
												else:
														type[sss] += 1

				else:
						for ss in range(1,list[3]+1):
								if cns.has_key(chr):
										if cns[chr].has_key(ss):
												cns[chr][ss] += sss + ","
												ann[chr][ss] += sss + ":" + ann_re.group(1) + ";"
												ori[chr][ss] = list[6]
												if not type.has_key(sss):
														type[sss] = 1
												else:
														type[sss] += 1

				for es in range(list[4]+1,list[4]+stream+2):
						if cns.has_key(chr):
								if cns[chr].has_key(es):
										cns[chr][es] += eee + ","
										ann[chr][es] += eee + ":" + ann_re.group(1) + ";"
										ori[chr][es] = list[6]
										if not type.has_key(eee):
												type[eee] = 1
										else:
												type[eee] += 1
		for nn in range(list[3],list[4]+1):
				if cns.has_key(chr):
						if cns[chr].has_key(nn):
								cns[chr][nn] += chara + ","
								ann[chr][nn] += ann_re.group(1) + ";"
								ori[chr][nn] = list[6]
								if not type.has_key(chara):
										type[chara] = 1
								else:
										type[chara] += 1


fp3 = open(bed)
for line in fp3:
		line = line.strip('\n')
		list = re.split('\t',line)
		id = list[0]
		start = 0
		end = 0
		if re_bed.group == 'bed':
				start = int(list[1])
				start += 1
				end = int(list[2])
		elif re_bed.group == 'gff':
				start = int(list[3])
				end = int(list[4])
		list[1] = int(list[1])
		list[2] = int(list[2])
		start = list[1]
		end = list[2]
		for i in range(start,end+1):
				if cns.has_key(id):
						if cns[id].has_key(i):
								re_cns = re.search('=$',cns[id][i])
								if re_cns:
										cns[id][i] += 'distal,'
										if not type.has_key('distal'):
												type['distal'] = 1
										else:
												type['distal'] += 1

								re_ann = re.search('=$',ann[id][i])
								if re_ann:
										ann[id][i] += 'distal;'
								print '{}\t{}\t{}\t{}\t{}'.format(id, i, ori[id][i], cns[id][i], ann[id][i])

ft = open(bed + '.stat','w')
for key in  (type.keys()):
		ft.write('{}\t{}\n'.format(key, type[key]))
		
		
		
