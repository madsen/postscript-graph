#!/usr/bin/perl
use strict;
use warnings;

use Test;
BEGIN { plan tests => 6 };
use PostScript::File 0.12 qw(check_file);
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
	    auto => [qw(green blue red width)],
	    bar => {},
	},
);

$bar->build_chart("t/const.csv");
ok(1);

my $name = "t/24st-colour";
$bar->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 60003);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
