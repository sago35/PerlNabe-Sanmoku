package PerlNabe::Sanmoku::Tomcha;
use strict;
use warnings;
use utf8;
use Moo;

use DDP{deparse => 1};
use Data::Dumper;

use lib 'lib';

extends 'PerlNabe::Sanmoku::Base';

sub calc_next {
  my $self = shift;
  my @data = @_;
  my @te_candidate;

  make_te(\@data, \@te_candidate);
  my $good_te = undef;
  my $good_score = -998;
  for my $te (@te_candidate){
    if ($good_score < $te->[1]){
      $good_te = $te->[0];
      $good_te = $te->[1];
    }
  }

  if ($good_te){
    return $good_te;
  }else{
    foreach my $i (List::Util::shuffle (0 .. 9 - 1)) {
      if ($data[$i] == 0) {
        return $i;
      }
    }
  }
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

  if ($sore == 1){
    #味方の手番
    for (my $i = 0; $i <= 6 ;$i += 3){
      #h1, h2, h3
      $score += self_calcbit($data->[$i]) * self_calcbit($data->[$i+1]) * self_calcbit($data->[$i+2]);
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

sub make_te{
  my $data = shift;
  my $te_candidate = shift;

  my $sore = 1;#1 = self手番, 2= enemy手番
  my @te;
  $| = 1;
  
  # 空マスを調べて、配列で受け取る(階層1の初期値)

  print "初期の\@teの数:" . scalar @te . "\n";

  for my $i (0..8){
    if ($data->[$i] == 0){
      my @datacp = @$data;
      push @te, [$i, \@datacp, 1, 0];#[ルート打つ場所, 盤面配列,深さ(1~9),スコア]
    }
  }

  print "1階層回した後の\@teの数:" . scalar @te . "\n";
  
  my $depth = 2;
  while (@te > 0){
    my $te = pop @te;

    # 空マスを調べて、配列で受け取る
    for my $i (0..8){
      if ($te->[1]->[$i] == 0){
        my @datasub = @{$te->[1]};
        push @te, [$te->[0], \@datasub, 1, 0];#[ルート打つ場所, 盤面配列,深さ(1~9),スコア]
      }
    }

  print "1つPOPした後の\@teの数:" . scalar @te . "\n";


    $te->[1][$te->[0]] = $sore;
#    p $sore;
#    p $data;
    my $bord_score = evaluate_function($sore, $data);
#    print 'eva after';
    $te->[3] = $bord_score;

    if ($bord_score == 999 || $bord_score == -999){
      push @$te_candidate, [$te->[0], $bord_score];
#      print '999';
      next;
    }

    if ($te->[2] == $depth){
      push @$te_candidate, [$te->[0], $bord_score];
#      print 'depth';
      next;
    }

    if ($sore == 1){
      $sore = 2;
    }else{
      $sore = 1;
    }
#    print 'push';
    print "depth:$te->[2]\n";
    print "\@teの数".scalar(@te)."\n";
    push @te, [$te->[0], $te->[1], $te->[2] + 1 ,0];
    print "\@teの数".scalar(@te)."\n";


    #else @spaceへもう一度push
    #push $te@space
  }
  # pushで位置を埋めて譜をつくる
  # 譜を評価して点数を受け取る
  # 位置と点数と譜のデータ
}
1;
