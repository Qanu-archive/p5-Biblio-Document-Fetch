package Biblio::Document::Fetch::Doc;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

has agent => ( is => 'rw', isa => InstanceOf['LWP::UserAgent'] );

has uri => ( is => 'rw', isa => InstanceOf['URI'] );

has info => ( is => 'lazy', isa => HashRef ); # TODO

1;
