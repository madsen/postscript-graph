#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 6 };
use PostScript::File       0.12 qw(check_file);
use PostScript::Graph::Bar 0.02;
ok(1);

my $bar = new PostScript::Graph::Bar(
	file  => {
	    landscape => 1,
	    debug => 2,
	    errors => 1,
	},
	layout => {
	    heavy_color => [0, 0, 0.7],
	    mid_color => [0, 0.5, 1],
	},
	style => {
	    bar => {
		color => [0.8, 0.4, 0],
	    },
	},
	x_axis => {
	    show_lines => 1,
	},
);
ok($bar);

$bar->build_chart("t/single.csv");
ok(1);

my $name = "t/35ba-single";
$bar->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 24544);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
