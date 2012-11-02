package Fetch::Paper::Doc::Role::ProxyDomain;

use strict;
use warnings;
use Moo::Role;
with ('Fetch::Paper::Doc::Role::FullText', 'Fetch::Paper::Doc::Role::Proxy');

has proxy_domain => ( is => 'ro' );

sub _build_ft_agent {
	my ($self) = @_;
	$self->proxy->add_host($self->proxy_domain);
	$self->proxy->agent;
}

1;
