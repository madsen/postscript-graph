package PostScript::Graph::Key;
use strict;
use warnings;
use PostScript::File 0.1 qw(str);
use PostScript::Graph::Paper 0.08;

our $VERSION = '0.04';

=head1 NAME

PostScript::Graph::Key - a Key area for PostScript::Graph::Paper

=head1 SYNOPSIS

    use PostScript::File;
    use PostScript::Graph::Key;
    use PostScript::Graph::Paper;
    
=head2 Typical

    my $ps = new PostScript::File;
    my @bbox = $psf->get_page_bounding_box();

    # Calculate variables from the graph data
    # planned layout and available space ...
    
    my $gk = new PostScript::Graph::Key(
		num_items   => ... ,
		max_height  => ... ,
		text_width  => ... ,
		icon_width  => ... ,
		icon_height => ... ,
	    );

    # Need to pass this to GraphPaper
    my $width = $pgk->width();

    my $gp = new PostScript::Graph::Paper(
		file => $ps,
		chart => {
		    key_width => $width,
		},
	    );

    # Now we can link the two
    $gk->build_key( $gp );

    foreach $line (@lines) {
	... draw line on graph_paper ...

	$gk->add_key_item( $title, <<END );
	    ... postscript code 
	    ... drawing icon
    END
    }

=head2 All options

    my $gp = new PostScript::Graph::Paper(
	file => $ps_file,
	graph_paper => $ps_gpaper,
	max_height => 500,
	num_items => 5,
	background => 0.9,
	outline_color => [0.5, 0.5, 0.2],
	outline_wdith => 0.8,
	spacing => 4,
	horizontal_spacing => 4,
	vertical_spacing => 6,
	icon_height => 12,
	icon_width => 40,
	text_size => 10,
	text_width => 72,
	text_color => 0,
	text_font => 'Courier',
	title => 'My Key',
	title_color => [1, 0, 0],
	title_font => 'Times-Bold',
	title_size => 14,
    };

=head1 DESCRIPTION

This module is designed as a supporting part of the PostScript::Graph suite.  For top level modules that output
something useful, see

    PostScript::Graph::Bar
    PostScript::Graph::Stock
    PostScript::Graph::XY

A companion object to PostScript::Graph::Paper, this is used by any module that requies a Key for a graph.  The
size and shape is automatically adjusted to accomodate the number of items in the space available, adding more
columns if there is not enough vertical space.

The opportunity is provided to draw an icon with each key item.  Ideally, this should use the same code and style
as is used on the graph.

=head1 CONSTRUCTOR

=cut

