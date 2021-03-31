#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2021-03-29 15:33:29
    Example: sym.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

my %hash;
open IN,"Sym.ID.list";
<IN>;
while (<IN>){
	$hash{$1} = $2 if /(\S+)\s+(\S+)/;
}

open IN,"Medicago_CNE_V1.0.gff3";
my $head = <IN>;
chomp $head;
print "$head\tSymbiosisGene\n";
print STDERR "$head\tSymbiosisGene\n";

while (<IN>){
	my $sym = "";
	my $check = 0;
	if (/gene=([^;]+)/){
		$sym = exists $hash{$1} ? $hash{$1} : "NA";
		$sym .= ";";
		$check = 1 if exists $hash{$1};
	}
	if (/rev_gene=([^;]+)/){
		$sym .= exists $hash{$1} ? $hash{$1} : "NA";
		$sym .= ";";
		$check = 1 if exists $hash{$1};
	}
	chomp;
	say $_ . "\t" . $sym;
	say STDERR $_ . "\t" . $sym if $check;
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
