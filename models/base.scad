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

thickness = 2;
body_radius = 40;
body_border = 2;

difference() {
    union() {
        translate([0, 0, -thickness/2]) cylinder(h=thickness, r=body_radius, center=true, $fn=90);
        
        translate([0, 0, 3]) {
            translate([-23/2, -58/2, 0]) screw();
            translate([ 23/2, -58/2, 0]) screw();
            translate([-23/2,  58/2, 0]) screw();
            translate([ 23/2,  58/2, 0]) screw();
        }
        
        translate([0, 0, 0]) difference() {
            cylinder(r = body_radius-body_border-0.25, h=3, $fn=90);
            intersection() {
                cylinder(r = body_radius-body_border-2, h=20, center=true, $fn=90);
                cube([100, body_radius, 100], center=true);
            }
        }
    }
    union() {
        cylinder(h=100, r=6, center=true);
    }
}

module screw(height = 2.5)
{
    translate([0, 0, height/2]) difference() {
            cylinder(h = height, r=3.00, center=true);
            cylinder(h = height+0.1, r=1.18, center=true);
    }
}