sub new {
    my $class = shift;
    my $opt = {};
    if (@_ == 1) { 
	$opt = $_[0]; 
    } elsif (@_ == 2 and $_[0]+0 > 0) {
	($opt->{max_height}, $opt->{num_lines}) = @_; 
    } else { 
	%$opt = @_; 
    }
   
    my $o = {};
    bless( $o, $class );
    
    $o->{gp}       = defined($opt->{graph_paper})        ? $opt->{graph_paper}         : undef;
    my $ps         = defined($o->{gp})                   ? $o->{gp}->file()            : undef;
    $o->{ps}       = defined($opt->{file})               ? $opt->{file}                : $ps;

    $o->{title}    = defined($opt->{title})              ? $opt->{title}               : "Key";
    $o->{hcolor}   = defined($opt->{title_color})        ? $opt->{title_color}         : 0;
    $o->{hfont}    = defined($opt->{title_font})         ? $opt->{title_font}          : 'Helvetica-Bold';
    $o->{hsize}    = defined($opt->{title_size})         ? $opt->{title_size}          : 12;
    $o->{tcolor}   = defined($opt->{text_color})         ? $opt->{text_color}          : 0;
    $o->{tfont}    = defined($opt->{text_font})          ? $opt->{text_font}           : 'Helvetica';
    $o->{tsize}    = defined($opt->{text_size})          ? $opt->{text_size}           : 10;
    $o->{twidth}   = defined($opt->{text_width})         ? $opt->{text_width}          : $o->{tsize} * 4;
    $o->{fcolor}   = defined($opt->{background})         ? $opt->{background}          : 1;
    $o->{ocolor}   = defined($opt->{outline_color})      ? $opt->{outline_color}       : 0;
    $o->{owidth}   = defined($opt->{outline_width})      ? $opt->{outline_width}       : 0.75;
    
    die "Option 'max_height' must be given\nStopped" unless (defined $opt->{max_height});
    die "Option 'num_items' must be given\nStopped" unless (defined $opt->{num_items});
    $o->{height}   = $opt->{max_height};
    $o->{nitems}   = $opt->{num_items};
    
    $o->{spc}      = defined($opt->{spacing})            ? $opt->{spacing}             : 4;
    $o->{vspc}     = defined($opt->{vertical_spacing})   ? $opt->{vertical_spacing}    : $o->{spc};
    $o->{hspc}     = defined($opt->{horizontal_spacing}) ? $opt->{horizontal_spacing}  : $o->{spc} * 2;
    $o->{dxicon}   = defined($opt->{icon_width})         ? $opt->{icon_width}          : $o->{tsize};
    $o->{dyicon}   = defined($opt->{icon_height})        ? $opt->{icon_height}         : $o->{tsize};
    
    $o->{dx}       = $o->{hspc} + $o->{dxicon} + $o->{hspc} + $o->{twidth} + $o->{hspc};
    $o->{dyicon}   = ($o->{dyicon} > $o->{tsize} ? $o->{dyicon} : $o->{tsize});	       # dyicon always >= tsize
    $o->{dy}       = $o->{vspc} + $o->{dyicon};					       # space above each item
    $o->{tmargin}  = ($o->{tsize} * 2 + $o->{vspc});
    my $margins    = $o->{tmargin} + 2 * $o->{vspc};
    my $height     = $o->{height} - $margins;
    if ($o->{nitems} * $o->{dy} <= $height) {
	$o->{rows} = $o->{nitems};
	$o->{cols} = 1;
    } else {
	$o->{rows} = int( $height/$o->{dy} );
	my $cols   = $o->{nitems}/$o->{rows};
	$o->{cols} = $cols > int($cols) ? int($cols)+1 : int($cols);
    }
    $o->{height}   = $margins + $o->{rows} * $o->{dy};
    $o->{start}    = $margins;
    $o->{width}    = $o->{hspc} + $o->{cols} * $o->{dx};
    $o->{current}  = 0;	    # item to be shown
    
    return $o;
}

=head2 new( [options] )

C<options> should be either a list of hash keys and values or a hash reference.  Unlike other objects in this
series, a couple of these (C<max_height> and C<num_items>) are required.  Another difference is that all options
occur within a flat space - there are no sub-groups.  This is because it is expected that this module will only be
used as part of another Chart object, with these options passed as a group through that constructor.

All values are in PostScript native units (1/72 inch).

=head3 file

If C<graph_paper> is not given, this probably should be.  It is the PostScript::File object that holds the graph
being constructed.  It is possible to specify this later, when calling B<add_key_item>.  (No default)

=head3 background 

Background colour for the key rectangle.  (Default: 1)

=head3 graph_paper

If given, this should be a PostScript::Graph::Paper object.  A GraphKey needs to know which GraphPaper
has allocated space for it.  But the GraphPaper need the GraphKey to have already worked out how much space it
needs.  The best solution is to create the GraphKey before the GraphPaper, then pass the latter to B<build_chart>.
(No default)

=head3 horizontal_spacing

The gaps between edges, icon and text.  (Defaults to C<spacing>)

=head3 icon_height

Vertical space for each icon.  This will never be smaller than the height of the text.  (Defaults to C<text_size>)

=head3 icon_width

Amount of horizontal space to allow for the icon to the left of each label.  (Defaults to C<text_size>)

=head3 max_height

The vertical space available for the key rectangle.  GraphKey tries to fit as many items as possible within this
before adding another column.

=head3 num_items

The number of items that will be placed in the key.

=head3 outline_color

Colour of the box's outline.  (Default: 0)

