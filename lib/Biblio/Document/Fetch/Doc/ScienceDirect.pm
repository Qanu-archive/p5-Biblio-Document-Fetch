package Biblio::Document::Fetch::Doc::ScienceDirect;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use HTML::TreeBuilder::XPath;
use List::Util qw/first/;
use Try::Tiny;

extends 'Biblio::Document::Fetch::Doc';

has proxy_domain => ( is => 'ro', default => sub { 'www.sciencedirect.com' } );

with ('Biblio::Document::Fetch::Doc::Role::FullTextHTMLContentPDF',
	'Biblio::Document::Fetch::Doc::Role::ProxyDomain');

around uri => sub {
	my $orig = shift;
	my $self = shift;
	my $uri = $orig->($self, @_);

	# Need to add this so that non-progressive mode is enabled.
	#
	# > This page uses JavaScript to progressively load the article content as a
	# > user scrolls.  Screen reader users, click the load entire article button
	# > to bypass dynamically loaded article content.
	$uri->query_form( np => 'y' );

	$uri;
};

sub _build_info {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->content );

	my @title_nodes = $tree->findnodes('//h1[contains(@class,"svTitle")]');
	my @author_nodes = $tree->findnodes('//a[contains(@class,"authorName")]');
	my @abstract_nodes = $tree->findnodes('//div[contains(@class,"abstract")]');
	my $doi_text = ($self->content =~ /SDM\.doi\s*=\s*'(\S*)';/m)[0];
	my @kw_nodes = $tree->findnodes('//ul[contains(@class,"keyword")]/li');

	my @title; push @title, $_->as_text for @title_nodes;
	my @author; push @author, $_->as_text for @author_nodes;
	my $abstract = ''; $abstract .= $_->as_text for @abstract_nodes;
	$abstract =~ s/^Abstract//;
	my @keyword; push @keyword, $_->as_text for @kw_nodes;
	s/;\s+$//g for @keyword;
	my $doi = URI->new($doi_text, 'doi');
	return {
		title => \@title,
		author => \@author,
		abstract => $abstract,
		keywords => \@keyword,
		doi => $doi,
	};
}
sub _tree_pdf_node {
	my ($self, $tree) = @_;
	return $tree->findnodes(q#//a[contains(@id,"pdfLink")]#)->[0];
}
sub _content_has_pdf {
	my ($self, $content) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $content );
	$self->_tree_pdf_node($tree)->as_text =~ /PDF/;
}
sub get_pdf_link {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->_content_for_pdf );
	my $pdf_link = $self->_tree_pdf_node($tree);
	my $link = URI->new($pdf_link->attr('href')) if $pdf_link->attr('href') =~ q/\.pdf$/;
	return $link;
}

1;
