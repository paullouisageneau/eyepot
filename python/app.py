'''
    Copyright (C) 2017 by Paul-Louis Ageneau
    paul-louis (at) ageneau (dot) org

    This file is part of Eyepot.

    Eyepot is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of
    the License, or (at your option) any later version.

    Eyepot is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public
    License along with Eyepot.
    If not, see <http://www.gnu.org/licenses/>.
'''

import control
import controlthread

from flask import Flask, request, Response, send_file, url_for, jsonify

app = Flask(__name__)
app.config.from_object(__name__)

ctrl = control.Control('/dev/serial0', 9600)
ctrl.start()
ctrlThread = controlthread.ControlThread(ctrl)
ctrlThread.start()

@app.route('/', methods=['GET'])
def home():
    return send_file('static/index.html')

@app.route('/move', methods=['POST'])
def move():
	data = request.get_json()
	ctrlThread.state = data["state"] if data["state"] else 'idle'
	return Response('', 200)

@app.route('/battery', methods=['GET'])
def battery():
    return jsonify({"level": ctrl.battery_level})


if __name__ == '__main__':
	app.run(host = '0.0.0.0', port = 8080)
