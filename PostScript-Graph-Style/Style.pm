package PostScript::Graph::Style;
use strict;
use warnings;
use PostScript::File qw(str);

=head1 NAME

PostScript::Graph::Style - style settings for postscript objects

=head1 SYNOPSIS

=head2 Simplest

Each time a new object is created the default style will be slightly different.

    use PostScript::File;
    use PostScript::Graph::Style;

    my $file = new PostScript::File();
    my $seq = new PostScript::Graph::Sequence();
    
    while (...) {
	my $style = new PostScript::Graph::Style(
		sequence => $seq,
		point	 => {}
	    );
	$style->write($file);
	
	$file->add_to_page( <<END_OF_CODE );
	    % code using point variables...
	    
	    % setting colour or grey shade
	    gpaperdict begin
		pocolor gpapercolor
	    end

	    % choosing a line width
	    powidth setlinewidth
	    
	    % scaled relative to point sizing
	    0 ppsize rlineto
	    
	    % showing the chosen point shape
	    100 200 ppshape
    END_OF_CODE
    }
    
=head2 Typical

It is possible to control how each new object varies.

    my $seq = new PostScript::Graph::Sequence();
    $seq->setup( "red", [0, 1, 0.2, 0.8, 0.4, 0.6] );
	    
    my $file = new PostScript::File();
    while (...) {
	my $style = new PostScript::Graph::Style(
	    sequence => $seq,
	    auto     => [ qw(dashes red shape) ], 
	    bar      => {},
	);
	$style->write($file);
	
	... postscript using bar variables ...
    }
    
Some of the styles may be overriden.

    my $style = new PostScript::Graph::Style(
		sequence => $seq,
		auto     => [qw(red green blue)],
		color    => 1,
		line     => {
		    width        => 4,
		    outer_dashes => [],
		    outer_color  => [1, 0, 0],
		},
	    );

Or the automatic default feature can be supressed and some or all details specified directly.

    my $style = new PostScript::Graph::Style(
		auto  => "none",
		point => {
		    shape => "circle",
		    size  => 12,
		},
	    );

=head2 All options

    my $style = new PostScript::Graph::Style(
	sequence     => $seq,
	auto	     => [qw(red green blue)],
	changes_only => 0,
	same	     => 1,

	line => {
	    color	 => [0, 1, 0],
	    inner_color  => [1, 1, 0],
	    outer_color  => 0,
	    dashes	 => [3, 3],
	    inner_dashes => [5, 2, 5, 10],
	    outer_dashes => [],
	    width	 => 2,
	    inner_width  => 2,
	    outer_width  => 2.5,
	},

	point => {
	    size         => 8,
	    shape        => "diamond",
	    color	 => [0, 1, 0],
	    inner_color  => [1, 1, 0],
	    outer_color  => 0,
	    width	 => 2,
	    inner_width  => 2,
	    outer_width  => 2.5,
	},

	bar => {
	    color	 => [0, 1, 0],
	    inner_color  => [1, 1, 0],
	    outer_color  => 0,
	    width	 => 2,
	    inner_width  => 2,
	    outer_width  => 2.5,
	},
    );

=head1 DESCRIPTION

This module is designed as a supporting part of the PostScript::Graph suite.  For top level modules that output
something useful, see

    PostScript::Graph::Bar
    PostScript::Graph::Stock
    PostScript::Graph::XY

Style settings are provided for objects placed on a graph.  Lines on the same graph need to be distinguishable
from each other.  Each line would have a PostScript::Graph::Style object holding its settings.  Passing each line
a reference to the same PostScript::Graph::Sequence object makes the styles vary.  This can either use the defaults of be
controlled to every last detail.

Settings are provided for three types of object.  A B<line> is any unfilled path, a B<bar> is any filled path
while a B<point> is a filled path that may contain holes.

They all have outer and inner components.  The inner component provides the main shape and colour, while the outer
'edge' is provided to insulate this from any background colour.  Lines may be whole or broken and a variety of
builtin shapes is provided.  By default, repeated calls to B<new> return styles that differ from one another
although like everything else this can be under detailed user control if required.

The settings are only useful once they have been written out to a PostScript::File object using B<write>.  The
following functions return values set in the constructor.  See L</"new"> for more details.

    bar_outer_color()
    bar_outer_width()
    bar_inner_color()
    bar_inner_width()

    color()
    
    line_outer_color()
    line_outer_width()
    line_outer_dashes()
    line_inner_color()
    line_inner_width()
    line_inner_dashes()

    point_size()
    point_shape()
    point_outer_color()
    point_outer_width()
    point_inner_color()
    point_inner_width()

    same()
    sequence()
    
=cut

