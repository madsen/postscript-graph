use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::XY',
    ABSTRACT_FROM	=> 'XY.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'XY.pm',
    PREREQ_PM		=> {	PostScript::Graph::File  => 0,
				PostScript::Graph::Style => 0,
				PostScript::Graph::Paper => 0,
				PostScript::Graph::Key   => 0,
				},
);
