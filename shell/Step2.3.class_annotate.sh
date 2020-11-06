#!/bin/bash
# File Name: cmd.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-11-26 11:14:41
source ~/.bashrc

ln -s ../Medicago_truncatula.gff
for i in `ls *sorted.merged.bed`; do
	R=`echo $i | perl -ne 'print $1 if /([^\.]+)/'`
	echo "source ~/.bashrc
	python ~/abysw/CNSanner.py Medicago_truncatula.gff $i mRNA $R. 1
	catstream.py $i
	CNE_distance.pl $i.stream $i.bed.cns.bed.genes > $i.stream.xls
	CNE_distance.pl $i.bed.cns.bed.upstream $i.bed.cns.bed.genes > $i.upstream.xls" > $i.sh
done

#$ for i in `ls *.genes| sed s/.genes//`;do CNE_distance_ud.pl $i.genes -m 50; perl CNE_distance_ud.pl $i.stream; Rscript R.R $i.stream.xls $i.genes.xls ; done