### PostScript::Graph::Sequence

package PostScript::Graph::Sequence;

# Largely for testing
our $sequence_id = 1;

sub new {
    my $class = shift;

    my $o= {};
    bless( $o, $class );
    $o->{id}      = $sequence_id++;
    $o->{styleid} = 0;

    # Starting selections 
    $o->{red}     = [ 0.5, 1, 0 ],
    $o->{green}   = [ 0, 0.5, 0.25, 0.75, 1 ],
    $o->{blue}    = [ 0, 1, 0.5 ],
    $o->{yellow}  = [ 0.9, 0.2, 0.5 ],
    $o->{mauve}   = [ 0.9, 0.2, 0.5 ],
    $o->{cyan}    = [ 0.9, 0.2, 0.5 ],
    $o->{gray}    = [ 0.6, 0, 0.45, 0.15, 0.75, 0.3, 0.9 ],
    $o->{shape}   = [qw(dot cross square plus diamond circle)],
    $o->{width}   = [ 1, 0.5, 4, 2 ],
    $o->{dashes}  = [ [], [3, 3], [9, 9], [10, 5, 3, 5] ],
    $o->{size}    = [ 5, 3, 7 ],

    
    $o->{initialized} = 0;	    # Ensure init_defaults is only called once
    $o->{pstyle}      = undef;	    # previous style
    $o->{style}       = undef;	    # most recent style
    
    $o->{choices}     = [];
    $o->{max}         = [];
    $o->{count}       = [];

    return $o;
}

=head2 Style Generation

Although it is possible to specify styles directly, mostly  the style just needs to be different from the last
one.  These dynamic defaults provide around 3600 variations which should be suitable for most cases.  The values
themselves can be replaced if desired.  Permutations of these are then generated on demand and the permutation order
is also under user control.

=head3 PostScript::Graph::Sequence new

Whenever a new PostScript::Graph::Style object is created, it uses certain defaults.  These defaults can be made to
vary if a sequence is declared as one of the options.  This should be the value returned from:

    my $seq = new PostScript::Graph::Sequence();

=cut

sub create {
    my ($o, $opts) = @_;
    my $list = (defined($opts) and ref($opts) eq "HASH") ? $opts->{auto} : [];
    return defaults() if ($o->{none});

    if (defined $opts->{auto}) {
	my $old = $o->{choices};
	if ($#$old == $#$list) {
	    for (my $i = 0; $i <= $#$list; $i++) {
		if($list->[$i] ne $old->[$i]) {
		    $o->{initialized} = 0;
		    last;
		}
	    }
	} else {
	    $o->{initialized} = 0;
	}
    }
    $o->{styleopts} = $opts;
    
    if ($o->{initialized}) {
	return $o->next_row();
    } else {
	$o->doreset($list);
	return $o->output_row();
    }
}
# Internal method
# create a new set of values in this sequence
# $opts is hash ref with {auto} key
# Adds pstyle => previous_style on return

sub reset {
    shift()->{initialized} = 0;
}

=head3 reset()

Starts the sequence of defaults again.

=cut

sub doreset {
    my ($o, $list) = @_;
    $list = $o->{styleopts}{auto} unless (defined $list);
    $o->{initialized} = 1;
    @{$o->{choices}} = ();
    @{$o->{max}} = ();
    @{$o->{count}} = ();
    
    foreach my $ch (@$list) {
	push @{$o->{choices}}, $ch if (defined $o->{$ch});
    }
    if (@{$o->{choices}} == 0) {
	$o->{choices} = [ qw(shape dashes size width) ];
    }
    #print "choices = " . join(", ", @{$o->{choices}}) . "\n";

    foreach my $key (@{$o->{choices}}) {
	if (defined $o->{$key}) {
	    push @{$o->{max}}, $#{$o->{$key}};
	    push @{$o->{count}}, 0;
	}
    }
    return;
}
# Internal method
# called by create()

sub defaults {
    my %ref;
    $ref{red} = 0;
    $ref{green} = 0;
    $ref{blue} = 0;
    $ref{gray} = 0;
    $ref{shape} = "dot";
    $ref{width} = 0.5;
    $ref{dashes} = [];
    $ref{size} = 5;
    $ref{pstyle} = 0;	# special signal for auto => 'none'
    return \%ref;
}
# Internal function
# ensuring all defaults have some value

