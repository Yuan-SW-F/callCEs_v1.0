#!/app/anaconda2/bin/python
# -*- coding: UTF-8 -*-
# Author: Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-04-12 16:32:53
# Example kaks-fy.py   
import sys, os, re

bin = 'path-syntenic'

blast = ''
pep = ''
cds = ''
pair = ''

for i in sys.argv:
		re_suffix = re.search('(\w+)$',i)
		suffix = re_suffix.group(1)
		if suffix == 'blast':
				blast = i
		elif suffix == 'pep':
				pep = i
		elif suffix == 'cds':
				cds = i
		elif suffix == 'pair':
				pair = i

### muscle
cmd = '{}/muscle/prepare_muscle_blast.pl {} {} {} output muscle.sh'.format(bin, pair, pep, cds)
print cmd
os.system(cmd)

os.system('sh muscle.sh')

os.system('perl {}/muscle/muscle_combine_blast.pl output'.format(bin))
os.system('cp output/all.cds.axt .')
faxt = os.popen('echo `pwd`/all.cds.axt')
axt = faxt.readline()
axt = axt.strip('\n')
os.system('echo `pwd`/all.cds.axt > axt.list')

### kaks
os.system('KaKs_Calculator -i {} -o out.KaKs -m GMYN'.format(axt))

scale = 0.05
col = [3, 4, 5]
type = ['Ka','Ks','KaDKs']

cmd = "grep  -v  'Sequence' out.KaKs | awk '{print $" + '{}'.format(col[1]) + "}' | sort -n > out."+type[1]+".sort"
os.system(cmd)
cmd = "perl {}/plot/copy-combine.genepair.pl out out.{}.sort out.{}.sort.com{} {}".format(bin, type[1], type[1], scale, scale)
print cmd
os.system(cmd)
cmd = "perl {}/plot/num2propotion.pl out.{}.sort.com{} out.{}.sort.com{}.rate".format(bin, type[1], scale, type[1], scale,)
os.system(cmd)
cmd = "perl {}/plot/4dTv_histogram_rate.pl -type {} -scale {} out.{}.sort.com{}.rate out.{}.sort.com{}.rate.svg".format(bin, type[1], scale, type[1], scale, type[1], scale)
os.system(cmd)



