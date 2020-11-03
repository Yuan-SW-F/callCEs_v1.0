me: Step2.1.class_callCS.sh
# Author  : fuyuan, 907569282@qq.com
# Created Time: 2020-03-23 00:40:01
source ~/.bashrc

###
mkdir 01.forbed
cd 01.forbed
perl -ne '/(\S+)/;open O, ">$1.bed" if ! exists $hash{$1}; $hash{$1} = 1; print O $_;' ../MtCNE.bed
for i in `ls *.bed`;do cns.sh $i;done
cd ..

###
mkdir 02.locandbed
cd 02.locandbed
for i in `ls ../01.forbed/ | grep CNS | sed s/.bed-CNS//`;do
	grep $i ../MtCNE.bed > $i.bed;
	cp ../01.forbed/$i.bed-CNS/all.loc $i.loc;
        grep $i $i.loc > $i.loc.bed
done
cd ..

###
mkdir 03.idbed
cd 03.idbed
for i in `ls ../01.forbed/ | grep CNS | sed s/.bed-CNS//`;do
	perl ../getbed.pl $i
done
forspcne.sh
for i in `ls */*/*sh `;do
	echo $i | perl -ne ‘/(\S+)\/(\w+.sh)/; print “cd $1; sh $2; cd -”’ | sh
done
mkdir ../04.species_bed/
for i in `ls M*bed/*/bed/*bed`;do
        echo $i | perl -ne 'chomp; /\-(\w+.bed)/; print "cat $_ >> ../04.species_bed/$1\n"' |sh
done

###
cd ../04.species_bed
mkdir -P ../05.PAV_CNE/00.uniq/
for i in `ls *bed`;do echo "sort $i | uniq > ../05.PAV_CNE/00.uniq/$i & "; done
cd ../05.PAV_CNE
ln -s ../ 04.species_bed 01.CNE
PAV_CNS.pl | sed -d1 > CNS.pav
Rscript FETpav.R CNS.pav CNS.pav.FET.xls

