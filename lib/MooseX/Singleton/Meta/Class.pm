#!/usr/bin/env perl
package MooseX::Singleton::Meta::Class;
use Moose;
use MooseX::Singleton::Meta::Instance;
use MooseX::Singleton::Meta::Method::Constructor;

extends 'Moose::Meta::Class';

sub initialize {
    my $class = shift;
    my $pkg   = shift;

    my $self = $class->SUPER::initialize(
        $pkg,
        instance_metaclass => 'MooseX::Singleton::Meta::Instance',
        constructor_class  => 'MooseX::Singleton::Meta::Method::Constructor',
        @_,
    );

    return $self;
}

sub existing_singleton {
    my ($class) = @_;
    my $pkg = $class->name;

    no strict 'refs';

    # create exactly one instance
    if (defined ${"$pkg\::singleton"}) {
        return ${"$pkg\::singleton"};
    }

    return;
}

sub clear_singleton {
    my ($class) = @_;
    my $pkg = $class->name;
    no strict 'refs';
    undef ${"$pkg\::singleton"};
}

override _construct_instance => sub {
    my ($class) = @_;

    # create exactly one instance
    my $existing = $class->existing_singleton;
    return $existing if $existing;

    my $pkg = $class->name;
    no strict 'refs';
    return ${"$pkg\::singleton"} = super;
};

no Moose;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Meta::Class

=head1 DESCRIPTION

This metaclass is where the forcing of one instance occurs. The first call to
C<construct_instance> is run normally (and then cached). Subsequent calls will
return the cached version.

=cut
