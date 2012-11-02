package Fetch::Paper::Query::Result;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

has info => ( is => 'lazy', isa => HashRef ); # TODO

1;
