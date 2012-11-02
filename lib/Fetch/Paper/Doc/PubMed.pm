package Fetch::Paper::Doc::PubMed;
# TODO

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

extends 'Fetch::Paper::Doc';

has _content => ( is => 'rw' );

sub _build_info {
	my ($self) = @_;
}

1;
