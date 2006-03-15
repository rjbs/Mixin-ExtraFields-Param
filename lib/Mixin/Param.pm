package Mixin::Param;

use warnings;
use strict;

use Carp ();
use Scalar::Util ();
use Tie::RefHash::Weak;

use Sub::Exporter -setup => {
  exports  => [ qw(param) ],
  groups   => { default => [ qw(param) ] },
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
provided by L<CGI>, L<CGI::Application>, and other classes.

=head1 METHODS

=head2 C< param >

 my @params = $object->param;        # get names of existing params

 my $value = $object->param('name'); # get value of a param

 my $value = $object->param(name => $value); # set a param's value

 my @values = $object->param(n1 => $v1, n2 => $v2, ...); # set many values

=cut

my %_params_for;
BEGIN { tie %_params_for, 'Tie::RefHash::Weak'; }

sub __params_storage_guts { %_params_for }

sub param {
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
}

=head2 C< delete_param >

 my $deleted = $object->delete_param('name'); # delete the param entirely

 my @deleted = $object->delete_param(@names); # delete several params

 my $deleted = $object->delete_param(@names); # returns the first deleted value

=cut

sub delete_param {
  my $self = shift;
  my (@keys) = @_;
  
  Carp::croak "delete_param is an instance method"
    unless Scalar::Util::blessed($self);

  my $stash = $_params_for{ $self } ||= {};

  my @deleted = map { scalar delete $stash->{$_} } @keys;

  return wantarray ? @deleted : $deleted[0];
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
