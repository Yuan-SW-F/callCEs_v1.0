#!/public/agis/chengshifeng_group/fuyuan/pip-fuyuan/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: fuyuan (907569282@qq.com)
# Created Time: 2019-05-15 09:11:13
# Example get_gg_file.py   
import sys, os, re

fp = open(sys.argv[1])
for line in fp:
		re_line = re.match('(\S+\/(\w+)[^\/\s]+)',line)
		print re_line.group(2) + ':',
		fp1 = open(re_line.group(1))
		for i in fp1:
				re_i = re.match('>(\S+)',i)
				if re_i:
						print re_i.group(1),
		print ''
