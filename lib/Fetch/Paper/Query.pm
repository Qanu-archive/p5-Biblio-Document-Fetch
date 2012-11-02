package Fetch::Paper::Query;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

has agent => ( is => 'rw', isa => InstanceOf['LWP::UserAgent'] );

before agent => sub {
	$_[0] = $_[0]->clone if $@;
};

# return a list of Paper
sub query {
	my ($self, $query) = @_;
}

1;
