package PostScript::GraphStyle;
use strict;
use warnings;
use PostScript::File qw(str);
require Exporter;

our $VERSION = "0.01";
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(defaults init_defaults);

our %flag;
$flag{color} = 1;
$flag{same} = 0;

# Prototypes for functions only
sub init_defaults ($);
sub output_row;
sub next_row;
    
#== Style object =============================================================

=head1 NAME

PostScript::GraphStyle - style settings for postscript objects

=head1 SYNOPSIS

Each time a new object is created the default style will be slightly different.

    use PostScript::GraphStyle;
    use PostScript::File;

    $psf = new PostScript::File();
    while (...) {
	$pgs = new PostScript::GraphStyle();
	$psf->add_to_page( <<END_OF_CODE );
	    % code fragments using variables...
	    
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
    
It is possible to control how each new object varies.

    $PostScript::GraphStyle::defaults{red} =
	    [ 0, 1, 0.2, 0.8, 0.4, 0.6 ];
	    
    $pgs = new PostScript::GraphStyle(
		auto => [ qw(dashes cyan shape) ], 
	    );

    $psf = new PostScript::File();
    while (...) {
	$pgs = new PostScript::GraphStyle();
	... the same postscript variables ...
    }
    
Some of the styles may be overriden.

    $pgs = new PostScript::GraphStyle(
		auto  => [ qw(red green blue) ],
		color => 1,
		line  => {
		    width        => 4,
		    outer_dashes => [],
		    outer_color  => [1, 0, 0],
		},
	    );

Or the automatic default feature can be supressed and some or all details specified directly.


    $pgs = new PostScript::GraphStyle(
		auto  => "none",
		point => {
		    shape => "circle",
		    size  => 12,
		},
	    );

=head1 DESCRIPTION

Creating a new style will by default do just that - create a new style.  Such dynamic defaults are a main
feature of this class and most users should not need to specify individual settings.

Settings are provided for three types of object.  A B<line> is any unfilled path, a B<bar> is any filled path
while a B<point> is a filled path that may contain holes.

They all have outer and inner components.  The inner component provides the main shape and colour, while the outer
'edge' is provided to insulate this from any background colour.  Lines may be whole or broken and a variety of
builtin shapes is provided.  By default, repeated calls to B<new> return styles that differ from one another
although like everything else this can be under detailed user control if required.

The following functions return values set in the constructor.  See L</"new"> for more details.

    same()
    color()
    line_outer_color()
    line_outer_width()
    line_outer_dashes()
    line_inner_color()
    line_inner_width()
    line_inner_dashes()

    bar_outer_color()
    bar_outer_width()
    bar_inner_color()
    bar_inner_width()

    point_size()
    point_shape()
    point_outer_color()
    point_outer_width()
    point_inner_color()
    point_inner_width()

head1 CONSTRUCTOR

B<new( [options] )>

C<options> can either be a list of hash keys and values or a single hash reference.  In both cases the hash must
have the same structure.  There are a few principal keys and most of these refer to hashes holding a group of
options.  No attempt is made to constrain the combinations but not all are useful or sensible and bizarre choices
will probably fail.

=head2 Global settings

These are mainly concerned with how the defaults are generated for each new PostScript::GraphStyle object.  

=head3 auto

This can either be the string "none" or a list of features.  The first feature mentioned will vary fastest from
one style to the next while the last varies slowest.  Any features not mentioned will not be varied.  See
L</"DYNAMIC DEFAULTS"> for how to change the defaults for these features.  

    red	    green   blue
    yellow  mauve   cyan
    dashes  width   shapes
    size    gray

B<Example 1>

    $ps = new PostScript::GraphStyle(
	    auto => [qw( dashes shapes )],
	);
	
Setting C<auto> to the string 'none' (instead of the array) prevents the automatic generation of defaults, as
does setting every option directly.

If nothing is given, the behaviour depends on whether this is the first call to B<new> or a repeated call.  If
C<auto> is not present or no list is given when the dynamic defaults are first initialized, all non-colour values
are assumed.  Calling B<new> again without C<auto> being specified returns the next set of defaults (the same if
'none' was given initially).  Whenever C<auto> is given a new list, the dynamic defaults are reset.

=head3 color

Set this to 0 to use shades of grey for monochrome printers.

This also must be set to 0 to cycle through user defined colours.  This switch actually determines whether the
colour value is taken from the defaults{grey} array or a composite of the red, green and blue arrays.  So putting
the custom colours into defaults{grey} and setting C<color> to 0 reads these.  The internal postscript code
handles each format interchangeably, so the result is coloured gray!

    $PostScript::GraphStyle::Defaults{gray} =
	[ [ 0, 0, 0 ],	    # white
	  [ 0, 0, 1 ],	    # blue
	  [ 0, 1, 0 ],	    # green
	  [ 0, 1, 1 ],	    # cyan
	  [ 1, 0, 0 ],	    # red
	  [ 1, 0, 1 ],	    # mauve
	  [ 1, 1, 0 ],	    # yellow
	  [ 1, 1, 1 ], ];   # black

    $gs = new PostScript::GraphStyle(
		auto  => [qw(gray)],
		color => 0,
	    );
    
=head3 same

By default, the outer colour is the complement of the background (see L</"outer_color">).  Setting this to 1 makes
the outer colour the same as the background.

=head2 Graphic settings

The options described below belong within C<line>, C<bar> or C<point> sub-hashes unless otherwise mentioned.
For example, referring to the descriptions for C<color> and C<size>:

    line  => { color => ... }	    valid
    point => { color => ... }	    valid
    
    line  => { size => ... }	    NOT valid
    point => { size => ... }	    valid

All C<color> options take either a single greyscale decimal or a reference to an array holding decimals for
red, green and blue components.  All decimals should be between 0 and 1.0 inclusive.

    color       => 1		    white
    outer_color => 0		    black
    inner_color => [1, 0, 0]	    red
    
B<Example 2>

    $ps = new PostScript::GraphStyle(
	    defaults => "none",
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
L<PostScript::GraphPaper/gpapercolor>.  If B<default_bgnd()> is called later, it fills all colours marked thus
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

sub new {
    my $class = shift;
    my $opt = {};
    if (@_ == 1) {
	$opt = $_[0];
    } else {
	%$opt = @_;
    }
   
    my $o = {};
    bless( $o, $class );

    my $d         = init_defaults($opt->{auto});

    $o->{same}    = defined($opt->{same})         ? $opt->{same}         : 0;	# 'don't complement bgnd'
    $o->{color}   = defined($opt->{color})        ? $opt->{color}        : 1;	# 'not monochrome'
    my $color     = $o->{color} ? [ $d->{red}, $d->{green}, $d->{blue} ] : $d->{gray};
    
    my $li = $opt->{line};
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
    
    my $bl = $opt->{bar};
    my $bwidth    = defined($li->{width})         ? $li->{width}         : $d->{width};
    $o->{bocolor} = defined($bl->{outer_color})   ? $bl->{outer_color}   : -1;
    $o->{bowidth} = defined($bl->{outer_width})   ? $bl->{outer_width}   : 2 * $bwidth;
    
    $o->{bicolor} = defined($li->{color})         ? $li->{color}         : $color;
    $o->{bicolor} = defined($bl->{inner_color})   ? $bl->{inner_color}   : $o->{bicolor};
    $o->{biwidth} = defined($bl->{inner_width})   ? $bl->{inner_width}   : $bwidth;
    $o->{use_bar} = 1;

    my $sh = $opt->{point};
    my $pwidth    = defined($li->{width})         ? $li->{width}         : $d->{width};
    $o->{ssize}   = defined($sh->{size})          ? $sh->{size}          : $d->{size};
    $o->{sshape}  = defined($sh->{shape})         ? $sh->{shape}         : $d->{shape};
    
    $o->{socolor} = defined($sh->{outer_color})   ? $sh->{outer_color}   : -1;
    $o->{sowidth} = defined($sh->{outer_width})   ? $sh->{outer_width}   : 2 * $pwidth;
    
    $o->{sicolor} = defined($sh->{color})         ? $sh->{color}         : $color;
    $o->{sicolor} = defined($sh->{inner_color})   ? $sh->{inner_color}   : $o->{sicolor};
    $o->{siwidth} = defined($sh->{inner_width})   ? $sh->{inner_width}   : $pwidth;
    $o->{use_point} = 1;

    return $o;
}

=head3 ps_functions( ps [, dict [, set]] )

=over 4

=item C<ps>

The PostScript::File object being written to.

=item C<dict>

The postscript dictionary where these 14 definitions are to be added.

=item C<set>

Put 0 here if the call to B<set()> is not required.

=back

Add style functions into the postscript prolog.  Nothing works unless this is given.  It is not included within
B<new> to give the opportunity to specify the postscript dictionary.  Typically this would be the main 'userdict'
replacement.  The dictionary C<gpaperdict> must be present.  See L<PostScript::GraphPaper/"POSTSCRIPT CODE">).

This includes a call to L</"set">.

=cut

sub ps_functions {
    my ($o, $ps, $dict, $set) = @_;
    my ($begin, $end);
    $set = 1 unless (defined $set);
    if (defined $dict) {
	$begin = "gpaperdict begin $dict begin";
	$end   = "end end";
    } else {
	$begin = "gpaperdict begin";
	$end   = "end";
    }
    
    my $name = "GraphStyle";
    $ps->add_function( $name, <<END_FUNCTIONS ) unless ($ps->has_function($name));
	$dict begin
	    % _ => _
	    /line_outer {
		$begin
		    locolor gpapercolor
		    lowidth setlinewidth
		    lostyle 0 setdash
		$end
	    } bind def
	    
	    % _ => _
	    /line_inner {
		$begin
		    licolor gpapercolor
		    liwidth setlinewidth
		    listyle 0 setdash
		$end
	    } bind def
	    
	    % _ => _
	    /point_outer {
		$begin
		    pocolor gpapercolor
		    powidth setlinewidth
		    [ ] 0 setdash
		$end
	    } bind def
	    
	    % _ => _
	    /point_inner {
		$begin
		    picolor gpapercolor
		    piwidth setlinewidth
		    [ ] 0 setdash
		$end
	    } bind def

	    % _ => _
	    /bar_outer {
		$begin
		    pocolor gpapercolor
		    powidth setlinewidth
		    [ ] 0 setdash
		$end
	    } bind def
	    
	    % _ => _
	    /bar_inner {
		$begin
		    picolor gpapercolor
		    piwidth setlinewidth
		    [ ] 0 setdash
		$end
	    } bind def

	    % _ x y => _
	    /make_plus {
		$begin
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
		$end
	    } bind def
	    
	    % x y => _
	    /make_cross {
		$begin
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
		$end
	    } bind def
	    
	    % x y => _
	    /make_dot {
		$begin
		    newpath
		    1 index ppsize 2 div add 1 index moveto
		    ppsize 2 div 0 360 arc
		    closepath
		$end
	    } bind def

	    % x y => _
	    /make_circle {
		$begin
		    newpath
		    1 index ppsize 0.6 mul add 1 index moveto
		    2 copy ppsize 0.6 mul 0 360 arc
		    1 index ppsize 0.5 mul add 1 index moveto
		    ppsize 0.5 mul 0 360 arc
		    closepath
		$end
	    } bind def

	    % x y => _
	    /make_square {
		$begin
		    newpath
		    ppsize 2 div add exch
		    ppsize 2 div add exch moveto
		    0 ppsize neg rlineto
		    ppsize neg 0 rlineto
		    0 ppsize rlineto
		    closepath
		$end
	    } bind def

	    % x y => _
	    /make_diamond {
		$begin
		    newpath
		    /dx ppsize 0.5 mul def
		    /dy ppsize 0.75 mul def
		    dy add moveto
		    dx neg dy neg rlineto
		    dx dy neg rlineto
		    dx dy rlineto
		    closepath
		$end
	    } bind def

	end
END_FUNCTIONS

    $o->set( $ps, $dict ) if ($set);
}

=head3 set( ps, [ dict ] )

=over 4

=item C<ps>

The PostScript::File object being written to.

=item C<dict>

If given, a selection of the 19 possible definitions are added to the postscript dictionary.

=back

The point at which the style values are set into postscript.  This is a convenient way of setting all the
postscript variables at the same time as it calls each of the line, point and bar variants below.  It is called by
B<ps_functions> which should be sufficient in most cases.

=item B<set_line( ps, [ dict ] )>

This sets the following postscript variables.

    PostScript	Perl method
    ==========	===========
    locolor	line_outer_color
    lowidth	line_outer_width
    lostyle	line_outer_dashes
    licolor	line_inner_color
    liwidth	line_inner_width
    listyle	line_inner_dashes
 
=item B<set_point( ps, [ dict ] )>

This sets the following postscript variables.

    PostScript	Perl method
    ==========	===========
    ppshape	point_shape
    ppsize	point_size
    pocolor	point_outer_color
    powidth	point_outer_width
    picolor	point_inner_color
    piwidth	point_inner_width


=item B<set_bar( ps, [ dict ] )>

This sets the following postscript variables.

    PostScript	Perl method
    ==========	===========
    bocolor	bar_outer_color
    bowidth	bar_outer_width
    bicolor	bar_inner_color
    biwidth	bar_inner_width

=cut

sub set {
    my $o = shift;
    $o->set_line(@_);
    $o->set_point(@_);
    $o->set_bar(@_);
}

sub set_line {
    my ($o, $ps, $dict) = @_;
    my ($begin, $end) = ("", "");
    if (defined $dict) {
	$begin = "$dict begin";
	$end = "end";
    }
   
    if ($o->{use_line}) {
	my $locolor = str($o->{locolor});
	my $lostyle = str($o->{lostyle});
	my $licolor = str($o->{licolor});
	my $listyle = str($o->{listyle});

	$ps->add_to_page( <<END_LINE_STYLE );
	    $begin
		/locolor $locolor def
		/lowidth $o->{lowidth} def
		/lostyle $lostyle def
		/licolor $licolor def
		/liwidth $o->{liwidth} def
		/listyle $listyle def
	    $end
END_LINE_STYLE
    }
}   

sub set_point {
    my ($o, $ps, $dict) = @_;
    my ($begin, $end) = ("", "");
    if (defined $dict) {
	$begin = "$dict begin";
	$end = "end";
    }
 
    if ($o->{use_point}) {
	my $socolor = str($o->{socolor});
	my $sicolor = str($o->{sicolor});
	
	$ps->add_to_page( <<END_SHAPE_STYLE );
	    $begin
		/ppshape /make_$o->{sshape} cvx def
		/ppsize $o->{ssize} def
		/pocolor $socolor def
		/powidth $o->{sowidth} def
		/picolor $sicolor def
		/piwidth $o->{siwidth} def
	    $end
END_SHAPE_STYLE
    }
}   

sub set_bar {
    my ($o, $ps, $dict) = @_;
    my ($begin, $end) = ("", "");
    if (defined $dict) {
	$begin = "$dict begin";
	$end = "end";
    }
    
    if ($o->{use_bar}) {
	my $bocolor = str($o->{bocolor});
	my $bicolor = str($o->{bicolor});
	
	$ps->add_to_page( <<END_BLOCK_STYLE );
	    $begin
		/bocolor $bocolor def
		/bowidth $o->{bowidth} def
		/bicolor $bicolor def
		/biwidth $o->{biwidth} def
	    $end
END_BLOCK_STYLE
    }
}   

=head3 background( grey | arrayref [, same] )

The default outer colour setting (-1) is interpreted as 'use complement to graphpaper background'.  Of course, it
is not possible to bind that until the graphpaper object exists.  Calling this function sets all outer colour
values to be a complement of the colour given, unless C<same> is set to non-zero.  If not given, C<same> takes on
the value given to the constuctor or 0 by default.

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
    $o->{locolor} = $col if ($o->{locolor} < 0);
    $o->{socolor} = $col if ($o->{socolor} < 0);
    $o->{bocolor} = $col if ($o->{bocolor} < 0);
}