sub output_row {
    my $o = shift;
    my $r = defaults();
    for (my $i = 0; $i < @{$o->{count}}; $i++) {
	my $key    = $o->{choices}[$i];
	my $chosen = $o->{count}[$i];
	my $value  = $o->{$key}[$chosen];
	CASE: {
	    if ($key =~ /yellow/) {
		$r->{red}   = $value;
		$r->{green} = $value;
		last CASE;
	    }
	    if ($key =~ /mauve/) {
		$r->{red}   = $value;
		$r->{blue}  = $value;
		last CASE;
	    }
	    if ($key =~ /cyan/) {
		$r->{green} = $value;
		$r->{blue}  = $value;
		last CASE;
	    }
	    if ($key =~ /gray/) {
		if (ref($value) ne "ARRAY") {
		    $r->{red}   = $value * 0.3;
		    $r->{green} = $value * 0.59;
		    $r->{blue}  = $value * 0.11;
		}
		$r->{gray}  = $value;
		last CASE;
	    }
	    $r->{$key} = $value if (defined $r->{$key});
	}
    }
    $r->{pstyle} = $o->{pstyle};
    #print "count = " . join(", ", @{$o->{count}}) . "\n";
    return $r;
}
# Internal method
# Returns a hash ref filled with suitable values

sub next_row {
    my $o = shift;
    if (@{$o->{count}}) {
	my $i = 0;
	while (1) {
	    if ($o->{count}[$i] < $o->{max}[$i]) {
		$o->{count}[$i]++;
		return $o->output_row();
	    } else {
		$o->{count}[$i] = 0;
		if ($i < $#{$o->{choices}}) {
		    $i++;
		} else {
		    $i = 0;
		    return $o->output_row();
		}
	    }
	}
    } else {
	return defaults();
    }
}
# Internal function returning next permutation
# as output_row(), repeating indefinitely.

sub setup {
    my ($o, $key, $aref) = @_;
    if (exists $o->{$key} and ref($aref) eq "ARRAY") {
	$o->{$key} = $aref;
	$o->{initialized} = 0;
    }
    return;
}

=head3 setup( key, array )

The defaults provided by the PostScript::Graph::Sequence are chosen from arrays which may be redefined using this method.  Note
that it is a B<PostScript::Graph::Sequence> method and B<NOT> a PostScript::Graph::Style method, and should typically be called
directly after the PostScript::Graph::Sequence object is created.

Example
    
    use PostScript::Graph::Style;
    
    my $seq = new PostScript::Graph::Sequence();
    $seq->setup( "red", [0, 0.5, 1] );

C<array> is always an array reference as in the example.  C<key> may be one of the following.

    red	    green   blue
    yellow  mauve   cyan
    gray    shape   size
    dashes  width
    
Mostly, their arrays contain integers (0 to 1.0 for colours).  The exceptions are C<dashes>, C<shape> and
possibly C<gray>.

See L</"inner_dashes"> for details on the arrays required for dashes.  Suitable values for shape can be one of
these entries, taken from the default array.

    my $seq = new PostScript::Graph::Sequence();
    $seq->setup( "shape",
	[ qw(cross plus dot circle square diamond) ]);

<gray> allows the user to define custom colour sequences.  The 'color' style option must be set for this, see
L</"color">.  If the gray array is filled with decimals between 0 and 1 (inclusive), the result is varying shades
of grey.  However, it is also possible to use arrays of red-green-blue colours:
    
    my $seq = new PostScript::Graph::Sequence();
    $seq->setup( "gray",
	[ [ 0, 0, 0 ],	    # white
	  [ 0, 0, 1 ],	    # blue
	  [ 0, 1, 0 ],	    # green
	  [ 0, 1, 1 ],	    # cyan
	  [ 1, 0, 0 ],	    # red
	  [ 1, 0, 1 ],	    # mauve
	  [ 1, 1, 0 ],	    # yellow
	  [ 1, 1, 1 ], ]);  # black

    my $gs = new PostScript::Graph::Style(
		auto  => [qw(gray)],
		color => 0,
		bar   => {},
	    );

The full range of colours may be used provided that the 'same' style option has not been set.  By default each
line, point and bar are outlined in the complementary colour to the background, making them stand out.

More than one variable can be set of course.  For example the following would ensure lines with 15 shades of
red-orange-yellow, if 'auto' was set to some combination of red, blue and green.

    my $seq = new PostScript::Graph::Sequence();
    $seq->setup("red", [ 0.2, 1, 0.4, 0.8, 0.6 ]);
    $seq->setup("green", [ 0, 0.8, 0.4 ]);
    $seq->setup("blue", [ 0 ]);
    
=cut

sub new_style_id {
    my $o = shift;
    $o->{styleid}++;
    return $o->{styleid};
}

sub previous_style {
    return (shift()->{pstyle} || 0);
}

sub register_style {
    my ($o, $style) = @_;
    $o->{pstyle} = $style;
}

sub style_id {
    return shift()->{styleid};
}

