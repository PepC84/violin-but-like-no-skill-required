// mp1 addresses = 
/*  -- |pin on the circuit| |name of pin on hardware| |ID of the LED on arduino|
--  21  GPA0  0  A#4
--  22  GPA1  1  C#5  
--  23  GPA2  2  C5
--  24  GPA3  3  G#5
--  25  GPA4  4  F#5
--  26  GPA5  5  A#5
--  27  GPA6  6  F5
--  28  GPA7  7  B4
--  1   GPB0  8  G3
--  2   GPB1  9  A5
--  3   GPB2  10 D#5
--  4   GPB3  11 E5
--  5   GPB4  12 G5
--  6   GPB5  13 A4
--  7   GPB6  14 D4
--  8   GPB7  15 D5
*/
//mp2 addresses = 
/* substract 16 for actual address
--  21  GPA0  16 G4
--  22  GPA1  17 C#4
--  23  GPA2  18 A#3
--  24  GPA3  19 G#4
--  25  GPA4  20 
--  26  GPA5  21 E4
--  27  GPA6  22 
--  28  GPA7  23 A3
--  1   GPB0  24 B3
--  2   GPB1  25 F4
--  3   GPB2  26 C3
--  4   GPB3  27 
--  5   GPB4  28 G#3
--  6   GPB5  29 
--  7   GPB6  30 D#3
--  8   GPB7  31 F#4
*/ 


// h,000,000,000,e ps send format
// j,000,000,000,r arduino send format
#include <SoftwareSerial.h>
SoftwareSerial HC06(0,1);
char data;
String dataString = "";
#include <Adafruit_MCP23X17.h>
#include <Wire.h>

Adafruit_MCP23X17 mcp1;
Adafruit_MCP23X17 mcp2;

String inString; 
int inByte;

int value1 = 0;
int value2 = 0;
int value3 = 0;

String  value1String;
String  value2String;
String  value3String;

long timeStampContact = millis();
void setup() {
   Serial.begin(9600);
   HC06.begin(9600);


mcp1.begin_I2C(0x21); //low low high
mcp2.begin_I2C(0x22); //low high low

for(int i=0;i<16;i++) {
  mcp1.pinMode(i, OUTPUT);
  mcp2.pinMode(i, OUTPUT);
  if(i==15) {
    break;
  }
}

setLEDsLow(); 
//establishContact();
}

void loop() {

mcp2.digitalWrite(15,HIGH);

 
  if (HC06.available() > 0) {

   //   HC06.write('C');
    inString = HC06.readStringUntil('e');
  if(inString != "null" )
    { 


 if (inString.startsWith("h") )                  //   si string inicia con  "h" es valida y guarda contenido en arreglo sa[]
     {  

        value1String   =    inString.substring(2,5);
          value1 = value1String.toInt();
        value2String   =    inString.substring(6,9); 
          value2 =  value2String.toInt();
        value3String   =    inString.substring(10,13); 
          value3 =  value3String.toInt();

          
       
        Serial.print("v1 ");
         Serial.println(value1);
          Serial.print("v2 ");
           Serial.println(value2);
            Serial.print("v3 ");
             Serial.println(value3);

                          }
                         
    }
    }


}
/*void establishContact() {

 while (HC06.available() <= 0) {
  if (millis() - timeStampContact > 3000)
 {
      HC06.write('A');   // send a capital A
    timeStampContact = millis();
  }
 }
}
*/
void setLEDsLow() {
     for(int i=0;i<16;i++) {
mcp1.digitalWrite(i,LOW);
mcp2.digitalWrite(i,LOW);
  if(i==15) {
    break;
  }
 }
}


