#!/bin/bash
# File Name: stat.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2019-05-06 15:08:16
source ~/.bashrc
echo CNS stat of $1
echo -ne "mRNA\t"
cut -f 4 $1 | grep mRNA |tee $1.mRNA | wc -l
echo -ne "CDS\t"
less $1.mRNA | grep CDS |wc -l
echo -ne "three_prime_UTR\t"
less $1.mRNA | grep three_prime_UTR | grep -v "CDS" | wc -l
echo -ne "five_prime_UTR\t"
less $1.mRNA | grep five_prime_UTR | grep -v "CDS\|three_prime_UTR" | wc -l
echo -ne "intron\t"
less $1.mRNA | grep intron | grep -v "CDS\|five_prime_UTR\|three_prime_UTR" |wc -l 

echo -ne "Others\t"
less $1.mRNA | grep -v "CDS\|five_prime_UTR\|three_prime_UTR\|intron" |wc -l

cut -f 4 $1 | grep -v mRNA > $1.nomRNA
echo -ne "distal\t"
less $1.nomRNA | grep  distal |wc -l
echo -ne "upstream\t"
less $1.nomRNA | grep upstream |grep -v "CDS\|intron\|distal\|three_prime_UTR\|five_prime_UTR" | wc -l
echo -ne "downstream\t"
less $1.nomRNA | grep downstream | grep -v "CDS\|intron\|distal\|three_prime_UTR\|five_prime_UTR\|upstream" | wc -l
