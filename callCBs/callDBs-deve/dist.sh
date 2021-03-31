#!/bin/bash
# File Name: dist.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2021-01-05 15:10:09
source ~/.bashrc

for i in CLN CLn Cln ClN cLN clN cLn; do
	                echo -ne "$i\t"
					                grep -P "=$i" Medicago.CNE.bed.fun.bed.gff | awk '{i+=$5-$4+1;j++;}END{print j"\t"i}'
									done

