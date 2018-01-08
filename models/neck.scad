
thickness = 5;
height = 20;

$fn = 60;

difference() {
    union() {
        cylinder(h=height, r=6+thickness, center=true);
        translate([0, 0, (height-height/3)/2]) cylinder(h=height/3, r1=6+thickness, r2=6+10, center=true);
        translate([0, 0, -height/2]) rotate_extrude(convexity = 10) {
            translate([6+thickness, 0, 0]) circle(r = 10/2);
        }
    }
    union() {
        cylinder(h=100, r=6, center=true);
        translate([0, 0, -height/2-50]) cube([100, 100, 100], center=true);
    }
}