sub same              { my $o = shift; return $o->{same}; }
sub color             { my $o = shift; return $o->{color}; }
sub line_outer_color  { my $o = shift; return $o->{locolor}; }
sub line_outer_width  { my $o = shift; return $o->{lowidth}; }
sub line_outer_dashes { my $o = shift; return $o->{lostyle}; }
sub line_inner_color  { my $o = shift; return $o->{licolor}; }
sub line_inner_width  { my $o = shift; return $o->{liwidth}; }
sub line_inner_dashes { my $o = shift; return $o->{listyle}; }

sub bar_outer_color  { my $o = shift; return $o->{bocolor}; }
sub bar_outer_width  { my $o = shift; return $o->{bowidth}; }
sub bar_inner_color  { my $o = shift; return $o->{bicolor}; }
sub bar_inner_width  { my $o = shift; return $o->{biwidth}; }

sub point_size         { my $o = shift; return $o->{ssize}; }
sub point_shape        { my $o = shift; return $o->{sshape}; }
sub point_outer_color  { my $o = shift; return $o->{socolor}; }
sub point_outer_width  { my $o = shift; return $o->{sowidth}; }
sub point_inner_color  { my $o = shift; return $o->{sicolor}; }
sub point_inner_width  { my $o = shift; return $o->{siwidth}; }

