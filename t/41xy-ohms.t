#!/usr/bin/perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 7 };
use PostScript::File      0.12 qw(check_file);
use PostScript::Graph::XY 0.04;
ok(1);

my $xy = new PostScript::Graph::XY();
ok($xy);

$xy->line_from_file( "t/ohms.csv", "Current (mA)" );
ok(1);

$xy->build_chart();
ok(1);

my $name = "t/41xy-ohms";
$xy->output( $name );
ok(1); # survived so far
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 18053);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";
