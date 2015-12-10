package PerlNabe::Sanmoku::Nqounet;
use utf8;
use Moo;
extends 'PerlNabe::Sanmoku::Base';
use List::AllUtils qw(all);

use Data::Printer {deparse => 1};
use namespace::clean;

sub calc_next {
    my $self = shift;
    my @data = @_;
    my %score;
    my @pattern;
    push @pattern,
      {
        ban => [@data[0, 1, 2]],
        key => [0,       1, 2]
      };
    push @pattern,
      {
        ban => [@data[3, 4, 5]],
        key => [3,       4, 5]
      };
    push @pattern,
      {
        ban => [@data[6, 7, 8]],
        key => [6,       7, 8]
      };
    push @pattern,
      {
        ban => [@data[0, 4, 8]],
        key => [0,       4, 8]
      };
    push @pattern,
      {
        ban => [@data[2, 4, 6]],
        key => [2,       4, 6]
      };
    push @pattern,
      {
        ban => [@data[0, 3, 6]],
        key => [0,       3, 6]
      };
    push @pattern,
      {
        ban => [@data[1, 4, 7]],
        key => [1,       4, 7]
      };
    push @pattern,
      {
        ban => [@data[2, 5, 8]],
        key => [2,       5, 8]
      };

    for my $p (@pattern) {
        my $score = 0;
        map { $score++ unless $_ } @{$p->{ban}};
        $score++ if all { $_ == 0 } @{$p->{ban}};
        my @p = grep { $_ == 1 } @{$p->{ban}};
        my @e = grep { $_ == 2 } @{$p->{ban}};
        $score += 20 if @p == 2;
        $score += 10 if @e == 2;

        # score
        map { $score{$_} += $score } @{$p->{key}};
    }

    # result
    my $result;
    for my $i (0 .. 8) {
        if ($data[$i]) {
            $score{$i} = 0;
        }
        if ($data[$i] == 0) {
            $result = $i;
        }
    }
    my $max = 0;
    for my $key (sort keys %score) {
        if ($score{$key} > $max) {
            $result = $key;
            $max    = $score{$key};
        }
    }
    return $result;
}

1;