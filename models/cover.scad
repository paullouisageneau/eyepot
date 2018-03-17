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
