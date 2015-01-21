package Biblio::Document::Fetch::Role::Agent;

use strict;
use warnings;
use Moo::Role;
use MooX::Types::MooseLike::Base qw(:all);

has agent => ( is => 'rw', builder => 1, isa => InstanceOf['LWP::UserAgent'] );

1;
