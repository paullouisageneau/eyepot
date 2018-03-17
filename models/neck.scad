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
