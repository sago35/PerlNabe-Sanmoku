use strict;
use warnings;
use utf8;

# Exec.pmで動かすための外部コマンド実装サンプルです
#   標準入力からスペース区切りで以下を受け取ります
#   順に$data[0]、$data[1]、というイメージです
#
#   0 0 0
#   0 0 0
#   0 0 0
#
#   自分が打つ手は、標準出力に出力してください
#   真ん中に打つ場合は、以下の通りです
#   改行文字の有無はどちらでも構いません
#
#   printf "%d\n", 4;
#

my @data;
while (<STDIN>) {
    push @data, (split /\s+/)[0 .. 2];
}

die if scalar @data != 9;

foreach my $i (4, 0, 2, 6, 8, 1, 3, 5, 7) {
    if ($data[$i] == 0) {
        printf "%d\n", $i;
        exit 0;
    }
}
die;

