#!/usr/bin/perl
use strict;
use warnings;

use PostScript::GraphPaper;
my $gp = new PostScript::GraphPaper();

print <<'END_PROLOG';
#!/usr/bin/perl
use Test;
BEGIN { plan tests => 77 };
use PostScript::GraphPaper;
ok(1); # module found

my $gp = new PostScript::GraphPaper();
ok($gp); # object created
END_PROLOG

print "ok(\$gp->chart_left_edge(), ${\($gp->chart_left_edge())});\n";
print "ok(\$gp->chart_bottom_edge(), ${\($gp->chart_bottom_edge())});\n";
print "ok(\$gp->chart_right_edge(), ${\($gp->chart_right_edge())});\n";
print "ok(\$gp->chart_top_edge(), ${\($gp->chart_top_edge())});\n";
print "ok(\$gp->chart_right_margin(), ${\($gp->chart_right_margin())});\n";
print "ok(\$gp->chart_top_margin(), ${\($gp->chart_top_margin())});\n";
print "ok(\$gp->chart_spacing(), ${\($gp->chart_spacing())});\n";
print "ok(\$gp->chart_dots_per_inch(), ${\($gp->chart_dots_per_inch())});\n";

print "ok(\$gp->chart_heading(), \'${\($gp->chart_heading())}\');\n";
print "ok(\$gp->chart_heading_height(), ${\($gp->chart_heading_height())});\n";
print "ok(\$gp->chart_key_width(), ${\($gp->chart_key_width())});\n";
print "ok(\$gp->chart_key_height(), ${\($gp->chart_key_height())});\n";
print "ok(\$gp->chart_key_title(), \'${\($gp->chart_key_title())}\');\n";

print "ok(\$gp->chart_background(), ${\($gp->chart_background())});\n";
print "ok(\$gp->chart_color(), ${\($gp->chart_color())});\n";
print "ok(\$gp->chart_heavy_color(), ${\($gp->chart_heavy_color())});\n";
print "ok(\$gp->chart_mid_color(), ${\($gp->chart_mid_color())});\n";
print "ok(\$gp->chart_light_color(), ${\($gp->chart_light_color())});\n";
print "ok(\$gp->chart_heavy_width(), ${\($gp->chart_heavy_width())});\n";
print "ok(\$gp->chart_mid_width(), ${\($gp->chart_mid_width())});\n";
print "ok(\$gp->chart_light_width(), ${\($gp->chart_light_width())});\n";

print "ok(\$gp->chart_font(), \'${\($gp->chart_font())}\');\n";
print "ok(\$gp->chart_font_size(), ${\($gp->chart_font_size())});\n";
print "ok(\$gp->chart_font_color(), ${\($gp->chart_font_color())});\n";
print "ok(\$gp->chart_heading_font(), \'${\($gp->chart_heading_font())}\');\n";
print "ok(\$gp->chart_heading_font_size(), ${\($gp->chart_heading_font_size())});\n";
print "ok(\$gp->chart_heading_font_color(), ${\($gp->chart_heading_font_color())});\n";

print "ok(\$gp->chart_key_title_font(), \'${\($gp->chart_key_title_font())}\');\n";
print "ok(\$gp->chart_key_title_font_size(), ${\($gp->chart_key_title_font_size())});\n";
print "ok(\$gp->chart_key_title_font_color(), ${\($gp->chart_key_title_font_color())});\n";
print "ok(\$gp->chart_key_fill_color(), ${\($gp->chart_key_fill_color())});\n";
print "ok(\$gp->chart_key_outline_color(), ${\($gp->chart_key_outline_color())});\n";
print "ok(\$gp->chart_key_outline_width(), ${\($gp->chart_key_outline_width())});\n";

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
print "ok(\$gp->vertical_bar_area(1), (" . join(", ", $gp->vertical_bar_area(1)) . "));\n";
print "ok(\$gp->horizontal_bar_area(1), (" . join(", ", $gp->horizontal_bar_area(1)) . "));\n";
print "ok(\$gp->physical_point(20, 50), (" . join(", ", $gp->physical_point(20, 50)) . "));\n";
print "ok(\$gp->logical_point(100, 200), (" . join(", ", $gp->logical_point(100, 200)) . "));\n";
print "ok(\$gp->px(24), ${\($gp->px(24))});\n";
print "ok(\$gp->py(67), ${\($gp->py(67))});\n";
print "ok(\$gp->lx(345), ${\($gp->lx(345))});\n";
print "ok(\$gp->ly(678), ${\($gp->ly(678))});\n";
