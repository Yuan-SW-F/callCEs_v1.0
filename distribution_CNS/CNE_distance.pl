#!/usr/bin/perl -w
=head1 Info
    Script Author  : Yuan-SW-F, yuanswf@163.com
    Created Time   : 2019-10-11 10:39:25
    Example: perl.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

my $stream = shift;
my $gene = shift;
my $gene_num = `wc -l $gene` if $gene;
$gene_num = $1 if $gene_num=~/(\d+)/;
$gene_num ||= 0;
open IN, $stream;
my %hash;
$hash{0} = $gene_num;
my $cut = 1000;
my $max = 21;
while (<IN>){
	chomp;
	my @line = split "\t", $_;
	my $num = int(1 + $line[-1]/$cut);
	if ($num < $max){
		$hash{$num*$cut} += 1;
	}else{
		$hash{$max*$cut} += 1;
	}
}
for (-$max..$max){
	$hash{$_*$cut} = 0 if ! exists $hash{$_*$cut};
	print $_*$cut."\t".$hash{$_*$cut}."\n";
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
