package CsvMod;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&parse_csv_line &which_columns &check_range);
$VERSION = 1.0;


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

1;