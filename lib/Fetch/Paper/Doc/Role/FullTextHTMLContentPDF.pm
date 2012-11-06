package Fetch::Paper::Doc::Role::FullTextHTMLContentPDF;

use strict;
use warnings;
use Moo::Role;

with ('Fetch::Paper::Doc::Role::FullTextHTMLContent',
	'Fetch::Paper::Doc::Role::HTMLContent',
	'Fetch::Paper::Doc::Role::PDF');

has _content_for_pdf => ( is => 'lazy' );

requires qw( _content_has_pdf );

# sub _content_has_pdf { my ($self, $content) = @_; undef; }

sub get_pdf_link { undef; }

sub _agent_for_pdf {
	my ($self) = @_;
	return $self->agent if($self->_content_has_pdf($self->content));
	$self->ft_agent;
}

sub _build__content_for_pdf {
	my ($self) = @_;
	return $self->content if($self->_content_has_pdf($self->content));
	$self->_ft_content;
}

sub get_pdf {
	my ($self, @opt) = @_;
	my $agent = $self->_agent_for_pdf;
	my $link = $self->get_pdf_link;
	my $response = $agent->get($link, @opt) if defined $link;
	$response;
}

1;
