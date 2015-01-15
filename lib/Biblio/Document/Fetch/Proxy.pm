package Biblio::Document::Fetch::Proxy;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

use LWP::UserAgent;
use Try::Tiny;
use Carp;

use constant EZPROXY_LOGIN => q,https://login.ezproxy.lib.uh.edu/login,;
use constant EZPROXY_APPEND => q,.ezproxy.lib.uh.edu,;

has fetch => ( is => 'rw' );
has agent => ( is => 'rw', builder => "_build_agent", lazy => 1 );
has _hosts => ( is => 'rw', isa => ArrayRef ); # TODO use a set

has _logged_in => ( is => 'rw' );

sub add_host {
	my ($self, $host ) = @_;
	my $hosts = $self->_hosts;
	return if grep { $host } @$hosts;
	push @$hosts, $host; $self->_hosts($hosts);
	$self->agent->add_handler(
		request_prepare => sub {
			my($request, $ua, $h) = @_; 
			my $new_uri = $request->uri->clone;
			$new_uri->host($new_uri->host . EZPROXY_APPEND);
			$request->uri($new_uri);
		}, m_host => $host
	);
}

sub _build_agent {
	my ($self) = @_;
	my $agent = $self->fetch->agent->clone;
	$self->_logged_in(0);
	$agent;
}

sub _around_login_for_agent {
	my $orig = shift;
	my $self = shift;
	my $agent = $orig->($self, @_);
	$self->login($agent);
	$agent;
}

around _build_agent => sub { &_around_login_for_agent };

around agent => sub {
	return $_[0]->($_[1]) unless $_[1]; # $orig->($self) unless @_;
	&_around_login_for_agent;
};

sub login {
	my ($self, $agent) = @_;
	$agent->cookie_jar({}) unless defined $agent->cookie_jar;
	$agent->get(EZPROXY_LOGIN);
	
	my $response;
	try {
		$response = $agent->post(EZPROXY_LOGIN,
			{user => $ENV{UH_COUGARNET_USER},
			pass => $ENV{UH_COUGARNET_PASS}},);
		croak "Invalid user/password\n" unless $response->code == 302;
	} catch {
		croak "Can not login: $_\n";
	};
	$self->_logged_in(1);
	$response;
}

1;
