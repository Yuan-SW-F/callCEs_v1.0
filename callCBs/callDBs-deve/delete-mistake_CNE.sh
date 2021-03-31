#!/bin/bash
# File Name: delete-mistake_CNE.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2021-03-10 14:59:28
source ~/.bashrc

grep cln miss-mistake.bed | cut -f 5 > miss-mistake.id

cat miss-total.bed mis.mis.check.bed | grep -vf miss-mistake.id | perl -ne 's/cLN/cLn/ if /CNE_079947/; s/cLN/cLn/ if /CNE_100756/; s/cLN/cLn/ if /CNE_280983/; print ' > miss-corrected.bed