#== Dynamic default styles ===================================================

=head1 DYNAMIC DEFAULTS

Although it is possible to specify styles directly, mostly  the style just needs to be different from the last
one.  These dynamic defaults provide around 3600 variations which should be suitable for most cases.

The values themselves are placed in a pseudo-hash and can be replaced if desired.  Permutations of these are then
generated on demand.  The permutation order is under user control.

=head2 defaults

This class variable must be explicitly requested:

    use PostScript::GraphStyle qw(defaults);

It is a pseudo-hash with fields C<red>, C<green>, C<blue>, C<shape>, C<width>, C<dashes>  Thickness is
'width' elsewhere.  Green is used for C<gray> below.  Each refers to an array of suitable values whose order is
significant.

    $defaults{blue}   = [ 0.0, 1.0, 0.5 ];
    $defaults{shape}  = [qw(dot square cross)];
    $defaults{dashes} = [ [], [3 3], [10 5 3 5] ];

Specifying alternative values determines the pool of defaults.  For example the following would ensure lines with
15 shades of red-orange-yellow.

    $defaults{red}    = [ 0.2, 1, 0.4, 0.8, 0.6 ];
    $defaults{green}  = [ 0, 0.8, 0.4 ];
    $defaults{blue}   = [ 0 ];
    
=cut

