#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 6 };
use PostScript::File qw(check_file);
use PostScript::Graph::Bar;
ok(1);

my $bar = new PostScript::Graph::Bar(
	    file   => {
		landscape  => 1,
		errors     => 1,
		debug      => 2,
	    },
	    layout => {
		left_edge  => 100,
		background => [1, 1, 0.9],
	    },
	    x_axis => {
		smallest   => 8,
	    },
	    y_axis => {
		smallest   => 4,
	    },
	    style  => {
		auto       => [qw(green blue red)],
	    }
	);
ok($bar);

my $data = [ [qw(Control First Second Third Fourth Fifth Sixth Seventh Eighth Nineth Tenth)],
	     [ "Line 1", 1, 2, 3, 4, 5, 6, 7, 8, 9,10 ],
	     [ "Line 2", 2, 3, 4, 5, 6, 7, 8, 9,10,11 ],
	     [ "Line 3", 3, 4, 5, 6, 7, 8, 9,10,11,12 ],
	     [ "Line 4", 4, 5, 6, 7, 8, 9,10,11,12,13 ], ];

$bar->series_from_array( $data );
ok(1);
$bar->build_chart();
ok(1);

my $name = "02arrays";
$bar->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);
print STDERR "\nUse 'gv' or similar to visually check output file:\n";
print STDERR "$file\n";

