package Biblio::Document::Fetch::Query::Google::Scholar;

use strict;
use warnings;
use Moo;
extends 'Biblio::Document::Fetch::Query';

use URI;
use URI::QueryParam;
use Biblio::Document::Fetch::Query::Google::Scholar::ResultsPage;
use Carp;
use Try::Tiny;
use Digest::MD5;
use HTML::Form;


use constant QUERY_URL => URI->new('http://scholar.google.com/scholar');
use constant QUERY_PARAM => 'q';
use constant NUMBER_PARAM => (num => 20);
	# TODO, this could be configurable, but not needed? Maximising this minimises queries
use constant COOKIE_CITE_RIS_ID => 2;
use constant COOKIE_CITE_BIBTEX_ID => 4;

has header => ( is => 'lazy' );

sub query {
	my ($self, $query ) = @_;
	my $uri = QUERY_URL->clone;
	$uri->query_param(QUERY_PARAM, $query); # want the constant (not =>)
	$uri->query_param(NUMBER_PARAM);
	my $response = $self->get($uri);
	my $results;
	$results = Biblio::Document::Fetch::Query::Google::Scholar::ResultsPage->new(query => $self,
		response => $response) if defined $response;
	return $results;
}

sub _build_header {
	return [ 'Cookie' => "GSP=ID=@{[unpack('h*',pack('d',rand()))]}:CF=@{[COOKIE_CITE_BIBTEX_ID]}" ];
}

sub get {
	my ($self, $uri, @rest ) = @_;
	my $response = try {
		$self->agent->get($uri, @{$self->header}, @rest);

	} catch {
		croak "Error: $_";
	};
	$response;
}

# TODO consolidate all HTTP GETs?


1;
