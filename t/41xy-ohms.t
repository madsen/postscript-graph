#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 6 };
use PostScript::File 0.10 qw(check_file);
use PostScript::Graph::XY 0.03;
ok(1);

my $xy = new PostScript::Graph::XY();
ok($xy);

$xy->line_from_file( "t/ohms.csv", "Current (mA)" );
ok(1);

$xy->build_chart();
ok(1);

my $name = "41xy-ohms";
$xy->output( $name, "test-results" );
ok(1); # survived so far
my $file = check_file( "$name.ps", "test-results" );
ok($file);
