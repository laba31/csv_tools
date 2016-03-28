#!/usr/bin/env perl

#Author: Ladislav Babjak
#VERSION: 1.0

use strict;
use CsvMod;
use Getopt::Std;
getopts('hd:f:n:r:i');


# my favorit delimiter
my $delimiter = ';';
my $new_delimiter = ';';
# head of csv file
my @head = undef;
my $line = undef;
my @columns = undef;
my $case_sensitive = -1;


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
        -n      delimiter for output, usefull for conversion format
        -r      name of columns as regexp
        -i      ignore case sensitive, It makes sense only using with the parameter -r

Some examples:

$0 -d ',' -f 1-5
$0 -f 2,3,5
$0 -d '\\t' -f 1:3
$0 -d '\\t' -n ':' -f 1:3
$0 -f id,name,age
$0 -r name,date,address -i

END_HELP
}




if($::opt_h) {
    &help();
    exit 0;
}

if((! $::opt_f) and (! $::opt_r)) {
    &help();
    exit 0;
}

if($::opt_f and $::opt_r) {
    &help();
    exit 0;
}

if($::opt_i and (! $::opt_r)) {
    print "parameter -i makes sense only using with parameter -r\n";
    exit 0;
}

if($::opt_d) {
    if($::opt_d eq "\\t") {
        $new_delimiter = $delimiter = "\t";
    }
    else {
        $new_delimiter = $delimiter = $::opt_d;
    }
}

if($::opt_n) {
    if($::opt_n eq "\\t") {
        $new_delimiter = "\t";
    }
    else {
        $new_delimiter = $::opt_n;
    }
}

if($::opt_i) {
    $case_sensitive = 1;
}


if(@ARGV == 1) {
    open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
}
else {
    open(FD, "-") or die "I can not open STDIN\n";
}

$line=<FD>;

@head = &parse_line($delimiter, $line);
if($::opt_f) {
    @columns = &which_columns($::opt_f, \@head);
}
else {
    @columns = &which_columns_regexp($::opt_r, \@head, $case_sensitive);
}

if((&check_range(\@columns, \@head)) == -1) {
    print "Range of choice fields is wrong.\n";
    exit 1;
}

my @tmp_list = ();
foreach my $item (@columns) {
    push(@tmp_list, $head[$item]);
}

print join($new_delimiter, @tmp_list) . "\n";

@tmp_list = ();
while($line=<FD>) {
    my @full_list = &parse_line($delimiter, $line);
    foreach my $item (@columns) {
        push(@tmp_list, $full_list[$item]);
    }
    print join($new_delimiter, @tmp_list) . "\n";
    @tmp_list = ();
}

close(FD);

