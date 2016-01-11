package PerlNabe::Sanmoku::CLI::Run;
use 5.008001;
use strict;
use warnings;
use utf8;
use Carp;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use PerlNabe::Sanmoku;

sub run {
    my $class = shift;
    my @argv = @_;

    my $options = {
        nowait  => 0,
        reverse => 0,
    };

    my @params;

    while (scalar @argv > 0) {
        if ($argv[0] =~ /^-/) {
            local @ARGV = @argv;
            GetOptions($options,
                "no-wait" => \$options->{nowait},
                "reverse" => \$options->{reverse},
            ) || confess "error";
            @argv = @ARGV;
        } else {
            push @params, shift @argv;
        }
    }

    my $players = $options->{reverse} ? [@params[1, 0]] : [@params[0, 1]];
    my $sanmoku = PerlNabe::Sanmoku->new(
        players => $players,
        wait    => !$options->{nowait},
    );
    $sanmoku->run;
}

1;
