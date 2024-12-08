/* [General] */
$fn = $preview ? 20 : 64;

/* [Grip] */
grip_end_width = 20;
grip_end_length = 10;
grip_length = 85;
// Higher values mean more comfort but it gets harder to print.
grip_fn = 8;
grip_hole_diameter = 15;
grip_hole_y_offset = -20;

/* [Paddle size] */
paddle_width = 70;
paddle_length = 154;
paddle_corner_radius = 10;
paddle_thickness = 15;

/* [Paddle text] */
paddle_text = "XOXO";
paddle_font_size = 36;
// Custom fonts can be included in the code below.
paddle_text_font = "Comic Neue:style=Bold";
paddle_text_height = 0.8;

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
_grip_diameter = 70 * _grip_factor;

/* creates a single spike */
module spike() {
    cylinder(r1 = spike_bottom_radius, r2 = spike_top_radius, h=spike_height);
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

// Include font
use <ComicNeue-Bold.ttf>;

// Paddle
difference() {
    union() {
        // Grip v2
        difference() {
            scale([_grip_factor, 1, 1]) translate([0, grip_length + grip_end_length + paddle_corner_radius + 4, grip_diameter / 2]) rotate([90, 0, 0]) rotate_extrude(angle=360, convexity=2)
                translate([35, 0, 0]) 
                rotate([0, 0, 90])
                mirror([0, 0, 0]) import("handle.svg");

            translate([-paddle_width/2, -50, -50 + epsilon]) cube([paddle_width, 200, 50]);
            translate([-paddle_width/2, -50, paddle_thickness - epsilon]) cube([paddle_width, 200, 50]);
            translate([0, grip_hole_y_offset, -epsilon]) cylinder(d=grip_hole_diameter, h=paddle_thickness + 2 * epsilon);
        }
        translate([-paddle_width / 2, grip_end_length + grip_length, 0]) rounded_cube([paddle_width, paddle_length, paddle_thickness], paddle_corner_radius);    
    }
    // Paddle text
    color("Turquoise") translate([0, grip_end_length + grip_length + paddle_length / 2, -epsilon]) linear_extrude(paddle_text_height + epsilon) rotate([0, 0, 90]) text(paddle_text, font=paddle_text_font, size=paddle_font_size, valign="center", halign="center");
}



// Paddle spikes
color("Tomato") translate([-((spike_bottom_radius * 2 + spike_gap) * (_spike_count_x - 1)) / 2, grip_end_length + grip_length + (paddle_length / 2) -((spike_bottom_radius * 2 + spike_gap) * (_spike_count_y - 1)) / 2, paddle_thickness])
for(x = [0 : _spike_count_x - 1]) {
    for(y = [0 : _spike_count_y - 1]) {
        translate([x * (spike_bottom_radius * 2 + spike_gap), y * (spike_bottom_radius * 2 + spike_gap), 0]) spike();
    }
}
