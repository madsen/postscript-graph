use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'PostScript::Graph',
    'VERSION_FROM'	=> 'XY.pm', # finds $VERSION
    'PREREQ_PM'		=> { Text::CSV_XS => 0,
			     Date::Pcalc => 0,
			     PostScript::File  => 0.10,
			   },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (AUTHOR     => 'Christopher Willmot <chris@willmot.co.uk>') : ()),
);
