#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'List::AutoDeref';
}

diag "Testing List::AutoDeref/$List::AutoDeref::VERSION";
