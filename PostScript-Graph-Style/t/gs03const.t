#!/usr/bin/perl
use strict;
use warnings;

use Test;
BEGIN { plan tests => 8 };
use PostScript::File qw(check_file);
ok(1);
use PostScript::Graph::Bar;
ok(1);
use PostScript::Graph::Style;
ok(1);

my $bar = new PostScript::Graph::Bar(
	file => {
	    landscape => 1,
	    debug => 2,
	    errors => 1,
	},
	style => {
	    auto => [qw(red green blue)],
	    bar => {},
	},
);
ok(1);

$bar->build_chart("t/const.csv");
ok(1);

my $name = "gs03const";
$bar->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);
ok(-e $file);
print STDERR "\nInspect $file for colours\n";

