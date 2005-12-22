package Does::Param;

use warnings;
use strict;

=head1 NAME

Does::Param - make your class provide a familiar "param" method

=head1 VERSION

version 0.01

 $Id$

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

  package Widget::Parametric;
  use Does::Param;

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

sub param {

}

=head1 AUTHOR

Ricardo Signes, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-does-param@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2005 Ricardo Signes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
