use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::Bar',
    ABSTRACT_FROM	=> 'Bar.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'Bar.pm',
    PREREQ_PM		=> {	PostScript::File  => 0,
				PostScript::Graph::Style => 0,
				PostScript::Graph::Paper => 0,
				PostScript::Graph::Key   => 0,
				},
);
