#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 8 };
use PostScript::File 0.12 qw(check_file);
ok(1);
use PostScript::Graph::Style 0.07;
ok(1);

my $gf = new PostScript::File();
ok($gf);

my $seq = new PostScript::Graph::Sequence;
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

my $name = "t/21st-simple";
$gf->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 5021);	# the chart looks different?
warn "Don't worry, the results file should be blank:\n$psfile\n";

