#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 9 };
use PostScript::File qw(check_file);
use PostScript::Graph::Style;
ok(1);
use PostScript::Graph::XY;
ok(1);

my $seq = new PostScript::Graph::Sequence;
ok(1);

my $xy = new PostScript::Graph::XY(
	    file   => {
		landscape  => 1,
		errors     => 1,
		debug      => 1,
	    },
	    layout  => {
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
		auto       => [qw(dashes green)],
		same       => 0,
		color      => 1,
		line       => {
		    width => 2,
		},
		point      => {
		},
	    }
	);
ok($xy);

my $data = [ [qw(Control First Second Third Fourth Fifth Sixth Seventh Eighth Nineth Tenth)],
	     [ 1, 1, 2, 3, 4, 5, 6, 7, 8, 9,10 ],
	     [ 2, 2, 3, 4, 5, 6, 7, 8, 9,10,11 ],
	     [ 3, 3, 4, 5, 6, 7, 8, 9,10,11,12 ],
	     [ 4, 4, 5, 6, 7, 8, 9,10,11,12,13 ], ];

$xy->line_from_array( $data );
ok(1);

$xy->build_chart();
ok(1);

my $name = "xy03styles";
$xy->output( $name, "test-results" );
ok(1); # survived so far
my $file = check_file( "$name.ps", "test-results" );
ok($file);
ok(-e $file);
