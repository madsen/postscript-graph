#!/usr/bin/perl
use strict;
use warnings;

use Test;
BEGIN { plan tests => 6 };
use PostScript::File 0.10 qw(check_file);
use PostScript::Graph::Bar 0.02;
ok(1);
use PostScript::Graph::Style 0.05;
ok(1);

my $bar = new PostScript::Graph::Bar(
	file => {
	    landscape => 1,
	    debug => 2,
	    errors => 1,
	},
	style => {
	    auto => [qw(gray width)],
	    use_color => 0,
	    bar => {},
	},
);

$bar->build_chart("t/const.csv");
ok(1);

my $name = "24st-colour";
$bar->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);
ok(-e $file);

