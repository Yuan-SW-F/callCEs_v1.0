#!/bin/bash
# File Name: add.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2020-03-09 03:18:27
source ~/.bashrc

for i in MtrunA17Chr0c07_Metru MtrunA17Chr0c08_Metru MtrunA17Chr0c11_Metru MtrunA17Chr0c13_Metru MtrunA17Chr0c16_Metru MtrunA17Chr0c21_Metru MtrunA17Chr0c23_Metru MtrunA17Chr0c24_Metru MtrunA17Chr0c25_Metru MtrunA17Chr0c26_Metru;do 
	perl -ne 'chomp; print "$_\tDistal\tUnknown\t.\t.\t.\t.\n"' $i.bed > $i.bed.stream
	done
