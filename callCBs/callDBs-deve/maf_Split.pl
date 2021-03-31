#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2021-03-09 14:41:19
    Example: maf_Split.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

my %loc;
open IN,shift;
while (<IN>){
	$loc{$1} = $2 if /\S+\s+(\S+)\s+(\S+)/;
}

my $file = shift;
open IN,"less $file | grep -v \\# | grep -v \"^a\"|";
$/ = "\n\n";
say "##maf version=1 scoring=maf_project.v12
##maf_Split abyss";
while (<IN>){
	my @lines = split /\n/, $_;
	chomp $lines[0];
	my @line_head = split /\s+/, $lines[0];
	my $i = 0;
	my $j = 0;
	if (exists $loc{$line_head[2]}){
		say "a score=1000";
		for (split //, $line_head[-1]){
			$i ++ if $_=~ /[ATCGatcgNn]/;
			$j ++;
			last if $i == $loc{$line_head[2]} - $line_head[2];
		}
		for (@lines){
			chomp;
			my @line = split /\s+/, $_;
			my $seq = substr($line[-1], 0, $j);
			my $len = $seq;
			$len =~ s/[^ATCGatcgNn]//g;
			$len = length($len);
			/(\S+\s+\S+\s+\S+)\s+\S+\s+(\S+\s+\S+)/;
			say "$1 $len $2 $seq";
		}
		say "";
	}
}
say "##eof maf";

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
