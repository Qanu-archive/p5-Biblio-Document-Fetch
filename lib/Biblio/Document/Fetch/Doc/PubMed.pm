package Biblio::Document::Fetch::Doc::PubMed;
# TODO

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

extends 'Biblio::Document::Fetch::Doc';

has _content => ( is => 'rw' );

sub _build_info {
	my ($self) = @_;
}

1;
