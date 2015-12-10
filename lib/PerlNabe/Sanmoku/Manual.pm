package PerlNabe::Sanmoku::Manual;
use 5.008001;
use strict;
use warnings;
use utf8;
use Moo;
use Term::ReadKey;
use Time::HiRes;

extends 'PerlNabe::Sanmoku::Base';

# Manual.pmを使う時は、wait = 0 がお勧め
# perl -Ilib script/sanmoku.pl Manual Sample 0

sub calc_next {
    my $key;
    ReadMode 4;
    while (1) {
        while (not defined ($key = ReadKey(-1))) {
            Time::HiRes::sleep(0.1);
        }

        if ($key =~ /^\d$/) {
            ReadMode 0;
            return int $key;
        }
    }
}

1;
