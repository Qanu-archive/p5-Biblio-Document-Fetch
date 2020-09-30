package Biblio::Document::Fetch::Query::Google::Scholar::Result;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use URI;
use URI::QueryParam;

extends 'Biblio::Document::Fetch::Query::Result';

has entry_data => ( is => 'rw', isa => InstanceOf['HTML::Element'] );

sub _build_info {
	my ($self) = @_;
	my @title_nodes = $self->entry_data->findnodes('//h3[contains(@class,"gs_rt")]');
	my @links_nodes = $self->entry_data->findnodes('//h3[contains(@class,"gs_rt")]//a');
	my @author_nodes = $self->entry_data->findnodes('//div[contains(@class,"gs_a")]');
	my @text_nodes = $self->entry_data->findnodes('//div[contains(@class,"gs_rs")]');
	my @title;
	for my $title_node (@title_nodes) {
		my @citation_text_nodes = $title_node->findnodes(q{./span[ @class =~ /gs_ctu/ ]});
		$_->delete for @citation_text_nodes;
		push @title, $_->as_text for @title_nodes;
	}
	my @link; push @link, $self->_clean_link(URI->new($_->attr('href'))) for @links_nodes;
	my @author; push @author, $_->as_text for @author_nodes;
	my @text; push @text, $_->as_text for @text_nodes;
	(my $cited_by =
		$self->entry_data->findnodes('//a[contains(text(),"Cited by")]')
		->[0]->as_text)
		=~ s,Cited by ,,g;
	my $info =  {
		title =>  \@title,
		author =>  \@author,
		link =>  \@link,
		text =>  \@text,
	};
	$info->{cited_count} = $cited_by if $cited_by;
	return $info;
}

sub _clean_link {
	my ($self, $uri) = @_;
	if( $uri->host eq 'books.google.com' ) {
		#my @values = $uri->query_param( 'sig' );
		$uri->query_param_delete('sig');
		#my $v = \@values;
		#use DDP; p $v;
	}
	return $uri;
}

1;
