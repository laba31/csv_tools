package CsvMod;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&parse_csv_line);
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

1;
