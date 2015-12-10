package PerlNabe::Sanmoku::Nqounet;
use utf8;
use Moo;
extends 'PerlNabe::Sanmoku::Base';
use List::AllUtils qw(all shuffle max);

use Data::Printer {deparse => 1};
use namespace::clean;

sub calc_next {
    my $self = shift;

    # 引数を取得
    my @data = @_;

    # パターンを定義
    my @lines = ([0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 4, 8], [2, 4, 6], [0, 3, 6], [1, 4, 7], [2, 5, 8]);
    my @pattern;
    for my $line (@lines) {
        push @pattern,
          +{
            ban => [@data[@{$line}]],
            key => $line,
          };
    }

    # 盤を評価
    my %score;
    for my $p (@pattern) {
        my $score = 0;
        map { $score++ unless $_ } @{$p->{ban}};
        $score += 5 if all { $_ == 0 } @{$p->{ban}};
        my @p = grep { $_ == 1 } @{$p->{ban}};
        my @e = grep { $_ == 2 } @{$p->{ban}};
        $score += 20 if @p == 2;
        $score += 10 if @e == 2;

        # score
        map { $score{$_} += $score } @{$p->{key}};
    }

    # 評価の高いものから選んで返す
    my @results;
    for my $i (0 .. 8) {
        if ($data[$i]) {
            $score{$i} = 0;
        }
    }
    my $max = max(values %score);
    for my $key (keys %score) {
        next if $score{$key} < $max;
        push @results, $key;
    }
    my ($result) = shuffle @results;
    return $result;
}

1;
