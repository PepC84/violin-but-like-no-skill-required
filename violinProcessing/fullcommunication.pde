// https://www.desmos.com/calculator/phl5mlfgnq
/*
Table table;

void setup() {

  table = loadTable("MusicSheet.csv", "header");

  println(table.getRowCount() + " total rows in table");

  for (TableRow row : table.rows()) {


    String duration = row.getString("duration");
    String octave = row.getString("octave");
    String note = row.getString("note");
    String id = row.getString("id");
    println(note + " " + octave + " " + duration );
    
    
 //   table.addRow().setString("duration", "2");
  }

}
*/

import processing.serial.*;
Serial port;
PImage treble;

Table blankTable;

boolean leftRelease = false;
long lastTime = 0;              // timestamp for that moment
int stepSend = 0;               // number of ongoing case 
int timeStep = 10;            // first action moment          
boolean sendStringVar = false;  // function enabled or disabled
int interval = 10;            // number in milliseconds       // difference per case (1000 = 1 Second)
long timeStampReceived = 0;
boolean firstContact = false;
int inByte;
String inString = null;
boolean receivedContact = false;
long timerSend = millis() - 7000;
int sendValue1 = 000;
int sendValue2 = 000;
int sendValue3 = 000;
int rowCount = 0;
int noteRadius = 13;
boolean leftPressed = false;
boolean leftReleased = false;
int noteSelectTime = 0;
int screenWidth = 1024;
int screenHeight = 720;
int intervalSelected;
boolean noteInterval;
String buttonSelected;
String pitchNoteSelected;
noteButton noteG3 = new noteButton(50 + noteRadius * 4,93 + noteRadius * 7 ,   "G3");
noteButton noteA3 = new noteButton(50 + noteRadius * 8,93 + noteRadius * 6.5,  "A3");
noteButton noteB3 = new noteButton(50 + noteRadius * 12,93 + noteRadius * 6,   "B3");
noteButton noteC4 = new noteButton(50 + noteRadius * 16,93 + noteRadius * 5.5, "C4");
noteButton noteD4 = new noteButton(50 + noteRadius * 20,93 + noteRadius * 5,   "D4");
noteButton noteE4 = new noteButton(50 + noteRadius * 24,93 + noteRadius * 4.5, "E4");
noteButton noteF4 = new noteButton(50 + noteRadius * 28,93 + noteRadius * 4,   "F4");
noteButton noteG4 = new noteButton(50 + noteRadius * 32,93 + noteRadius * 3.5, "G4");
noteButton noteA4 = new noteButton(50 + noteRadius * 36,93 + noteRadius * 3,   "A4");
noteButton noteB4 = new noteButton(50 + noteRadius * 40,93 + noteRadius * 2.5, "B4");
noteButton noteC5 = new noteButton(50 + noteRadius * 44,93 + noteRadius * 2,   "C5");
noteButton noteD5 = new noteButton(50 + noteRadius * 48,93 + noteRadius * 1.5, "D5");
noteButton noteE5 = new noteButton(50 + noteRadius * 52,93 + noteRadius * 1,   "E5");
noteButton noteF5 = new noteButton(50 + noteRadius * 56,93 + noteRadius * .5,  "F5");
noteButton noteG5 = new noteButton(50 + noteRadius * 60,93 + noteRadius * 0,   "G5");
noteButton noteA5 = new noteButton(50 + noteRadius * 64,93 + noteRadius * -.5, "A5");
noteButton noteB5 = new noteButton(50 + noteRadius * 68,93 + noteRadius * -1,  "B5");
pentagram pentaButtons = new pentagram(50,screenWidth - 50,100,noteRadius);
pentagram pentaSelect = new pentagram(50- noteRadius * 2,50 + noteRadius * 2,275 - noteRadius * 3,noteRadius);


squareButton tempo0 = new squareButton(100,225,200,262,  "1");
squareButton tempo1 = new squareButton(202,225,302,262, "1/2");
squareButton tempo2 = new squareButton(304,225,404,262, "1/4");
squareButton tempo3 = new squareButton(406,225,506,262, "1/8");
squareButton tempo4 = new squareButton(508,225,608,262, "1/16");
squareButton tempo5 = new squareButton(610,225,710,262, "1/32");
squareButton note = new squareButton(100,264,150,300, "note");
squareButton rest = new squareButton(152,264,202,300, "rest");
squareButton place = new squareButton(710,225,760,300, "place");

