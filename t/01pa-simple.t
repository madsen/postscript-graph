#!/usr/bin/perl
use Test;
BEGIN { plan tests => 5 };
use PostScript::File  0.11 qw(check_file);
use PostScript::Graph::Paper 0.10;
ok(1); # module found

my $ps = new PostScript::Graph::Paper();
ok($ps); # object created

my $name = "t/01pa-simple";
$ps->output( $name );
ok(1); # survived so far
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 9266);	# the chart looks different?
warn "Use ghostview or similar to inspect results file:\n$psfile\n";

