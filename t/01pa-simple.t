use Test;
BEGIN { plan tests => 5 };
use PostScript::File  0.1 qw(check_file);
use PostScript::Graph::Paper 0.08;
ok(1); # module found

my $ps = new PostScript::Graph::Paper();
ok($ps); # object created

my $name = "01pa-simple";
$ps->output( $name, "test-results" );
ok(1); # survived so far
my $file = check_file( "$name.ps", "test-results" );
ok($file);
ok(-e $file);

