#!/usr/bin/perl -w
=head1 Info
    Script Author  : Yuan-SW-F, yuanswf@163.com
    Created Time   : 2020-03-23 17:02:45
    Example: PAV_CNS.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

open IN,"01.CNE/Metru.bed";
my @cne;
while (<IN>){
	my @l =split /\t/;
	push @cne, $l[3];
}

open IN,"88.sp.list";
my %sp;
my %sim;
my @class = qw(Rhizobia Actinomycetes NA Outgroup);
my @sps;
while (<IN>){
	chomp;
	my @l = split /\t/;
	$sim{$l[1]} = $l[0];
	$sp{$l[-1]}{$l[1]} = 1;
	push @sps, $l[1];

}

print "CNEID";
for my $j (@class){
	for my $k (@sps){
	#	print "$j\t$k\t";
		if (exists $sp{$j}{$k}){
			print "\t$sim{$k}";
		}
	}
}
print "\n";
say join "\t", qw(Nodulators Non-nodulators Outgroup);
my %cn;
for my $i (`ls 01.CNE/*bed`){
	my $sp = $1 if $i =~ /(\w+).bed/;
	open IN,$i;
	while (<IN>){
		my @l =split /\t/;
		$cn{$sp}{$l[3]} = 1;
	}
}

for my $i (@cne){
	for my $j (@sps){
		$cn{$j}{$i} = 0 if ! exists $cn{$j}{$i};
	}
}

for my $i (@cne){
	print $i;
	my $n = 0;
	for my $j (@class[0,1]){
		for my $k (@sps){
	#		print "$j\t$k\t";
			if (exists $sp{$j}{$k}){
				$n += $cn{$k}{$i};
			}
		}
	}
	print "\t$n";
	$n = 0;
	for my $j (@class[2]){
		for my $k (@sps){
			if (exists $sp{$j}{$k}){
				$n += $cn{$k}{$i};
			}
		}
	}
	print "\t$n";
	$n = 0;
	for my $j (@class[3]){
		for my $k (@sps){
			if (exists $sp{$j}{$k}){
				$n += $cn{$k}{$i};
			}
		}
	}
	print "\t$n";

	print "\n";
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
