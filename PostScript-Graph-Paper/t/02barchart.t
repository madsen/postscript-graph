#!/usr/bin/perl
use Test;
BEGIN { plan tests => 77 };
use PostScript::GraphPaper;
ok(1); # module found

my $gp = new PostScript::GraphPaper(
	    chart  => {
		heading  => "Bar chart",
		right_edge => 250,
		top_edge   => 500,
		key_width  => 100,
		key_height => 150,
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

$gp->output("02barchart");
ok($gp->chart_left_edge(), 37);
ok($gp->chart_bottom_edge(), 37);
ok($gp->chart_right_edge(), 250);
ok($gp->chart_top_edge(), 500);
ok($gp->chart_right_margin(), 15);
ok($gp->chart_top_margin(), 5);
ok($gp->chart_spacing(), 0);
ok($gp->chart_dots_per_inch(), 300);
ok($gp->chart_heading(), 'Bar chart');
ok($gp->chart_heading_height(), 27);
ok($gp->chart_key_width(), 100);
ok($gp->chart_key_height(), 150);
ok($gp->chart_key_title(), 'Key');
ok($gp->chart_background(), 1);
ok($gp->chart_color(), 0.5);
ok($gp->chart_heavy_color(), 0.5);
ok($gp->chart_mid_color(), 0.5);
ok($gp->chart_light_color(), 0.5);
ok($gp->chart_heavy_width(), 0.75);
ok($gp->chart_mid_width(), 0.75);
ok($gp->chart_light_width(), 0.25);
ok($gp->chart_font(), 'Helvetica');
ok($gp->chart_font_size(), 10);
ok($gp->chart_font_color(), 0);
ok($gp->chart_heading_font(), 'Helvetica-Bold');
ok($gp->chart_heading_font_size(), 12);
ok($gp->chart_heading_font_color(), 0);
ok($gp->chart_key_title_font(), 'Helvetica-Bold');
ok($gp->chart_key_title_font_size(), 10);
ok($gp->chart_key_title_font_color(), 0);
ok($gp->chart_key_fill_color(), 1);
ok($gp->chart_key_outline_color(), 0);
ok($gp->chart_key_outline_width(), 0.25);
ok($gp->x_axis_low(), 0);
ok($gp->x_axis_high(), 2);
ok($gp->x_axis_width(), 68);
ok($gp->x_axis_height(), 98);
ok($gp->x_axis_label_gap(), 30);
ok($gp->x_axis_smallest(), 0.72);
ok($gp->x_axis_title(), '');
ok($gp->x_axis_font(), 'Helvetica');
ok($gp->x_axis_font_color(), 0);
ok($gp->x_axis_font_size(), 10);
ok($gp->x_axis_mark_min(), 0.5);
ok($gp->x_axis_mark_max(), 8);
ok($gp->x_axis_labels_req(), 2);
ok($gp->x_axis_labels(), '[ (First bar) (Second bar) (Third bar) ]');
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
ok($gp->graph_area(), (67, 135, 135, 468));
ok($gp->key_area(), (150, 226.5, 250, 376.5));
ok($gp->vertical_bar_area(1,300), (89.6666666666667, 135, 112.333333333333, 301.5));
ok($gp->horizontal_bar_area(1), (67, 135.8325, 135, 136.665));
ok($gp->physical_point(20, 50), (747, 93.375));
ok($gp->logical_point(100, 200), (0.970588235294118, 178.078078078078));
ok($gp->px(24), 883);
ok($gp->py(67), 107.5275);
ok($gp->lx(345), 8.17647058823529);
ok($gp->ly(678), 752.252252252252);
