use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::GraphKey',
    ABSTRACT_FROM	=> 'GraphKey.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'GraphKey.pm',
    PREREQ_PM		=> {	PostScript::File => 0.04,
				PostScript::GraphPaper => 0.01,
				},
);
