package PerlNabe::Sanmoku::Exec;
use 5.008001;
use strict;
use warnings;
use utf8;
use Moo;
use Path::Tiny;

extends 'PerlNabe::Sanmoku::Base';

has cmd => (is => 'ro');

sub calc_next {
    my $self = shift;
    my @data = @_;

    my $t = Path::Tiny->tempfile;
    printf "--- %s\n", $self->cmd;
    open my $in, "|" . $self->cmd . " @data > $t" or croak $!;
    printf $in "%s\n", join " ", @data[0..2];
    printf $in "%s\n", join " ", @data[3..5];
    printf $in "%s\n", join " ", @data[6..8];
    close $in;

    my $value = $t->slurp;
    chomp $value;

    return int $value;
}

1;
