#!/usr/bin/perl
use strict;
use warnings;

use Test;
BEGIN { plan tests => 23 };
use PostScript::File 0.12 qw(check_file);
ok(1);
use PostScript::Graph::Style 0.07;
ok(1);

my $s1 = new PostScript::Graph::Sequence;
ok($s1);
$s1->setup( "gray",
    [ [ 1, 1, 0 ],    # yellow
      [ 0, 1, 0 ],    # green
      [ 0, 1, 1 ], ]  # cyan
    );
ok(1);

my $opts = {
	    sequence => $s1,
	    auto  => [qw(gray dashes)],
	    color => 0,
	    line  => {
		width  => 2,
	    },
};

my $gf = new PostScript::File();
ok($gf);

my ($oldsid, $old);
for (my $c = 0; $c < 4; $c++) {
    my $s = new PostScript::Graph::Style($opts);
    $s->write($gf);
    my $id = $s->id();
    $id =~ /(\d+)\.(\d+)/;
    ok($1);
    ok($2);
    ok($oldsid, $1) if (defined $oldsid);
    $oldsid = $1;
    ok($old+1, $2) if (defined $old);
    $old = $2;
    $gf->add_to_page("% use style $id\n");
}
ok(1);

my $name = "t/22st-styles";
$gf->output( $name );
ok(1);
my $psfile = check_file( "$name.ps" );
ok($psfile);
ok(-s $psfile == 4987);	# the chart looks different?
warn "Don't worry, the results file should be blank:\n$psfile\n";

