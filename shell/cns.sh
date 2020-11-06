#!/bin/bash
# File Name: cns.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-11-05 15:14:15
source ~/.bashrc

R=$1
F=$1
D=$PWD
DIR=$D/$R-CNS
mkdir $DIR
mkdir $DIR/loc
cd $DIR
perl -ne 'chomp;/(\S+)/;`echo "$_" >> ./loc/$1.bed `' ../$F
mkdir maf
cd maf
ln -s $D/*.maf .
cd ..
cd loc
for i in `ls *bed|sed s/.bed//`;do 
	choice_CNS4maf.py $i.bed ../maf/$i.maf > $i.bed.loc ;
done 
cd ..
cat $DIR/loc/*.loc > $DIR/all.loc
cat $DIR/loc/*.bed > $DIR/all.bed
rm -rf muscle
mkdir muscle
cd muscle
cp ../all.bed .
getsubbed.py ../all.loc all.bed Metru
for i in `ls all.bed.* `;do 
	bedsortmerge.sh $i ../../../all.fa 
done 
super_CNE.py ../sp.list 'ls *.muscle' > ../$R.phy
cd ..
PhyML -i $R.phy
alter_tree.pl $R.phy_phyml_tree.txt --taxon Medicago_truncatula > $R.phy_phyml_tree.txt.root
draw_tree.pl $R.phy_phyml_tree.txt.root > $R.phy_phyml_tree.txt.root.svg
cd ..

mkdir annotate
cd annotate
cp ../all.loc .
getque4mref.py all.loc
for i in `ls $DIR/annotate/*bed`;do
	sortBed -i $i > $i.sorted
	mergeBed -i $i.sorted -d 5 > $i.sorted.merged.bed
	annotation_cns.py ../Medicago_truncatula.gff $i.sorted.merged.bed > $i.sorted.merged.gff;
	cns_stat.sh $i.sorted.merged.gff > $i.sorted.merged.gff.xls;
done
