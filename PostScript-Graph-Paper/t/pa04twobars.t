use Test;
BEGIN { plan tests => 6 };
use PostScript::File qw(check_file);
ok(1); # module found
use PostScript::Graph::Paper;
ok(1); # module found

my $gp = new PostScript::Graph::Paper(
	file => {
	    landscape => 1,
	    left => 40,
	    right => 40,
	    top => 30,
	    bottom => 30,
	    clipping => 1,
	    clipcmd => "stroke",
	    debug => 2,
	    errors => 1,
	    errx => 36,
	    erry => 300,
	},
	layout => {
	    key_width => 100,
	},
	x_axis => {
	    labels => [qw(aaa bbb ccc ddd eee fff ggg hhh iii jjj)],
	    show_lines => 1,
	    center => 1,
	    offset => 0,
	},
	y_axis => {
	    labels => [qw(aaa bbb ccc ddd eee fff ggg hhh iii jjj)],
	},
    );
ok($gp);

my $name = "pa04twobars";
$gp->output( $name, "test-results" );
ok(1); # survived so far
my $file = check_file( "$name.ps", "test-results" );
print STDERR "\nUse 'gv' or similar to inspect results file:\n$file\n";
ok($file);
ok(-e $file);
