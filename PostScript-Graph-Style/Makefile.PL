use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::GraphStyle',
    ABSTRACT_FROM	=> 'GraphStyle.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'GraphStyle.pm',
    PREREQ_PM		=> {	PostScript::File => 0.04,
				},
);
