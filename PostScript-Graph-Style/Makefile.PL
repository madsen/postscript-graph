use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::Style',
    ABSTRACT_FROM	=> 'Style.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.co.uk>',
    VERSION_FROM	=> 'Style.pm',
    PREREQ_PM		=> {	PostScript::File => 0.10,
				PostScript::Graph::Bar => 0.02,
				},
);
