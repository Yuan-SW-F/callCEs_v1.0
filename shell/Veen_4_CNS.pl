#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2019-10-16 16:53:57
    Example: perl.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

my @files = qw(FabRhi.CNE.d3l5  nonnfix.CNE.d3l5  OAct.CNE.d3l5  outgroup.CNE.d3l5 FabRhi.CNE.d3l5);
#my @files = qw(fabales.CNE.d3l5 rosales.CNE.d3l5 fagales.CNE.d3l5 cucurbitales.CNE.d3l5 outgroup.CNE.d3l5 fabales.CNE.d3l5);
#cucurbitales.CNE.d3l5 fabales.CNE.d3l5 fagales.CNE.d3l5 nfix.CNE.d3l5 nfn.CNE.d3l5 nonnfix.CNE.d3l5 outgroup.CNE.d3l5 rosales.CNE.d3l5
#nfix.cons.bed.CNE.d3l5.bed nonnfix.cons.bed.CNE.d3l5.bed nfn.cons.bed.CNE.d3l5.bed);

my %hash;
for (@files){
	/(\w+)/;
	$hash{$_} = $1;
}

for my $n (1..4){
`bedtools intersect -a $files[$n-1] -b $files[$n] > $hash{$files[$n-1]}.$hash{$files[$n]}.i`;
`bedtools subtract -a $files[$n-1] -b $files[$n] > $hash{$files[$n-1]}.$hash{$files[$n]}.s`;


for my $i (0..3){
	next if $i == $n;
	next if $i == $n-1;
	next if ($i == 0 && $n == 4);
	for my $j(`ls *i *s`){
		print $j;
		chomp $j;
		`bedtools intersect -a $j -b $files[$i] > $j.$hash{$files[$i]}.i`;
		`bedtools subtract -a $j -b $files[$i] > $j.$hash{$files[$i]}.s`;
		`rm $j`;
	}
}
`mkdir stat`;
`mv *i *s stat`;
}
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
