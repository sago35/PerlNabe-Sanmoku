package PerlNabe::Sanmoku::Sample;
use 5.008001;
use strict;
use warnings;
use utf8;
use Moo;

extends 'PerlNabe::Sanmoku::Base';

sub calc_next {
    my $self = shift;
    my @data = @_;

    foreach my $i (reverse (0 .. 9 - 1)) {
        if ($data[$i] == 0) {
            return $i;
        }
    }
}

1;
