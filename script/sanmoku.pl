#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use lib 'lib';
use PerlNabe::Sanmoku;

if (scalar @ARGV < 2) {
    die "usage : $0  Sample  Base";
}

use Term::Encoding qw(term_encoding);
my $encoding = term_encoding;
binmode STDOUT => ":encoding($encoding)";

my @players = @ARGV[0 .. 1];
my $wait    = $ARGV[2] // 1;

my $sanmoku = PerlNabe::Sanmoku->new(
    players => [@players],
    wait    => $wait,
);
$sanmoku->run;



__END__

=encoding utf-8

=head1 NAME

PerlNabe::Sanmoku - ○×ゲーム

=head1 SYNOPSIS

    # PerlNabe::Sanmoku::Base および PerlNabe::Sanmoku::Rand モジュールを対決させる
    # 最初の引数に指定した側が先行となる

    $ script/sanmoku.pl Base Rand

=head1 DESCRIPTION

○×ゲームを実施するスクリプトです。
PerlNabe::Sanmoku::Baseを継承して、sub calc_next()を実装してください。

calc_next()内では、引数により現在の盤にアクセスする事が可能です。
添え字はそれぞれ、以下の位置に対応します。

    #  0 | 1 | 2
    # ---+---+---
    #  3 | 4 | 5
    # ---+---+---
    #  6 | 7 | 8

    sub calc_next {
        my $self = shift;
        my @data = @_;
        # $data[0] は 左上の状態、$data[4]は真ん中の状態を表す

        return 4; # 真ん中に自分の手を打つ場合は、4を返す
    }

盤の状況は、それぞれ以下の通りです。

    0 : 何もない
    1 : 自分の駒が存在
    2 : 相手の駒が存在

サンプルは、PerlNabe/Sanmoku/以下にあります。
シンプルに試す場合は、以下のようにすることが出来ますし、
もちろんTest::More等のテストモジュールで確認する事も出来ます。

    use strict;
    use warnings;
    use PerlNabe::Sanmoku::Rand;


    my $s = PerlNabe::Sanmoku::Rand->new;

    my @data = (0) x 9;

    printf "%s\n", join " ", @data;
    my $x = $s->calc_next(@data);

    printf "%d\n", $x;

例として、以下の状況を実行するcalc_next()を示します。

    #  X | O | O      X | O | O
    # ---+---+---    ---+---+---
    #    | X |    ->    | X |
    # ---+---+---    ---+---+---
    #    |   |          |   | O
    #
    # リーチとなっているので、右下(添え字=8)に打ちたい

    sub calc_next {
        my $self = shift;
        my @data = @_;

        # 左上($data[0]) と 真ん中($data[4]) が相手の駒なら、右下(8)を返す
        if ($data[0] == 2 and $data[4] == 2) {
            return 8
        }
    }

=head2 I can't write perl script

PerlNabe::Sanmoku::Execを使う事で、標準入出力を使ったプログラムでプレイする事が可能です。
C言語やruby、golang等で開発する事も可能です。
Base.pmと実際に対戦させるサンプルは以下の通りです。
今回は lib/PerlNabe/Sanmoku/exec_sample.pl での例を示します。
他の言語でも同じように実装する事で対戦が可能です。

    $ perl -Ilib script/sanmoku.pl Base "Exec=perl lib/PerlNabe/Sanmoku/exec_sample.pl"

作成するプログラムの仕様は以下の通りです。

    標準入力からスペース区切りで以下を受け取ります
    順に$data[0]、$data[1]、というイメージです

    0 0 0
    0 0 0
    0 0 0

    自分が打つ手は、標準出力に出力してください
    C言語で真ん中に打つ例は、以下の通りです
    改行文字の有無はどちらでも構いません

    printf("%d\n", 4);

=head1 LICENSE

Copyright (C) sago35.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sago35 E<lt>sago35@gmail.comE<gt>

=cut
