#!/bin/bash
# File Name: Step2.1.class_callCS.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2019-09-23 00:40:01
source ~/.bashrc

perl getmafbyclass.pl $1.lst

N=`grep -v Medicago_truncatula $1.lst | wc -l`;
#N=`echo $N | perl -ne 'chomp; print $_'`;
cd $1 

for i in `ls *maf`; do 
	echo "source ~/.bashrc;callCEs.py $i $N 2 0.9 nump" > $i.sh
	QS 1 1 $i.sh
	#echo "nohup sh $i.sh &" > shell.sh
done 

#for i in cucurbitales fabales fagales nfix nfn nonnfix rosales; do echo "nohup sh Step2.1.class_callCS.sh $i & ";done

