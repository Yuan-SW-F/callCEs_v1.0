#!/bin/bash
# File Name: forspcne.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2020-03-14 14:15:54
source ~/.bashrc

#rm bed/*
#rm tmp/*

for R in `ls *.bed`;do 
#R=$1
mkdir $R.bed
cd $R.bed
mkdir tmp bed
cp ../$R .
for i in `cut -f 1 $R | perl -ne 'print "$1\n" if /(\w\w\w\w\w)$/' | sort | uniq`;do
	mkdir $i
	cd $i
	mkdir tmp;
	mkdir bed;
	grep $i ../$R > $R
	echo "
	for j in \`cut -f 4 $R | uniq\`;do 
		grep \$j $R > tmp/$i.bed
		sortBed -i tmp/$i.bed > tmp/$i.sorted.bed
		mergeBed -i tmp/$i.sorted.bed -d 3 > tmp/$i.sorted.merged.bed
		perl idbed.pl $R $i
		#head -n 1 tmp/$i.sorted.bed | cut -f 4-6 > tmp/add
		#perl -ne 'chomp; @l = split /\\t/; \$n = \`head -n 1 tmp/add\`; print join \"\\t\", @l, \$n;' tmp/$i.sorted.merged.bed >> bed/$R-$i.bed
	done
	" >> $i.sh
	cd ..
done
cd ..
done
