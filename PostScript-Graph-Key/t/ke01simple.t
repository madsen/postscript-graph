use Test;
BEGIN { plan tests => 12 };
use PostScript::Graph::File qw(check_file);
ok(1);
use PostScript::Graph::Paper;
ok(1);
use PostScript::Graph::Key;
ok(1);

my $gf = new PostScript::Graph::File();
ok($gf);
my $gk = new PostScript::Graph::Key(
	max_height => 300,
	num_items => 5,
    );
ok($gk);
my $keyw = $gk->width();
ok($keyw);

my $gp = new PostScript::Graph::Paper(
	file => $gf,
	paper => {
	    key_width => $keyw,
	},
    );
ok($gp);

my $paper_keyw = $gp->paper_key_width();
ok($paper_keyw, $keyw);

$gk->build_key( $gp );
ok(1);

my $name = "ke01simple";
$gf->output( $name, "test-results" );
ok(1);
my $file = check_file( "$name.ps", "test-results" );
ok($file);
ok(-e $file);

