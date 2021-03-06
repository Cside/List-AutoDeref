#!perl -w
use strict;
use Test::More;
use Data::Dump qw/dump/;

use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use List::AutoDeref qw/:all/;

sub is_deeply2 { is dump($_[0]), dump($_[1]); }
sub _sort { CORE::sort {$a cmp $b} @_ }

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
    
    my $func = sub { shift };
    is $func->('arg'), 'arg';
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

my %hash    = (foo => 'Foo', bar => 'Bar');
my $hashref = {foo => 'Foo', bar => 'Bar'};
my @_hash    =  qw/foo Foo bar Bar/;
my $_hashref = [qw/foo Foo bar Bar/];
subtest keys => sub {
    is_deeply2([_sort(keys %hash    )], [_sort(qw/foo bar/)]);
    is_deeply2([_sort(keys $hashref )], [_sort(qw/foo bar/)]);
    is_deeply2([_sort(keys @_hash   )], [_sort(0..3       )]);
    is_deeply2([_sort(keys $_hashref)], [_sort(0..3       )]);
};

subtest values => sub {
    is_deeply2([_sort(values %hash    )], [_sort(qw/Foo Bar/)]);
    is_deeply2([_sort(values $hashref )], [_sort(qw/Foo Bar/)]);
    is_deeply2([_sort(values @_hash   )], [_sort(@_hash     )]);
    is_deeply2([_sort(values $_hashref)], [_sort(@_hash     )]);
};

subtest each => sub {
    my (%got1, %got2);
    do {my ($x, $y) = each(%hash);    $got1{$x} = $y} for (1..2);
    do {my ($x, $y) = each($hashref); $got1{$x} = $y} for (1..2);
    is_deeply2(\%got1, \%hash);
    is_deeply2(\%got1, $hashref);
    
    is_deeply2([_sort(each @_hash   )], [_sort(qw/0 foo/)]);
    is_deeply2([_sort(each @_hash   )], [_sort(qw/1 Foo/)]);
    is_deeply2([_sort(each $_hashref)], [_sort(qw/0 foo/)]);
    is_deeply2([_sort(each $_hashref)], [_sort(qw/1 Foo/)]);
};

subtest join => sub {
    my @strs    = qw/foo bar/;
    my $strs    = [@strs];
    my %strs    =  @strs;
    my $strs_hr = {@strs};
    is join('', @strs),    'foobar';
    is join('', $strs),    'foobar';
    is join('', %strs),    'foobar';
    is join('', $strs_hr), 'foobar';
};

subtest map_array => sub {
    my @nums    = 0..5;
    my $nums    = \@nums;
    my %nums    =  @nums;
    my $nums_hr = {@nums};

    is_deeply2([_sort(map_array {$_ + 1} @nums   )], [1..6]);
    is_deeply2([_sort(map_array {$_ + 1} $nums   )], [1..6]);
    is_deeply2([_sort(map_array {$_ + 1} %nums   )], [1..6]);
    is_deeply2([_sort(map_array {$_ + 1} $nums_hr)], [1..6]);
};

subtest grep_array => sub {
    my @nums    = 0..5;
    my $nums    = \@nums;
    my %nums    =  @nums;
    my $nums_hr = {@nums};

    is_deeply2([_sort(grep_array {$_ % 2 == 0} @nums   )], [0, 2, 4]);
    is_deeply2([_sort(grep_array {$_ % 2 == 0} $nums   )], [0, 2, 4]);
    is_deeply2([_sort(grep_array {$_ % 2 == 0} %nums   )], [0, 2, 4]);
    is_deeply2([_sort(grep_array {$_ % 2 == 0} $nums_hr)], [0, 2, 4]);
};

done_testing;
