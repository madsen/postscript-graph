#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 8 };
use PostScript::Graph::File qw(check_file);
ok(1);
use PostScript::Graph::Style;
ok(1);

my $gf = new PostScript::Graph::File();
ok($gf);

my $seq = new StyleSequence;
ok($seq);

my $ops = {
    sequence     => $seq,
    auto         => [qw(dashes gray)],
    changes_only => 0,
};

for my $i (1 .. 10) {
    my $s = new PostScript::Graph::Style( $ops );
    $s->write( $gf );
    $gf->add_to_page("% use style here\n");
}
ok(1);

my $name = "gs01simple";
$gf->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);
ok(-e $file);

