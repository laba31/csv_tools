#!/usr/bin/perl -w

#Author: Ladislav Babjak
#VERSION: 1.0

use CsvMod;
use Getopt::Std;
getopts('hd:f:');


my $delimiter = ';';


sub help() {
    print << "END_HELP";

    Usage $0 [OPTION]... [filename.csv]
Without last parameter filename script read standard input

        -h      print this help message
        -d      set other then default delimiter ';' for .csv file
        -f      which of the columns will be displayed
                1-3 or 1:3 are same for range of values
                4,2,8 columns for selection
                id,name,age columns for selection by name

Some examples:

$0 -d ',' -f 1-5
$0 -f 2,3,5
$0 -d '\t' -f 1:3
$0 -f id,name,age

END_HELP
}



if($opt_h) {
        &help();
        exit 0;
}

if($opt_d) {
        $delimiter=$opt_d;
}


