package Biblio::Document::Fetch::Query::Google::Scholar::ResultsPage;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use URI;
use HTML::TreeBuilder::XPath;
use Biblio::Document::Fetch::Query::Google::Scholar::Result;
use Try::Tiny;
use Carp;

use HTTP::Response;

extends 'Biblio::Document::Fetch::Query::ResultsPage';

has response => ( is => 'rw', isa => InstanceOf['HTTP::Response'] );
has tree => ( is => 'lazy' );


sub _build_entries {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->response->decoded_content );
	my @nodes = $tree->findnodes('//div[@class="gs_r"]');
	return [ map { Biblio::Document::Fetch::Query::Google::Scholar::Result->new( entry_data => $_ ) }
	 ( @nodes ) ];
}

sub _build_next_page {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->response->decoded_content );
	my @next_link = $tree->findnodes('//span[contains(@class,"gs_ico_nav_next")]/parent::*');
	return undef unless @next_link;
	my $next_uri = URI->new_abs( $next_link[0]->attr('href'), $self->response->base );
	my $res = try { $self->query->get($next_uri); } catch { carp "Not able to retrieve next page: $_"; };
	my $results;
	$results = Biblio::Document::Fetch::Query::Google::Scholar::ResultsPage->new( query => $self->query,
		response => $res ) if defined $res;
	return $results;
}

sub _build_previous_page {
	# TODO cache?
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->response->decoded_content );
	my @prev_link = $tree->findnodes('//a/span[contains(@class,"gs_ico_nav_previous")]/parent::*');
	return undef unless @prev_link;
	my $prev_uri = URI->new_abs( $prev_link[0]->attr('href'), $self->response->base );
	my $res = try { $self->query->get($prev_uri); } catch { carp "Not able to retrieve previous page: $_"; };
	my $results;
	$results = Biblio::Document::Fetch::Query::Google::Scholar::ResultsPage->new( query => $self->query,
		response => $res) if defined $res;
	return $results;
}


1;
