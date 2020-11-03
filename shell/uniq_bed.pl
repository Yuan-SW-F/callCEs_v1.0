#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2020-03-31 11:20:59
    Example: uniq_bed.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

open IN,"MtCNE.gff.bed";
my %chr;
my %id;
my %start;
my %end;
my %gene;
my %ori;
while (<IN>){
	chomp;
	my @line = split /\t/;
	if (! exists $gene{$line[3]}){
		$chr{$line[3]}   = $line[0];
		$start{$line[3]} = $line[1];
		$end{$line[3]} = $line[2];
		$gene{$line[3]}  = $line[4];
		$ori{$line[3]}   = $line[5];
	}else{
		$start{$line[3]} = $line[1] if $line[1] < $start{$line[3]};
		$end{$line[3]}   = $line[2] if $line[2] > $end{$line[3]};
		$gene{$line[3]} .= ";".$line[4];
		$ori{$line[3]}  .= ";".$line[5];
	}
}
for (sort {$a cmp $b} keys %gene){
	say join "\t", $chr{$_}, $start{$_}, $end{$_}, $_, $gene{$_}, $ori{$_};
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
