#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-09-23 09:27:07
# Example CNSanner.py   
import sys, os, re

gff = sys.argv[1]
bed = sys.argv[2]
fp = open(sys.argv[2])
line = fp.readline()
list = line.split()
if len(list) > 5:
	cmd = 'cut -f 1,4,5 ' + bed + ' |awk \'{i+=1;print $1"\\t"$2"\\t"$3"\\t"$1"_CNE_"i}\' > ' + bed + '.bed\n'
else:
	cmd = 'cat ' + bed + ' |awk \'{i+=1;print $1"\\t"$2"\\t"$3"\\t"$1"_CNE_"i}\' > ' + bed + '.bed\n'
bed = bed + '.bed'
os.system(cmd)

re_id = re.match('([^\.\s]+)', bed)
id = re_id.group(1)
type = "mRNA"
if len(sys.argv) > 3:
	type = sys.argv[3]
cmd = 'grep -P "\\texon\\t" ' + gff + '| grep AABBDD_AA | sed s/AABBDD_AA.// | grep ' + id + '> ' + bed + ".exon\n"
cmd += 'grep -P "\\tCDS\\t" ' + gff + '| grep AABBDD_AA | sed s/AABBDD_AA.// | grep ' + id + '> ' + bed + ".cds\n"
cmd += 'grep -P "\\t' + type + '\\t" ' + gff + '| grep AABBDD_AA | sed s/AABBDD_AA.// | grep ' + id + '> ' + bed + ".mrna\n"
os.system(cmd)

cmd = 'bedtools intersect -a ' + bed + ".mrna -b " + bed + " |sort -k 4 -n > " + bed + ".mrna.cons.bed\n"
cmd += 'bedtools intersect -a ' + bed + " -b " + bed + ".mrna |sort -k 2 -n > " + bed + ".mrna.cons.bed.id\n"
cmd += 'bedtools subtract -a ' + bed + ".mrna.cons.bed -b " + bed + ".cds" + " |sort -k 4 -n > " + bed + ".intron.cons\n"
cmd += 'bedtools subtract -a ' + bed + ".mrna.cons.bed.id" + " -b " + bed + ".cds |sort -k 2 -n > " + bed + ".intron.cons.id\n"
#cmd += 'bedtools intersect -a ' + bed + " -b " + bed + ".intron.cons |sort -k 2 -n > " + bed + ".intron.cons.id\n"
cmd += 'bedtools intersect -a ' + bed + ".mrna -b " + bed + ".intron.cons" + " > " + bed + ".intron.cons.bed\n"
cmd += 'bedtools subtract -a ' + bed + " -b " + bed + ".mrna " + " > " + bed + ".cns.bed\n"
os.system(cmd)


fp = os.popen('paste ' + bed + ".mrna.cons.bed.id " + bed + ".mrna.cons.bed")
dict = {}
for line in fp:
	line = line.strip()
	list = line.split()
	re_id = re.search('\=([^\s\;]+)', list[12])
	if re_id:
		list[12] = re_id.group(1)
	if not dict.has_key(list[3]):
		dict[list[3]] = "\t".join([list[0], list[1], list[2], "mRNA:"])
	dict[list[3]] += list[12] + ';'

fp = os.popen('paste ' + bed + ".intron.cons.id " + bed + ".intron.cons")
for line in fp:
	line = line.strip()
	list = line.split()
	re_id = re.search('\=([^\s\;]+)', list[12])
	if re_id:
		list[12] = re_id.group(1)
	if not dict.has_key(list[3]):
		dict[list[3]] = "\t".join([list[0], list[1], list[2], "intron:"])
	dict[list[3]] += "intron:" + list[12] + ";"
ft = open(bed + ".cns.bed.genes", 'w')
#for i in dict.keys():
#	ft.write(dict[i] + "\n")

fp = open(bed + ".mrna")
tss = {}
od  = {}
ids = {}
id = ''
tes = {}
chr = list[0]
for line in fp:
	line = line.strip()
	list = line.split()
	re_id = re.match('ID=([^\;\s]+)', list[8])
	id = re_id.group(1)
	od[id] = list[6]
#	if not ids.has_key(list[0]):
#		ids[list[0]] = []
#	ids[list[0]].append(id)
	if list[6] == '+':
		tss[id] = int(list[3])
		tes[id] = int(list[4])
	else:
		tss[id] = int(list[4])
		tes[id] = int(list[3])

