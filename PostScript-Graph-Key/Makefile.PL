use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::Key',
    ABSTRACT_FROM	=> 'Key.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'Key.pm',
    PREREQ_PM		=> {	PostScript::File => 0.08,
				PostScript::Graph::Paper => 0.06,
				PostScript::Graph::Style => 0.03,
				},
);
