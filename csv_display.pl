#!/usr/bin/perl -w

#Author: Ladislav Babjak
#VERSION: 1.0

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


sub which_columns($) {
    my($arg) = @_;

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


sub check_range($$) {
    my($columns, $head) = @_;

    my $ret_cod = 0;
    my $max_pos = @$head;
    $max_pos--;

    foreach my $item (@$columns) {
        if(($item < 0) or ($item > $max_pos)) {
            $ret_cod = -1;
        }
    }
return $ret_cod;
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

print join($delimiter, @tmp_list) . "\n";

@tmp_list = ();
while($line=<FD>) {
    my @full_list = &parse_line($delimiter, $line);
    foreach my $item (@columns) {
        push(@tmp_list, $full_list[$item]);
    }
    print join($delimiter, @tmp_list) . "\n";
    @tmp_list = ();
}

close(FD);