sub id {
    return shift()->{id};
}

sub line {
    my $o = shift;
    my $so = $o->{styleopts};
    return $so ? $so->{line} : undef; 
}
# Used by PostScript::Graph::Style 

sub point { 
    my $o = shift;
    my $so = $o->{styleopts};
    return $so ? $so->{point} : undef; 
}
# Used by PostScript::Graph::Style 

sub bar { 
    my $o = shift;
    my $so = $o->{styleopts};
    return $so ? $so->{bar} : undef; 
}
# Used by PostScript::Graph::Style 

sub default {
    our $default_seq = new PostScript::Graph::Sequence() unless (defined $default_seq);
    return $default_seq;
}

# The fallback sequence if none given
our $default_seq;

=head2 Class Methods

=head3 default()

Return a fallback PostScript::Graph::Sequence.  Note that this is possibly called by many, unrelated objects, so the sequences
generated may not be predictable or even useful.

=cut

### PostScript::Graph::Style

package PostScript::Graph::Style;

our $VERSION = '0.04';

=head1 CONSTRUCTOR

B<new( [options] )>

C<options> can either be a list of hash keys and values or a single hash reference.  In both cases the hash must
have the same structure.  There are a few principal keys and most of these refer to hashes holding a group of
options.  

It is B<essential> that the settings to be specified are indicated, so at least one of C<line>, C<point> or
C<bar> is given, even if the hashes are empty.  Otherwise no style settings will actually be output.

=cut

sub new {
    my $class = shift;
    my $opt = {};
    if (@_ == 1) { $opt = $_[0]; } else { %$opt = @_; }
   
    my $o = {};
    bless( $o, $class );

    ## collect the defaults
    my ($d, $seq);
    $o->{none}    = (defined($opt->{auto}) and ref($opt->{auto}) ne "ARRAY");
    if ($o->{none}) {
	$d        = PostScript::Graph::Sequence::defaults();
    } else {
	$seq      = defined($opt->{sequence})     ? $opt->{sequence}     : PostScript::Graph::Sequence::default();
	$d        = $seq->create($opt);
	$o->{seq} = $seq;
	$o->{id}  = $seq->new_style_id();
    }
    
    $o->{rel}     = defined($opt->{changes_only}) ? $opt->{changes_only} : 1;	# 'don't set everything'
    $o->{same}    = defined($opt->{same})         ? $opt->{same}         : 0;	# 'don't complement bgnd'
    $o->{color}   = defined($opt->{use_color})    ? $opt->{use_color}    : 1;	# 'not monochrome'
    my $color     = $o->{color} ? [ $d->{red}, $d->{green}, $d->{blue} ] : $d->{gray};
    
    ## line options
    my $li = $opt->{line};
    if ($li) {
	my $lwidth    = defined($li->{width})         ? $li->{width}         : $d->{width};
	my $dashes    = defined($li->{dashes})        ? $li->{dashes}        : $d->{dashes};
	$o->{locolor} = defined($li->{outer_color})   ? $li->{outer_color}   : -1;
	$o->{lowidth} = defined($li->{outer_width})   ? $li->{outer_width}   : 2 * $lwidth;
	$o->{lostyle} = defined($li->{outer_dashes})  ? $li->{outer_dashes}  : $dashes;
	
	$o->{licolor} = defined($li->{color})         ? $li->{color}         : $color;
	$o->{licolor} = defined($li->{inner_color})   ? $li->{inner_color}   : $o->{licolor};
	$o->{liwidth} = defined($li->{inner_width})   ? $li->{inner_width}   : $lwidth;
	$o->{listyle} = defined($li->{inner_dashes})  ? $li->{inner_dashes}  : $dashes;
	$o->{use_line} = 1;
    }
    
    ## bar options
    my $bl = $opt->{bar};
    if ($bl) {
	my $bwidth    = defined($bl->{width})         ? $bl->{width}         : $d->{width};
	$o->{bocolor} = defined($bl->{outer_color})   ? $bl->{outer_color}   : -1;
	$o->{bowidth} = defined($bl->{outer_width})   ? $bl->{outer_width}   : 2 * $bwidth;
	
	$o->{bicolor} = defined($bl->{color})         ? $bl->{color}         : $color;
	$o->{bicolor} = defined($bl->{inner_color})   ? $bl->{inner_color}   : $o->{bicolor};
	$o->{biwidth} = defined($bl->{inner_width})   ? $bl->{inner_width}   : $bwidth;
	$o->{use_bar} = 1;
    }

    ## point options
    my $pp = $opt->{point};
    if ($pp) {
	my $pwidth     = defined($pp->{width})         ? $pp->{width}         : $d->{width};
	$o->{ppsize}   = defined($pp->{size})          ? $pp->{size}          : $d->{size};
	$o->{ppshape}  = defined($pp->{shape})         ? $pp->{shape}         : $d->{shape};
	
	$o->{pocolor} = defined($pp->{outer_color})   ? $pp->{outer_color}   : -1;
	$o->{powidth} = defined($pp->{outer_width})   ? $pp->{outer_width}   : 2 * $pwidth;
	
	$o->{picolor} = defined($pp->{color})         ? $pp->{color}         : $color;
	$o->{picolor} = defined($pp->{inner_color})   ? $pp->{inner_color}   : $o->{picolor};
	$o->{piwidth} = defined($pp->{inner_width})   ? $pp->{inner_width}   : $pwidth;
	$o->{use_point} = 1;
    }

    return $o;
}

