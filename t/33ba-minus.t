#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 6 };
use PostScript::File         0.12 qw(check_file);
use PostScript::Graph::Bar   0.03;
ok(1);

my $bar = new PostScript::Graph::Bar(
	file => {
	    landscape => 1,
	    debug => 2,
	    errors => 1,
	},
	layout  => {
	    heavy_color => [0, 0, 0.7],
	    mid_color => [0, 0.5, 1],
	},
	y_axis => {
	    high => 0,
	},
	style => {
	    auto => [qw(blue red green)],
	},
);
ok($bar);

$bar->build_chart("t/minus.csv");
ok(1);

my $name = "t/33ba-minus";
$bar->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 20829);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
