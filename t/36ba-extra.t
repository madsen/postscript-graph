#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 8 };
use PostScript::File 0.10 qw(check_file);
use PostScript::Graph::Style 0.05 qw(defaults);
use PostScript::Graph::Bar 0.02;
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
	    auto => [qw(blue red green)],
	},
);
ok($bar);

my $data2 =
    [ [ "", "First", "Second", ],
      [ "eee", 5, 6, ],
      [ "fff", 6, 7, ], ];
    
$bar->series_from_array($data2, 1);
ok(1);

my $data1 =
    [ [ "", "First", "Second", ],
      [ "aaa", 1, 2, ],
      [ "bbb", 2, 3, ],
      [ "ccc", 3, 4, ],
      [ "ddd", 4, 5, ], ];
    
$bar->series_from_array($data1, 0);
ok(1);

my $data3 =
    [ [ "", "Third", "Forth", ],
      [ "aaa", 11, 12, ],
      [ "bbb", 12, 13, ],
      [ "eee", 15, 16, ],
      [ "fff", 16, 17, ], ];
    
$bar->series_from_array($data3, 1);
ok(1);

$bar->build_chart();
ok(1);

my $name = "36ba-extra";
$bar->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);

