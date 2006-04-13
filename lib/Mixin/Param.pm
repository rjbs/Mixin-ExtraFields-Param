package Mixin::Param;

use warnings;
use strict;

use Carp ();
use Scalar::Util ();
use Tie::RefHash::Weak;

use Sub::Exporter -setup => {
  groups   => {
    default => [ '-param' ],
    param   => \&_param_gen,
  },
};

=head1 NAME

Mixin::Param - make your class provide a familiar "param" method

=head1 VERSION

version 0.01

 $Id$

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

  package Widget::Parametric;
  use Mixin::Param;

  ...

  my $widget = Widget::Parametric->new({ flavor => 'vanilla' });

  printf "%s: %s\n", $_, $widget->param($_) for $widget->param;

=head1 DESCRIPTION

This module mixes in to your class to provide a C<param> method like the ones
provided by L<CGI>, L<CGI::Application>, and other classes.  It doesn't store
any information on your object, so it can work on any sort of object.  It
doesn't need a DESTROY method, so you don't need to worry about cleaning up
your Mixin::Param values when your object is destroyed.

By default, the methods provided are:

=over

=item * param

=item * has_param

=item * delete_param

=back

These are documented below.  They are mixed in by default if you use
Mixin::Param.  You can also import them explicitly by importing the "param"
group.  These group can be passed a hashref of named arguments; see
L<Sub::Exporter> for more information on how it works.  One important argument
is "noun", which changes the names of the methods by replacing "param" with the
value of the "noun" argument.

If the "param" group is imported multiple times with different noun values, the
methods will operate on distinct sets of data.

=head1 METHODS

=cut

sub _param_gen {
  my (undef, undef, $arg) = @_;
  my $P = $arg->{noun} || 'param';

  tie my %_params_for, 'Tie::RefHash::Weak';

  my %sub;

  $sub{"__$P\_storage_guts"} = sub { %_params_for };

=head2 param

 my @params = $object->param;        # get names of existing params

 my $value = $object->param('name'); # get value of a param

 my $value = $object->param(name => $value); # set a param's value

 my @values = $object->param(n1 => $v1, n2 => $v2, ...); # set many values

This method sets or retrieves parameters.

=cut

  $sub{$P} = sub {
    my $self = shift;
    
    Carp::croak "param is an instance method" unless Scalar::Util::blessed($self);

    my $stash = $_params_for{ $self } ||= {};

    return keys %$stash unless @_;

    @_ = %{$_[0]} if @_ == 1 and ref $_[0] eq 'HASH';
    
    Carp::croak "invalid call to param: odd, non-one number of params"
      if @_ > 1 and @_ % 2 == 1;

    if (@_ == 1) {
      my $key = $_[0];
      return unless exists $stash->{$key};
      return $stash->{$key};
    }

    my @assigned;
    while (@_) {
      # We don't put @_ into a hash because we guarantee processing (and more
      # importantly return) order. -- rjbs, 2006-03-14
      my ($key, $value) = splice @_, 0, 2;
      $stash->{$key} = $value;
      push @assigned, $value;
    }
    return wantarray ? @assigned : $assigned[0];
  };

=head2 delete_param

 my $deleted = $object->delete_param('name'); # delete the param entirely

 my @deleted = $object->delete_param(@names); # delete several params

 my $deleted = $object->delete_param(@names); # returns the first deleted value

This method deletes any entry for the named parameter(s).

=cut

  $sub{"delete_$P"} = sub {
    my $self = shift;
    my (@keys) = @_;
    
    Carp::croak "delete_param is an instance method"
      unless Scalar::Util::blessed($self);

    my $stash = $_params_for{ $self } ||= {};

    my @deleted = map { scalar delete $stash->{$_} } @keys;

    return wantarray ? @deleted : $deleted[0];
  };

=head2 C< has_param >

  if ($object->has_param($name) { ... }

This method is true if the named parameter exists in the object's set of
parameters, even if it is undefined.

=cut

  $sub{"has_$P"} = sub {
    my ($self, $key) = @_;
    
    Carp::croak "delete_param is an instance method"
      unless Scalar::Util::blessed($self);

    my $stash = $_params_for{ $self } ||= {};

    return exists $stash->{$key};
  };

  return \%sub;
}

=head1 AUTHOR

Ricardo Signes, C<< <rjbs@cpan.org> >>

=head2 THANKS

Thanks to Yuval Kogman, not only for writing Tie::WeakRefHash, but for pointing
it out to me when I said that someone should write it.

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mixin-param@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2005-2006 Ricardo Signes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
