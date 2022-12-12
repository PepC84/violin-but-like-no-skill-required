
// mp1 addresses = 
/*  -- |pin on the circuit| |name of pin on hardware| |ID of the LED on arduino|
--  21  GPA0  0  G3
--  22  GPA1  1  G#3
--  23  GPA2  2  A3
--  24  GPA3  3  A#3
--  25  GPA4  4  B3
--  26  GPA5  5  C4
--  27  GPA6  6  C#4
--  28  GPA7  7  D4
--  1   GPB0  8  D4#
--  2   GPB1  9  E4
--  3   GPB2  10 F4
--  4   GPB3  11 F#4
--  5   GPB4  12 G4
--  6   GPB5  13 G#4
--  7   GPB6  14 A4
--  8   GPB7  15 A#4
*/
//mp2 addresses = 
/* substract 16 for actual address
--  21  GPA0  16 B4
--  22  GPA1  17 C5
--  23  GPA2  18 C#5
--  24  GPA3  19 D5
--  25  GPA4  20 D#5
--  26  GPA5  21 E5
--  27  GPA6  22 F5
--  28  GPA7  23 F#5
--  1   GPB0  24 G5
--  2   GPB1  25 G#5
--  3   GPB2  26 A5
--  4   GPB3  27 A#5
--  5   GPB4  28 B5
--  6   GPB5  29 B#5
--  7   GPB6  30
--  8   GPB7  31
*/
// h,00,00,00,e ps send format
#include <LiquidCrystal.h>
LiquidCrystal lcd(7,8,9,10,11,12);

#include <Adafruit_MCP23X17.h>
#include <Wire.h>

Adafruit_MCP23X17 mcp1;
Adafruit_MCP23X17 mcp2;


short int ledStates [31];
long ledTimers [31];
int funnyVariable = 0;
long lastResetLCD = millis();
short ledSelected = 16;
int  ledPattern = 3000;;
long offTimerCheck = millis();
long ledSelect = millis();

int value1 = 0;
int value2 = 0;
int value3 = 0;
long  timeStampReceived = millis();
long timeStampContact = millis();
long timeStampLCD = millis();
long timeStampClearLCD = millis();
boolean timeSinceNaN = false;
String inString; 
int inByte;
boolean clearedLCD = false;
boolean toggleVals = false;
boolean firstContact = false;
String  value1String;
String  value2String;
String  value3String;

void setup() {
Serial.begin(9600);
establishContact();
mcp1.begin_I2C(0x21); //low low high
mcp2.begin_I2C(0x22); //low high low

 for(int i=0;i<16;i++) {
  mcp1.pinMode(i, OUTPUT);
  mcp2.pinMode(i, OUTPUT);
  if(i==15) {
    break;
  }
 }
 
lcd.begin(16,2);
lcd.print("baller v1.2");
}

void loop() {  
  if(millis() - lastResetLCD > 500) {
    lcd.clear();
    lastResetLCD = millis();
  }
    if (toggleVals == true) {
    lcd.setCursor(0,1);
  lcd.print(value1String + " " + value2String + " " + value3String);
  lcd.setCursor (0,0);
  }
    if (Serial.available() > 0) {
    lcd.setCursor(15,0);
    lcd.print('a');
    lcd.setCursor(0,0);
    inString = Serial.readStringUntil('e');
    
     if(inString != "null" ){
       lcd.setCursor(14,0);
       lcd.print('1');
       lcd.setCursor(0,0);

          if (inString.startsWith("h")){
            lcd.setCursor(13,0);
            lcd.print('h');
            lcd.setCursor(0,0);
             value1String   =    inString.substring(2,4);
              value1 = value1String.toInt();
             value2String   =    inString.substring(5,7); 
              value2 =  value2String.toInt();
             value3String   =    inString.substring(8,10); 
              value3 =  value3String.toInt();
             toggleVals = true;
                          }
        } else {
        lcd.setCursor(14,0);
        lcd.print('n');
        lcd.setCursor(0,0);
        }
    }

  if(ledStates[ledSelected] > 0 && millis() - ledTimers[ledSelected] >= ledStates[ledSelected])  {
    turnOffLED(ledSelected);
  }
  if(ledStates[ledSelected] < 0 && millis() - offTimerCheck > 10)
  {
    offTimerCheck = millis();
    ledStates[ledSelected] = ledStates[ledSelected] + 10; 
  }
  if(ledStates[ledSelected] == 0) {
    turnLED2sec(ledSelected);
  }
}
void turnOffLED (int ledID) {
     short int actualLedID;
    if(ledID >= 16) {
      actualLedID = ledID - 16;
      mcp2.digitalWrite(actualLedID, LOW) ;
      ledTimers[ledID] = millis();
      ledStates[ledID] = -50;
    } else {
      mcp1.digitalWrite(ledID , LOW);
      ledTimers[ledID] = millis();
      ledStates[ledID] = -50;
     }

}
void turnLED2sec (int ledID) {
  short int actualLedID;
    if(ledID >= 16) {
      actualLedID = ledID - 16;
      mcp2.digitalWrite(actualLedID, HIGH) ;
      ledStates[ledID] = 1000;
      ledTimers[ledID] = millis();
    } else {
      mcp1.digitalWrite(ledID,HIGH);
      ledStates[ledID] = 1000;
      ledTimers[ledID] = millis();
     }

}
void establishContact() {
 while (Serial.available() <= 0) {
  if (millis() - timeStampContact > 3000)
 {
      Serial.write('A');   // send a capital A
      lcd.setCursor(15,1);
      lcd.print('A');
      lcd.setCursor(0,0);
    timeStampContact = millis();
  }
 }
}
