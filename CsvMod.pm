package CsvMod;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&parse_csv_line &which_columns &check_range &which_columns_regexp &parse_line);
$VERSION = 1.0;


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


sub parse_csv_line($) {
    my($line) = @_;

    chomp($line);    
    my @list = ();
    my $new_i = undef;
    my $ch = undef;
    my $offset = undef;

    my $i = 0;
    while(1) {

            $ch = substr($line, $i, 1);

            if($ch eq "\"") {
                    $new_i = index($line, "\",", ($i));
                    if($new_i != -1) {
                            $offset = ($new_i - $i - 1);
                            push(@list, substr($line, ($i+1), $offset));
                            $i = ($new_i + 2);
                            next;
                    } else {
                            $offset = ((length($line) - 2) - $i);
                            push(@list, substr($line, ($i+1), $offset));
                            last;
                    }
            } else {
                    $new_i = index($line, ",", ($i));
                    if($new_i != -1) {
                        $offset = ($new_i - $i);
                        push(@list, substr($line, $i, $offset ));
                        $i = ($new_i + 1);
                        next;
                    } else {
                            $offset = ((length($line)) - $i);
                            push(@list, substr($line, $i, $offset));
                            last;
                    }

            }
    }
return @list;
}


sub which_columns($$) {
    my($arg, $head) = @_;

    my @positions = undef;

    # columns by name
    if($arg =~ /[a-zA-ZľščťžýáíéúňôĽŠČŤŽÝÁÍÉÚŇÔ]/) {
        @positions = &columns_by_name($arg, \@$head);
    } else {
        @positions = &columns_by_number($arg);
    }

return @positions;
}


sub columns_by_name($$) {
    my($arg, $head) = @_;

    my @columns = undef;
    my @indexes = ();

    if($arg =~ /,/){  # values comma separated
        @columns = &parse_csv_line($arg);
        foreach my $item (@columns) {
            my $i = &return_index_from_list($item, \@$head);
            if($i > -1) {
                push(@indexes, $i);
            }
        }
    }
    elsif($arg =~ /:/) { # range of values
        my($first, $last) = split(/:/, $arg);
        my $low  = &return_index_from_list($first, \@$head);
        my $high = &return_index_from_list($last, \@$head);
        for(my $i = $low; $i < ($high + 1); $i++) {
            push(@indexes, $i);
        }
    }
    elsif($arg =~ /-/) { # range of values
        my($first, $last) = split(/-/, $arg);
        my $low  = &return_index_from_list($first, \@$head);
        my $high = &return_index_from_list($last, \@$head);
        for(my $i = $low; $i < ($high + 1); $i++) {
            push(@indexes, $i);
        }
    }
    else {
        my $i = &return_index_from_list($arg, \@$head);
        push(@indexes, $i);
    }

return @indexes;
}


sub return_index_from_list($$) {
    my($string, $list) = @_;

    my $index = 0;
    my $success = -1;

    foreach my $item (@$list) {
        if($item eq $string) {
            $success = 1;
            last;
        }
        else {
            $index++;
        }
    }

    if($success == 1) {
        return $index;
    }
    else {
        return -1;
    }
}


sub return_index_by_regexp($$$) {
    my($string, $head, $case_sensitive) = @_;

    my $index = 0;
    my @indexes = ();

    if($case_sensitive > -1) {
        foreach my $item (@$head) {
            if($item =~ /$string/i) {
                push(@indexes, $index);
            }
            $index++;
        }
    }
    else {
        foreach my $item (@$head) {
            if($item =~ /$string/) {
                push(@indexes, $index);
            }
            $index++;
        }
    }

return @indexes;
}


sub which_columns_regexp($$$) {
    my($arg, $head, $case_sensitive) = @_;

    my @columns_regexp = undef;
    my @indexes = ();

    if($arg =~ /,/){  # values comma separated
        my @columns_regexp = split(/,/, $arg);
    }
    else {
        @columns_regexp = ();
        push(@columns_regexp, $arg);
    }

    foreach my $item (@columns_regexp) {
       push(@indexes, &return_index_by_regexp($item, \@$head, $case_sensitive)); 
    }

return @indexes;
}


sub columns_by_number($) {
    my($arg) = @_;

    my @positions = ();

    if($arg =~ /,/){  # values comma separated
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

return @positions;
}


sub check_range($$) {
    my($columns, $head) = @_;

    if((scalar @$columns) == 0) {
        return -1;
    }

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

1;
