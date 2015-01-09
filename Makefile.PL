use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;
WriteMakefile
(
  NAME         => 'Biblio-Document-Fetch',
  VERSION_FROM => 'lib/Biblio/Document/Fetch.pm',
  PREREQ_PM    => {
         'LWP'                      => '0.0',
         'LWP::Protocol::https'     => '0.0',
         'Moo'                      => '0.0',
         'HTML::TreeBuilder::XPath' => '0.0',
         'HTML::Form'               => '0.0',
         'Regexp::Common'           => '0.0',
         'Text::BibTeX'             => '0.0',
         'Try::Tiny'                => '0.0',
         'URI'                      => '0.0',
         'utf8::all'                => '0.0',
         'MooX::Types::MooseLike'   => '0.0',
         'File::Slurp'              => '0.0',
  },
  BUILD_REQUIRES => {
    'Test::More'    => '0.0',
    'Test::Deep'    => '0.0',
    'Data::Printer' => '0.0',
  },
);
