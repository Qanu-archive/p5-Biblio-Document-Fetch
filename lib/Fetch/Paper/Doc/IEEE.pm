package Fetch::Paper::Doc::IEEE;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use HTML::TreeBuilder::XPath;
use Regexp::Common qw /whitespace/;
use Carp;
use Try::Tiny;

extends 'Fetch::Paper::Doc';
with ('Fetch::Paper::Doc::Role::FullTextHTMLContentPDF',
	'Fetch::Paper::Doc::Role::ProxyDomain');

has base_uri => ( is => 'ro', default => sub { URI->new('http://ieeexplore.ieee.org/') } );
has proxy_domain => ( is => 'ro', default => sub { 'ieeexplore.ieee.org' } );

sub _build_info {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->content );


	# <meta name="citation_author" content="Lin Jia Jun">
	# <meta name="citation_author_institution" content="Res. Inst. of Autom., ECUST, Shanghai">
	# <meta name="citation_author" content="Liu Rui Ming">
	# <meta name="citation_author" content="Le Hui Feng">
	# <meta name="citation_author" content="Yu Jin Shou">

	my @abstract_nodes = $tree->findnodes('//div[contains(@class,"abstract")]');
	my $abstract; $abstract .= $_->as_text for @abstract_nodes;
	$abstract =~ s/^Abstract//g;
	$abstract =~ s/$RE{ws}{crop}//g;
	return {
		title => $self->_meta_content($tree, "citation_title"),
		date => $self->_meta_content($tree, "citation_date"),
		volume => $self->_meta_content($tree, "citation_volume"),
		issue => $self->_meta_content($tree, "citation_issue"),
		first_page => $self->_meta_content($tree, "citation_firstpage"),
		last_page => $self->_meta_content($tree, "citation_lastpage"),
		doi => $self->_meta_content($tree, "citation_doi"),
		#abstract_html_url => $self->_meta_content($tree, "citation_abstract_html_url"),
		#pdf_url => $self->_meta_content($tree, "citation_pdf_url"),
		issn => $self->_meta_content($tree, "citation_issn"),
		isbn => $self->_meta_content($tree, "citation_isbn"),
		language => $self->_meta_content($tree, "citation_language"),
		keywords => [ map {s/$RE{ws}{crop}//g; $_} split ';', $self->_meta_content($tree, "citation_keywords") ],
		conference => $self->_meta_content($tree, "citation_conference"),
		publisher => $self->_meta_content($tree, "citation_publisher"),
		author => [ map { $_->attr('content') }
			$tree->findnodes('//meta[@name = "citation_author"]') ],
		abstract => $abstract,
	};
}
sub _meta_content {
	my ($self, $tree, $name) = @_;
	return [$tree->findnodes("//meta[\@name = '$name']")]->[0]->attr('content');
}
sub _tree_pdf_node {
	my ($self, $tree) = @_;
	return $tree->findnodes(q#//a[contains(@href,"stamp.jsp")]#)->[0];
}
sub _content_has_pdf {
	my ($self, $content) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $content );
	my $node = $self->_tree_pdf_node($tree);
	return $node->as_text =~ /Access Full Text in PDF/ if defined $node;
	return;
}
sub get_pdf_link {
	my ($self) = @_;

	my $tree = HTML::TreeBuilder::XPath->new;
	my $link;
	my $pdf_page;

	try {
		$tree->parse( $self->_content_for_pdf );
		my $pdf_link = $self->_tree_pdf_node($tree);
		$link = URI->new_abs($pdf_link->attr('href'), $self->base_uri);
		$pdf_page = $self->_agent_for_pdf->get($link);
	} catch {
		croak "Could not get PDF: $@";
	};

	$tree->parse( $pdf_page->decoded_content );
	my $pdf_file = $tree->findnodes(q#//frame[contains(@src,".pdf")]#)->[0];
	$link = URI->new($pdf_file->attr('src'));

	return $link;
}

1;
