#!/usr/bin/perl -w

#Author: Ladislav Babjak
#VERSION: 1.0

use CsvMod;
use Getopt::Std;
getopts('hd:f:n:');


# my favorit delimiter
my $delimiter = ';';
my $new_delimiter = ';';
# head of csv file
my @head = undef;
my $line = undef;
my @columns = undef;


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

Some examples:

$0 -d ',' -f 1-5
$0 -f 2,3,5
$0 -d '\t' -f 1:3
$0 -d '\t' -n ':' -f 1:3
$0 -f id,name,age

END_HELP
}


sub parse_line($$) {
    my($delimiter, $line) = @_;

    chomp($line);
    my @head = undef;

    if($delimiter eq ",") {
        @head = &parse_csv_line($line);
    }
    else {
        @head = split(/$delimiter/, $line);
    }

return @head;
}



if($opt_h) {
    &help();
    exit 0;
}

if(! $opt_f) {
    &help();
    exit 0;
}

if($opt_d) {
    if($opt_d eq "\\t") {
        $new_delimiter = $delimiter = "\t";
    }
    else {
        $new_delimiter = $delimiter = $opt_d;
    }
}

if($opt_n) {
    if($opt_n eq "\\t") {
        $new_delimiter = "\t";
    }
    else {
        $new_delimiter = $opt_n;
    }
}


if(@ARGV == 1) {
    open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
}
else {
    open(FD, "-") or die "I can not open STDIN\n";
}

$line=<FD>;

@head = &parse_line($delimiter, $line);
@columns = &which_columns($opt_f);

if((&check_range(\@columns, \@head)) == -1) {
    print "\nRange of choice fields is wrong.\n";
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

