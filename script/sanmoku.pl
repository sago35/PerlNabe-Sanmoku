use strict;
use warnings;
use utf8;
use PerlNabe::Sanmoku;

if (scalar @ARGV < 2) {
    die "usage : $0  Sample  Base";
}

binmode STDOUT => "encoding(cp932)";

my @players = @ARGV[0 .. 1];
my $wait    = @ARGV[2] // 0;

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

    $ perl sanmoku.pl Base Rand

=head1 DESCRIPTION

○×ゲームを実施するスクリプトです。
PerlNabe::Sanmoku::Baseを継承して、sub calc_next()を実装してください。

calc_next()内では、引数により現在の盤にアクセスする事が可能です。
添え字はそれぞれ、以下の位置に対応します。

    #  0 |  1 |  2
    # ---+----+----
    #  3 |  4 |  5
    # ---+----+----
    #  6 |  7 |  8

    my @data = @{$self->data()};

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

=head1 LICENSE

Copyright (C) sago35.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sago35 E<lt>sago35@gmail.comE<gt>

=cut
