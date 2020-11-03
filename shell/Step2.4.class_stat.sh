#!/bin/bash
# File Name: cmd.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2020-02-18 11:35:17
source ~/.bashrc


cat ../01.annotate/$1/*CNS > $1.CNS
cat ../01.annotate/$1/*CNE > $1.CNE

cat ../01.annotate/$1/*.genes > $1.genes
cat ../01.annotate/$1/*.stream > $1.stream
cat ../01.annotate/$1/*.downstream > $1.downstream
cat ../01.annotate/$1/*.upstream > $1.upstream


grep five_prime_UTR Medicago_truncatula.gff > five_prime_UTR.gff
grep three_prime_UTR Medicago_truncatula.gff > three_prime_UTR.gff
grep -P "\tCDS\t" Medicago_truncatula.gff > Medicago_truncatula.gff.cds
grep -P "\tmRNA\t" Medicago_truncatula.gff > Medicago_truncatula.gff.mRNA
bi -a $1*CNE -b Medicago_truncatula.gff.mRNA > Medicago_truncatula.gff.mRNA-CNE.bed
sortBed -i Medicago_truncatula.gff.mRNA-CNE.bed > Medicago_truncatula.gff.mRNA-CNE.bed-
mergeBed -i Medicago_truncatula.gff.mRNA-CNE.bed- > Medicago_truncatula.gff.mRNA-CNE.bed.tmp
mv Medicago_truncatula.gff.mRNA-CNE.bed.tmp Medicago_truncatula.gff.mRNA-CNE.bed
bs -a Medicago_truncatula.gff.mRNA-CNE.bed -b five_prime_UTR.gff > Medicago_truncatula.gff.mRNA-CNE.bed.tmp
bs -a Medicago_truncatula.gff.mRNA-CNE.bed.tmp -b three_prime_UTR.gff > Medicago_truncatula.gff.mRNA-CNE.bed
mergeBed -i Medicago_truncatula.gff.mRNA-CNE.bed > Medicago_truncatula.gff.mRNA-CNE.intron
rm Medicago_truncatula.gff.mRNA-CNE.bed*

echo -ne "CNS\t"
cat $1*CNS | awk '{i+=1;j += $3-$2}END{print i"\t"j}'

echo -ne "CDS\t";
bi -a $1*CNS -b Medicago_truncatula.gff.cds > CDS.bed
sortBed -i CDS.bed > CDS.bed-
mergeBed -i CDS.bed- | awk '{i+=1;j += $3-$2}END{print i"\t"j}'
rm CDS.bed*
echo -ne "Nocoding DNA\t"
cat $1.CNE | awk '{i+=1;j += $3-$2}END{print i"\t"j}'

echo -ne "Distal\t"
cat $1*.stream |awk '{if ($9 > 50000){print }}' |awk '{i+=1;j += $3-$2}END{print i"\t"j}'
echo -ne "Upstream (50kb)\t"
cat $1*.stream | grep UPSTREAM |awk '{if ($9 <= 50000){print }}' |awk '{i+=1;j += $3-$2}END{print i"\t"j}'

echo -ne "5'UTR\t"
bi -a $1*.CNS -b five_prime_UTR.gff > 5.bed
sortBed -i 5.bed > 5.bed-
mergeBed -i 5.bed- | awk '{i+=1;j += $3-$2}END{print i"\t"j}'
rm 5.bed*
echo -ne "Intronic\t"
cat Medicago_truncatula.gff.mRNA-CNE.intron | awk '{i+=1;j += $3-$2}END{print i"\t"j}'
echo -ne "3'UTR\t"
bi -a $1*.CNS -b three_prime_UTR.gff > 3.bed
sortBed -i 3.bed > 3.bed-
mergeBed -i 3.bed- | awk '{i+=1;j += $3-$2}END{print i"\t"j}'
rm 3.bed*
echo -ne "Downstream (50kb)\t"
cat $1*.stream | grep DOWNSTREAM |awk '{if ($9 <= 50000){print }}' |awk '{i+=1;j += $3-$2}END{print i"\t"j}'

