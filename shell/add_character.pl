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
#FabRhi.nonnfix.i.OAct.i.outgroup.i.fun.xls
my $file = shift;
my @sps = qw(FabRhi nonnfix OAct outgroup);
my @id = split /\./,$1 if $file=~/([^\/]+)$/;
my %present;
my %tmp;
$tmp{"FabRhi"} = "R";
$tmp{"nonnfix"} = "N";
$tmp{"OAct"} = "A";
$tmp{"outgroup"} = "O";
$present{$id[0]} = $tmp{$id[0]};

$present{$id[1]} = $id[2] eq 'i' ? $tmp{$id[1]} : lc($tmp{$id[1]});
$present{$id[3]} = $id[4] eq 'i' ? $tmp{$id[3]} : lc($tmp{$id[3]});
$present{$id[5]} = $id[6] eq 'i' ? $tmp{$id[5]} : lc($tmp{$id[5]});
my $note = "$present{$sps[0]}$present{$sps[2]}$present{$sps[1]}$present{$sps[3]}";
open IN,$file;
open OUT,">$note.gff";
while (<IN>){
	chomp;
	say OUT "$_\t$note";
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
