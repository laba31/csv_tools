#!/usr/bin/env perl

use strict;
use CsvMod;
use Getopt::Std;
getopts('hbr:f:');


sub help() {
    print << "END_OF_HELP";

Usage $0 -r 'perl_regexp' -f which_columns [filename.csv]
Without last parameter filename.csv script read standard input.

    -h  print this help message
    -b  copy original file with sufix .bkp

Some examples:

$0 -r '/YES/NO/' -f 1       string NO replacing string YES in column 1
$0 -r '/YES/NO/' -f 2,4,6   string NO replacing string YES in columns 2, 4 and 6
$0 -r '/YES/NO/' -f 2:6     string NO replacing string YES from column 2 to column 6
$0 -r '/YES/NO/' -f 2-6     same as previous example

$0 -r '/.*//' -f 1          delete value in whole column 1
$0 -r '/^.*$/YES/' -f 1     everything setting on YES, including empty value

END_OF_HELP
}


if($::opt_h) {
    &help();
    exit 0;
}

if((! $::opt_f) and (! $::opt_r)) {
    &help();
    exit 0;
}

