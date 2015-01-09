#!/usr/bin/perl

use Test::More;
use Test::Deep;
use lib 't/lib';

use Storable qw/dclone/;

BEGIN { use_ok( 'Biblio::Document::Fetch' ); }
require_ok( 'Biblio::Document::Fetch' );

BEGIN { use_ok( 'Biblio::Document::Fetch::Query::Google::Scholar' ); }
require_ok( 'Biblio::Document::Fetch::Query::Google::Scholar' );

my $fetch;
ok defined( $fetch = Biblio::Document::Fetch->new()), "create fetcher";
isa_ok($fetch->agent, LWP::UserAgent, "agent");

my $first_page;
ok defined( $first_page = $fetch->query('Google::Scholar', 'test' )), "Google::Scholar first page";
#use DDP; p $first_page->response->decoded_content;
#use DDP; p $_->info for @{$first_page->entries};
is( @{$first_page->entries}, 100, 'Google::Scholar first page entries length');

is($first_page->previous_page, undef, "Google::Scholar non-existent page -1");

my $next_page;
ok defined($next_page = $first_page->next_page), 'Google::Scholar page 2';
#use DDP; p $_->info for @{$next_page->entries};
is( @{$next_page->entries}, 100, 'Google::Scholar 2nd page entries length');

my $first_page_copy;
ok defined($first_page_copy = $next_page->previous_page), "Google::Scholar request page 1 (copy) from page 2";
is($first_page_copy->previous_page, undef, "Google::Scholar (copy) non-existent page -1");
is( @{$first_page_copy->entries}, 100, 'Google::Scholar first page (copy) entries length');

# clear out entry data as we are not comparing these
$first_page_e = dclone($first_page->entries);
$first_page_c_e = dclone($first_page_copy->entries);
delete $_->{entry_data} for @$first_page_e;
delete $_->{entry_data} for @$first_page_c_e;
cmp_deeply( $first_page_e, $first_page_c_e, 'Google::Scholar first page copy' );

ok($first_page->response->decoded_content =~ 'Import into BibTeX', 'Google::Scholar page 1 contains BibTeX link');
ok($next_page->response->decoded_content =~ 'Import into BibTeX', 'Google::Scholar page 2 contains BibTeX link');
ok($first_page_copy->response->decoded_content =~ 'Import into BibTeX', 'Google::Scholar page 1 (copy) contains BibTeX link');


done_testing;
