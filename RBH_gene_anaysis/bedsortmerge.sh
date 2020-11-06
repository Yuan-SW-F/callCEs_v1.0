#!/bin/bash
# File Name: bedsortmerge.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-06-04 17:40:08
source ~/.bashrc

sortBed -i $1 > $1.sorted
python mergebed.py $1.sorted > $1.sorted.merge
#mergeBed -i $1.sorted -d 5 > $1.sorted.merge
bedtools getfasta -s -fi $2 -bed $1.sorted.merge -fo $1.sorted.merge.fa
muscle -quiet -in $1.sorted.merge.fa -out $1.sorted.merge.fa.muscle
