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

import threading
import time

class ControlThread(threading.Thread):
    def __init__(self, ctrl):
        super().__init__()
        self.state = "idle"
        self.ctrl = ctrl

    def run(self):
        self.ctrl.rotateLeft(10)
        self.ctrl.rotateRight(10)

        while self.state != "stop":
            if self.state == "idle":
                self.ctrl.idle();
            elif self.state == "front":
                self.ctrl.translateFront()
            elif self.state == "back":
                self.ctrl.translateBack()
            elif self.state == "left":
                self.ctrl.translateLeft()
            elif self.state == "right":
                self.ctrl.translateRight()
            elif self.state == "rotl":
                self.ctrl.rotateLeft()
            elif self.state == "rotr":
                self.ctrl.rotateRight()
            else:
                self.state = "idle"

