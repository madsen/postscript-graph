use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'PostScript::Graph::Paper',
    ABSTRACT_FROM	=> 'Paper.pm',
    AUTHOR		=> 'Christopher Willmot <chris@willmot.org.uk>',
    VERSION_FROM	=> 'Paper.pm',
    PREREQ_PM		=> { PostScript::File => 0 },
);
