#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 6 };
use PostScript::File       0.12 qw(check_file);
use PostScript::Graph::Bar 0.03;
ok(1);

my $bar = new PostScript::Graph::Bar(
	file => {
	    paper => 'Letter',
	    height => 600,
	    top => 25,
	    bottom => 15,
	    left => 15,
	    right => 15,
	    landscape => 0,
	    debug => 0,
	    errors => 0,
	    clipping => 1,
	    clip_command => 'stroke',
	},
	layout  => {
	    left_edge => 60,
	    right_edge => 580,
	    top_edge => 500,
	    bottom_edge => 40,
	    heading => "Values from 'single.csv'",
	    heavy_color => [0, 0, 0.7],
	    mid_color => [0, 0.5, 1],
	},
	x_axis => {
	    height => 80,
	},
	style => {
	    bar => {
		color => [0.8, 0.4, 0],
	    },
	},
	key => {
	    background => [0.9, 1, 1],
	    spacing => 8,
	},
);
ok($bar);

$bar->build_chart("t/single.csv");
ok(1);

my $name = "t/37ba-lines";
$bar->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 21204);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
