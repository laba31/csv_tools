#!/usr/bin/env perl

use Getopt::Std;
getopts('hd:');

my $line = undef;
my $delimiter = ';';

sub help() {
        print "\nUsage $0 [OPTION]... [filename.csv]\n";
        print "Without last parameter filename script read standard input\n\n";
        print "\t-h\tprint this help message\n";
        print "\t-d\tset other then default delimiter ';' for .csv file\n\n";
        print "Some examples:\n";
        print "csv_columns.pl -d '\|' test_pipe.csv\n";
        print "csv_columns.pl -d '\t' test_tab.csv\n";
        print "csv_columns.pl < file.csv\n\n";
}


if($opt_h) {
        &help();
        exit 0;
}

if($opt_d) {
        $delimiter=$opt_d;
}

if(@ARGV == 1) {
        open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
        $line=<FD>;
}
else {
        $line=<>;
}


chomp($line);
my @items = split(/$delimiter/, $line);

my $num = 1;
foreach $col (@items) {
        print "$num\t$col\n";
        $num++;
}

