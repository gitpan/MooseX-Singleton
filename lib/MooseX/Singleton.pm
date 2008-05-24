package MooseX::Singleton;
use Moose;
use MooseX::Singleton::Object;
use MooseX::Singleton::Meta::Class;

our $VERSION = 0.08;

sub import {
    my $caller = caller;

    Moose::init_meta($caller, 'MooseX::Singleton::Object', 'MooseX::Singleton::Meta::Class');

    Moose->import({into => $caller});
    strict->import;
    warnings->import;
}

no Moose;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton - turn your Moose class into a singleton

=head1 VERSION

Version 0.08, released 24 May 08

=head1 SYNOPSIS

    package MyApp;
    use MooseX::Singleton;

    has env => (
        is      => 'rw',
        isa     => 'HashRef[Str]',
        default => sub { \%ENV },
    );

    package main;

    delete MyApp->env->{PATH};
    my $instance = MyApp->instance;
    my $same = MyApp->instance;

=head1 DESCRIPTION

A singleton is a class that has only one instance in an application.
C<MooseX::Singleton> lets you easily upgrade (or downgrade, as it were) your
L<Moose> class to a singleton.

All you should need to do to transform your class is to change C<use Moose> to
C<use MooseX::Singleton>. This module uses a new class metaclass and instance
metaclass, so if you're doing metamagic you may not be able to use this.

C<MooseX::Singleton> gives your class an C<instance> method that can be used to get a handle on the singleton. It's actually just an alias for C<new>.

Alternatively, C<< YourPackage->method >> should just work. This includes
accessors.

=head1 TODO

=over

=item Always more tests and doc

=item Fix speed boost

C<instance> invokes C<new> every time C<< Package->method >> is called, which
incurs a nontrivial runtime cost. I've implemented a short-circuit for this
case, which does eliminate nearly all of the runtime cost. However, it's ugly
and should be fixed in a more elegant way.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Shawn M Moore E<lt>sartak@gmail.comE<gt>

=head1 SOME CODE STOLEN FROM

Anders Nor Berle E<lt>debolaz@gmail.comE<gt>

=head1 AND PATCHES FROM

Ricardo SIGNES E<lt>rjbs@cpan.orgE<gt>

Dave Rolsky E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007, 2008 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

