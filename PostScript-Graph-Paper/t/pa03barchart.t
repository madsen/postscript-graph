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
ok($gp->paper_left_edge(), 37);
ok($gp->paper_bottom_edge(), 37);
ok($gp->paper_right_edge(), 250);
ok($gp->paper_top_edge(), 500);
ok($gp->paper_right_margin(), 15);
ok($gp->paper_top_margin(), 5);
ok($gp->paper_spacing(), 0);
ok($gp->paper_dots_per_inch(), 300);
ok($gp->paper_heading(), 'Bar chart');
ok($gp->paper_heading_height(), 27);
ok($gp->paper_key_width(), 100);
ok($gp->paper_background(), 1);
ok($gp->paper_color(), 0.5);
ok($gp->paper_heavy_color(), 0.5);
ok($gp->paper_mid_color(), 0.5);
ok($gp->paper_light_color(), 0.5);
ok($gp->paper_heavy_width(), 0.75);
ok($gp->paper_mid_width(), 0.5);
ok($gp->paper_light_width(), 0.25);
ok($gp->paper_font(), 'Helvetica');
ok($gp->paper_font_size(), 10);
ok($gp->paper_font_color(), 0);
ok($gp->paper_heading_font(), 'Helvetica-Bold');
ok($gp->paper_heading_font_size(), 12);
ok($gp->paper_heading_font_color(), 0);
ok($gp->x_axis_low(), 0);
ok($gp->x_axis_high(), 3);
ok($gp->x_axis_width(), 67);
ok($gp->x_axis_height(), 98);
ok($gp->x_axis_label_gap(), 30);
ok($gp->x_axis_smallest(), 0.72);
ok($gp->x_axis_title(), '');
ok($gp->x_axis_font(), 'Helvetica');
ok($gp->x_axis_font_color(), 0);
ok($gp->x_axis_font_size(), 10);
ok($gp->x_axis_mark_min(), 0.5);
ok($gp->x_axis_mark_max(), 8);
ok($gp->x_axis_labels_req(), 3);
ok($gp->x_axis_labels(), '[ (First bar) (Second bar) (Third bar) () ]');
ok($gp->x_axis_rotate(), 1);
ok($gp->x_axis_center(), 2);
ok($gp->y_axis_low(), 100);
ok($gp->y_axis_high(), 500);
ok($gp->y_axis_width(), 30);
ok($gp->y_axis_height(), 463);
ok($gp->y_axis_label_gap(), 30);
ok($gp->y_axis_smallest(), 0.72);
ok($gp->y_axis_title(), 'Readings');
ok($gp->y_axis_font(), 'Helvetica');
ok($gp->y_axis_font_color(), 0);
ok($gp->y_axis_font_size(), 10);
ok($gp->y_axis_mark_min(), 0.5);
ok($gp->y_axis_mark_max(), 8);
ok($gp->y_axis_labels_req(), 11);
ok($gp->y_axis_labels(), '[ 100 150 200 250 300 350 400 450 500 ]');
ok($gp->y_axis_rotate(), 0);
ok($gp->y_axis_center(), 0);
ok($gp->graph_area(), (67, 135, 134, 468));
ok($gp->key_area(), (149, 37, 249, 500));
ok($gp->vertical_bar_area(1,300), (100.5, 135, 122.833333333333, 301.5));
ok($gp->horizontal_bar_area(1), (67, 135.8325, 134, 136.665));
ok($gp->physical_point(20, 50), (513.666666666667, 93.375));
ok($gp->logical_point(100, 200), (1.47761194029851, 178.078078078078));
ok($gp->px(24), 603);
ok($gp->py(67), 107.5275);
ok($gp->lx(345), 12.4477611940298);
ok($gp->ly(678), 752.252252252252);