=head2 Global settings

These are mainly concerned with how the defaults are generated for each new PostScript::Graph::Style object.  

=head3 auto

This can either be the string "none" or a list of features.  The list of features only makes sense if C<sequence>
is also given.

The first feature mentioned will vary fastest from one style to the next while the last varies slowest.  Any
features not mentioned will not be varied.  See L</"Style Generation"> for how to change the defaults for these
features.  

    red	    green   blue
    yellow  mauve   cyan
    gray    dashes  width
    shape   size

B<Example 1>

    $ps = new PostScript::Graph::Style(
	    auto => [qw( dashes shape )],
	    bar  => {},
	);
	
Setting C<auto> to the string 'none' (instead of the array) prevents the automatic generation of defaults, as
does setting every option directly.

Calling B<new> again with the same options returns the next set of defaults.  

Whenever C<auto> is given a new list, the dynamic defaults are reset.

If nothing is given, the behaviour depends on whether this is the first call to B<new> or a repeated call.  If
C<auto> is not present or no list is given when the dynamic defaults are first initialized, all non-colour values
are assumed.  

=head3 changes_only

Set this to 0 if you need every style parameter written out to postscript.  If this is 1, only the changes from
the previous style settings are added to the file.  (Default: 1)

=head3 use_color

Set this to 0 to use shades of grey for monochrome printers.

This also must be set to 0 to cycle through user defined colours.  See L</"Style Generation"> for how to set
those.  This switch actually determines whether the colour value is taken from the gray array or a composite of
the red, green and blue arrays.  So putting the custom colours into 'gray' and setting C<color> to 0 reads these.
The internal postscript code handles each format interchangeably, so the result is coloured gray!

=head3 same

By default, the outer colour is the complement of the background (see L</"outer_color">).  Setting this to 1 makes
the outer colour the same as the background.

=head3 sequence

This identifies a sequence of default values.  If this is not defined (but 'auto' is not 'none'), a new sequence
would be created with each call resulting in the same style every time.

=head2 Graphic settings

The options described below belong within C<line>, C<bar> or C<point> sub-hashes unless otherwise mentioned.
For example, referring to the descriptions for C<color> and C<size>:

    line  => { color => ... }	    valid
    point => { color => ... }	    valid
    
    line  => { size => ... }	    NOT valid
    point => { size => ... }	    valid

The sub-hashes are significant.  B<They should be present> if that feature is to be used, even if the sub-hash is
empty.  Otherwise, no postscript values of that type will be defined.
    
All C<color> options within these sub-hashes take either a single greyscale decimal or a reference to an array
holding decimals for red, green and blue components.  All decimals should be between 0 and 1.0 inclusive.

    color       => 1		    white
    outer_color => 0		    black
    inner_color => [1, 0, 0]	    red
    
B<Example 2>

    $ps = new PostScript::Graph::Style(
	    auto  => "none",
	    line  => {
		width       => 2,
		inner_color => [ 1, 0.6, 0.4 ],
	    }
	    point => {
		shape       => "diamond",
		size        => 12,
		color       => [ 1, 0.8, 0.8 ],
		inner_width => 2,
		outer_width => 1,
	    }
	);
   
=head3 color

A synonym for C<inner_color>.  See L</"new">.

=head3 dashes

Set both inner and outer dash patterns.  See L</"inner_dashes">.

=head3 inner_color

The main colour of the line or point.  See L</"new">.

=head3 inner_dashes

This array ref holds values that determine any dash pattern.  They are repeated as needed to give the size 'on'
then 'off'.  Examples are the best way to describe this.

    inner_dashes => []		-------------------------
    inner_dashes => [ 3 3 ]	---   ---   ---   ---   -
    inner_dashes => [ 5 2 1 2 ]	-----  -  -----  -  -----

Only available for lines.

=head3 inner_width

