#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 5 };
use PostScript::File qw(check_file);
use PostScript::Graph::Bar;
ok(1);

my $bar = new PostScript::Graph::Bar();
ok($bar);

$bar->build_chart( [
	[qw(Control First Second Third Fourth Fifth Sixth Seventh Eighth Nineth Tenth)],
	[ "One", 1, 2, 3, 4, 5, 6, 7, 8, 9,10 ],
	[ "Two", 2, 3, 4, 5, 6, 7, 8, 9,10,11 ],
	[ "Three", 3, 4, 5, 6, 7, 8, 9,10,11,12 ],
	[ "Four", 4, 5, 6, 7, 8, 9,10,11,12,13 ], 
    ]);
ok(1);

my $name = "01default";
$bar->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);
print STDERR "\nUse 'gv' or similar to visually check output file:\n";
print STDERR "$file\n";

