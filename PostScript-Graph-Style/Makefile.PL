use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::Style',
    ABSTRACT_FROM	=> 'Style.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'Style.pm',
    PREREQ_PM		=> {	PostScript::Graph::File => 0,
				},
);
