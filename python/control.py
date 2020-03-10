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

import serial
import time
import threading

class Control(threading.Thread):

    def __init__(self, device = '/dev/serial0', baudrate = 9600):
        super().__init__()
        self.ser = serial.Serial(device, baudrate, timeout = 1)
        self.battery_level = 100

    def run(self):
        while self.ser.is_open:
            self.send('B')
            while True:
                command = self.read()
                if not command:
                    break
                self.process(command)

    def reset(self):
        self.send('R')

    def commit(self):
        self.send('C')

    def send(self, command):
        self.ser.write((command + '\n').encode())

    def read(self):
        return self.ser.readline().decode()

    def process(self, command):
        c = command[0]
        arg = command[1:].strip()
        if c == 'B':
            self.battery_level = int(arg)

    # leg angle > 0 => down
    def leg(self, i, angle):
        self.move(i, 90+angle if i < 2 else 90-angle)

    # hip angle > 0 => front
    def hip(self, i, angle):
        self.move(4+i, 90+angle if i < 2 else 90-angle)

    def move(self, servo, angle):
        if servo >= 0 and servo < 8:
            angle = min(max(angle, 0), 180)
            self.send('{:s}{:d}'.format(chr(ord('0')+servo), int(angle)))

    def idle(self):
        self.reset()
        self.commit()
        time.sleep(0.1)

    def translateFront(self, f = 25):
        self.walk(f, 0, 0)

    def translateBack(self, f = 25):
        self.walk(-f, 0, 0)

    def translateRight(self, f = 25):
        self.walk(0, f, 0)

    def translateLeft(self, f = 25):
        self.walk(0, -f, 0)

    def rotateRight(self, f = 25):
        #self._pattern1(20, 0, [30, 30, -30, -30], [0, 3, 1, 2], 0.2)
        self.walk(0, 0, f)

    def rotateLeft(self, f = 25):
        #self._pattern1(20, 0, [-30, -30, 30, 30], [2, 1, 3, 0], 0.2)
        self.walk(0, 0, -f)

    def walk(self, forward, sideward, rotation):
        fu = [1, 1, 1, 1]
        su = [-1, 1, 1, -1]
        ru = [1, 1, -1, -1]
        v = [f*forward + s*sideward + r*rotation for f, s, r in zip(fu, su, ru)]
        self._pattern2(30, 5, v, 0.15)

    def _pattern1(self, ldown, lup, hangles, legs, step):
        for i in legs:
            self.leg(i, ldown)
            self.hip(i, lup)
        self.commit()
        time.sleep(step)

        for i in legs:
            self.leg(i, lup)
            self.hip(i, hangles[i])
            self.commit()
            time.sleep(step/2)

            self.leg(i, ldown)
            self.commit()
            time.sleep(step/2)

    def _pattern2(self, ldown, lup, hangles, step):
        offsets = [-a/4 for a in hangles]

        self.leg(0, lup)
        self.leg(1, ldown)
        self.leg(2, ldown)
        self.leg(3, lup)
        self.commit()
        time.sleep(step/2)

        self.hip(0, offsets[0] + hangles[0])
        self.hip(1, offsets[1])
        self.hip(2, offsets[2])
        self.hip(3, offsets[3] + hangles[3])
        self.commit()
        time.sleep(step/2)

        self.leg(0, ldown)
        self.leg(3, ldown)
        self.commit()
        time.sleep(step/2)

        self.hip(0, offsets[0])
        self.hip(1, offsets[1] - hangles[1])
        self.hip(2, offsets[2] - hangles[2])
        self.hip(3, offsets[3])
        self.commit()
        time.sleep(step/2)

        self.leg(0, ldown)
        self.leg(1, lup)
        self.leg(2, lup)
        self.leg(3, ldown)
        self.commit()
        time.sleep(step/2)

        self.hip(0, offsets[0])
        self.hip(1, offsets[1] + hangles[1])
        self.hip(2, offsets[2] + hangles[2])
        self.hip(3, offsets[3])
        self.commit()
        time.sleep(step/2)

        self.leg(1, ldown)
        self.leg(2, ldown)
        self.commit()
        time.sleep(step/2)

        self.hip(0, offsets[0] - hangles[0])
        self.hip(1, offsets[1])
        self.hip(2, offsets[2])
        self.hip(3, offsets[3] - hangles[3])
        self.commit()
        time.sleep(step/2)


