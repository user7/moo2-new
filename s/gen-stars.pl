#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;

sub tt {
    print (Data::Dumper->new([@_])->Indent(0)->Terse(1)->Dump, "\n");
}

sub mul {
    my ($arr, $c) = @_;
    for my $v (@{$arr}) {
        $v *= $c;
    }
}

my $sz = 20;
my $gscale = 1;
my ($mx, $my) = (0, 0);
my ($nmx, $nmy) = (1, 1);

sub gen_svg_paths {
    my ($rgba, $rgbb) = @_;
    my @x  = ( 1,  0,  1,  2);
    my @y  = ( 0,  1,  2,  1);
    my @dx = ( 0,  1,  0, -1);
    my @dy = ( 1,  0, -1,  0);
    my @dpi = (0, 2, 4);
    my @dri = (5, 7, 9);

    my $mulc = $sz / 2;
    mul(\@x, $mulc);
    mul(\@y, $mulc);

    my $pi = sub {
        my ($vi, $d) = @_;
        my $px = ($x[$vi] + $dx[$vi] * $d + $mx * $sz) * $gscale;
        my $py = ($y[$vi] + $dy[$vi] * $d + $my * $sz) * $gscale;
        return "$px $py";
    };
    my $piri = sub {
        my ($vi, $si) = @_;
        $vi %= @x;
        return ($pi->($vi, $dpi[$si]), $pi->($vi, $dri[$si]))
    };

    my $ns = @dpi;
    my $out = "";
    for (my $si = 0; $si < $ns; ++$si) {
        for (my $vi = 0; $vi < @dx; ++$vi) {
            my ($pi, $ri) = $piri->($vi, $si);
            my ($pn, $rn) = $piri->($vi + 1, $si);
            $out .= "<path d=\"M $pi" if $vi == 0;
            $out .= "   C $ri $rn $pn";
        }
        my $color = "";
        for (my $ci = 0; $ci < 3; ++$ci) {
            my $ca = $rgba->[$ci];
            my $cb = $rgbb->[$ci];
            my $cx = $ca + ($cb - $ca) * $si / ($ns - 1);
            $color .= sprintf("%02x", $cx);
        }
        $out .= "\" fill=\"#$color\" />\n";
    }
    return $out;
}

sub wrap_svg {
    my $sizex = $sz * $gscale * $nmx;
    my $sizey = $sz * $gscale * $nmy;
    my $wh = "width=\"$sizex\" height=\"$sizey\"";
    my $out = "<svg $wh xmlns=\"http://www.w3.org/2000/svg\">\n";
    $out .= "<rect $wh fill=\"black\"\/>\n";
    $out .= $_[0];
    $out .= "</svg>";
    return $out;
}

sub gen_svg {
    wrap_svg(gen_svg_paths(@_));
}

sub write_file {
    my ($name, $text) = @_;
    open (my $f, '>', $name) or die "unable to open $name for writing: $!";
    print $f $text;
    close $f;
}

sub gen_svg_file {
    my ($name, @colors) = @_;
    write_file($name, gen_svg(@colors));
}

my @stars = (
    # blue
    [[ 50,  50, 255], [184, 184, 255]],
    [[ 80,  80, 255], [255, 255, 255]],

    # grey
    [[ 80,  80,  80], [200, 200, 200]],
    [[120, 120, 120], [255, 255, 255]],

    # yellow
    [[190, 160,  20], [255, 240, 184]],
    [[190, 160,  50], [255, 240, 240]],

    # orange
    [[240, 120,  50], [255, 220, 160]],
    [[240, 120,  80], [255, 240, 200]],

    # red
    [[255,  50,  50], [255, 184, 184]],
    [[255,  80,  80], [255, 255, 255]],

    # brown
    [[156, 120,  94], [255, 240, 210]],
    [[156, 120,  94], [255, 255, 255]],

    # purple
    [[200,   0, 200], [ 30,  30,  30]],
    [[255,   0, 250], [ 30,  30,  30]],
);

# useful for reviewing all stars together
sub gen_stars_one_sheet {
    my $out = "";
    $nmx = 2;
    $nmy = 7;
    for ($my = 0; $my < $nmy; ++$my) {
        for ($mx = 0; $mx < $nmx; ++$mx) {
            $out .= gen_svg_paths(@{$stars[$my * $nmx + $mx]});
        }
    }

    write_file("star.svg", wrap_svg($out));
}

#gen_stars_one_sheet();

sub gen_stars_files {
    for (my $i = 0; $i < 14; $i += 2) {
        gen_svg_file("../svg/star-norm-$i.svg", @{$stars[$i]});
        gen_svg_file("../svg/star-high-$i.svg", @{$stars[$i + 1]});
    }
}

gen_stars_files();
