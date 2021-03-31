#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2020-05-05 23:58:23
    Example: stat.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

#MtrunA17Chr1_Metru      Abyss   intron  768928  768932  CNE029149       MtrunA17Chr1g0147041    +       768164  763     FAB_P;FAG_P;CUC_A;ROS_A;OUT_A;RAno      Putative aminoacyltransferase, E1 ubiquitin-activating enzyme

open IN,shift;
my (%check,%len,%gene,%count);
while (<IN>){
	my @line = split /\t/;
	$line[10] =~ /\;(\w+)$/;
	$len{$1} += $line[4] - $line[3] + 1;
	$count{$1} += 1;
	$gene{$1} += 1 if ! exists $check{$1}{$line[6]};
	$check{$1}{$line[6]} = 1;
}

say join "\t", qw(class CNE_number CNE_length Gene_number);
for (sort {$b cmp $a } keys %count){
	say join "\t", $_, $count{$_}, $len{$_}, $gene{$_};
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
