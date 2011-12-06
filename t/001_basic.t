#!perl -w
use strict;
use Test::More;
use Data::Dump qw/dump/;

use List::AcceptReference qw/:all/;

subtest push => sub {
    my @array    =  1..3;
    my $arrayref = [1..3];
    
    push @array   , 4;
    push $arrayref, 4;
    is_deeply2(\@array,   [1..4]);
    is_deeply2($arrayref, [1..4]);

    push @array,    5..6;
    push $arrayref, 5..6;
    is_deeply2(\@array,   [1..6]);
    is_deeply2($arrayref, [1..6]);
};

subtest unshift => sub {
    my @array    =  4..6;
    my $arrayref = [4..6];
    
    unshift @array   , 3;
    unshift $arrayref, 3;
    is_deeply2(\@array,   [3..6]);
    is_deeply2($arrayref, [3..6]);

    unshift @array,    1..2;
    unshift $arrayref, 1..2;
    is_deeply2(\@array,   [1..6]);
    is_deeply2($arrayref, [1..6]);
};

subtest pop => sub {
    my @array    =  1..3;
    my $arrayref = [1..3];
    
    pop @array;
    pop $arrayref;
    is_deeply2(\@array,   [1..2]);
    is_deeply2($arrayref, [1..2]);
};

subtest shift => sub {
    my @array    =  1..3;
    my $arrayref = [1..3];

    shift @array;
    shift $arrayref;
    is_deeply2(\@array,   [2..3]);
    is_deeply2($arrayref, [2..3]);

    my $func = sub { shift };
    is $func->('arg'), 'arg';
    #goto TEST_ARGV;
};
#TEST_ARGV: {
#    local @ARGV = qw/arg1 arg2/;
#    my $first_argv = shift;
#    warn '=========';
#    is $first_argv, 'arg1';
#}

subtest splice => sub {
    {
        my @array    =  1..5;
        my $arrayref = [1..5];
        splice @array;
        splice $arrayref;
        is_deeply2(\@array,   []);
        is_deeply2($arrayref, []);
    }
    {
        my @array    =  1..5;
        my $arrayref = [1..5];
        splice @array,    3;
        splice $arrayref, 3;
        is_deeply2(\@array,   [1..3]);
        is_deeply2($arrayref, [1..3]);
    }
    {
        my @array    =  1..5;
        my $arrayref = [1..5];
        splice @array,    2, 2;
        splice $arrayref, 2, 2;
        is_deeply2(\@array,   [1,2,5]);
        is_deeply2($arrayref, [1,2,5]);
    }
    {
        my @array    =  1..5;
        my $arrayref = [1..5];
        splice @array,    2, 1, -3;
        splice $arrayref, 2, 1, -3;
        is_deeply2(\@array,   [1, 2, -3, 4, 5]);
        is_deeply2($arrayref, [1, 2, -3, 4, 5]);
    }
    {
        my @array    =  1..5;
        my $arrayref = [1..5];
        splice @array,    2, 2, -3, -4;
        splice $arrayref, 2, 2, -3, -4;
        is_deeply2(\@array,   [1, 2, -3, -4, 5]);
        is_deeply2($arrayref, [1, 2, -3, -4, 5]);
    }
};

sub is_deeply2 {
    my ($got, $expected) = @_;
    is dump($got), dump($expected);
}

done_testing;
