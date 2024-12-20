include<fontmetrics/fontmetrics.scad>;

/* [General] */
$fn = $preview ? 20 : 64;

/* [Grip] */
grip_length = 95;

// Higher values mean more comfort but it gets harder to print.
grip_hole_diameter = 15;
grip_hole_y_offset = -20;

/* [Paddle size] */
paddle_width = 70;
paddle_length = 154;
paddle_corner_radius = 10;
paddle_thickness = 15;

/* [Paddle text] */
paddle_text = "I ♥ U";
paddle_font_size = 35;
// Custom fonts can be included in the code below.
paddle_text_font = "Liberation Sans:style=Bold";
paddle_text_height = 1.0;

/* [Paddle Spikes] */
spike_bottom_radius = 5;
spike_top_radius = 1;
spike_height = 3;
spike_gap = 2;
spike_padding = 5;

/* [Hidden] */
epsilon = 0.001;

// Calculated values
_spike_count_x = floor((paddle_width - (2 * spike_padding)) / (spike_bottom_radius * 2 + spike_gap));
_spike_count_y = floor((paddle_length - (2 * spike_padding)) / (spike_bottom_radius * 2 + spike_gap));
_grip_factor = paddle_width / 70; // The grip originally was designed for a 70mm wide paddle. This factor scales the grip to the paddle width.

if((paddle_width / 3) < grip_hole_diameter) {
    echo("WARNING: Grip hole might be too small.");
}

/* creates a single spike */
module spike() {
    cylinder(r1 = spike_bottom_radius, r2 = spike_top_radius, h=spike_height);
}

module draw_text() {
    _tb = measureWrappedTextBounds(paddle_text,font=paddle_text_font,size=paddle_font_size,spacing=1,linespacing=1,indent=0,width=paddle_length,halign="center");
    rotate([0, 0, 90])
    translate([0, -ascender(paddle_text_font, size=paddle_font_size) + _tb[1][1]/2, 0])
    drawWrappedText(paddle_text,font=paddle_text_font,size=paddle_font_size,spacing=1,linespacing=1,indent=0,width=paddle_length,halign="center");
}

/* Creates a cube which is rounded off on the x and y axis */
module rounded_cube(dimmensions, corner_radius) {
    hull() {
        translate([dimmensions[0] - corner_radius, dimmensions[1] - corner_radius, 0]) cylinder(r = corner_radius, h = dimmensions[2]);
        translate([0 + corner_radius, dimmensions[1] - corner_radius, 0]) cylinder(r = corner_radius, h = dimmensions[2]);
        translate([dimmensions[0] - corner_radius, 0 + corner_radius, 0]) cylinder(r = corner_radius, h = dimmensions[2]);
        translate([0 + corner_radius, 0 + corner_radius, 0]) cylinder(r = corner_radius, h = dimmensions[2]);
    }
}

// Paddle
difference() {
    union() {
        // Grip v2
        difference() {
            scale([_grip_factor, 1, 1]) translate([0, grip_length  + paddle_corner_radius + 4, paddle_thickness / 2]) rotate([90, 0, 0]) rotate_extrude(angle=360, convexity=2)
                translate([35, 0, 0]) 
                rotate([0, 0, 90])
                mirror([0, 0, 0]) import("handle.svg");

            translate([-paddle_width/2, -50, -50 + epsilon]) cube([paddle_width, 200, 50]);
            translate([-paddle_width/2, -50, paddle_thickness - epsilon]) cube([paddle_width, 200, 50]);
            translate([0, grip_hole_y_offset, -epsilon]) cylinder(d=grip_hole_diameter, h=paddle_thickness + 2 * epsilon);
        }
        translate([-paddle_width / 2,  grip_length, 0]) rounded_cube([paddle_width, paddle_length, paddle_thickness], paddle_corner_radius);    
    }
    // Paddle text
    translate([0, 0, 0]) color("Turquoise") translate([0, grip_length + paddle_length / 2, -epsilon]) linear_extrude(paddle_text_height) draw_text();
}



// Paddle spikes
color("Tomato") translate([-((spike_bottom_radius * 2 + spike_gap) * (_spike_count_x - 1)) / 2, grip_length + (paddle_length / 2) -((spike_bottom_radius * 2 + spike_gap) * (_spike_count_y - 1)) / 2, paddle_thickness])
if(_spike_count_x > 0 && _spike_count_y > 0) {
    for(x = [0 : _spike_count_x - 1]) {
        for(y = [0 : _spike_count_y - 1]) {
            translate([x * (spike_bottom_radius * 2 + spike_gap), y * (spike_bottom_radius * 2 + spike_gap), 0]) spike();
        }
    }
} else {
    echo("WARNING: Paddle is to small for adding spikes.");
}