sort_tss = sorted(tss.items(), key = lambda x:x[1])
for i in sort_tss:
	if not ids.has_key(chr):
		ids[chr] = []
	ids[chr].append(i[0])

fp = open(bed + ".cns.bed")
ft1 = open(bed + ".cns.bed.upstream", 'w')
ft2 = open(bed + ".cns.bed.downstream", 'w')

for line in fp:
	line = line.strip()
	list = line.split()
	length = 0
	note = ''
	check = 0
	stream = 'distalis'
	w_out = 0
	if dict.has_key(list[3]):
		dict[list[3]] += "intergenic;"
		continue
	for i in ids[list[0]]:
		if check > 0:
			check = 0
			break
		if od[i] == '+':
#			print length
#			if length > 0 and tss[i] - int(list[2]) < 0:
#				ft1.write('\t'.join([list[0], list[1], list[2], 'UPSTREAM', note]) + '\n')
#				ft2.write('\t'.join([list[0], list[1], list[2], 'DOWNSTREAM', i, str(tss[i]), od[i], str(tss[i] - int(list[2]))]) + '\n')
#				check = 1
			if length > 0 and tss[i] - int(list[2]) > length:
				if length <= 10000:
					stream = 'UPSTREAM'
				ft1.write('\t'.join([list[0], list[1], list[2], stream, note]) + '\n')
				w_out = 1
				check = 1
			length = tss[i] - int(list[2])
			note = '\t'.join([i, str(tss[i]), od[i], str(length)]) 
			odo = '+'
		else:
			if length > 0 and int(list[1]) - tss[i] > length:
				if length <= 10000:
					stream = 'UPSTREAM'
				ft1.write('\t'.join([list[0], list[1], list[2], stream, note]) + '\n')
				w_out = 1
				check = 1
			if int(list[1]) - tss[i] > 0:
				length = int(list[1]) - tss[i]
				note = '\t'.join([i, str(tss[i]), od[i], str(length)])
	if w_out == 0:
		ft1.write('\t'.join([list[0], list[1], list[2], stream, note]) + '\n')


tss = tes
sort_tss = sorted(tss.items(), key = lambda x:x[1])
ids = {}
for i in sort_tss:
	if not ids.has_key(chr):
		ids[chr] = []
	ids[chr].append(i[0])

for i in dict.keys():
	ft.write(dict[i] + "\n")

fp = open(bed + ".cns.bed")
for line in fp:
	line = line.strip()
	list = line.split()
	length = 0
	note = ''
	check = 0
	stream = 'distalis'
	w_out = 0
	if dict.has_key(list[3]):
		continue
	for i in ids[list[0]]:
		if check > 0:
			check = 0
			break
		if od[i] == '+':
			if length < 0 and tss[i] - int(list[1]) < length:
				if length >= -10000:
					stream = 'DOWNSTREAM'
				ft2.write('\t'.join([list[0], list[1], list[2], stream, note]) + '\n')
				w_out = 1
				check = 1
			length = tss[i] - int(list[1])
			note = '\t'.join([i, str(tss[i]), od[i], str(length)])
		else:
			if length < 0 and int(list[1]) - tss[i] < length:
				if length >= -10000:
					stream = 'DOWNSTREAM'
				ft2.write('\t'.join([list[0], list[1], list[2], stream, note]) + '\n')
				w_out = 1
				check = 1
			if int(list[1]) - tss[i] < 0:
				length = int(list[1]) - tss[i]
				note = '\t'.join([i, str(tss[i]), od[i], str(length)])

	if w_out == 0:
		ft2.write('\t'.join([list[0], list[1], list[2], stream, note]) + '\n')



	



#exon = os.system('grep -P "\texon\t" ' + gff + ' > ' + gff + ".exon")
#cds = os.system('grep -P "\tCDS\t" ' + gff + ' > ' + gff + ".cds")
#mrna = os.system('grep -P "\tmRNA\t" ' + gff + ' > ' + gff + ".mrna")
#c_mrna = os.system('bedtools intersect -a ' + gff + ".mrna -b " + bed + " > " + gff + ".mrna.cons.bed")
#c_intron = os.system('bedtools subtract -a ' + gff + ".mrna -b " + gff + ".mrna.cons.bed" + " > " + gff + ".intron.cons.bed")
#cns = os.system('bedtools subtract -a ' + bed + " -b " + gff + ".mrna " + " > " + gff + ".cns.bed")



