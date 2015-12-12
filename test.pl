#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use open qw/:encoding(utf-8) :std/;
use v5.12;
 
use Data::Dumper;
use DDP{deparse => 1};

use lib 'lib';
use PerlNabe::Sanmoku::Tomcha;
use PerlNabe::Sanmoku::Base;

my $b = PerlNabe::Sanmoku::Base->new;
my $t = PerlNabe::Sanmoku::Tomcha->new;

my $r = $t->calc_next((0,0,0,0,0,0,0,0,0,));
p $r;
