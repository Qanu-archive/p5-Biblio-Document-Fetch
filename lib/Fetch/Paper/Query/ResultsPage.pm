package Fetch::Paper::Query::ResultsPage;

use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);

has query => ( is => 'rw', isa => InstanceOf['Fetch::Paper::Query::Google::Scholar']);

has entries => ( is => 'lazy', isa => ArrayRef['Fetch::Paper::Query::Result'] );

has next_page => ( is => 'lazy', isa => Maybe['Fetch::Paper::Query::ResultsPage'] );

has previous_page => ( is => 'lazy', isa => Maybe['Fetch::Paper::Query::ResultsPage'] );

has page_number => ( is => 'lazy', isa => Int );

has total_entries => ( is => 'lazy', isa => Maybe[Int] );

1;
