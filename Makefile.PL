use ExtUtils::MakeMaker;
use 5.6.1;
WriteMakefile(
    NAME	=> 'PostScript::Graph',
    VERSION	=> '0.14',
    ABSTRACT	=> 'Bar, line and scatter graphs from CSV to PostScript files',
    PREREQ_PM	=> { 
	'Exporter' => 0,
	'Carp' => 0,
	'Test::More' => 0,
	'Text::CSV_XS' => 0,
	'PostScript::File'  => 0.12,
		   },
    PM	=> {
	'Graph/Bar.pm'   => '$(INST_LIBDIR)/Graph/Bar.pm',
	'Graph/Key.pm'   => '$(INST_LIBDIR)/Graph/Key.pm',
	'Graph/Paper.pm' => '$(INST_LIBDIR)/Graph/Paper.pm',
	'Graph/Style.pm' => '$(INST_LIBDIR)/Graph/Style.pm',
	'Graph/XY.pm'    => '$(INST_LIBDIR)/Graph/XY.pm',
    },
    AUTHOR => 'Christopher Willmot <chris@willmot.org.uk>',
);