ArrayList <pentagram> pentagramas = new ArrayList <pentagram>();
void settings() {
 size(screenWidth,screenHeight, P3D);
}
void setup() {
  
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[1], 9600);
  port.clear();
  inString = port.readStringUntil('r');
  inString = null;
  
  blankTable = new Table();
  blankTable.addColumn("id");
  blankTable.addColumn("note");
  blankTable.addColumn("duration");
  blankTable.addColumn("octave");
  
  saveTable(blankTable, "data/NewMusicSheet.csv");
  
  treble = loadImage("gclef.png");
}
void draw() {

background(255);
fill(255);
drawNoteSelect();
stroke(0);
strokeWeight(1);
fill(0);

 
image(treble, 50,100 - noteRadius * 2,noteRadius * 3,noteRadius *8);
pentaButtons.showPentagram();pentaSelect.showPentagram();
//CRAZY CODE
noteG3.showNote();noteA3.showNote();noteB3.showNote();noteC4.showNote();noteD4.showNote();noteE4.showNote();noteF4.showNote();noteG4.showNote();noteA4.showNote();noteB4.showNote();noteC5.showNote();noteD5.showNote();noteE5.showNote();noteF5.showNote();noteG5.showNote();noteA5.showNote();noteB5.showNote();
tempo0.show();tempo1.show(); tempo2.show();tempo3.show(); tempo4.show();tempo5.show(); 
note.show(); rest.show();place.show();

text("x: "+mouseX+" y: "+mouseY, 10, 15);

if (sendStringVar == true) {
  sendString(int(sendValue1),int(sendValue2),int(sendValue3));
}

if (firstContact == true ) {
   text(" Arduino Contactado ", 10,90);
  } else {
   text("Arduino no contactado", 10,90); 
  }  
}

void sendString( int a, int b , int c) {
  
  String sa = nf(a,2);
  String sb = nf(b,2);
  String sc = nf(c,2);

if (firstContact == true)
{
  
   if ( millis() - lastTime > timeStep )
   {

    stepSend = stepSend + 1;
    timeStep = timeStep + interval;
    
 switch(stepSend) {
    case 1:
  port.write('h');
 break;
    case 2:
  port.write(',');
 break;
    case 3:
  port.write(sa);
 break;
    case 4:
 port.write(',');
 break;
    case 5:
  port.write(sb);
 break;
    case 6:
 port.write(',');
  break;
    case 7:
 port.write(sc);
  break;
    case 8:
  port.write(',');
  break;
    case 9:
  sendStringVar = false;
  stepSend = 0;
  timeStep = 10;
  lastTime = millis(); 
  port.write('e');
  break;
                 }
    }
    
  } 
    
 }

