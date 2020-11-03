#!/bin/bash
# File Name: sortmerge.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2020-02-20 12:37:08
source ~/.bashrc
mkdir $1
ln -s /vol3/asbc/CHENGSHIFENG_GROUP/fuyuan/02.Nfix/00.81species_CNE/23.CNE/01.class/$1/*.score-0.9.sorted $1
cp /vol3/asbc/CHENGSHIFENG_GROUP/fuyuan/02.Nfix/00.81species_CNE/23.CNE/01.class/$1/*maf $1

cd $1
for i in `ls *.score-0.9.sorted |sed s/.score-0.9.sorted//`; do  mergeBed -d 3 -i $i.score-0.9.sorted  | sed s/Medicago_truncatula.// > $i.cons.bed; sortBed -i $i.cons.bed > $i.cons.bed.sorted ; mergeBed -i $i.cons.bed.sorted | awk '{if ($3-$2>=5){print}}' > $i.cons.bed.sorted.merged.bed;done

get_chr_maf.py MtrunA17Chr0_Metru.maf Medicago_truncatula
rm Medicago_truncatula.cds.gff shell MtrunA17Chr0_Metru.maf

perl -ne '/(\S+)/;open O, ">$1.cons.bed.sorted.merged.bed" if ! exists $hash{$1}; $hash{$1} = 1; print O $_;' MtrunA17Chr0_Metru.cons.bed.sorted.merged.bed


cd ..
