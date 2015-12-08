package PerlNabe::Sanmoku;
use 5.008001;
use strict;
use warnings;
use utf8;
use Moo;
use Carp;

our $VERSION = "0.01";

has players => (is => 'rw');
has data => (is => 'rw', default => sub {return [0, 0, 0, 0, 0, 0, 0, 0, 0]});
has wait => (is => 'ro', default => 1);

sub run {
    my $self = shift;

    my @players;
    foreach my $player (@{$self->players}) {
        require "PerlNabe/Sanmoku/$player.pm";
        push @players, "PerlNabe::Sanmoku::$player"->new(name => $player);
    }

    printf "player[0] (○) => %s\n", $players[0]->name;
    printf "player[1] (×) => %s\n", $players[1]->name;
    printf "\n";


    $self->dump;

    for (my $i = 0; $i < 9; $i++) {
        printf "\n";
        printf "next: player[%d] (%s)\n", ($i)%2, $players[($i)%2]->name;
        if ($self->wait) {
            <STDIN>;
        }

        my $next = $players[$i%2]->calc_next($self->data_for_player($i%2));

        if ($i % 2) {
            $self->add_x($next);
        } else {
            $self->add_o($next);
        }

        $self->dump;

        if ($self->judge == 1) {
            printf "\n";
            printf "player[0] (%s) win!\n", $players[0]->name;
            last;
        } elsif ($self->judge == 2) {
            printf "\n";
            printf "player[1] (%s) win!\n", $players[1]->name;
            last;
        }
    }

    if ($self->judge == 0) {
        printf "\n";
        printf "draw!\n";
    }

    return $self->judge;
}

sub add {
    my $self = shift;
    my $i    = shift // confess;
    my $turn = shift // confess;

    if ($turn != 1 and $turn != 2) {
        confess;
    }

    if (0 <= $i and $i < 9) {
        if ($self->data->[$i] == 0) {
            $self->data->[$i] = $turn;
        } else {
            confess "already placed";
        }
    } else {
        confess;
    }
}

sub add_o {
    my $self = shift;
    my $i = shift // confess;
    $self->add($i, 1);
}

sub add_x {
    my $self = shift;
    my $i = shift // confess;
    $self->add($i, 2);
}

sub judge {
    my $self = shift;
    my @data = @{$self->data};
    my @check_patterns = (
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],

        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],

        [0, 4, 8],
        [2, 4, 6],
    );

    foreach my $pattern (@check_patterns) {
        if ((grep {$_ == 1} map {$data[$_]} @$pattern) == 3) {
            return 1;
        } elsif ((grep {$_ == 2} map {$data[$_]} @$pattern) == 3) {
            return 2;
        }
    }
    return 0;
}

sub data_for_player {
    my $self = shift;
    my $player = shift;

    if ($player == 0) {
        return @{$self->data};
    } elsif ($player == 1) {
        return map {$_ == 1 ? 2 : $_ == 2 ? 1 : 0} @{$self->data};
    }
}

sub dump {
    my $self = shift;
    my @data = @{$self->data};
    printf "%s\n", join " | ", map {$_ == 1 ? "○" : $_ == 2 ? "×" : "  "} @data[0 .. 0 + 2];
    printf "---+----+---\n";
    printf "%s\n", join " | ", map {$_ == 1 ? "○" : $_ == 2 ? "×" : "  "} @data[3 .. 3 + 2];
    printf "---+----+---\n";
    printf "%s\n", join " | ", map {$_ == 1 ? "○" : $_ == 2 ? "×" : "  "} @data[6 .. 6 + 2];
}


1;
__END__

=encoding utf-8

=head1 NAME

PerlNabe::Sanmoku - It's new $module

=head1 SYNOPSIS

    use PerlNabe::Sanmoku;

=head1 DESCRIPTION

PerlNabe::Sanmoku is ...

=head1 LICENSE

Copyright (C) sago35.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sago35 E<lt>sago35@gmail.comE<gt>

=cut

