#!/usr/bin/perl
use strict;
use warnings;

sub array_cmp ($$) {
    my ($a, $b) = @_;
    return 0 if (@$a != @$b);
    for (my $i = 0; $i <= $#$a; $i++) {
	return 0 if ($a->[$i] != $b->[$i]);
    }
    return 1;
}
# Expects two array refs
# Return true if contents are the same

use PostScript::Graph::Paper;
my $gp = new PostScript::Graph::Paper(
	    layout  => {
		heading  => "Bar chart",
		right_edge => 250,
		top_edge   => 500,
		key_width  => 100,
	    },
	    x_axis => {
		labels => [ "First bar",
			    "Second bar",
			    "Third bar" ],
	    },
	    y_axis => {
		low    => 123,
		high   => 456.7,
		title  => "Readings",
	    },
	);

open(OUTFILE, ">", "pa03barchart.t") or die "Unable to output file: $!\nStopped";
select OUTFILE;
print <<'END_PROLOG';
#!/usr/bin/perl
use Test;
BEGIN { plan tests => 68 };
use PostScript::File qw(check_file);
use PostScript::Graph::Paper;
ok(1); # module found

sub array_cmp ($$) {
    my ($a, $b) = @_;
    return 0 if (@$a != @$b);
    for (my $i = 0; $i <= $#$a; $i++) {
	return 0 if ($a->[$i] != $b->[$i]);
    }
    return 1;
}
# Expects two array refs
# Return true if contents are the same

my $gp = new PostScript::Graph::Paper(
	    layout  => {
		heading  => "Bar chart",
		right_edge => 250,
		top_edge   => 500,
		key_width  => 100,
	    },
	    x_axis => {
		labels => [ "First bar",
			    "Second bar",
			    "Third bar" ],
	    },
	    y_axis => {
		low    => 123,
		high   => 456.7,
		title  => "Readings",
	    },
	);
ok($gp); # object created

my $name = "pa03barchart";
$gp->output( $name, "test-results" );
ok(1); # survived so far
my $file = check_file( "$name.ps", "test-results" );
print STDERR "\nUse 'gv' or similar to inspect results file:\n$file\n";
ok($file);
ok(-e $file);
END_PROLOG

print "ok(\$gp->layout_left_edge(), ${\($gp->layout_left_edge())});\n";
print "ok(\$gp->layout_bottom_edge(), ${\($gp->layout_bottom_edge())});\n";
print "ok(\$gp->layout_right_edge(), ${\($gp->layout_right_edge())});\n";
print "ok(\$gp->layout_top_edge(), ${\($gp->layout_top_edge())});\n";
print "ok(\$gp->layout_right_margin(), ${\($gp->layout_right_margin())});\n";
print "ok(\$gp->layout_top_margin(), ${\($gp->layout_top_margin())});\n";
print "ok(\$gp->layout_spacing(), ${\($gp->layout_spacing())});\n";
print "ok(\$gp->layout_dots_per_inch(), ${\($gp->layout_dots_per_inch())});\n";

print "ok(\$gp->layout_heading(), \'${\($gp->layout_heading())}\');\n";
print "ok(\$gp->layout_heading_height(), ${\($gp->layout_heading_height())});\n";
print "ok(\$gp->layout_key_width(), ${\($gp->layout_key_width())});\n";

print "ok(\$gp->layout_background(), ${\($gp->layout_background())});\n";
print "ok(\$gp->layout_color(), ${\($gp->layout_color())});\n";
print "ok(\$gp->layout_heavy_color(), ${\($gp->layout_heavy_color())});\n";
print "ok(\$gp->layout_mid_color(), ${\($gp->layout_mid_color())});\n";
print "ok(\$gp->layout_light_color(), ${\($gp->layout_light_color())});\n";
print "ok(\$gp->layout_heavy_width(), ${\($gp->layout_heavy_width())});\n";
print "ok(\$gp->layout_mid_width(), ${\($gp->layout_mid_width())});\n";
print "ok(\$gp->layout_light_width(), ${\($gp->layout_light_width())});\n";

