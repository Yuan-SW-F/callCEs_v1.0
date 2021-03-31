#!/bin/bash
# File Name: ../sh.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2021-03-05 17:17:21
source ~/.bashrc

sortBed -i $1 | perl -ne 's/(\S+)/$1\_Metru/; print' > $2.gff3

bi -a $2.gff3 -b ../Medicago.latest_CNE.bed > 1

bi -a ../Medicago.latest_CNE.bed -b $2.gff3 > 2

paste 1 2 | perl -ne 'chomp;@l=split /\t/; print join "\t", @l[0,1,2,3,4,12,6,13,8];print "\n"' | less > Medicago.latest_CNE_ol_$2.gff
perl ../check_len_CNE.pl Medicago.latest_CNE_ol_$2.gff > Medicago.latest_CNE_ol_$2.gff3
