
/* [Grip] */
grip_end_width = 20;
grip_end_length = 10;
grip_diameter = 15;
grip_length = 85;
// Higher values mean more comfort but it gets harder to print.
grip_fn = 8;

/* [Paddle size] */
paddle_width = 70;
paddle_length = 150;
paddle_corner_radius = 10;

/* [Paddle text] */
paddle_text = "XOXO";
paddle_font_size = 36;
// Custom fonts can be included in the code below.
paddle_text_font = "Comic Neue:style=Bold";
paddle_text_height = 0.4;

/* [Paddle Spikes] */
spike_bottom_radius = 5;
spike_top_radius = 1;
spike_height = 3;
spike_gap = 2;

/* [Hidden] */
epsilon = 1;

// Calculated values
_grip_radius = grip_diameter / 2;
_grip_inner_circle_radius = _grip_radius * cos(180/grip_fn);
_grip_height_from_plate = _grip_inner_circle_radius + ((grip_fn % 2) == 0 ? _grip_inner_circle_radius : (grip_diameter / 2));
_spike_count_x = floor(paddle_width / (spike_bottom_radius * 2 + spike_gap));
_spike_count_y = floor(paddle_length / (spike_bottom_radius * 2 + spike_gap));

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

// Grip end cube
translate([-grip_end_width/2, 0, 0]) cube([grip_end_width, grip_end_length, _grip_height_from_plate]);

// Grip
translate([0, grip_end_length, _grip_inner_circle_radius]) rotate([-90, 0, 0]) rotate([0, 0, (180-(360/grip_fn))/2]) cylinder(d = grip_diameter, h = grip_length, $fn = grip_fn);

// Paddle
difference() {
    translate([-paddle_width / 2, grip_end_length + grip_length, 0]) rounded_cube([paddle_width, paddle_length, _grip_height_from_plate], paddle_corner_radius);
    // Paddle text
    color("Turquoise") translate([0, grip_end_length + grip_length + paddle_length / 2, -epsilon]) linear_extrude(paddle_text_height + epsilon) rotate([0, 0, 90]) text(paddle_text, font=paddle_text_font, size=paddle_font_size, valign="center", halign="center");
}



// Paddle spikes
color("Tomato") translate([-((spike_bottom_radius * 2 + spike_gap) * (_spike_count_x - 1)) / 2, grip_end_length + grip_length + (paddle_length / 2) -((spike_bottom_radius * 2 + spike_gap) * (_spike_count_y - 1)) / 2, _grip_height_from_plate])
for(x = [0 : _spike_count_x - 1]) {
    for(y = [0 : _spike_count_y - 1]) {
        translate([x * (spike_bottom_radius * 2 + spike_gap), y * (spike_bottom_radius * 2 + spike_gap), 0]) spike();
    }
}
