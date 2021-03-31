#!/bin/bash
# File Name: cmd.sh
# Author  : yuan, yuanswf@163.com
# Created Time: 2020-12-20 20:08:00
source ~/.bashrc

mkdir 04.clade
mkdir 05.clade_block
cd 04.clade
for c in $1 ;do
#for c in NFC NFN NFL;do
    L=`cat ../$c.lst | abyss lst`
    C=`cat ../$c.lst | wc -l | perl -ne 'print int(0.9*$1 + 0.999) if /(\d+)/'`
    D="../03.MSA_blocks"
    mkdir $c
    cd $c
    for i in `ls ../$D | grep maf`;do
            maf_order ../$D/$i $L > $i.order
               mafFilter -minRow=$C $i.order > $i.order.filter
           F=`echo $i.order.filter.$c-blocks.maf | perl -ne 's/.maf.blocks.order.filter//; print $1 if /(\S+)/'`
                cp $i.order.filter ../../05.clade_block/$F
             abyss maf2bed ../../05.clade_block/$F | sed s/Medicago_truncatula.// > ../../05.clade_block/$F.bed
    done
    cd ..
done
