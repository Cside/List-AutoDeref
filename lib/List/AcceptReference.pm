package List::AcceptReference;
use 5.008_001;
use strict;
use warnings;
our $VERSION = '0.01';
use parent qw/Exporter/;
our @EXPORT_OK = qw/pop push shift unshift/;
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
use subs @EXPORT_OK;

sub push (\[$@]@) {
    my ($arrayref, @list) = @_;
    $arrayref = $$arrayref if (ref($arrayref) eq 'REF');
    CORE::push @$arrayref, @list;
}

sub unshift (\[$@]@) {
    my ($arrayref, @list) = @_;
    $arrayref = $$arrayref if (ref($arrayref) eq 'REF');
    CORE::unshift @$arrayref, @list;
}

sub pop (\[$@]) {
    my ($arrayref, @list) = @_;
    $arrayref = $$arrayref if (ref($arrayref) eq 'REF');
    CORE::pop @$arrayref;
}

sub shift (\[$@]) {
    my ($arrayref, @list) = @_;
    $arrayref = $$arrayref if (ref($arrayref) eq 'REF');
    CORE::shift @$arrayref;
}

1;
__END__

=head1 NAME

List::AcceptReference - enable builtin functions that operate on array or hash containers to accept array or hash references

=head1 VERSION

This document describes List::AcceptReference version 0.01.

=head1 SYNOPSIS

    use List::AcceptReference qw/:all/;

    my $arrayref = [1..3];

    push    $arrayref, 4;
    unshift $arrayref, 5;
    pop   $arrayref;
    shift $arrayref;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Hiroki Honda (Cside) E<lt>cside.story@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, Hiroki Honda (Cside). All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
