package Biblio::Document::Fetch::Doc::Role::PDF;

use strict;
use warnings;
use Moo::Role;
use HTTP::Response;

# TODO: add pdf_response, pdf attr
# add method to convert to text <http://stackoverflow.com/questions/1136990/how-can-i-extract-text-from-a-pdf-file-in-perl>

sub get_pdf { return HTTP::Response->new( 404 ); }

1;
