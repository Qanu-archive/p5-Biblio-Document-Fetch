package Biblio::Document::Fetch::Query::ResultsPage;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

has query => ( is => 'rw', isa => InstanceOf['Biblio::Document::Fetch::Query::Google::Scholar']);

has entries => ( is => 'lazy', isa => ArrayRef[InstanceOf['Biblio::Document::Fetch::Query::Result']] );

has next_page => ( is => 'lazy', isa => Maybe[InstanceOf['Biblio::Document::Fetch::Query::ResultsPage']] );

has previous_page => ( is => 'lazy', isa => Maybe[InstanceOf['Biblio::Document::Fetch::Query::ResultsPage']] );

has page_number => ( is => 'lazy', isa => Int );

has total_entries => ( is => 'lazy', isa => Maybe[Int] );

1;
