#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2021-03-08 14:22:17
    Example: check_len_CNE.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

my %cne;
open IN,"../Medicago.latest_CNE.bed";
while (<IN>){
	chomp;
	my @line = split;
	$cne{$line[-1]} = $line[2] - $line[1];
}

open IN,shift;
my $cut = shift;
$cut ||= 0.5;
while (<IN>){
	chomp;
	my @line = split;
	say STDERR $_ if ! exists $cne{$line[7]};
	say $_ if ($line[4] - $line[3] + 1) / $cne{$line[7]} >= $cut;
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
