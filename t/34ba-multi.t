#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 5 };
use PostScript::File qw(check_file);
use PostScript::Graph::Style qw(defaults);
use PostScript::Graph::Bar;
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
	style => {
	    auto => [qw(red green blue)],
	},
);
ok($bar);

$bar->build_chart("t/multi.csv");
ok(1);

my $name = "34ba-multi";
$bar->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);

