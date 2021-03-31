#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2020-02-24 18:49:08
    Example: perl.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

open IN,shift;
my $n = shift;
$n ||= 5000;
while (<IN>){
	chomp;
	my @line = split /\t/;
	$line[1] = $line[1] - $n < 1 ? 0 : $line[1] - $n;
	$line[2] = $line[2] + $n;
	say join "\t", @line;
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