The size of the central portion of the line.  Although this can be set of points, C<size> is more likely to be
what you want.  Probably should be no less than 0.1 to be visible - 0.24 on a 300dpi device or 1 on 72dpi.
(Default: 0.5)

When used in conjunction with C<inner_dashes>, setting inner and outer widths to the same value produces
a two-colour dash.

=head3 outer_color

Colour for the 'edges' of the line or point.  To be visible C<outer_width> must be greater than <inner_width>.
(Default: -1)

Note that the default is NOT a valid postscript value (although C<gpapercolor> handles it fine. See
L<PostScript::Graph::Paper/gpapercolor>.  If B<default_bgnd()> is called later, it fills all colours marked thus
with a background colour now known.

=head3 outer_dashes

If this is unset, inner lines alternate with the outer colour.  To get a dashed line, this should be the same
value as C<inner_dashes>.  (Default: "[]")

Only available for lines.

=head3 outer_width

Total width of the line or point, including the border (which may be invisible, depending on colour).  The edge is
only visible if this is at least 0.5 greater than C<inner_width>.  2 or 3 times C<inner_width> is often best.
(Default: 1.5)

When using the C<circle> point shape, this should be quite small to allow the line to be visible inside the
circle.

=head3 shape

This string specifies the built-in shape to use for points.  Suitable values are "plus", "cross", "dot", "circle",
"square" and "diamond".  (Default: "dot")

Only available for points.

=head3 size

Width across the inner part of a point shape.  (Default: 5)

Not available for lines.

=head3 width

Set the inner line width.  The outer width is also set to twice this value.

=cut

sub number_value {
    my ($o, $name) = @_;
    my $res = "/$name ". $o->{$name} . " def\n";
    my $prev = $o->{seq} && $o->{seq}->previous_style();
    if ($o->{rel} and $prev) {
	my $new = $o->{$name} || '';
	my $old = $prev->{$name} || '';
	$res = '' if ($new eq $old);
    }
    return $res;
}
# Internal method
# expects variable name and hash key
# string to add to postscript code

sub shape_value {
    my ($o, $name) = @_;
    my $res = "/$name /make_$o->{$name} cvx def\n";
    my $prev = $o->{seq} && $o->{seq}->previous_style();
    if ($o->{rel} and $prev) {
	my $new = $o->{$name} || '';
	my $old = $prev->{$name} || '';
	$res = '' if ($new eq $old);
    }
    return $res;
}

sub array_value {
    my ($o, $name) = @_;
    my $res = "/$name ". str($o->{$name}) . " def\n";
    my $prev = $o->{seq} && $o->{seq}->previous_style();
    if ($o->{rel} and $prev) {
	my $new = str($o->{$name}) || '';
	my $old = str($prev->{$name}) || '';
	$res = '' if ($new eq $old);
    }
    return $res;
}

=head1 OBJECT METHODS

=cut

sub write {
    my ($o, $ps) = @_;
    $o->ps_functions($ps);	    # only active on first call
  
    #my $prev = $o->{seq}->previous_style() if ($o->{seq});
    #my $psid = $prev ? $prev->id() : 'undef';
    #print "write ${\($o->id())}, pstyle=$psid\n";
    
    my $settings = "gstyledict begin\n";
    $settings .= $o->array_value ("locolor") if ($o->{use_line});
    $settings .= $o->number_value("lowidth") if ($o->{use_line});
    $settings .= $o->array_value ("lostyle") if ($o->{use_line});
    $settings .= $o->array_value ("licolor") if ($o->{use_line});
    $settings .= $o->number_value("liwidth") if ($o->{use_line});
    $settings .= $o->array_value ("listyle") if ($o->{use_line});
    $settings .= $o->shape_value ("ppshape") if ($o->{use_point});
    $settings .= $o->number_value("ppsize")  if ($o->{use_point});
    $settings .= $o->number_value("powidth") if ($o->{use_point});
    $settings .= $o->array_value ("pocolor") if ($o->{use_point});
    $settings .= $o->array_value ("picolor") if ($o->{use_point});
    $settings .= $o->number_value("piwidth") if ($o->{use_point});
    $settings .= $o->array_value ("bocolor") if ($o->{use_bar});
    $settings .= $o->number_value("bowidth") if ($o->{use_bar});
    $settings .= $o->array_value ("bicolor") if ($o->{use_bar});
    $settings .= $o->number_value("biwidth") if ($o->{use_bar});
    $settings .= "end\n";

    $o->{seq}->register_style($o) if ($o->{seq});
    $ps->add_to_page( $settings );
}   

=head3 write( ps )

Write style settings to the PostScript::File object.  This is a convenient way of setting all the postscript
variables at the same time as it calls each of the line, point and bar variants below.

All of the postscript variables are set if the constructor option C<changes_only> was
set to 0.  Otherwise, only those values that are different from the previous style are written out.

See L</POSTSCRIPT CODE> for a list of the variables set.

=cut

sub background {
    my ($o, $col, $same) = @_;
    $same = $o->{same} unless (defined $same);

    unless ($same) {
	if (ref($col) eq "ARRAY") {
	    $col->[0] = 1 - $col->[0];
	    $col->[1] = 1 - $col->[1];
	    $col->[2] = 1 - $col->[2];
	} else {
	    $col = 1 - $col;
	}
    }
    $o->{locolor} = $col if ($o->{use_line}  and $o->{locolor} < 0);
    $o->{pocolor} = $col if ($o->{use_point} and $o->{pocolor} < 0);
    $o->{bocolor} = $col if ($o->{use_bar}   and $o->{bocolor} < 0);
}

=head3 background( grey | arrayref [, same] )

The default outer colour setting (-1) is interpreted as 'use complement to graphpaper background'.  Of course, it
is not possible to bind that until the graphpaper object exists.  Calling this function sets all outer colour
values to be a complement of the colour given, unless C<same> is set to non-zero.  If not given, C<same> takes on
the value given to the constuctor or 0 by default.

=cut

sub sequence { 
    shift()->{seq}; 
}

sub id {
    my $o = shift;
    my $seqid = $o->{seq} ? $o->{seq}->id() : "<none>";
    my $ownid = $o->{id} ? $o->{id} : "<none>";
    return "$seqid.$ownid";
}

sub same { 
    shift()->{same}; 
}

sub color {
    shift()->{color};
}

sub line_outer_color { 
    shift()->{locolor}; 
}

sub line_outer_width {
    shift()->{lowidth};
}

sub line_outer_dashes {
    shift()->{lostyle};
}

sub line_inner_color {
    shift()->{licolor};
}

sub line_inner_width {
    shift()->{liwidth};
}

sub line_inner_dashes { 
    shift()->{listyle}; 
}

sub bar_outer_color {
    shift()->{bocolor};
}

sub bar_outer_width {
    shift()->{bowidth};
}

sub bar_inner_color {
    shift()->{bicolor};
}

sub bar_inner_width {
    shift()->{biwidth};
}

sub point_size {
    shift()->{ppsize}; 
}

sub point_shape {
    shift()->{ppshape};
}

sub point_outer_color {
    shift()->{pocolor};
}

sub point_outer_width {
    shift()->{powidth};
}

sub point_inner_color {
    shift()->{picolor};
}
sub point_inner_width {
    shift()->{piwidth};
}

sub use_line {
    return shift()->{use_line};
}

=head2 use_line

Return 1 if line settings are used.

=cut

sub use_point {
    return shift()->{use_point};
}

=head2 use_point

Return 1 if point settings are used.

=cut

sub use_bar {
    return shift()->{use_bar};
}

=head2 use_bar

Return 1 if bar settings are used.

=cut

=head1 POSTSCRIPT CODE

=head2 PostScript variables

These are set within the 'gstyledict' dictionary.  All C<...color> variables are either a decimal or an array
holding red, green and blue values.  They are best passed to L<PostScript::Graph::Paper/gpapercolor>.

    PostScript	Perl method
    ==========	===========
    locolor	line_outer_color
    lowidth	line_outer_width
    lostyle	line_outer_dashes
    licolor	line_inner_color
    liwidth	line_inner_width
    listyle	line_inner_dashes
 
    ppshape	point_shape
    ppsize	point_size
    pocolor	point_outer_color
    powidth	point_outer_width
    picolor	point_inner_color
    piwidth	point_inner_width
    
    bocolor	bar_outer_color
    bowidth	bar_outer_width
    bicolor	bar_inner_color
    biwidth	bar_inner_width

=head2 Setting Styles

Once B<write> has been called to update the postscript variables, the graphic environment must be set to use them.
The GraphStyle resource provides a number of functions for this.

=head3 line_inner

Sets the colour, width and dash pattern for a line.

=head3 line_outer

Sets the colour, width and dash pattern for a line's edge.

=head3 point_inner

Sets the colour and width for a point.

=head3 point_outer

Sets the colour and width for a point's edge.

=head3 bar_inner

Sets the colour and width for a bar.

=head3 bar_outer

Sets the colour and width for a bar's edge.

=head2 Drawing Functions

The functions which draw the shapes all remove 'x y' from the stack.  They use a variable 'ppsize' which should be
the total width of the shape.

    make_plus
    make_cross
    make_dot
    make_circle
    make_square
    make_diamond

=cut

sub ps_functions {
    my ($class, $ps) = @_;
    
    my $name = "GraphStyle";
    $ps->add_function( $name, <<END_FUNCTIONS ) unless ($ps->has_function($name));
	/gstyledict 20 dict def
	gstyledict begin
	    % _ => _
	    /line_outer {
		gpaperdict begin gstyledict begin
		    locolor gpapercolor
		    lowidth setlinewidth
		    lostyle 0 setdash
		end end
	    } bind def
	    
	    % _ => _
	    /line_inner {
		gpaperdict begin gstyledict begin
		    licolor gpapercolor
		    liwidth setlinewidth
		    listyle 0 setdash
		end end
	    } bind def
	    
	    % _ => _
	    /point_outer {
		gpaperdict begin gstyledict begin
		    pocolor gpapercolor
		    powidth setlinewidth
		    [ ] 0 setdash
		end end
	    } bind def
	    
	    % _ => _
	    /point_inner {
		gpaperdict begin gstyledict begin
		    picolor gpapercolor
		    piwidth setlinewidth
		    [ ] 0 setdash
		end end
	    } bind def

	    % _ => _
	    /bar_outer {
		gpaperdict begin gstyledict begin
		    pocolor gpapercolor
		    powidth setlinewidth
		    [ ] 0 setdash
		end end
	    } bind def
	    
	    % _ => _
	    /bar_inner {
		gpaperdict begin gstyledict begin
		    picolor gpapercolor
		    piwidth setlinewidth
		    [ ] 0 setdash
		end end
	    } bind def

	    % _ x y => _
	    /make_plus {
		gpaperdict begin gstyledict begin
		    newpath
		    moveto
		    /dx ppsize 0.5 mul def
		    /dy ppsize 0.5 mul def
		    1 -1 rmoveto
		    dx 0 rlineto
		    0 1 rlineto
		    dx neg 0 rlineto
		    0 dy rlineto
		    -1 0 rlineto
		    0 dy neg rlineto
		    dx neg 0 rlineto
		    0 -1 rlineto
		    dx 0 rlineto
		    0 dy neg rlineto
		    1 0 rlineto
		    0 dy rlineto
		    closepath
		end end
	    } bind def
	    
	    % x y => _
	    /make_cross {
		gpaperdict begin gstyledict begin
		    newpath
		    moveto
		    /dx ppsize 0.7071 mul def
		    /dy ppsize 0.7071 mul def
		    dx dy rlineto
		    dx neg dy neg rlineto
		    dx neg dy rlineto
		    dx dy neg rlineto
		    dx neg dy neg rlineto
		    dx dy rlineto
		    dx dy neg rlineto
		    dx neg dy rlineto
		    closepath
		end end
	    } bind def
	    
	    % x y => _
	    /make_dot {
		gpaperdict begin gstyledict begin
		    newpath
		    1 index ppsize 2 div add 1 index moveto
		    ppsize 2 div 0 360 arc
		    closepath
		end end
	    } bind def

	    % x y => _
	    /make_circle {
		gpaperdict begin gstyledict begin
		    newpath
		    1 index ppsize 0.6 mul add 1 index moveto
		    2 copy ppsize 0.6 mul 0 360 arc
		    1 index ppsize 0.5 mul add 1 index moveto
		    ppsize 0.5 mul 0 360 arc
		    closepath
		end end
	    } bind def

	    % x y => _
	    /make_square {
		gpaperdict begin gstyledict begin
		    newpath
		    ppsize 2 div add exch
		    ppsize 2 div add exch moveto
		    0 ppsize neg rlineto
		    ppsize neg 0 rlineto
		    0 ppsize rlineto
		    closepath
		end end
	    } bind def

	    % x y => _
	    /make_diamond {
		gpaperdict begin gstyledict begin
		    newpath
		    /dx ppsize 0.5 mul def
		    /dy ppsize 0.75 mul def
		    dy add moveto
		    dx neg dy neg rlineto
		    dx dy neg rlineto
		    dx dy rlineto
		    closepath
		end end
	    } bind def

	end
END_FUNCTIONS
}

=head2 ps_functions

This class function provides the PostScript dictionary C<gstyledict> and code defining the specialist Style functions.

=cut

=head1 BUGS

Using the compound colours yellow, mauve and cyan with other colours can have unpredictable results.

Using an auto colour with 'color => 0' fails to produce shades of grey.

=head1 AUTHOR

Chris Willmot, chris@willmot.org.uk

=head1 SEE ALSO

L<PostScript::File>, L<PostScript::Graph::Paper>, L<PostScript::Graph::Key>, L<PostScript::Graph::XY>.

=cut

1;
