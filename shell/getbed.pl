#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2020-03-14 11:51:31
    Example: getbed.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

my $chr = shift;
open IN,"bedtools intersect -a $chr.bed -b $chr.loc.bed|";
my %hash;
while (<IN>){
	chomp;
	my @line = split /\t/;
	my $id = $line[3];
	$hash{$line[0]}{$line[1]}{$line[2]} = $line[3];
}

open IN,"$chr.loc";
my $id = "";
while (<IN>){
	chomp;
	my @line = split /\t/;
	if ($line[0] eq $chr){
		$id = $hash{$line[0]}{$line[1]}{$line[2]};
	}
	$line[3] = $id;
	say join "\t",@line;
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
