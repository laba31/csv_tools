#!/usr/bin/perl -w

#Author: Ladislav Babjak
#VERSION: 1.0

use CsvMod;
use Getopt::Std;
getopts('hd:');


my $delimiter = ';';
my $check_empty_column = undef;
my $check_white_chars = undef;
my $line = undef;
my @head = undef;


sub help() {
    print << 'END_OF_HELP';

Usage $0 [OPTION]... [filename.csv]
Without last parameter filename script read standard input

    -h      print this help message
    -d      set other then default delimiter ';' for .csv file
    -e  print warning message when column is empty
    -w  print warning message when column include only white characters

END_OF_HELP
}



if($opt_h) {
    &help();
    exit 0;
}

if($opt_d) {
    $delimiter = $opt_d;
}

if($opt_e) {
    $check_empty_column = 1;
}

if($opt_w) {
    $check_white_chars = 1;
}


if(@ARGV == 1) {
    open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
}
else {
    open(FD, "-") or die "I can not open STDIN\n";
}


$line=<FD>;
@head = &parse_line($delimiter, $line);

