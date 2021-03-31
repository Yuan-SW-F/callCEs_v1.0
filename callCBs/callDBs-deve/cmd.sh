#!/bin/bash
# File Name: cmd.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2019-11-26 11:14:41
source ~/.bashrc

ln -s ../Medicago_truncatula.gff
for i in `ls *Metru.bed`; do
	R=`echo $i | perl -ne 'print $1 if /([^\.]+)/'`
	echo "source ~/.bashrc
	python ~/abysw/CNSanner.py Medicago_truncatula.gff $i mRNA $R. 1
	catstream.py $i
	CNE_distance.pl $i.stream $i.bed.cns.bed.genes > $i.stream.xls
	CNE_distance.pl $i.bed.cns.bed.upstream $i.bed.cns.bed.genes > $i.upstream.xls" > $i.sh
done
for i in `ls *sh`;do
	sh $i
done

for i in MtrunA17Chr0c07_Metru MtrunA17Chr0c08_Metru MtrunA17Chr0c11_Metru MtrunA17Chr0c13_Metru MtrunA17Chr0c16_Metru MtrunA17Chr0c21_Metru MtrunA17Chr0c23_Metru MtrunA17Chr0c24_Metru MtrunA17Chr0c25_Metru MtrunA17Chr0c26_Metru;do
	perl -ne 'chomp; print "$_\tDistal\tUnknown\t.\t.\t.\t.\n"' $i.cons.bed.sorted.merged.bed > $i.cons.bed.sorted.merged.bed.stream
done

#$ for i in `ls *.genes| sed s/.genes//`;do CNE_distance_ud.pl $i.genes -m 50; perl CNE_distance_ud.pl $i.stream; Rscript R.R $i.stream.xls $i.genes.xls ; done

