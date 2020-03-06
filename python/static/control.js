/*
	Copyright (C) 2017 by Paul-Louis Ageneau
	paul-louis (at) ageneau (dot) org

	This file is part of Eyepot.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

var control = {};

// Update control state and send if changed
function changeControl(key, state) {
	if(control[key] != state) {
		control[key] = state;
		updateControl();
	}
}

// Send current control order to robot
function updateControl() {
	var state = 'idle';
	if(control['up']) state = 'front';
	else if(control['down']) state = 'back';
	else if(control['right']) state = 'right';
	else if(control['left']) state = 'left';
	else if(control['rotr']) state = 'rotr';
	else if(control['rotl']) state = 'rotl';
	
	var message = JSON.stringify({ 
		'state': state,
	});
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/move');
	xhr.setRequestHeader('Content-Type', 'application/json');
	xhr.send(message);
}

// Send current control order to robot
function updateBattery() {
	var xhr = new XMLHttpRequest();
	xhr.open('GET', '/battery');
	xhr.onreadystatechange = function() {
		if (xhr.readyState === 4) {
		      	var result = JSON.parse(xhr.response);
			var level = document.getElementById('battery_level');
			var bar = document.getElementById('battery_bar');
			bar.style.width = result.level + '%';
			level.innerHTML = result.level + '%';
		}
	};
	xhr.send();
}

// Callback for key down
function handleKeyDown(evt) {
	switch (evt.keyCode) {
		case 37: changeControl('rotl', true); break;
		case 38: changeControl('up',   true); break;
		case 39: changeControl('rotr', true); break;
		case 40: changeControl('down', true); break;
	}
}

// Callback for key up
function handleKeyUp(evt) {
	switch (evt.keyCode) {
		case 37: changeControl('rotl', false); break;
		case 38: changeControl('up',   false); break;
		case 39: changeControl('rotr', false); break;
		case 40: changeControl('down', false); break;
	}
}

function initControl() {
	const arrow = {
		up:    document.getElementById('arrow_up'),
		down:  document.getElementById('arrow_down'),
		left:  document.getElementById('arrow_left'),
		right: document.getElementById('arrow_right'),
		rotl:  document.getElementById('arrow_rotate_left'),
		rotr:  document.getElementById('arrow_rotate_right')
	};
	
	// Set arrow button callbacks
	for(const key in arrow) {
		if (arrow.hasOwnProperty(key)) {
			const element = arrow[key];
			element.onmousedown = function(evt) { 
				evt.preventDefault();
				changeControl(key, true);
			};
			element.onmouseup = function(evt) {
				changeControl(key, false);
			};
			if('ontouchstart' in element) {
				element.ontouchstart = element.onmousedown;
				element.ontouchend = element.onmouseup;
			}
		}
	}
	
	// Set key callbacks
	document.onkeydown = handleKeyDown;
	document.onkeyup   = handleKeyUp;
	
	updateControl();

	function loopUpdate() {
		updateBattery();
		setTimeout(loopUpdate, 5000);
	}
	loopUpdate();
}

