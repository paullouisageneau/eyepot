
thickness = 3;
space = 22;

servo_width  = 23;
servo_depth  = 13;
servo_height = 22;
servo_height_total = 28.5;
servo_height_bottom = 15.5;
servo_axis_offset = 6;

height = servo_height_bottom + thickness;
length = 70;

$fn = 60;

union() {
    difference() {
        union() {
            cube([space, servo_height_total+thickness*3, height], center=true);
            translate([space/2, 0, 0]) rotate([90, 0, 0]) cylinder(h=servo_height_total+thickness*3, r=height/2, center=true);
        }
        union() {
            translate([50-space/2+thickness, 0, 0]) cube([100, servo_height_total+thickness, 100], center=true);
            translate([space/2, -50, 0]) rotate([90, 0, 0]) cylinder(h=100, r=3.75, center=true);
            translate([space/2, -50, 50]) cube([5.5, 100, 100], center=true);
            translate([space/2-15/2, -servo_height_total/2-thickness, 0]) {
                rotate([0, -90, 0]) truncatedpyramid([6, 6], 15, 6/4*15, [0, -3, 0]);
                translate([-15/2, 0, 0]) rotate([90, 0, 0]) cylinder(h=6, r=2);
                translate([-15/2, 0, 0]) rotate([90, 0, 0]) cylinder(h=10, r=0.5, center=true);
            }
        }
    }

    translate([space/2, (servo_height_total+thickness)/2, 0]) sphere(r=3, center=true);
    translate([space/2-15, -(servo_height_total+thickness)/2+0.01, 0]) difference() {
        union() {
            sphere(r=5, center=true);
            translate([-5/2, 0, 0]) rotate([0, 90, 0]) cylinder(r=5, h=5, center=true);
        }
        translate([0, -50, 0]) cube([100, 100, 100], center=true);
    }

    translate([-space/2-length/2, 0, -height/2]) rotate([0, -90, 0]) { 
        truncatedpyramid([height, height], length, length*5, [height/2, 0, 0]);
        translate([(height/2)/5, 0, length/2]) scale([1, 1, 1]/5) rotate([90, 0, 0]) cylinder(h=height, r=height/2, center=true);
    }
}

module halfcylinder(h, r) {
    difference() {
        cylinder(h=h, r=r, center=true);
        translate([-r, 0, 0]) cube([r*2, r*4, h*2], center=true);
    }
}

module truncatedpyramid(p, z1, z2, t = [0, 0, 0]) {
    linear_extrude(height=z1, center=true, convexity=10, scale=z1/z2)
    translate(t) square(p, center = true);
}
