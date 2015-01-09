package Biblio::Document::Fetch::Doc::Role::ProxyDomain;

use strict;
use warnings;
use Moo::Role;
with ('Biblio::Document::Fetch::Doc::Role::FullText', 'Biblio::Document::Fetch::Doc::Role::Proxy');

has proxy_domain => ( is => 'ro' );

sub _build_ft_agent {
	my ($self) = @_;
	$self->proxy->add_host($self->proxy_domain);
	$self->proxy->agent;
}

1;