=head3 outline_width

Width of the box's outline.  (Default: 0.75)

=head3 spacing

A larger value gives a less crowded feel, reduce it if you are short of space.  Think printing leading.  (Default: 4)

=head3 text_color

Colour of the text used in the body of the key.  (Default: 0)

=head3 text_font

Font used for the key body text.  (Default: "Helvetica")

=head3 text_size

Size of the font used for the key body text.  (Default: 10)

=head3 text_width

Amount of room allowed for the text label on each key item.  (Defaults to four times the font size)

=head3 title

The heading at the top of the key rectangle.  (Default: "Key")

=head3 title_color

Colour of the key heading.  (Default: 0)

=head3 title_font

The font used for the heading.  (Default: "Helvetica-Bold")

=head3 title_size

Size of the font used for the heading.  (Default: 12)

=head3 vertical_spacing

The gap between key items.  (Defaults to C<spacing>)

=head1 OBJECT METHODS

=cut

sub width { 
    return shift()->{width}; 
}

=head2 width()

Return the width required for the key rectangle.

=cut

sub height { 
    return shift()->{height}; 
}

=head2 height()

Return the height required for the key rectangle.

=cut

sub build_key {
    my ($o, $gp) = @_;
    if (defined $gp) {
	$o->{gp} = $gp;
	$o->{ps} = $gp->file();
    }
    die "No PostScript::Graph::Paper object\nStopped" unless (ref($o->{gp}) eq "PostScript::Graph::Paper");

    my ($kx0, $ky0, $kx1, $ky1) = $o->{gp}->key_area();
    my $offset = ($ky1 - $ky0 - $o->{height})/2;
    $ky0 += $offset;
    $ky1 = $ky0 + $o->{height};
    my $textc = str($o->{tcolor});
    my $outlinec = str($o->{ocolor});
    my $fillc = str($o->{fcolor});
    
    $o->{ps}->add_to_page( <<END_CODE );
	graphkeydict begin
	    /kx0 $kx0 def 
	    /ky0 $ky0 def 
	    /kx1 $kx1 def 
	    /ky1 $ky1 def
	    /kvspc $o->{vspc} def 
	    /khspc $o->{hspc} def
	    /kdxicon $o->{dxicon} def
	    /kdyicon $o->{dyicon} def
	    /kdxtext $o->{twidth} def
	    /kdytext $o->{tsize} def
	    /kfont /$o->{tfont} def
	    /ksize $o->{tsize} def
	    /kcol $textc def
	    ($o->{title}) /$o->{hfont} $o->{hsize} $o->{hcolor} $o->{owidth} $outlinec $fillc keybox
	end
END_CODE

    PostScript::Graph::Key->ps_functions($o->{ps});
}

=head2 build_key( [graph_paper] )

This is where the position of the key area is fixed and the outline and heading are drawn.  It must be called
before B<add_key_item>.

=cut

sub add_key_item {
    my ($o, $label, $code, $ps) = @_;
    $label   = ""  unless (defined $label);
    $code    = ""  unless (defined $code);
    $o->{ps} = $ps if     (defined $ps);
    die "No PostScript::File object to write to\nStopped" unless (ref($o->{ps}) eq "PostScript::File");
    
    my $n   = $o->{current}++;
    my $col = int( $n/$o->{rows} );
    my $row = $n - $col * $o->{rows};
    my $kdx = $col * $o->{dx};
    my $kdy = $o->{height} - $o->{tmargin} - ($row+1) * $o->{dy};
    $o->{ps}->add_to_page( <<END_ITEM );
	graphkeydict begin
	    /kdx $kdx def
	    /kdy $kdy def
	    newpath
	    movetoicon
	    $code
	    stroke
	    movetotext
	    ($label) show
	end
END_ITEM
}

=head2 add_key_item( label, code [, psfile] )

=over 4

=item C<label>

The text for this key item

=item C<code>

Postscript code which draws the icon.

=item C<psfile>

The PostScript::File object the code will be written to.  If it was not given to B<new> as either C<file> or
C<graph_paper>, it must be given here.

=back

