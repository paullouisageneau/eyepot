/*
 * Copyright (C) 2017 by Paul-Louis Ageneau
 * paul-louis (at) ageneau (dot) org
 *
 * This file is part of Eyepot.
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
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <Servo.h>

// ---------- Pin setup ----------
const int servoPins[8] = {5, 6, 7, 8, 9, 10, 11, 12};
const int offsetAngles[8] = { -5, 0, -10, -5, -10, 5, 10, -5 };
const int defaultAngles[8] = { 135, 135, 45, 45, 90, 90, 90, 90 };

const int batteryProbePin = A0;
const long batteryProbeFactor = 10200L;
const int batteryVoltageMin = 6300;
const int batteryVoltageMax = 8300;

int batteryProbeCount = 0;

Servo servos[8];
unsigned int angles[8];

String inputString = "";

void setup()
{
  // Init serial
  Serial.begin(9600);

  // Init servos
  for(int i = 0; i < 8; ++i)
  {
    angles[i] = defaultAngles[i];
    servos[i].attach(servoPins[i]);
    servos[i].write(offsetAngles[i] + angles[i]);
  }

  // Activity LED
  pinMode(13, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(100);
  digitalWrite(LED_BUILTIN, LOW);
}

void loop()
{
  int batteryVoltage = int(long(analogRead(batteryProbePin))*batteryProbeFactor/1024L);  // mV
  int batteryPercent = constrain(map(batteryVoltage, batteryVoltageMin, batteryVoltageMax, 0, 100), 0, 100);

  // Exit on low battery
  if(batteryPercent == 0)
  {
    ++batteryProbeCount;
    if(batteryProbeCount == 100)
    {
      Serial.println("B 0");
      for(int i = 0; i < 8; ++i)
      {
          servos[i].detach();
      }
      exit(0);
    }
    batteryPercent = 1;
  }
  else {
    batteryProbeCount = 0;
  }

  // Read commands on serial
  while(Serial.available())
  {
    char chr = (char)Serial.read();
    if(chr != '\n')
    {
      if(chr != '\r')
        inputString+= chr;
    }
    else if(inputString.length() > 0)
    {
      // Parse command
      char cmd = toupper(inputString[0]);
      String param;
      int pos = 1;
      while(pos < inputString.length() && inputString[pos] == ' ') ++pos;
      param = inputString.substring(pos);

      // Execute command
      if(cmd >= '0' && cmd < '8') // Servo
      {
        int i = int(cmd) - int('0');
        int angle = param.toInt();
        angles[i] = angle;
      }
      else if(cmd == 'R')        // Reset
      {
        for(int i = 0; i < 8; ++i)
          angles[i] = defaultAngles[i];
      }
      else if(cmd == 'C')        // Commit
      {
        for(int i = 0; i < 8; ++i)
          servos[i].write(offsetAngles[i] + angles[i]);
      }
      else if(cmd == 'B')        // Battery
      {
        Serial.print("B ");
        Serial.print(batteryPercent);
        Serial.println();
      }

      inputString = "";
    }
  }
}
