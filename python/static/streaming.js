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

var server = window.location.protocol + "//" + window.location.host + "/janus";
var opaqueId = Janus.randomString(12);
var streamId = 1;

var janus = null;
var streaming = null;

function initStreaming() {
	// Initialize the library (all console debuggers enabled)
	Janus.init({debug: "all", callback: function() {
		// Make sure the browser supports WebRTC
		if(!Janus.isWebrtcSupported()) {
			alert("No WebRTC support");
			return;
		}
		// Create session
		janus = new Janus({
			server: server,
			success: function() {
				// Attach to streaming plugin
				janus.attach({
					plugin: "janus.plugin.streaming",
					opaqueId: opaqueId,
					success: function(pluginHandle) {
						streaming = pluginHandle;
						Janus.log("Plugin attached (" + streaming.getPlugin() + ", id=" + streaming.getId() + ")");
						startStream(streamId);
					},
					error: function(error) {
						Janus.error("Error attaching plugin", error);
						alert("Error attaching plugin");
					},
					onmessage: function(msg, jsep) {
						Janus.debug("Got a message");
						if(msg["error"] !== undefined && msg["error"] !== null) {
							alert(msg["error"]);
							stopStream();
							return;
						}
						if(jsep !== undefined && jsep !== null) {
							Janus.debug("Handling SDP");
							// Answer
							streaming.createAnswer({
								jsep: jsep,
								media: { audioSend: false, videoSend: false },	// We want recvonly audio/video
								success: function(jsep) {
									Janus.debug("Got SDP");
									var body = { "request": "start" };
									streaming.send({"message": body, "jsep": jsep});
								},
								error: function(error) {
									Janus.error("WebRTC error", error);
									alert("WebRTC error: " + JSON.stringify(error));
								}
							});
						}
					},
					onremotestream: function(stream) {
						Janus.debug("Got a remote stream");
						videoElement = document.getElementById("video");
						Janus.attachMediaStream(videoElement, stream);
					},
					oncleanup: function() {
						Janus.log("Got a cleanup notification");
					}
				});
			},
			error: function(error) {
				Janus.error(error);
				alert(error, function() {
					window.location.reload();
				});
			},
			destroyed: function() {
				window.location.reload();
			}
		});
	}});
}

function startStream(selectedStream) {
	Janus.log("Selected video id #" + selectedStream);
	var body = { "request": "watch", id: parseInt(selectedStream) };
	streaming.send({ "message": body });
}

function stopStream() {
	var body = { "request": "stop" };
	streaming.send({ "message": body });
	streaming.hangup();
}

