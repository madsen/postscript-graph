use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::XY',
    ABSTRACT_FROM	=> 'XY.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'XY.pm',
    PREREQ_PM		=> {	Text::CSV_XS => 0,
				PostScript::File  => 0.08,
				PostScript::Graph::Style => 0.03,
				PostScript::Graph::Paper => 0.06,
				PostScript::Graph::Key   => 0.04,
				},
);
