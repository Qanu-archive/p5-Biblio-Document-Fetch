#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use lib 't/lib';
use utf8::all;
use File::Slurp;

my $test_data = [
	{ uri => URI->new( q,http://www.sciencedirect.com/science/article/pii/S0925838803002378,), type => 'ScienceDirect', md5_hex => '4a4558d190ce1f3cb7b7498837375a84' },
	{ uri => URI->new( q,http://ieeexplore.ieee.org/xpl/articleDetails.jsp?tp=&arnumber=1176638,), type => 'IEEE', md5_hex => 'c938d4af7dabb630ef81228c1f07f27a' },
	{ uri => URI->new( q,http://www.springerlink.com/content/l31710138j271h72/,), type => 'SpringerLink', md5_hex => 'cea096bbd6f58b4c388299de540e03b7' },
];

plan tests => 6 + @$test_data;

BEGIN { use Biblio::Document::Fetch; }
require_ok( 'Biblio::Document::Fetch' );

BEGIN { use Biblio::Document::Fetch::Doc; }
require_ok( 'Biblio::Document::Fetch::Doc' );

BEGIN { use Biblio::Document::Fetch::Proxy; }
require_ok( 'Biblio::Document::Fetch::Proxy' );


my $fetch;
ok defined( $fetch = Biblio::Document::Fetch->new()), "create fetcher";
isa_ok($fetch->agent, 'LWP::UserAgent', "agent");

my $proxy;
ok defined( $proxy = Biblio::Document::Fetch::Proxy->new( fetch => $fetch )), "create proxy";

for my $test (@$test_data) {
	my $test_uri = $test->{uri};
	my $test_type = $test->{type};
	my $test_md5 = $test->{md5_hex};
	subtest $test_type => sub {
		plan tests => 5;
		my $doc;
		ok defined($doc = $fetch->doc( source => $test_type,
				uri => URI->new($test_uri), proxy => Biblio::Document::Fetch::Proxy->new(fetch => $fetch))), "Create $test_type doc";
		isa_ok( $doc, "Biblio::Document::Fetch::Doc::$test_type", "$test_type type");

		#use DDP; p $doc->agent;
		#use DDP; p $doc->ft_agent;

		my $pdf_response;
		is(($pdf_response = $doc->get_pdf)->code, 200, 'PDF status: OK');
		ok length $pdf_response->filename, 'PDF has filename';

		is md5_hex($pdf_response->decoded_content), $test_md5, 'PDF MD5 checksum';

		#use DDP; p $pdf_response->filename;
		write_file($pdf_response->filename, $pdf_response->decoded_content);

		my $fid = fork();
		if( not $fid ) {
			close $_ for (STDOUT,STDERR);
			exec('see', $pdf_response->filename);
		}
	}
}



done_testing;