void serialEvent(Serial port ) {
inString = port.readString();
if (inString != null) {
    if (inString.equals("A")) { 
      if (firstContact == false) {
         firstContact = true;
         port.buffer(15);
         port.clear();
        }
     }
 }
}
void mouseReleased() {
  if(mouseButton == LEFT && leftPressed == true) {
     leftRelease = true;
     leftPressed = false;
    } 
}
void drawNoteSelect() {
 strokeWeight(1.50);
 fill(255);
  if (mouseX > 50 - noteRadius * 2 && mouseY > 275 - noteRadius * 4 && mouseX < 50 + noteRadius * 2 && mouseY < 275 + noteRadius * 2) {
    stroke(100);
    print("balls");
    if(mousePressed && mouseButton == LEFT)  {
     leftPressed = true;
     strokeWeight(2);
    print("itch");
    if(leftRelease == true) {
      noStroke();
      print("bruh");
     leftRelease = false;
    }
  }
  }
  rect(50 - noteRadius * 2,275 - noteRadius * 4 ,noteRadius * 4  , noteRadius * 6);
stroke(0);
strokeWeight(1);
fill(0);
 
 switch(noteSelectTime) {
   case 6:
   rect(50 - noteRadius/2,275 - noteRadius * 2,noteRadius,noteRadius/2);
   break;
   case 7: 
   rect(50 - noteRadius/2,275 - noteRadius,noteRadius,noteRadius/2);
   break;
   case 8:
   fill(255);
   stroke(0);
   line(50 - noteRadius/2,275 - noteRadius * 2, 50 + noteRadius/2, 275 - noteRadius * 2 + noteRadius/2);
   fill(0);
   line(50 - noteRadius/2,275 - noteRadius * 2, 50 + noteRadius/2, 275);
   ellipse(50 + noteRadius/4,275 - noteRadius * 2 + noteRadius/4,6,6);
   break;
   case 9:
   fill(255);
   stroke(0);
   line(50 - noteRadius/2, 275 - noteRadius * 2 + noteRadius/2, 50 + noteRadius/2,275 - noteRadius * 2);
   fill(0);
   line(50 - noteRadius/2, 275 , 50 + noteRadius/2,275 - noteRadius * 2);
   ellipse(50 - noteRadius/4 ,275 - noteRadius * 2 + noteRadius/4,6,6);
   break;
   case 10:
      fill(255);
   stroke(0);
   line(50 - noteRadius/2, 275 - noteRadius * 2 + noteRadius/2 + noteRadius/2, 50 + noteRadius/2,275 - noteRadius * 2 + noteRadius/2);
   line(50 - noteRadius/2 + noteRadius/2, 275 - noteRadius * 3  + noteRadius/2 + noteRadius/2, 50 + noteRadius/2 + noteRadius/2,275 - noteRadius * 3 + noteRadius/2);
   fill(0);
   line(50 - noteRadius/2, 275 + noteRadius/2, 50 + noteRadius/2 + noteRadius/2,275 - noteRadius * 3 + noteRadius/2);
   ellipse(50 - noteRadius/4 ,275 - noteRadius * 2 + noteRadius/4 + noteRadius/2,6,6); 
   ellipse(50 - noteRadius/4 + noteRadius/2 ,275 - noteRadius * 3 + noteRadius/4  + noteRadius/2,6,6); 
   break;
   case 11: 
    fill(255);
   stroke(0);
   line(50 - noteRadius, 275 - noteRadius * 2 + noteRadius/2 + noteRadius, 50 ,275 - noteRadius * 2 + noteRadius);
   line(50 - noteRadius + noteRadius/2, 275 - noteRadius * 3  + noteRadius + noteRadius/2, 50 + noteRadius/2,275 - noteRadius * 3 + noteRadius);
   line(50 - noteRadius/4 , 275 - noteRadius * 4  + noteRadius + noteRadius/2, 50 + noteRadius/2 + noteRadius/2,275 - noteRadius * 4 + noteRadius);
   fill(0);
   line(50 - noteRadius/2 - noteRadius/4, 275 + noteRadius, 50 + noteRadius ,275 - noteRadius * 3 );
   ellipse(50,275 - noteRadius * 4 + noteRadius/4 + noteRadius + 6/2  ,6,6); 
   ellipse(50 - noteRadius ,275 - noteRadius * 2 + noteRadius/4 + noteRadius + 6/2 ,6,6); 
   ellipse(50 - noteRadius + noteRadius/2 ,275 - noteRadius * 3 + noteRadius/4  + noteRadius +  6/2  ,6,6); 
   break;
   case 0:
    fill(255);
    strokeWeight(2);
    ellipse(50,275 - noteRadius,15,15);
    break;
   case 1:
    fill(255);
    rect(50 + noteRadius/2 - noteRadius/6,275 - 35,1,(noteRadius * 3)- noteRadius/2);
    ellipse(50,275,15,15);
    strokeWeight(2);
    ellipse(50,275,12,12);
   break;
   case 2:
    ellipse(50,275,15,15);
    rect(50 + noteRadius/2 - noteRadius/6,275 - 35,1,(noteRadius * 3)- noteRadius/2);
   break;
   case 3: 
    ellipse(50,275,15,15);
    rect(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2,1,(noteRadius * 3));
    strokeWeight(2);
    line(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius * 2);
   break;
   case 4: 
    ellipse(50,275,15,15);
    rect(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2,1,(noteRadius * 3));
    strokeWeight(2);
    line(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius);
    line(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2 + noteRadius/2,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius + noteRadius/2);
    line(50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius + noteRadius/2);
   break;
   case 5:
    ellipse(50,275,15,15);
    rect(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2,1,(noteRadius * 3));
    strokeWeight(2);
    line(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius);
    line(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2 + noteRadius/2,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius + noteRadius/2);
    line(50 + noteRadius/2 - noteRadius/6,275 - 35 - noteRadius/2 + noteRadius/2 + noteRadius/2,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius + noteRadius);
    line(50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius,50 + noteRadius/2 - noteRadius/6 + noteRadius,275 - 35 + noteRadius + noteRadius);
   break;
 }
strokeWeight(1);
fill(0);
}
class squareButton {
  int limitLeft;
  int limitUp;
  int limitRight;
  int limitDown;
  String interval;
   squareButton(int templimitLeft, int templimitUp, int templimitRight,  int templimitDown, String tempInterval) {
     limitLeft = templimitLeft;
     limitUp = templimitUp;
     limitRight = templimitRight;
     limitDown = templimitDown;
     interval = tempInterval;
  }
  void show() {
 strokeWeight(1.50);
 fill(255);
  if (mouseX > limitLeft && mouseY > limitUp && mouseX < limitRight && mouseY < limitDown) {
    stroke(100);
    fill(255,0,0);
    if(mousePressed && mouseButton == LEFT)  {
     leftPressed = true;
     strokeWeight(2);
    }
    if(leftRelease == true) {
      noStroke();
     leftRelease = false;
     switch(interval) {
      case "1":
      intervalSelected = 0;
      buttonSelected = "1";
      break;
      case "1/2":
      intervalSelected = 1;
      buttonSelected = "1/2";
      break;
      case "1/4":
      intervalSelected = 2;
      buttonSelected = "1/4";
      break;
      case "1/8":
      intervalSelected = 3;
      buttonSelected = "1/8";
      break;
      case "1/16":
      intervalSelected = 4;
      buttonSelected = "1/16";
      break;
      case "1/32":
      intervalSelected = 5;
      buttonSelected = "1/32";
      break;
      case "rest":
      noteInterval = false;
      break;
      case "note":
      noteInterval = true;
      break;
     }
    }
  }
 if(intervalSelected >= 0) {
  if(noteInterval == true) {
  noteSelectTime = intervalSelected;
    if(interval == "note") {
  strokeWeight(3);
    }
  } else {
    if(interval == "rest") {
     strokeWeight(3); 
    }
  noteSelectTime = intervalSelected + 6;
  
  }
}
if(intervalSelected >= 0) {
 if(buttonSelected == interval) {
  strokeWeight(3); 
 }
}
  rect(limitLeft,limitUp,limitRight - limitLeft,limitDown - limitUp);
      fill(0);
    stroke(0);
    strokeWeight(1);
    int spaceFix = 1;
    if(interval.length() != 1) {
     spaceFix = spaceFix * 3 * interval.length();
    } else {
     spaceFix = 0; 
    }
    text(interval,limitLeft + (limitRight - limitLeft)/2 - spaceFix,limitUp + (limitDown - limitUp)/2 + (limitDown - limitUp)/8);
 }    
}
class pentagram {
 int xpos1;
 int xpos2;
 int ypos;
 int separator;
  pentagram(int tempxpos1, int tempxpos2, int tempypos,  int tempSeparator) {
     xpos1 = tempxpos1;
     xpos2 = tempxpos2;
     ypos = tempypos;
     separator = tempSeparator;
  }
  void showPentagram() {
    fill(0);
    stroke(0);
    strokeWeight(1);
line(xpos1,ypos,xpos2,ypos );
line(xpos1,ypos + separator * 1,xpos2,ypos + separator * 1);
line(xpos1,ypos + separator * 2,xpos2,ypos + separator * 2);
line(xpos1,ypos + separator * 3,xpos2,ypos + separator * 3);
line(xpos1,ypos + separator * 4,xpos2,ypos + separator * 4);

  }
}
class noteButton {
  float xpos;
  float ypos;
  String noteInfo;
  noteButton(float tempXpos,float tempYpos, String tempNoteInfo) {
   xpos = tempXpos;
   ypos = tempYpos;
   noteInfo = tempNoteInfo;
  }

void showNote() {
 fill(0); 
  text(noteInfo,xpos - noteRadius/2,ypos + 20);
  if (dist(xpos,ypos, mouseX, mouseY) <= noteRadius) {
    stroke(100);
    fill(100);
    
    if(mousePressed && mouseButton == LEFT)  {
     leftPressed = true;
     strokeWeight(2);
    }
    if(leftRelease == true) {
      noStroke();
     fill(255,0,0); 
     leftRelease = false;
     pitchNoteSelected = noteInfo;
    }
  } 
  if( noteInterval == true) {
  if(intervalSelected >= -1 && pitchNoteSelected == noteInfo) {
strokeWeight(3);
  } 
  } else {
   pitchNoteSelected = "none"; 
  }
    

 ellipse(xpos,ypos,15,15);
 rect(xpos + noteRadius/2 - noteRadius/6,ypos - 35,1,(noteRadius * 3)- noteRadius/2);
fill(0);
stroke(0);
strokeWeight(1);
}
}