our %defaults = (
    red    => [ 0.1, 0.9, 0.5 ],
    green  => [ 0.1, 0.9, 0.5 ],
    blue   => [ 0.1, 0.9, 0.5 ],
    yellow => [ 0.1, 0.9, 0.5 ],
    mauve  => [ 0.1, 0.9, 0.5 ],
    cyan   => [ 0.1, 0.9, 0.5 ],
    gray   => [ 0.1, 0.6, 0.2, 0.7, 0.3, 0.8, 0.5 ],
    shape  => [qw(dot cross square plus diamond circle)],
    width  => [ 0.25, 1, 0.5, 4, 2 ],
    dashes => [ [], [3, 3], [9, 9], [10, 5, 3, 5] ],
    size   => [ 5, 3, 7 ],
);

# Ensure init_defaults is only called once
our $initialized = 0;
our (@choices, @max, @count);

sub init_defaults ($) {
    my $d = shift;
    if (not defined($d) or ref($d) eq "ARRAY") {
	if ($initialized) {
	    return next_row();
	} else {
	    $initialized = 1;

	    foreach my $ch (@$d) {
		push @choices, $ch if (defined $defaults{$ch});
	    }
	    if (@choices == 0) {
		@choices = qw(shape dashes size width);
	    }
	    #print "choices = " . join(", ", @choices) . "\n";

	    foreach my $key (@choices) {
		if (defined $defaults{$key}) {
		    push @max, $#{$defaults{$key}};
		    push @count, 0;
		}
	    }

	    return output_row();
	}
    } else {
	return default_defaults();
    }
}

