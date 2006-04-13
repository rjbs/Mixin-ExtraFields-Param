#!perl -T
use strict;
use warnings;

use Test::More tests => 3;

{
  package Widget::Parameterized;
  use Mixin::Param;

  sub new { bless {} => shift; }
}

{
  my $widget = Widget::Parameterized->new;
  $widget->param(flavor => 'teaberry');
  $widget->param(size => 'big', limits => undef);

  my %guts = Widget::Parameterized->__param_storage_guts;
  ok(scalar %guts, "there are some params being stored universally (duh)");
  ok($guts{$widget}, "the widget has some params");
}

my %guts = Widget::Parameterized->__param_storage_guts;
ok(!(scalar %guts), "post GC, there are no params being stored universally");
