#!/usr/bin/env perl

use strict;
use CsvMod;
use Getopt::Std;
getopts('hbr:f:');


# my favorit delimiter
my $delimiter = ';';
# head of csv file
my @head = undef;
my $line = undef;
my @columns = undef;
my $work_file = undef;


sub help() {
    print << "END_OF_HELP";

Usage $0 -r 'perl_regexp' -f which_columns [-b] filename.csv

    -h  print this help message
    -b  copy original file with sufix .bkp
    -d  set other then default delimiter ';' for .csv file

Some examples:

$0 -r '/YES/NO/' -f 1       string NO replacing string YES in column 1
$0 -r '/YES/NO/' -f 2,4,6   string NO replacing string YES in columns 2, 4 and 6
$0 -r '/YES/NO/' -f 2:6     string NO replacing string YES from column 2 to column 6
$0 -r '/YES/NO/' -f 2-6     same as previous example

$0 -r '/.*//' -f 1          delete value in whole column 1
$0 -r '/^.*\$/YES/' -f 1     everything setting on YES, including empty value

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

if($::opt_d) {
        $delimiter=$::opt_d;
}


if(@ARGV == 1) {
    open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
    $work_file = $ARGV[0] . ".tmp";
    open(WD, '>', $work_file) or die "I can not create file $work_file\n";
}
else {
    print "Missing parameter filename.csv\n";
    exit 1;
}

# first line = head
$line=<FD>;
# write head to new file without changes
print WD $line;
@head = &parse_line($delimiter, $line);
@columns = &which_columns($::opt_f, \@head);

if((&check_range(\@columns, \@head)) == -1) {
    print "Range of choice fields is wrong.\n";
    exit 1;
}


my $regexp = "s" . $::opt_r . "g";

while($line=<FD>) {
    my @full_list = &parse_line($delimiter, $line);
    foreach my $item (@columns) {
        my $run_string = '$full_list[$item] =~ ' . $regexp . ';';
        eval $run_string;
        if($@) {
            print "Bad regular expression!\n";
            print $@;
            exit 1;
        }
    }
    my $new_line = join($delimiter, @full_list) . "\n";
    print WD $new_line;
}


close(FD);
close(WD);

# backup original file
if($::opt_b) {
    my $bkp_file = $ARGV[0] . ".bkp";
    rename $ARGV[0], $bkp_file or die "I can not rename file $ARGV[0] to $bkp_file\n";
}

# rename temporary file to original
rename $work_file, $ARGV[0] or die "I can not rename file $work_file to $ARGV[0]\n";