# Internal function
# ensuring all defaults have some value
# 
sub default_defaults {
    my %ref;
    $ref{red} = 0;
    $ref{green} = 0;
    $ref{blue} = 0;
    $ref{gray} = 0;
    $ref{shape} = "dot";
    $ref{width} = 0.5;
    $ref{dashes} = [];
    $ref{size} = 5;
    return \%ref;
}

# Internal function, returning a hash mapping
# $defaults fields with values chosen
# 
sub output_row {
    my $r = default_defaults();
    for (my $i = 0; $i < @count; $i++) {
	my $key    = $choices[$i];
	my $array  = $defaults{$key};
	my $chosen = $count[$i];
	my $value  = $array->[$chosen];
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
		$r->{blue}  = $value;
		$r->{green} = $value;
		last CASE;
	    }
	    if ($key =~ /gray/) {
		$r->{red}   = $value * 0.3;
		$r->{green} = $value * 0.59;
		$r->{blue}  = $value * 0.11;
		$r->{gray}  = $value;
		last CASE;
	    }
	    $r->{$key} = $value if (defined $r->{$key});
	}
    }
    #printf ('rgb=%s %s %s%s', $r->{red}, $r->{green}, $r->{blue}, "\n"); 
    #print "count = " . join(", ", @count) . "\n";
    return $r;
}

