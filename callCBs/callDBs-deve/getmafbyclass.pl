#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2019-09-20 17:51:38
    Example: getmafbyclass.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

my $in = shift;
my $dir = $1 if $in =~ /(\w+)/;
open IN,$in;
my %hash;
while (<IN>){
	/(\S+)/;
	next if $1 eq "Medicago_truncatula";
	$hash{$1} = 1;
	}

mkdir "$dir";
for my $i (split /\s+/,`ls /vol3/asbc/CHENGSHIFENG_GROUP/fuyuan/02.Nfix/00.81species_CNE/05.CNE/01.class/88maf/*maf`){
	my $file = $1 if $i =~ /([^\/]+)$/;
	open IN,$i;
	print "$dir/$file";
	open OUT,">$dir/$file";
#	my $head = <IN>;
#	print OUT $head;
#	$/="\n\n";
	while (<IN>){
		if (/^#/){
			print OUT $_;
			next;
		}
		$/="\n\n";
		my $check = 0;
		my @lines = split /\n/, $_;
		print $_ if @lines < 2;
		my $seq = "$lines[0]\n";
		$seq .= "$lines[1]\n";
		for (@lines){
			my $line = $_;
			if (/^s\s+([^\.]+)\./){
				$check += 1 if exists $hash{$1};
				$seq .= "$line\n" if exists $hash{$1};
			}
		}
		print OUT "$seq\n" if $check > 0;
	}
#	print OUT "##eof maf\n";
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
