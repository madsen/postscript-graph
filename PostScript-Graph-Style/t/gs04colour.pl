#!/usr/bin/perl
use strict;
use warnings;

use PostScript::Graph::Bar;
use PostScript::Graph::Style;

my $bar = new PostScript::Graph::Bar(
	file => {
	    landscape => 1,
	    debug => 2,
	    errors => 1,
	},
	style => {
	    auto => [qw(gray dashes)],
	    color => 0,
	    bar => {},
	},
);

$bar->build_chart("const.csv");
$bar->output("gs04-colour");

