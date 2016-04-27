#!/usr/bin/env perl
#Author: Ladislav Babjak
#VERSION: 1.0

# calling module from everywhere
BEGIN {
    $0 =~ m/(^.*\/)/;
    unshift @INC, $1;
}

use strict;
use CsvMod;
use Getopt::Std;
getopts('hd:ew');

# my favorit delimiter
my $delimiter = ';';
# variables for inspections
my $check_empty_column = undef;
my $check_white_chars = undef;
# for reading line from file
my $line = undef;
# header of csv file
my @head = undef;
# count of columns in header
my $num_head_columns = undef;
# detect error
my $err = 0;


sub help() {
    print << "END_OF_HELP";

Usage $0 [OPTION]... [filename.csv]
Without last parameter filename.csv script read standard input

    -h  print this help message
    -d  set other then default delimiter ';' for .csv file
    -e  print warning message when column is empty
    -w  print warning message when column include only white characters

END_OF_HELP
}



if($::opt_h) {
    &help();
    exit 0;
}

# set other then default(;) delimiter
if($::opt_d) {
    $delimiter = $::opt_d;
}

if($::opt_e) {
    $check_empty_column = 1;
}

if($::opt_w) {
    $check_white_chars = 1;
}


if(@ARGV == 1) {
    open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
}
else {
    open(FD, "-") or die "I can not open STDIN\n";
}

# first line = header
$line=<FD>;
# header in array
@head = &parse_line($delimiter, $line);
$num_head_columns = @head;

if($num_head_columns < 2) {
    print "CSV with less the 2 columns?\n";
    print "What's the point?\n";
    exit 1;
}


my $line_position = 2;

# main loop
while($line=<FD>) {
    my @line_items = &parse_line($delimiter, $line);
    my $num_line_columns = @line_items;

    # inspection of count of columns in row
    if($num_line_columns != $num_head_columns) {
        print "row $line_position has $num_line_columns columns and header has $num_head_columns columns\n";
        $err = 1;
    }

    # inspection of white character and empty value
    if($check_white_chars or $check_empty_column) {
        my $column = 1;
        foreach my $item (@line_items) {
            if($check_empty_column and (($item eq "") or ($item eq"\"\""))) {
                print "row $line_position column $column is empty\n";
                $err = 1;
            }
            elsif($check_white_chars and ($item =~ /^\s+$/)) {
                print "row $line_position column $column included only white characters\n";
                $err = 1;
            }
            $column++;
        }
    }

$line_position++;
}

# The grand finale
unless($err) {
    print "Everythins is OK. I hope, but I am not perfect.\n";
}

close(FD);
