#!/bin/bash
# File Name: gerp.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-05-17 09:59:09
source ~/.bashrc

RM=$2
TR=$3
RM="Medicago_truncatula"
TR="tree.nwk"
#maf-sort $1 $RM > $1.sorted

echo "source ~/.bashrc
gerpcol -t $TR -f $1 -e $RM
gerpelem -f $1.rates
less $1.rates.elems |sed s/region/$1/ | sed s/\.maf// > $1.bed
" > gerp_$1.sh
