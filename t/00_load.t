#!/usr/bin/perl

use Test::More;
use LWP::UserAgent;
use lib 't/lib';

BEGIN { use_ok( 'Biblio::Document::Fetch' ); }
require_ok( 'Biblio::Document::Fetch' );

BEGIN { use_ok( 'Biblio::Document::Fetch::Query' ); }
require_ok( 'Biblio::Document::Fetch::Query' );

BEGIN { use_ok( 'Biblio::Document::Fetch::Query::Result' ); }
require_ok( 'Biblio::Document::Fetch::Query::Result' );

BEGIN { use_ok( 'Biblio::Document::Fetch::Query::ResultsPage' ); }
require_ok( 'Biblio::Document::Fetch::Query::ResultsPage' );

ok(defined(Biblio::Document::Fetch::Query->new( agent => LWP::UserAgent->new )), 'new query');

done_testing;
