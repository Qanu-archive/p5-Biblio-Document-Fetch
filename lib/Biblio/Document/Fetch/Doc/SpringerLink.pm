package Biblio::Document::Fetch::Doc::SpringerLink;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use HTML::TreeBuilder::XPath;
use Regexp::Common qw /whitespace/;

extends 'Biblio::Document::Fetch::Doc';

has base_uri => ( is => 'ro', default => sub { URI->new('http://www.springerlink.com/') } );
has proxy_domain => ( is => 'ro', default => sub { 'www.springerlink.com' } );
has _abstract_content => ( is => 'lazy' );
has _abstract_uri => ( is => 'lazy' );

with qw(Biblio::Document::Fetch::Doc::Role::FullTextHTMLContentPDF
	Biblio::Document::Fetch::Doc::Role::ProxyDomain
	Biblio::Document::Fetch::Doc::Role::HTMLMetaTag);

sub _build_info {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->content );

	my $div_abstractText = $tree->findnodes('//div[contains(@class,"abstract-content")]')->[0];
	my $kw_node = $tree->findnodes('//ul[contains(@class,"abstract-keywords")')->[0];

	my @title = @{ $self->_meta_content($tree, "citation_title") };
	my @author = @{ $self->_meta_content($tree, "citation_author") };
	my $abstract = $div_abstractText->as_text;
	$abstract =~ s/$RE{ws}{crop}//g;
	my @keyword = map { $_->as_text } $kw_node->findnodes('li');

	# TODO
	#  <div class="heading enumeration">
	#        <div class="primary">
	#                <a lang="en" href="/content/978-3-540-35603-5/" title="Link to the Book of this Chapter">Mathematics and Democracy</a>
	#        </div><div class="secondary">
	#        <a lang="" href="/content/1614-0311/" title="Link to the Book Series of this Chapter">Studies in Choice and Welfare</a>, 2006, <span class="pagination">19-41</span>
	#        <span class="doi">, <span class="label">DOI:</span> <span class="value">10.1007/3-540-35605-3_2</span></span>
	#        </div>
	#</div><div class="heading primitive">
	#        <div class="coverImage" title="Cover Image" style="background-image: url(/content/g334k8/cover-medium.gif); background-size: contain;">
	return {
		title =>  \@title,
		author =>  \@author,
		#link =>  \@link,
		#text =>  \@text,
		abstract => $abstract,
		keywords =>  \@keyword,
	};
}
sub _build__abstract_content {
	my ($self) = @_;
	return $self->agent->get($self->_abstract_uri)->decoded_content;
}
sub _build__abstract_uri {
	my ($self) = @_;
	my $abstract = $self->uri->clone;
	$abstract->path_segments( $self->uri->path_segments, 'primary' ); 
	$abstract;
}

sub _tree_pdf_node {
	my ($self, $tree) = @_;
	return $tree->findnodes(q#//a[contains(@class,"pdf-resource-sprite")]#)->[0];
}
sub _content_has_pdf {
	my ($self, $content) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $content );
	my $node = $tree->findnodes(q#//div[contains(@class,"notRecognized")#)->[0];
	not defined $node; 
}
sub get_pdf_link {
	my ($self) = @_;
	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse( $self->_content_for_pdf );
	my $pdf_link = $self->_tree_pdf_node($tree);
	my $link = URI->new_abs($pdf_link->attr('href'), $self->base_uri) if $pdf_link->attr('href') =~ q/\.pdf$/;
	return $link;
}

around get_pdf => sub {
	my $orig = shift;
	my $self = shift;
	my $pdf_response = $orig->($self, @_);
	unless(length $pdf_response->filename and $pdf_response->filename ne 'fulltext.pdf') {
		my @p = $self->uri->path_segments;
		my ($id) = grep { $p[$_-1] eq 'content' } 1..$#p;
		my $filename = "$p[$id].pdf";
		$pdf_response->header('Content-Disposition' => qq/attachment; filename="$filename"/);
	}
	$pdf_response;
};

1;
