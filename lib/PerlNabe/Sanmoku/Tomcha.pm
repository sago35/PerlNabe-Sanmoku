package PerlNabe::Sanmoku::Tomcha;
use strict;
use warnings;
use utf8;
use Moo;

use DDP{deparse => 1};

use lib 'lib';

extends 'PerlNabe::Sanmoku::Base';

sub calc_next {
  my $self = shift;
  my @data = @_;
  my @te_candidate; # (打つ場所, スコア);

  for my $i (@data){
    $i = to_bit($i);
  }

  make_te(\@data, \@te_candidate);
  my $good_te = undef;
  my $good_depth = 9;
  my $good_score = -998;
  for my $te (@te_candidate){
    if ($good_score < $te->[2] && $good_depth >= $te->[1]){
      $good_score = $te->[2];
      $good_depth = $te->[1];
      $good_te = $te->[0];
    }
  }

#  if ($good_te){
    return $good_te;
#  }else{
#    foreach my $i (List::Util::shuffle (0 .. 9 - 1)) {
#      if ($data[$i] == 0) {
#        return $i;
#      }
#    }
#  }
}

sub to_bit{
  my $i = shift;
  if ($i == 1){
    $i = 0b011;
  }elsif ($i == 2){
    $i = 0b101;
  }else{
    $i = 0;
  }
  return $i;
}
sub evaluate_function{
  my $sore = shift;
  my $data = shift;
  my $score = 0;
  my $calcbit;
  
  # 詰みチェック
  for (my $i = 0; $i <= 6 ;$i += 3){
    #h1, h2, h3
    my $val = check_mate($data->[$i], $data->[$i+1], $data->[$i+2]);
    if ($val == 999 || $val == -999){
      return $val;
    }
  }

  for (my $i = 0; $i <= 2 ;$i++){
    #v1, v2, v3
    my $val = check_mate($data->[$i], $data->[$i+3], $data->[$i+6]);
    if ($val == 999 || $val == -999){
      return $val;
    }
  }

  my $val = check_mate($data->[0], $data->[4], $data->[8]);
  if ($val == 999 || $val == -999){
    return $val;
  }

  $val = check_mate($data->[2], $data->[4], $data->[6]);
  if ($val == 999 || $val == -999){
    return $val;
  }

  # 盤面評価
  if ($sore == 1){

    #味方の手番
    for (my $i = 0; $i <= 6 ;$i += 3){
      #h1, h2, h3
      $score = self_calcbit($data->[$i]) * self_calcbit($data->[$i+1]) * self_calcbit($data->[$i+2]);
    }

    for (my $i = 0; $i <= 2 ;$i++){
      #v1, v2, v3
      $score += self_calcbit($data->[$i]) * self_calcbit($data->[$i+3]) * self_calcbit($data->[$i+6]);
    }
    #x1, x2
    $score += self_calcbit($data->[0]) * self_calcbit($data->[4]) * self_calcbit($data->[8]);
    $score += self_calcbit($data->[2]) * self_calcbit($data->[4]) * self_calcbit($data->[6]);
  }elsif ($sore == 2){
    #敵の手番
    for (my $i = 0; $i <= 6 ;$i += 3){
      #h1, h2, h3
      $score += enemy_calcbit($data->[$i]) * enemy_calcbit($data->[$i+1]) * enemy_calcbit($data->[$i+2]);
    }

    for (my $i = 0; $i <= 2 ;$i++){
      #v1, v2, v3
      $score += enemy_calcbit($data->[$i]) * enemy_calcbit($data->[$i+3]) * enemy_calcbit($data->[$i+6]);
    }
    #x1, x2
    $score += enemy_calcbit($data->[0]) * enemy_calcbit($data->[4]) * enemy_calcbit($data->[8]);
    $score += enemy_calcbit($data->[2]) * enemy_calcbit($data->[4]) * enemy_calcbit($data->[6]);
  }
  return $score;
}

sub self_calcbit{
  my $val = shift;
  return ($val & 0b011) ^ 0b001;
}

sub enemy_calcbit{
  my $val = shift;
  return sqrt(($val & 0b101) ^ 0b001);
}

sub check_mate{
  my ($i, $j, $k) = @_;
  if (($i + $j + $k) == 9){
    return 999;
  }elsif(($i + $j + $k) == 15){
    return -999;
  }else{
    return 0;
  }
}



sub make_te{
  my $data = shift;
  my $te_candidate = shift;

  my $sore = 1;#1 = self手番, 2= enemy手番
  my @te;
  my $max_depth = 9;
  my $depth = $max_depth;
#  $| = 1;

  # サーバから与えられた棋譜から、合法手そ生成
  for my $i (0..8){
    if ($data->[$i] == 0){
      my @datacp = @$data;
      $datacp[$i] = to_bit($sore);
      push @te, [$i, \@datacp, 1, evaluate_function($sore, \@datacp)];#[ルート打つ場所, 盤面配列,深さ(1~9),スコア]
    }
  }

  # 探索開始
  while (@te > 0){
    my $te = shift @te;

    if ($te->[3] == 999 || $te->[3] == -999){
      
      # 読み筋の出力
#      print "bord: @{$te->[1]}, score: $te->[3], depth: $te->[2]\n";

      push @$te_candidate, [$te->[0], $te->[2], $te->[3]];
      $depth = $te->[2] if $depth > $te->[2];
      next;
    }

    if ($te->[2] == $depth){

      # 読み筋の出力
#      print "bord: @{$te->[1]}, score: $te->[3], depth: $te->[2]\n";

      push @$te_candidate, [$te->[0], $te->[2], $te->[3]];
      next;
    }

    # 勝ち負けが決まってない、かつ、探索深度まで達していない

    # 敵味方手番を変える

    if ($sore == 1){
      $sore = 2;
    }else{
      $sore = 1;
    }

    # 合法手を生成してpush
    for my $i (0..8){
      if ($te->[1]->[$i] == 0){
        my @datasub = @{$te->[1]};
        $datasub[$i] = to_bit($sore);
        push @te, [$te->[0], \@datasub, ($te->[2] + 1), evaluate_function($sore, \@datasub)];#[ルート打つ場所, 盤面配列,深さ(1~9),スコア]
      }
    }
  }
}
1;
