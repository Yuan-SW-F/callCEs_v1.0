#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2021-02-03 15:28:30
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
my %hash;
while (<IN>){
	my @line = split /\s+/;
	$hash{"$line[0].$line[3].$line[4]"} = $line[8];
}

open IN,shift;
my $head = <IN>;
print $head;
while (<IN>){
	my $line = $_;
	my @line = split /\s+/;
	if (exists $hash{"$line[0].$line[3].$line[4]"}){
		my @alt = split /ID=/, $hash{"$line[0].$line[3].$line[4]"};
		my $gene = $1 if $line =~ /gene=([^\;]+)/;
		my $alt = "";
		for (@alt){
			$alt = $_ if $_ ne $gene;
		}
		$line =~ s/gene=([^\;]+)/gene=$gene;rev_gene=$alt/;
		#print "Malt[0]\t$alt[1]\t$alt[2]\n";
	}
	print $line;

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
