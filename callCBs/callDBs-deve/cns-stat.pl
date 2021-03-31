#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, 907569282@qq.com
    Created Time   : 2019-09-23 17:15:12
    Example: cns-stat.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
	"help!"=>\&USAGE,)
or USAGE();

my $dir = shift;
my %hash;
for (`ls $dir/*xls`){
	open IN,$_;
	<IN>;
	while (<IN>){
		/(\S+)\s+(\S+)/;
		if (exists $hash{$1}){
			$hash{$1} += $2;
		}else{
			$hash{$1} = $2;
		}
	}
}
my $head = "species";
my $stat = "$dir";
for (sort {$a cmp $b} keys %hash){
	$head .= "\t$_";
	$stat .= "\t$hash{$_}";
	}
say $head;
say $stat;
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
