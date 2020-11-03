#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2020-02-20 19:25:45
    Example: perl.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

my $class = shift;
open IN,"gene_function.lst";
my %fun;
while (<IN>){
	chomp;
	/(\S+)\s+(.*)/;
	$fun{$1} = $2;
}

open IN,"cat $class.stream|";
open O,">$class.fun";
while (<IN>){
	chomp;
	s/mRNA://;
	my @line = split /\t/;
	$line[-1] = exists $fun{$line[4]} ? $fun{$line[4]} : "NA";
	say O join "\t",@line;
}
`bedtools intersect -a $class.genes -b ../five_prime_UTR.gff |sed s/intron/five_prime_UTR/ > 5.bed`;
`bedtools intersect -a ../five_prime_UTR.gff -b $class.genes > 5g.bed`;

`bedtools intersect -a $class.genes -b ../three_prime_UTR.gff | sed s/intron/three_prime_UTR/ > 3.bed`;
`bedtools subtract -a $class.genes -b ../five_prime_UTR.gff > 5s.bed`;
`bedtools subtract -a 5s.bed -b ../three_prime_UTR.gff > 3s.bed`;

`bedtools intersect -a ../three_prime_UTR.gff -b $class.genes > 3g.bed`;
`cat 5.bed 3.bed > 53.bed`;
`cat 5g.bed 3g.bed > 53g.bed`;
`sortBed -i 53.bed > 53.bed.s`;
`sortBed -i 53g.bed > 53g.bed.s`;
`paste 53.bed.s 53g.bed.s | perl -ne \'\@l=split /\\t/; \$l[4]=\$1 if /Parent=([^\\s\\;]+)/;print join \"\\t\", \@l[0..8];print \"\n\"\' > 53c.bed `;

open IN,"cat 53c.bed 3s.bed |";
open O,">>$class.fun";
while (<IN>){
	chomp;
	s/mRNA://;
	my @line = split /\t/;
	$line[-2]=$1 if $line[-1] =~ /(-?\d+)/;
#	$line[4] =$1 if $line[]
	$line[-1] = exists $fun{$line[4]} ? $fun{$line[4]} : "NA";
	say O join "\t",@line;
}

close O;
`sortBed -i $class.fun | awk \'{if (\$3-\$2>=5){print}}\' > $class.fun.xls`;
######################### Sub Routines #########################
sub USAGE{
my $uhead=`pod2text $0`;
my $usage=<<"USAGE";
USAGE:
	perl $0
	--help	output help information to screen
USAGE
print $uhead.$usage;
exit;}
