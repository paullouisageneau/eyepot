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

camera_radius = 4.2;

union() {
    translate([21/2, 0, 0])  screw();
    translate([-21/2, 0, 0]) screw();
    translate([0, 0, -1]) difference() {
        union() {
            cube([8*2, 12, 2], center=true);
            translate([8, 0, 0])  cylinder(h=2, r=6, center=true);
            translate([-8, 0, 0]) cylinder(h=2, r=6, center=true);
        }
        cylinder(h=100, r=camera_radius, center=true, $fn=90);
    }
}

module screw(height = 2.5)
{
    translate([0, 0, height/2]) difference() {
        cylinder(h = height, r=3.00, center=true);
        cylinder(h = height+0.1, r=1.18, center=true);
    }
}