A number of postscript variables are provided to help with the drawing.  See <L/POSTSCRIPT CODE> for the full list.

    kix0    left edge of icon area
    kiy0    bottom edge
    kix1    right edge
    kiy1    top edge

Your code should use its own dictionary and can refer to dictionaries you have begun but not yet ended at this
point.  For example, here is the code used by PostScript::Graph::XY.  It calculates the mid point of a diagonal line
and draws it using the same functions used for the main chart.  C<line_outer> etc. are provided by
PostScript::Graph::Style to change style settings, C<draw1point> just expects 'x y' and C<drawxyline> expects an
array of coordinates followed by the greatest index allowed.

    
	$graphkey->add_key_item( $line->{ytitle}, 
				 <<END_KEY_ITEM );
	    2 dict begin
		/kpx kix0 kix1 add 2 div def
		/kpy kiy0 kiy1 add 2 div def
		point_outer 
		kpx kpy draw1point
		[ kix0 kiy0 kix1 kiy1 ] 3  
		2 copy 
		line_outer drawxyline 
		line_inner drawxyline
		point_inner 
		kpx kpy draw1point
	    end
    END_KEY_ITEM

=cut

sub ps_functions {
    my ($class, $ps) = @_;
    my $name = "GraphKey";
    $ps->add_function( $name, <<END_FUNCTIONS ) unless ($ps->has_function($name));
	/graphkeydict 20 dict def
	graphkeydict begin
	    % _ title tfont tsize tcol boxw boxc fillc => _
	    /keybox {
		gpaperdict begin
		graphkeydict begin
		    newpath
		    kx0 ky0 moveto
		    kx1 ky0 lineto
		    kx1 ky1 lineto
		    kx0 ky1 lineto
		    closepath
		    gsave gpapercolor fill grestore
		    gpapercolor 
		    setlinewidth
		    [ ] 0 setdash
		    stroke
		    /tcol exch def
		    /tsize exch def
		    /tfont exch def
		    tfont tsize tcol gpaperfont
		    kx0 kx1 add 2 div
		    ky1 tsize 1.2 mul sub
		    centered
		end end
	    } bind def
	
	    % _ => _
	    /movetoicon {
		graphkeydict begin
		    /kix0 kx0 kdx add khspc add def
		    /kiy0 ky0 kdy add def
		    /kix1 kix0 kdxicon add def
		    /kiy1 kiy0 kdyicon add def
		    kix0 kiy0 moveto
		end
	    } bind def
		
	    % _ => _
	    /movetotext {
		graphkeydict begin
		    gpaperdict begin
			kfont ksize kcol gpaperfont
		    end    
		    /ktx0 kx0 kdx add khspc add kdxicon add khspc add def
		    /kty0 ky0 kdy add def
		    /ktx1 ktx0 kdxtext add def
		    /kty1 kty0 kdyicon add def
		    ktx0 kty0 kty1 add 2 div ksize 2 div sub kvspc 2 div add moveto
		end
	    } bind def
	end
END_FUNCTIONS
}

=head3 ps_functions( ps )

Normally, this is called in B<build_key>, but is provided as a class function so the dictionary may be still
available even when a Key object is not required.

=cut

=head1 POSTSCRIPT CODE

None of the postscript functions defined in this module would have application outside it.  However, the following
variables are defined within the C<graphkeydict> dictionary and may be of some use.

    kix0	left edge of icon area
    kiy0	bottom edge
    kix1	right edge
    kiy1	top edge
    kvspc	vertical spacing
    khspc	horizontal spacing
    kdxicon	width of icon area
    kdyicon	height of icon area
    kdxtext	width of text area
    kdytext	height of text area
    kfont	font used for text
    ksize	font size used
    kcol	colour of font used

=cut

=head1 BUGS

Very likely.  This is still alpha software and has only been tested in very predictable conditions.

=head1 AUTHOR

Chris Willmot, chris@willmot.co.uk

=head1 SEE ALSO

L<PostScript::File>, L<PostScript::Graph::Style>, L<PostScript::Graph::Paper>.

=cut


1;
