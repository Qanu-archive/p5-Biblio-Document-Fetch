package Biblio::Document::Fetch::Doc::Role::HTMLMetaTag;

use strict;
use warnings;
use Moo::Role;

sub _meta_content {
	my ($self, $tree, $name) = @_;
	my @meta_nodes = $tree->findnodes("//meta[\@name = '$name']");
	if(@meta_nodes) {
		return [ map { $_->attr('content') } @meta_nodes ];
	}
	warn "could not find any meta info for $name";
	undef;
}

1;
