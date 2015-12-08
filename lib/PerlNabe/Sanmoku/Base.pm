package PerlNabe::Sanmoku::Base;
use 5.008001;
use strict;
use warnings;
use utf8;
use Moo;

our $VERSION = "0.01";

has name => (is => 'ro', default => 'NO_NAME');

sub calc_next {
    my $self = shift;
    my @data = @_;

    for (my $i = 0; $i < @data; $i++) {
        if ($data[$i] == 0) {
            return $i;
        }
    }
}


1;
