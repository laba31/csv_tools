#!/usr/bin/perl -w

use Getopt::Std;
getopts('hd:');


my $delimiter = ';';


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



##### Main

if($opt_h) {
    &help();
    exit 0;
}

if($opt_d) {
    $delimiter = $opt_d;
}


