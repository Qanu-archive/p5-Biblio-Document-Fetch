package Biblio::Document::Fetch::Doc::Role::FullTextHTMLContent;

use strict;
use warnings;
use Moo::Role;

with ('Biblio::Document::Fetch::Doc::Role::FullText');

has _ft_content => ( is => 'rw', builder => "_build__ft_content", lazy => 1 );

sub _build__ft_content {
	my ($self) = @_;
	return $self->ft_agent->get($self->uri)->decoded_content;
}

1;
