package Biblio::Document::Fetch::Query;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

with qw(Biblio::Document::Fetch::Role::Agent);

before agent => sub {
	$_[0] = $_[0]->clone if $@;
};

# return a list of Paper
sub query {
	my ($self, $query) = @_;
}

1;
