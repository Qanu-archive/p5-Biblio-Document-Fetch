#!/usr/bin/perl

use Test::More;
use LWP::UserAgent;
use lib 't/lib';

BEGIN { use_ok( 'Fetch::Paper' ); }
require_ok( 'Fetch::Paper' );

BEGIN { use_ok( 'Fetch::Paper::Query' ); }
require_ok( 'Fetch::Paper::Query' );

BEGIN { use_ok( 'Fetch::Paper::Query::Result' ); }
require_ok( 'Fetch::Paper::Query::Result' );

BEGIN { use_ok( 'Fetch::Paper::Query::ResultsPage' ); }
require_ok( 'Fetch::Paper::Query::ResultsPage' );

ok(defined(Fetch::Paper::Query->new( agent => LWP::UserAgent->new )), 'new query');

done_testing;
