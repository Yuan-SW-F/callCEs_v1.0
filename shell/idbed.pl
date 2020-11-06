#!/usr/bin/perl -w
=head1 Info
    Script Author  : Yuan-SW-F, yuanswf@163.com
    Created Time   : 2020-04-30 02:37:19
    Example: ../../perl.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
        "help!"=>\&USAGE,)
or USAGE();

#head -n 1 tmp/Thcac.sorted.bed | cut -f 4-6 > tmp/add
#perl -ne 'chomp; @l = split /\t/; $n = `head -n 1 tmp/add`; print join "\t", @l, $n;' tmp/Thcac.sorted.merged.bed >> bed/MtrunA17MT_Metru.addid.bed-Thcac.bed
my $chr=shift;
my $sp = shift;
my $add = `head -n 1 tmp/$sp.sorted.bed | cut -f 4-6`;
open IN,"tmp/$sp.sorted.merged.bed";
open OUT,">>bed/$chr-$sp.bed";
while (<IN>){
        chomp;
        print OUT "$_\t$add";
}
close;
######################### Sub Routines #########################
sub USAGE{
my $uhead=`pod2text $0`;
my $usage=<<"USAGE";
USAGE:
        perl $0
        --help  output help information to screen
USAGE
print $uhead.$usage;
exit;}
