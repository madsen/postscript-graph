#!/usr/bin/perl
use strict;
use warnings;

use PostScript::Graph::Paper;
my $gp = new PostScript::Graph::Paper(
	    paper  => {
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
BEGIN { plan tests => 69 };
use PostScript::Graph::Paper;
ok(1); # module found

my $gp = new PostScript::Graph::Paper(
	    paper  => {
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

$gp->output("pa02barchart", "test-results");
END_PROLOG

print "ok(\$gp->paper_left_edge(), ${\($gp->paper_left_edge())});\n";
print "ok(\$gp->paper_bottom_edge(), ${\($gp->paper_bottom_edge())});\n";
print "ok(\$gp->paper_right_edge(), ${\($gp->paper_right_edge())});\n";
print "ok(\$gp->paper_top_edge(), ${\($gp->paper_top_edge())});\n";
print "ok(\$gp->paper_right_margin(), ${\($gp->paper_right_margin())});\n";
print "ok(\$gp->paper_top_margin(), ${\($gp->paper_top_margin())});\n";
print "ok(\$gp->paper_spacing(), ${\($gp->paper_spacing())});\n";
print "ok(\$gp->paper_dots_per_inch(), ${\($gp->paper_dots_per_inch())});\n";

print "ok(\$gp->paper_heading(), \'${\($gp->paper_heading())}\');\n";
print "ok(\$gp->paper_heading_height(), ${\($gp->paper_heading_height())});\n";
print "ok(\$gp->paper_key_width(), ${\($gp->paper_key_width())});\n";

print "ok(\$gp->paper_background(), ${\($gp->paper_background())});\n";
print "ok(\$gp->paper_color(), ${\($gp->paper_color())});\n";
print "ok(\$gp->paper_heavy_color(), ${\($gp->paper_heavy_color())});\n";
print "ok(\$gp->paper_mid_color(), ${\($gp->paper_mid_color())});\n";
print "ok(\$gp->paper_light_color(), ${\($gp->paper_light_color())});\n";
print "ok(\$gp->paper_heavy_width(), ${\($gp->paper_heavy_width())});\n";
print "ok(\$gp->paper_mid_width(), ${\($gp->paper_mid_width())});\n";
print "ok(\$gp->paper_light_width(), ${\($gp->paper_light_width())});\n";

print "ok(\$gp->paper_font(), \'${\($gp->paper_font())}\');\n";
print "ok(\$gp->paper_font_size(), ${\($gp->paper_font_size())});\n";
print "ok(\$gp->paper_font_color(), ${\($gp->paper_font_color())});\n";
print "ok(\$gp->paper_heading_font(), \'${\($gp->paper_heading_font())}\');\n";
print "ok(\$gp->paper_heading_font_size(), ${\($gp->paper_heading_font_size())});\n";
print "ok(\$gp->paper_heading_font_color(), ${\($gp->paper_heading_font_color())});\n";

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
print "ok(\$gp->x_axis_labels(), \'${\($gp->x_axis_labels())}\');\n";
print "ok(\$gp->x_axis_rotate(), ${\($gp->x_axis_rotate())});\n";
print "ok(\$gp->x_axis_center(), ${\($gp->x_axis_center())});\n";

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
print "ok(\$gp->y_axis_labels(), \'${\($gp->y_axis_labels())}\');\n";
print "ok(\$gp->y_axis_rotate(), ${\($gp->y_axis_rotate())});\n";
print "ok(\$gp->y_axis_center(), ${\($gp->y_axis_center())});\n";

print "ok(\$gp->graph_area(), (" . join(", ", $gp->graph_area()) . "));\n";
print "ok(\$gp->key_area(), (" . join(", ", $gp->key_area()) . "));\n";
print "ok(\$gp->vertical_bar_area(1,300), (" . join(", ", $gp->vertical_bar_area(1,300)) . "));\n";
print "ok(\$gp->horizontal_bar_area(1), (" . join(", ", $gp->horizontal_bar_area(1)) . "));\n";
print "ok(\$gp->physical_point(20, 50), (" . join(", ", $gp->physical_point(20, 50)) . "));\n";
print "ok(\$gp->logical_point(100, 200), (" . join(", ", $gp->logical_point(100, 200)) . "));\n";
print "ok(\$gp->px(24), ${\($gp->px(24))});\n";
print "ok(\$gp->py(67), ${\($gp->py(67))});\n";
print "ok(\$gp->lx(345), ${\($gp->lx(345))});\n";
print "ok(\$gp->ly(678), ${\($gp->ly(678))});\n";

select STDOUT;
close OUTFILE;

