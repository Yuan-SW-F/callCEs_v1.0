#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-06-10 11:47:43
# Example split_chr.py   
import sys, os, re

file = sys.argv[1]
re_file = re.search('(\w+)[^\/]+$',file)
name = re_file.group(1)

fi = open(file)
id = ''
cut = 50000000
str_s = "N" * 1000
string = ''
ft = open(name + '.err','w')
ft.write("chromosome\tlength\n")
for line in fi:
		line = line.strip()
		re_id = re.search('>(\S+)',line)
		if re_id:
				if id:
						print id
						seq = ''
						count = 0
						len_t = 0
						while len(string) > cut:
								seq = ''.join(string[0:cut])
								re_seq = ''.join(string[cut:])
								index = re_seq.find(str_s)
								count += 1
								if index > 0:
										seq = ''.join(string[0:cut+index])
										fo = open(id+"_" + str(count), 'w')
										fo.write('>' + id+"_" + str(count) + '\n' + seq + '\n')
										re_seq = ''.join(string[cut+index:])
										re_1 = re.match('(N+)(\S+)',re_seq)
										N_len = len(re_1.group(1))
										string = ''.join(string[cut+index+N_len:])
										len_t += cut+index+N_len
										outstr = id+"_" + str(count) + "\t" + str(len_t)
										ft.write(outstr + '\n')
										print outstr
								else:
										fo = open(id+"_" + str(count), 'w')
										fo.write('>' + id+"_" + str(count) + '\n' + seq + '\n')
										len_t += len(string)
										outstr = id+"_" + str(count) + "\t" + str(len_t)
										ft.write(outstr + '\n')
										print outstr
										string = ''
						count += 1
						fo = open(id+"_" + str(count), 'w')
						fo.write('>' + id+"_" + str(count) + '\n' + seq + '\n')
						len_t += len(string)
						outstr = id+"_" + str(count) + "\t" + str(len_t)
						ft.write(outstr + '\n')
						print outstr
						string = ''

				id = name + "_" + re_id.group(1)
				string = ''
		else:
				string += line

if id:
		seq = ''
		count = 0
		len_t = 0
		while len(string) > cut:
				seq = ''.join(string[0:cut])
				re_seq = ''.join(string[cut:])
				index = re_seq.find(str_s)
				count += 1
				if index > 0:
						seq = ''.join(string[0:cut+index])
						fo = open(id+"_" + str(count), 'w')
						fo.write('>' + id+"_" + str(count) + '\n' + seq + '\n')
						re_seq = ''.join(string[cut+index:])
						re_1 = re.match('(N+)(\S+)',re_seq)
						N_len = len(re_1.group(1))
						string = ''.join(string[cut+index+N_len:])
						len_t += cut+index+N_len
						outstr = id+"_" + str(count) + "\t" + str(len_t)
						ft.write(outstr + '\n')
						print outstr
				else:
						fo = open(id+"_" + str(count), 'w')
						fo.write('>' + id+"_" + str(count) + '\n' + seq + '\n')
						len_t += len(string)
						outstr = id+"_" + str(count) + "\t" + str(len_t)
						ft.write(outstr + '\n')
						print outstr
						string = ''
		count += 1
		fo = open(id+"_" + str(count), 'w')
		fo.write('>' + id+"_" + str(count) + '\n' + seq + '\n')
		len_t += len(string)
		outstr = id+"_" + str(count) + "\t" + str(len_t)
		ft.write(outstr + '\n')
		print outstr
		string = ''


