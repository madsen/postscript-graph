use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::GraphPaper',
    ABSTRACT_FROM	=> 'GraphPaper.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'GraphPaper.pm',
    PREREQ_PM		=> { PostScript::File => 0.04 },
);
