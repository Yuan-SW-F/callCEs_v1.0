#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2020-05-18 09:16:36
    Example: for_DEG_CNE.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

open IN,shift;
<IN>;
my $head = <IN>;
my @head = split /\t/, $head;
my $i = 0;
for (@head){
	last if /Pathway/;
	$i++;
}
my @LFC = @head[5..$i-1];
while (<IN>){
	next if $_ !~ /\S/;
	my @line = split /\t/;
	my $lfc = "";
	for my $j (5..$i-1){
		$lfc .= "$head[$j];" if $line[$j] =~ /\d+/;
	}
	say join "\t", $line[1], $line[2] - 1, $line[3], $line[0], "$lfc", $line[4];
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
