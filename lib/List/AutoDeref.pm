package List::AutoDeref;
use 5.008_001;
use strict;
use warnings;
our $VERSION = '0.02';
use parent qw/Exporter/;
our @EXPORT_OK = qw/pop push shift unshift splice keys values each/;
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
use subs @EXPORT_OK;

sub _to_ref { (ref($_[0]) eq 'REF') ? ${$_[0]} : $_[0]; }

sub push (\[$@]@) {
    my ($arrayref, @list) = (_to_ref(CORE::shift), @_);
    CORE::push @$arrayref, @list;
}

sub unshift (\[$@]@) {
    my ($arrayref, @list) = (_to_ref(CORE::shift), @_);
    CORE::unshift @$arrayref, @list;
}

sub pop (;\[$@]) {
    if (@_) {
        my ($arrayref) = _to_ref(CORE::pop);
        CORE::pop @$arrayref;
    } else {
        # in subroutine
        if (defined(scalar caller(1))) {
            {package DB; () = caller(1)}
            CORE::pop @DB::args;

        } else {
            my $pkg = scalar caller(0);
            no strict 'refs';
            CORE::pop @{"$pkg\::ARGV"};
        }
    }
}

sub shift (;\[$@]) {
    if (@_) {
        my ($arrayref) = _to_ref(CORE::shift);
        CORE::shift @$arrayref;
    } else {
        # in subroutine
        if (defined(scalar caller(1))) {
            {package DB; () = caller(1)}
            CORE::shift @DB::args;

        } else {
            my $pkg = scalar caller(0);
            no strict 'refs';
            CORE::shift @{"$pkg\::ARGV"};
        }
    }
}

sub splice (\[$@];$$@) {
    my ($arrayref, $offset, $length, @list) = (_to_ref(CORE::shift), @_);
    
    if (!defined($offset)) {
        CORE::splice @$arrayref;

    } elsif (!defined($length)) {
        CORE::splice @$arrayref, $offset;

    } elsif (!@list) {
        CORE::splice @$arrayref, $offset, $length;
        
    } else {
        CORE::splice @$arrayref, $offset, $length, @list;
    }
}

sub keys (\[$@%]) {
    my ($list) = _to_ref(CORE::shift);
    ref($list) eq 'HASH' ? CORE::keys %$list
                         : CORE::keys @$list;
}
sub values (\[$@%]) {
    my ($list) = _to_ref(CORE::shift);
    ref($list) eq 'HASH' ? CORE::values %$list
                         : CORE::values @$list;
}

sub each (\[$@%]) {
    my ($list) = _to_ref(CORE::shift);
    ref($list) eq 'HASH' ? CORE::each %$list
                         : CORE::each @$list;
}

1;
__END__

=head1 NAME

List::AutoDeref - enable builtin functions that operate on array or hash containers to accept array or hash references

=head1 VERSION

This document describes List::AutoDeref version 0.01.

=head1 SYNOPSIS

    use List::AutoDeref qw/:all/;

    my $arrayref = [1..3];

    push    $arrayref, 4;
    unshift $arrayref, 5;
    pop     $arrayref;
    shift   $arrayref;

=head1 DESCRIPTION

This module enables builtin functions that operate on array or hash containers to accept array or hash references

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
