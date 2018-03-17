/* 
 * Copyright (c) 2017 by Paul-Louis Ageneau
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

thickness = 3;
space = 22;

servo_width  = 23;
servo_depth  = 13;
servo_height = 22;
servo_height_total = 28.5;
servo_height_bottom = 15.5;
servo_axis_offset = 6;

height = servo_height_bottom + thickness;

$fn = 60;

union() {
    difference() {
        union() {
            cube([space, servo_height_total+thickness*3, height], center=true);
            translate([space/2, 0, 0]) rotate([90, 0, 0]) cylinder(h=servo_height_total+thickness*3, r=height/2, center=true);
        }
        union() {
            translate([50-space/2+thickness, 0, 0]) cube([100, servo_height_total+thickness, 100], center=true);
            translate([space/2, 50, 0]) rotate([90, 0, 0]) cylinder(h=100, r=3.75, center=true);
            translate([space/2, 50, 50]) cube([5.5, 100, 100], center=true);
            translate([space/2-15/2, servo_height_total/2+thickness, 0]) {
                rotate([0, -90, 0]) truncatedpyramid([6, 6], 15, 6/4*15, [0, 3, 0]);
                translate([-15/2, 0, 0]) rotate([-90, 0, 0]) cylinder(h=6, r=2);
                translate([-15/2, 0, 0]) rotate([-90, 0, 0]) cylinder(h=10, r=0.5, center=true);
            }
        }
    }

    translate([space/2, -(servo_height_total+thickness)/2, 0]) sphere(r=3, center=true);
    translate([space/2-15, (servo_height_total+thickness)/2+0.01, 0]) difference() {
        union() {
            sphere(r=5, center=true);
            translate([-5/2, 0, 0]) rotate([0, 90, 0]) cylinder(r=5, h=5, center=true);
        }
        translate([0, 50, 0]) cube([100, 100, 100], center=true);
    }

    translate([-space/2-servo_depth/2, 0, 0]) difference() {
        union() {
            translate([-thickness/2, 0, 0]) cube([servo_depth+thickness, servo_height_total+thickness*3, height], center=true);
        }
        union() {
            translate([0, 0, thickness]) cube([servo_depth, servo_width+1.5, height], center=true);
            translate([0, servo_width/2-servo_axis_offset, 0]) cylinder(h=100, r=3, center=true);
            translate([0, servo_width/2, -3]) rotate([90, -90, 0]) halfcylinder(h=20, r=servo_depth/2);
            translate([0, -servo_width/2-2.5, 0]) cylinder(h=100, r=0.75);
            translate([0,  servo_width/2+2.5, 0]) cylinder(h=100, r=0.75);
        }
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
