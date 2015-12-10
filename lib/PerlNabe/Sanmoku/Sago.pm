package PerlNabe::Sanmoku::Sago;
use 5.008001;
use strict;
use warnings;
use utf8;
use Moo;

extends 'PerlNabe::Sanmoku::Base';

sub calc_next {
    my $self = shift;
    my @data = @_;

    my @check_patterns = (
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],

        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],

        [0, 4, 8],
        [2, 4, 6],
    );

    if ($data[4] == 0) {
        return 4;
    }

    foreach my $pattern (@check_patterns) {
        if ((grep {$_ == 1} map {$data[$_]} @$pattern) == 2) {
            foreach my $p (@$pattern) {
                if ($data[$p] == 0) {
                    return $p;
                }
            }
        }
    }

    foreach my $pattern (@check_patterns) {
        if ((grep {$_ == 2} map {$data[$_]} @$pattern) == 2) {
            foreach my $p (@$pattern) {
                if ($data[$p] == 0) {
                    return $p;
                }
            }
        }
    }

    foreach my $i (0, 2, 6, 8, 1, 3, 4, 5, 7) {
        if ($data[$i] == 0) {
            return $i;
        }
    }
}

1;
