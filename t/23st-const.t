#!/usr/bin/perl
use strict;
use warnings;

use Test;
BEGIN { plan tests => 8 };
use PostScript::File 0.12 qw(check_file);
ok(1);
use PostScript::Graph::Bar 0.03;
ok(1);
use PostScript::Graph::Style 0.07;
ok(1);

my $bar = new PostScript::Graph::Bar(
	file => {
	    landscape => 1,
	    debug => 2,
	    errors => 1,
	},
	x_axis => {
	    rotate => 0,
	},
	style => {
	    auto => [qw(red green blue)],
	    bar => {},
	},
);
ok(1);

$bar->build_chart("t/const.csv");
ok(1);

my $name = "t/23st-const";
$bar->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 60022);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
