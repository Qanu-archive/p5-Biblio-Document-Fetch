#!/usr/bin/perl

use Test::More;
use lib 't/lib';

BEGIN { use_ok( 'Biblio::Document::Fetch' ); }
require_ok( 'Biblio::Document::Fetch' );

BEGIN { use_ok( 'Biblio::Document::Fetch::Doc' ); }
require_ok( 'Biblio::Document::Fetch::Doc' );

BEGIN { use_ok( 'Biblio::Document::Fetch::Doc::ScienceDirect' ); }
require_ok( 'Biblio::Document::Fetch::Doc::ScienceDirect' );

my $fetch;
ok defined( $fetch = Biblio::Document::Fetch->new()), "create fetcher";
isa_ok($fetch->agent, LWP::UserAgent, "agent");

my $doc;
#my @do  = qw/ SpringerLink /;
my @do  = qw/ ScienceDirect IEEE SpringerLink /;

if(grep { /ScienceDirect/ } @do) {
	ok defined($doc = $fetch->doc('ScienceDirect',
		URI->new('http://www.sciencedirect.com/science/article/pii/S0925838803002378'))),
		'Create ScienceDirect doc';
	isa_ok( $doc, 'Biblio::Document::Fetch::Doc::ScienceDirect', 'ScienceDirect type');
	use DDP; p $doc->info;
}

if(grep { /IEEE/ } @do) {
	ok defined($doc = $fetch->doc('IEEE',
		URI->new('http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber=860044'))),
		'Create IEEE doc';
	isa_ok( $doc, 'Biblio::Document::Fetch::Doc::IEEE', 'IEEE type');
	use DDP; p $doc->info;
	#URI->new('http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=860044');
}


if(grep { /SpringerLink/ } @do) {
	ok defined($doc = $fetch->doc('SpringerLink',
		URI->new('http://www.springerlink.com/content/p4p7668165p03723/'))),
		'Create SpringerLink doc';
	isa_ok( $doc, 'Biblio::Document::Fetch::Doc::SpringerLink', 'SpringerLink type');
	use DDP; p $doc->info;
}

# http://www.springerlink.com/content/P4P7668165P03723/primary
# http://resources.metapress.com/pdf-preview.axd?code=p4p7668165p03723&size=smaller
# http://www.springerlink.com/content/p4p7668165p03723/about/
# http://www.springer.com/computer/book/978-1-4302-1059-7


done_testing;
