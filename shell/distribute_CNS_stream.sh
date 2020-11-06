#!/bin/bash
# File Name: stream.sh
# Author  : Yuan-SW-F, yuanswf@163.com
# Created Time: 2020-03-06 10:59:20
source ~/.bashrc

#for i in `seq 10`;do 

for i in {0..50};do
#for i in -50000 -45000 -40000 -35000  -30000 -25000  -20000 -15000 -10000 -5000; do	 
#for i in -10000 -9000 -8000 -7000  -6000 -5000  -4000 -3000 -2000 -1000; do
#	echo -ne "$i\t\n"i
	echo $i | perl -ne 'print -50000+$1*1000 if /(\S+)/; print "\t"'
	#echo -ne "$i\t"
	#echo "awk '{if (\$10 < -50000+$i*1000+1000 && \$10>=-50000+$i*1000){print }}' $1"
	echo "awk '{if (\$10 < -50000+$i*1000+1000 && \$10>=-50000+$i*1000){print }}' $1" | sh |  awk '{i+=$5-$4+1;j++}END{print j"\t"i}'
#	echo "awk '{if (\$10 < $i+5000 && \$10>=$i){print }}' $1" | sh |  awk '{i+=$5-$4+1;j++}END{print j"\t"i}'

#	awk '{if ($8 < 0 && $8>=$i){ptint }}' $1 | awk '{j+=$3-$2}END{print j}'
done 
#grep Upstream $1.dis.xls
#grep -P "5'UTR" $1.dis.xls
#grep CDS $1.dis.xls
#grep Intronic $1.dis.xls
#grep -P "3'UTR" $1.dis.xls
#grep Downstream $1.dis.xls


for i in {1..50};do
	echo $i | perl -ne 'print $1*1000 if /(\S+)/; print "\t"'
	echo "awk '{if (\$10 > $i*1000-1000 && \$10<=$i*1000){print }}' $1" | sh |  awk '{i+=$5-$4+1;j++}END{print j"\t"i}'

#for i in 5000 10000 15000 20000 25000  30000 35000  40000 45000 50000;do

#for i in 1000 2000 3000 4000 5000  6000 7000  8000 9000 10000;do
#	echo -ne "$i\t\n"
#	echo -ne "$i\t"
#	echo "awk '{if (\$10 > $i-5000 && \$10<=$i){print }}' $1" | sh |  awk '{i+=$5-$4+1;j++}END{print j"\t"i}'

	#awk '{if ($8 > 0 && $8<=$i){ptint }}' $1 | awk '{j+=$3-$2}END{print j}'
done
