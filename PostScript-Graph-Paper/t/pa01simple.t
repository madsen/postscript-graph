use Test;
BEGIN { plan tests => 5 };
use PostScript::File qw(check_file);
use PostScript::Graph::Paper;
ok(1); # module found

my $ps = new PostScript::Graph::Paper();
ok($ps); # object created

my $name = "pa01simple";
$ps->output( $name, "test-results" );
ok(1); # survived so far
my $file = check_file( "$name.ps", "test-results" );
print STDERR "\nUse 'gv' or similar to check results file:\n$file\n";
ok($file);
ok(-e $file);

