use strict;
use warnings;
use Test::More;
use PerlNabe::Sanmoku;

{
    my $x = PerlNabe::Sanmoku->new;
    is_deeply($x->data, [0,0,0,0,0,0,0,0,0]);

    $x->add_o(0);
    is_deeply($x->data, [1,0,0,0,0,0,0,0,0]);

    $x->add_o(1);
    is_deeply($x->data, [1,1,0,0,0,0,0,0,0]);

    $x->add_o(2);
    is_deeply($x->data, [1,1,1,0,0,0,0,0,0]);

    $x->add_o(3);
    is_deeply($x->data, [1,1,1,1,0,0,0,0,0]);

    $x->add_o(4);
    is_deeply($x->data, [1,1,1,1,1,0,0,0,0]);

    $x->add_o(5);
    is_deeply($x->data, [1,1,1,1,1,1,0,0,0]);

    $x->add_o(6);
    is_deeply($x->data, [1,1,1,1,1,1,1,0,0]);

    $x->add_o(7);
    is_deeply($x->data, [1,1,1,1,1,1,1,1,0]);

    $x->add_o(8);
    is_deeply($x->data, [1,1,1,1,1,1,1,1,1]);
}

{
    my $x = PerlNabe::Sanmoku->new;
    is_deeply($x->data, [0,0,0,0,0,0,0,0,0]);

    $x->add_x(0);
    is_deeply($x->data, [2,0,0,0,0,0,0,0,0]);

    $x->add_x(1);
    is_deeply($x->data, [2,2,0,0,0,0,0,0,0]);

    $x->add_x(2);
    is_deeply($x->data, [2,2,2,0,0,0,0,0,0]);

    $x->add_x(3);
    is_deeply($x->data, [2,2,2,2,0,0,0,0,0]);

    $x->add_x(4);
    is_deeply($x->data, [2,2,2,2,2,0,0,0,0]);

    $x->add_x(5);
    is_deeply($x->data, [2,2,2,2,2,2,0,0,0]);

    $x->add_x(6);
    is_deeply($x->data, [2,2,2,2,2,2,2,0,0]);

    $x->add_x(7);
    is_deeply($x->data, [2,2,2,2,2,2,2,2,0]);

    $x->add_x(8);
    is_deeply($x->data, [2,2,2,2,2,2,2,2,2]);
}

{
    my $x = PerlNabe::Sanmoku->new;
    is_deeply($x->data, [0,0,0,0,0,0,0,0,0]);

    $x->add_o(0);
    is_deeply($x->data, [1,0,0,0,0,0,0,0,0]);

    $x->add_x(1);
    is_deeply($x->data, [1,2,0,0,0,0,0,0,0]);

    $x->add_o(2);
    is_deeply($x->data, [1,2,1,0,0,0,0,0,0]);

    $x->add_x(3);
    is_deeply($x->data, [1,2,1,2,0,0,0,0,0]);

    $x->add_o(4);
    is_deeply($x->data, [1,2,1,2,1,0,0,0,0]);

    $x->add_x(5);
    is_deeply($x->data, [1,2,1,2,1,2,0,0,0]);

    $x->add_o(6);
    is_deeply($x->data, [1,2,1,2,1,2,1,0,0]);

    $x->add_x(7);
    is_deeply($x->data, [1,2,1,2,1,2,1,2,0]);

    $x->add_o(8);
    is_deeply($x->data, [1,2,1,2,1,2,1,2,1]);
}

{
    my $x = PerlNabe::Sanmoku->new;
    $x->add_o(0);
    is($x->judge, 0);
    $x->add_o(1);
    is($x->judge, 0);
    $x->add_o(2);
    is($x->judge, 1);
}

{
    my $x = PerlNabe::Sanmoku->new;
    $x->add_x(0);
    is($x->judge, 0);
    $x->add_x(4);
    is($x->judge, 0);
    $x->add_x(8);
    is($x->judge, 2);
}

done_testing;

