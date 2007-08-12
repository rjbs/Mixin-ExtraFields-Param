use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Mixin::ExtraFields::Param',
    AUTHOR              => 'Ricardo SIGNES <rjbs@cpan.org>',
    VERSION_FROM        => 'lib/Mixin/ExtraFields/Param.pm',
    ABSTRACT_FROM       => 'lib/Mixin/ExtraFields/Param.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Mixin::ExtraFields' => 0.002,
        'Sub::Exporter'      => 0.90,
        'Test::More'         => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Mixin-ExtraFields-Param-* cover_db' },
);
