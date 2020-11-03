#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2019-11-26 16:02:32
    Example: /public/home/fuyuan/bin/CNE_distance_ud.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my $cut ||= 100;
my $max ||= 500;

my ($help);
GetOptions(
	"max:i" =>\$max,
	"help!"=>\&USAGE,)
or USAGE();

my $file = shift;
my %hash;

open IN,$file;
open OUT, "> $file.xls";
while (<IN>){
	chomp;
	my @line = split /\t/;
	$line[-1] = $line[-2];
	$line[-1] = 0 if $line[-1] =~ /intergenic/;
	my $num = int(($line[-1]-1)/$cut + 1);
	if ($line[-1] < 0){
		$num = int(($line[-1]+1)/$cut - 1);
	}
	if (-$max <= $num && $num <= $max){
		$hash{$num*$cut} += 1;
	}else{
		if ($num > 0){
			$hash{($max+1)*$cut} += 1;
		}else{
			$hash{(-$max-1)*$cut} += 1;
		}
	}
}

for (-$max..$max){
	$hash{$_*$cut} = 0 if ! exists $hash{$_*$cut};
	print OUT $_*$cut."\t".$hash{$_*$cut}."\n";
}
close OUT;
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
