use ExtUtils::MakeMaker;
WriteMakefile(
    NAME	=> 'PostScript::Graph',
    VERSION	=> '0.1',
    ABSTRACT	=> 'Bar, line and scatter graphs from CSV to PostScript files',
    PREREQ_PM	=> { Text::CSV_XS => 0,
		     Date::Pcalc => 0,
		     PostScript::File  => 0.10,
		   },
    PM	=> {
	'Graph/Bar.pm'   => '$(INST_LIBDIR)/Graph/Bar.pm',
	'Graph/Key.pm'   => '$(INST_LIBDIR)/Graph/Key.pm',
	'Graph/Paper.pm' => '$(INST_LIBDIR)/Graph/Paper.pm',
	'Graph/Style.pm' => '$(INST_LIBDIR)/Graph/Style.pm',
	'Graph/XY.pm'    => '$(INST_LIBDIR)/Graph/XY.pm',
    },
    ($] >= 5.005 ?
      (AUTHOR     => 'Christopher Willmot <chris@willmot.co.uk>') : ()),
);