# Internal function returning next permutation
# as output_row(), repeating indefinitely.
# 
sub next_row {
    if (@count) {
	my $i = 0;
	while (1) {
	    if ($count[$i] < $max[$i]) {
		$count[$i]++;
		return output_row();
	    } else {
		$count[$i] = 0;
		if ($i < $#choices) {
		    $i++;
		} else {
		    $i = 0;
		    return output_row();
		}
	    }
	}
    } else {
	return default_defaults();
    }
}

#=============================================================================

=head1 POSTSCRIPT CODE

=head2 PostScript variables

See L</"set"> for the values accessible from postscript.  All C<...color> variables are either a decimal or an
array holding red, green and blue values.  These are best passed to L<PostScript::GraphPaper/gpapercolor>.

=head2 Setting Styles

The styles only have any effect by calling the postscript functions provided in the GraphStyle resource.  They are
all called initially by B<new>.  When using several styles at the same time it will be necessary to call one of
the B<set_> methods to initialize the postscript variables before calling one of these functions to change the
graphic state values.

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

    
=head1 BUGS

Using the compound colours yellow, mauve and cyan with other colours can have unpredictable results.

Using an auto colour with 'color => 0' fails to produce shades of grey.

=head1 AUTHOR

Chris Willmot, chris@willmot.org.uk

=head1 SEE ALSO

L<PostScript::File>

=cut



1;

