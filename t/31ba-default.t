#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 6 };
use PostScript::File 0.12 qw(check_file);
use PostScript::Graph::Bar 0.03;
ok(1);

my $bar = new PostScript::Graph::Bar();
ok($bar);

$bar->build_chart( [
	[qw(Control First Second Third Fourth Fifth Sixth Seventh Eighth Nineth Tenth)],
	[ "One", 1, 2, 3, 4, 5, 6, 7, 8, 9,10 ],
	[ "Two", 2, 3, 4, 5, 6, 7, 8, 9,10,11 ],
	[ "Three", 3, 4, 5, 6, 7, 8, 9,10,11,12 ],
	[ "Four", 4, 5, 6, 7, 8, 9,10,11,12,13 ], 
    ]);
ok(1);

my $name = "t/31ba-default";
$bar->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 28117);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
