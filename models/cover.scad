
thickness = 3;
servo_width  = 23;
servo_depth  = 13;

width = 50-servo_depth;
depth = (servo_width+10)*2;

$fn = 60;

difference() {
    union() {
        translate([0, 0, -thickness/2]) cube([width, depth-thickness*2, thickness], center=true);
        translate([0, 0, thickness/2]) cube([width-thickness*2, depth-thickness*2, thickness], center=true);
        difference() {
            union() {
                translate([0, -depth/2+thickness, 0]) rotate([0, 90, 0]) cylinder(h=width, r=thickness, center=true);
                translate([0, depth/2-thickness, 0]) rotate([0, 90, 0]) cylinder(h=width, r=thickness, center=true);
            }
            translate([0, 0, 50]) cube([100, 100, 100], center=true);
        }
    }
    union() {
        translate([0, 0, thickness]) cube([width-thickness*4, depth-thickness*4, thickness*3], center=true);
        cylinder(h=100, r=5, center=true);
    }
}
