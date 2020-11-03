#!/bin/bash
# File Name: mergeclass.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2020-03-31 09:27:26
source ~/.bashrc

bi -a class.gff -b ../02.RANO/rnaO.gff > rnaO.gff

for i in `ls ../02.RANO/*gff | sed s#../02.RANO/## | sed s/.gff// `;do
	bi -a class.gff -b ../02.RANO/$i.gff | sed s/$/\;$i/ > $i.gff
done
