use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::Key',
    ABSTRACT_FROM	=> 'Key.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'Key.pm',
    PREREQ_PM		=> {	PostScript::Graph::File => 0,
				PostScript::Graph::Paper => 0,
				},
);
