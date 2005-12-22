use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Mixin::Param',
    AUTHOR              => 'Ricardo Signes <rjbs@cpan.org>',
    VERSION_FROM        => 'lib/Mixin/Param.pm',
    ABSTRACT_FROM       => 'lib/Mixin/Param.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Scalar::Util'      => 0,
        'Sub::Install'      => 0.03,
        'Test::More'        => 0,
        'Tie::RefHash:Weak' => 0.01,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Mixin-Param-* cover_db' },
);
