
thickness = 3;

servo_width  = 23;
servo_depth  = 13;
servo_height = 22;
servo_height_total = 28.5;
servo_height_bottom = 15.5;
servo_axis_offset = 6;

height = servo_height_bottom + thickness;

$fn = 60;

difference() {
    union() {
        translate([-50/2, (servo_width+10)/2, 0]) servosupport(1);
        translate([ 50/2, (servo_width+10)/2, 0]) servosupport(-1);
        translate([-50/2, -(servo_width+10)/2, 0]) rotate([0, 0, 180]) servosupport(-1);
        translate([ 50/2, -(servo_width+10)/2, 0]) rotate([0, 0, 180]) servosupport(1);

        translate([0, 0, -thickness/2]) cube([50-(servo_depth+thickness*2), (servo_width+10)*2, thickness], center=true);

        translate([0,  (servo_width+10)-thickness/2, (height-thickness)/2]) cube([50-(servo_depth+thickness*2), thickness, height-thickness], center=true);
        translate([0, -(servo_width+10)+thickness/2, (height-thickness)/2]) cube([50-(servo_depth+thickness*2), thickness, height-thickness], center=true);
    }
    union() {
        cylinder(h=100, r=6, center=true);
    }
}

module servosupport(direction=1) {
    translate([0, 0, -thickness]) union() {
        translate([0, 0, height/2]) difference() {
            union() {
                translate([0, 0, 0]) cube([servo_depth+thickness*2, servo_width+10, height], center=true);
            }
            union() {
                translate([0, 0, thickness]) cube([servo_depth, servo_width+1.5, height], center=true);
                translate([0, servo_width/2-servo_axis_offset, 0]) cylinder(h=100, r=3, center=true);
                translate([direction*servo_depth/2, servo_width/2-6, -3]) rotate([0, -90, 0]) halfcylinder(h=20, r=9);
                translate([0, -servo_width/2-2.5, 2]) cylinder(h=100, r=0.75);
                translate([0,  servo_width/2+2.5, 2]) cylinder(h=100, r=0.75);
            }
        }
    } 
}

module halfcylinder(h, r) {
    difference() {
        cylinder(h=h, r=r, center=true);
        translate([-r, 0, 0]) cube([r*2, r*4, h*2], center=true);
    }
}