print "ok(\$gp->layout_font(), \'${\($gp->layout_font())}\');\n";
print "ok(\$gp->layout_font_size(), ${\($gp->layout_font_size())});\n";
print "ok(\$gp->layout_font_color(), ${\($gp->layout_font_color())});\n";
print "ok(\$gp->layout_heading_font(), \'${\($gp->layout_heading_font())}\');\n";
print "ok(\$gp->layout_heading_font_size(), ${\($gp->layout_heading_font_size())});\n";
print "ok(\$gp->layout_heading_font_color(), ${\($gp->layout_heading_font_color())});\n";

print "ok(\$gp->x_axis_low(), ${\($gp->x_axis_low())});\n";
print "ok(\$gp->x_axis_high(), ${\($gp->x_axis_high())});\n";
print "ok(\$gp->x_axis_width(), ${\($gp->x_axis_width())});\n";
print "ok(\$gp->x_axis_height(), ${\($gp->x_axis_height())});\n";
print "ok(\$gp->x_axis_label_gap(), ${\($gp->x_axis_label_gap())});\n";
print "ok(\$gp->x_axis_smallest(), ${\($gp->x_axis_smallest())});\n";
print "ok(\$gp->x_axis_title(), \'${\($gp->x_axis_title())}\');\n";
print "ok(\$gp->x_axis_font(), \'${\($gp->x_axis_font())}\');\n";
print "ok(\$gp->x_axis_font_color(), ${\($gp->x_axis_font_color())});\n";
print "ok(\$gp->x_axis_font_size(), ${\($gp->x_axis_font_size())});\n";
print "ok(\$gp->x_axis_mark_min(), ${\($gp->x_axis_mark_min())});\n";
print "ok(\$gp->x_axis_mark_max(), ${\($gp->x_axis_mark_max())});\n";
print "ok(\$gp->x_axis_labels_req(), ${\($gp->x_axis_labels_req())});\n";
print "ok(\$gp->x_axis_rotate(), \'${\($gp->x_axis_rotate())}\');\n";
print "ok(\$gp->x_axis_center(), \'${\($gp->x_axis_center())}\');\n";
print "ok(\$gp->x_axis_show_lines(), \'${\($gp->x_axis_show_lines())}\');\n";

print "ok(\$gp->y_axis_low(), ${\($gp->y_axis_low())});\n";
print "ok(\$gp->y_axis_high(), ${\($gp->y_axis_high())});\n";
print "ok(\$gp->y_axis_width(), ${\($gp->y_axis_width())});\n";
print "ok(\$gp->y_axis_height(), ${\($gp->y_axis_height())});\n";
print "ok(\$gp->y_axis_label_gap(), ${\($gp->y_axis_label_gap())});\n";
print "ok(\$gp->y_axis_smallest(), ${\($gp->y_axis_smallest())});\n";
print "ok(\$gp->y_axis_title(), \'${\($gp->y_axis_title())}\');\n";
print "ok(\$gp->y_axis_font(), \'${\($gp->y_axis_font())}\');\n";
print "ok(\$gp->y_axis_font_color(), ${\($gp->y_axis_font_color())});\n";
print "ok(\$gp->y_axis_font_size(), ${\($gp->y_axis_font_size())});\n";
print "ok(\$gp->y_axis_mark_min(), ${\($gp->y_axis_mark_min())});\n";
print "ok(\$gp->y_axis_mark_max(), ${\($gp->y_axis_mark_max())});\n";
print "ok(\$gp->y_axis_labels_req(), ${\($gp->y_axis_labels_req())});\n";
print "ok(\$gp->y_axis_rotate(), \'${\($gp->y_axis_rotate())}\');\n";
print "ok(\$gp->y_axis_center(), \'${\($gp->y_axis_center())}\');\n";
print "ok(\$gp->y_axis_show_lines(), \'${\($gp->y_axis_show_lines())}\');\n";

print "ok(array_cmp([\$gp->graph_area()], [" . join(", ", $gp->graph_area()) . "]));\n";
print "ok(array_cmp([\$gp->key_area()],   [" . join(", ", $gp->key_area()) . "]));\n";
print "ok(\$gp->px(24), ${\($gp->px(24))});\n";
print "ok(\$gp->py(67), ${\($gp->py(67))});\n";
print "ok(\$gp->lx(345), ${\($gp->lx(345))});\n";
print "ok(\$gp->ly(678), ${\($gp->ly(678))});\n";

select STDOUT;
close OUTFILE;

