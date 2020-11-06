#!/usr/bin/perl -w
=head1 Info
    Script Author  : Yuan-SW-F, yuanswf@163.com
    Created Time   : 2020-03-10 17:00:40
    Example: add_clade.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

#Table3.5clade.cucurbitales.outgroup.s.fabales.i.rosales.s.fagales.i.fun.xls.xls
my $file = shift;
my @sps = qw(fabales fagales cucurbitales rosales outgroup);
my @id = split /\./,$1 if $file=~/([^\/]+)$/;
my %present;
$present{$id[0]} = "_P";
$present{$id[1]} = $id[2] eq 'i' ? "_P" : "_A";
$present{$id[3]} = $id[4] eq 'i' ? "_P" : "_A";
$present{$id[5]} = $id[6] eq 'i' ? "_P" : "_A";
$present{$id[7]} = $id[8] eq 'i' ? "_P" : "_A";
my $note = "FAB$present{$sps[0]};FAG$present{$sps[1]};CUC$present{$sps[2]};ROS$present{$sps[3]};OUT$present{$sps[4]}";
open IN,$file;
while (<IN>){
	chomp;
	say "$_\t$note";
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
