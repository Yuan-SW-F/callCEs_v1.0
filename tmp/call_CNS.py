#!/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-19 17:32:12
# Example call_CNS.py   
import sys, os, re

fp = open(sys.argv[1])
dict_s = {}
dict_e = {}
for line in fp:
		line = line.strip('\n')
		list_l = re.split('\s+',line)
		dict_s[list_l[0]] = list_l[1]
		dict_e[list_l[0]] = list_l[2]

fp_maf = open(sys.argv[2])
check = 0
id_c = 0
for lines in fp_maf:
		re_maf = re.match('s',lines)
		if re_maf:
				ref_m = re.split('\s+',lines)
				if ref_m:
						id_raw = re.search('(\w+)\.(\S+)',ref_m[1])
						id = id_raw.group(2)
#						id = ref_m.group(2)
						start = ref_m[2]
						len_m = ref_m[3]
						ori = ref_m[4]
						len_t = ref_m[5]
						if int(len_m) < 4:
								continue
						seq = ref_m[6]
						if dict_s.has_key(id):
								id_c += 1
								check = 1
								if ori == '+':
										end = int(start) + int(len_m) -1
										print '{}\tlastz\tCNS\t{}\t{}\t.\t{}\t.\tID=cns{}'.format(id, start, end, ori, id_c)
								else:
										end = int(start) + int(len_m) - 1
										print '{}\tlastz\tCNS\t{}\t{}\t.\t{}\t.\tID=cns{}'.format(id, start, end, ori, id_c)
						elif(check == 1):
								if ori == '+':
										end = int(start) + int(len_m) - 1
										print '{}\tlastz\tCNS\t{}\t{}\t.\t{}\t.\tID=cns{}'.format(id, start, end, ori, id_c)
								else:
										end = int(start) + int(len_m) -1
										print '{}\tlastz\tCNS\t{}\t{}\t.\t{}\t.\tID=cns{}'.format(id, start, end, ori, id_c)
		else:
				check = 0
				continue


