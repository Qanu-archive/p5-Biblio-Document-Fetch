package Biblio::Document::Fetch;

use strict;
use warnings;

our $VERSION = '0.01';

use Biblio::Document::Fetch::Extension;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use LWP::UserAgent;
use Module::Load;
use Try::Tiny;
use Carp;

with qw(Biblio::Document::Fetch::Role::Agent);

sub _build_agent {
	my $ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0 Firefox/2.5'); # TODO
	#$ua->agent('Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/12.0 Iceweasel/12.0'); # TODO
	return $ua;
}

sub query_object {
	my ($self, $source ) = @_;
	my $source_module = __PACKAGE__."::Query::".$source;
	try { load "$source_module"; } catch { croak "Could not load module: $_"; };
	return $source_module->new( agent => $self->agent->clone );
}

sub doc {
	my ($self, %args) = @_;
	my $source = delete $args{source};
	my $uri = delete $args{uri};
	my $source_module = __PACKAGE__."::Doc::".$source;
	try { load "$source_module"; } catch { croak "Could not load module: $_"; };
	return $source_module->new( agent => $self->agent->clone, uri => $uri, %args );
}

sub query {
	my ($self, $source, $query ) = @_;
	return $self->query_object( $source )->query( $query );
}

1;
