package Biblio::Document::Fetch::Doc;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

with qw(Biblio::Document::Fetch::Role::Agent);

has uri => ( is => 'rw', isa => InstanceOf['URI'] );

has info => ( is => 'lazy', isa => HashRef ); # TODO

1;
