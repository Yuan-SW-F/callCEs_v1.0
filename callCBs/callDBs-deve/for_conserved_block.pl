#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2021-03-08 15:39:42
    Example: for_conserved_block.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

open IN,"Medicago.latest_CNE.bed";
my %cne;
while (<IN>){
	chomp;
	my @line = split;
	$cne{$line[0]."_".$line[1]."_".$line[2]} = $_;
#	$cne{$1} = $_ if /(\S+)$/;
}

open IN,"88.sp.list";
#my @class = qw(Rhizobia Actinomycetes NA Outgroup);
my @class = qw(Nodulators Non-nodulators Outgroup);
my %clade;
while (<IN>){
	chomp;
	my @line = split;
	$clade{$line[0]} = "Nodulators" if $line[4] eq "Rhizobia";
	$clade{$line[0]} = "Nodulators" if $line[4] eq "Actinomycetes";
	$clade{$line[0]} = "Non-nodulators" if $line[4] eq "NA";
	$clade{$line[0]} = "Outgroup" if $line[4] eq "Outgroup";
}

open IN,"less maf/*maf | grep -v \\# | grep -v \"^a\"|";
$/ = "\n\n";
my (@lines, @line);
my %sp;
while (<IN>){
	my @lines = split /\n/, $_;
	my $id;
	if ($lines[0] =~ /Medicago_truncatula.(\S+)/){
		$id = $1 . "_";
		chomp $lines[0];
		my @line = split /\s+/, $lines[0];
		$id .= $line[2] . "_";
		$id .= $line[2] + $line[3];
		if (exists $cne{$id}){
			$sp{$id}{"Nodulators"} = 1;
			for (@lines[1..$#lines]){
				my @line = split /\s+/;
				next if @line < 3;
				my $clade = "";
				if ($line[1] =~ /(\w+)\./){
					say $1 if ! exists $clade{$1};
					$clade = $clade{$1};
				}
				$sp{$id}{$clade} += 1 ;
			}
		}
	
		if (exists $cne{$id}){
			print "$cne{$id}";
			for (@class){
				if (exists $sp{$id}{$_}){
					print "\t" . $sp{$id}{$_};
				}else{
					print "\t0";
				}
			}
			print "\n";
			delete $cne{$id};
		}
	}
}

for (keys %cne){
	say STDERR "$cne{$_}";
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
