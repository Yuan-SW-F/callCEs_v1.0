#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2021-01-07 15:14:26
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
while (<IN>){
	if (/Clade=(\w+)/){
		my @line = split;
		my $bed = "$line[0]\t";
		$bed .= $line[3]-1;
		$bed .= "\t$line[4]";
		`echo $bed >> $1.bed`;
	}
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
