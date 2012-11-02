package Fetch::Paper::Doc::Role::BibTeX;

use strict;
use warnings;
use Moo::Role;
use Text::BibTeX;
use MooX::Types::MooseLike::Base qw(:all);

has bibtex => ( is => 'lazy', isa => InstanceOf['Text::BibTeX::Entry'] );

1;
