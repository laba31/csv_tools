#!/usr/bin/perl -w

#Author: Ladislav Babjak
#VERSION: 1.0

use Data::Dumper;
use CsvMod;
use Getopt::Std;
getopts('hd:f:');


# my favorit delimiter
my $delimiter = ';';
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

Some examples:

$0 -d ',' -f 1-5
$0 -f 2,3,5
$0 -d '\t' -f 1:3
$0 -f id,name,age

END_HELP
}


sub parse_head($$) {
    my($delimiter, $line) = @_;

    chomp($line);
    my @head;

    if($delimiter eq ",") {
        @head = &parse_csv_line($line);
    }
    else {
        @head = split(/$delimiter/, $line);
    }

return @head;
}


sub which_columns($$) {
    my($arg, $head) = @_;

    my @positions = ();

    # columns by name
    if($arg =~ /[a-zA-Z]/) {
    }
    else{  #only numbers of columns
        if($arg =~ /,/){  # values comma separeted
            @positions = split(/,/, $arg);
            for(my $i = 0; $i < @positions; $i++) {
                $positions[$i] -= 1; 
            }
        }
        elsif($arg =~ /:/) {  # range of values
            my($low, $high) = split(/:/, $arg); 
            for(my $i = ($low - 1); $i < $high; $i++) {
                push(@positions, $i);
            }
        }
        elsif($arg =~ /-/) {  # range of values
            my($low, $high) = split(/-/, $arg); 
            for(my $i = ($low - 1); $i < $high; $i++) {
                push(@positions, $i);
            }
        }
        else {
            push(@positions, ($arg - 1));
        }
    }
return @positions;
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
        $delimiter=$opt_d;
}

if(@ARGV == 1) {
        open(FD, $ARGV[0]) or die "I can not open file $ARGV[0]\n";
        $line=<FD>;
}
else {
        $line=<>;
}


@head = &parse_head($delimiter, $line);
@columns = &which_columns($opt_f, \@head);

print "Hlavicka:\n";
print Dumper(@head);
print "\n\nVybrane stlpce:\n";
print Dumper(@columns);


