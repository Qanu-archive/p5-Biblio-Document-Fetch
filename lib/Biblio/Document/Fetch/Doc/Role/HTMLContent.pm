package Biblio::Document::Fetch::Doc::Role::HTMLContent;

use strict;
use warnings;
use Moo::Role;

has content => ( is => 'lazy' );

sub _build_content {
	my ($self) = @_;
	return $self->agent->get($self->uri)->decoded_content;
}

1;
