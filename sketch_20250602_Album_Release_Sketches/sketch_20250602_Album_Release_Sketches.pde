//import codeanticode.syphon.*;

//SyphonServer server;

import processing.serial.*;
Serial myPort;  // Create object from Serial class
String accelData;
String pAccelData;


PGraphics pg;

void setup() {
  size(800, 300, P3D);
  colorMode(HSB);
  pg = createGraphics(width, height);

  String portName = Serial.list()[0];
  println(portName);
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');




  accelData = null;
  pAccelData = null;
  //frameRate(12);

  // Create syhpon server to send frames out.
  //server = new SyphonServer(this, "Processing Syphon");
}


int sketchNum = 0;
float zTilt =0;
float totalAcc =0;
float gyroX =0;
float gyroY =0;
int upJolt =0;
int downJolt =0;
int forwardJolt =0;
int backJolt=0;
int button = 0;
int pButton = 0;
int numOfSketches = 11;

int pDownJolt = 0;

int speedCounter = 0;
float joltFactor = (upJolt+downJolt)/2;



void draw() {


  // getControllerVars();

  joltFactor = (upJolt+downJolt)/2;

  if (button!=pButton) {

    if (button == 0) {
      sketchNum++;
    }

    pButton = button;
  }


  
    //print(sketchNum);
  switch(sketchNum) {
 

  case 0:
    //Intermission

    worm.update(200);
    break;
  case 1:
    //Unfamiliar State

    fallingCircles.update();


    // worm.update();
    break;
  case 2:
    //riper than ripe
    RTR();

    break;
  case 3:
    //Odysseus
    cloud.update();
    break;
  case 4:
    //Let's all Get Pessimistic
    spiral.update();
    strobe();
    break;
  case 5:

    //Henry David + Lightning in a Bottle
    spinningCircles.update();
    strobe();
    break;
  case 6:
    //You're Dead?
    expandingPolygons.update();
    strobe();

    break;

  case 7:
    // Not Your Type
    polyWorm.update();
    break;
  case 8:
    //little drone + head in the cloud
    goldenCircles.update();
    strobe();
    break;
  case 9:
    //jkolitm
    background(0);
    intenseWaves.update();
    strobe();
    break;

  case 10:
    //Crush
    scanLines();
    strobe();
    break;
  }





  sketchNum = sketchNum% numOfSketches;
  //println(gyroY);
  // println(downJolt);
  //println(sketchNum);
  //server.sendScreen();

  pDownJolt = downJolt;
}

void strobe() {

  //if(downJolt>100){

  if (frameCount%5<3) {
    //background(0,50);

    fill(0, map(downJolt, 500, 2000, 0, 150));
    rect(0, 0, width, height);
  } else {

    fill(255, map(downJolt, 500, 2000, 0, 150));
    rect(0, 0, width, height);
  }




  //}
}


void serialEvent(Serial p) {
  
  
  accelData = p.readString();
  println(accelData);
  
  
  JSONArray json = parseJSONArray(accelData);
  
  println(json);
  
  if (json==null) {
    
        println("JSONArray could not be parsed");

  }
  else{
    
    zTilt = json.getFloat(0);
    totalAcc = json.getFloat(1);
    gyroX = json.getFloat(2);
    gyroY = json.getFloat(3);
    upJolt= json.getInt(4);
    downJolt = json.getInt(5);
    forwardJolt = json.getInt(6);
    backJolt = json.getInt(7);
    button = json.getInt(8);
    
     println(zTilt);
  }
  
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  //pg.rotate(PI);
  pg.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    pg.vertex(sx, sy);
  }
  pg.endShape(CLOSE);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      sketchNum ++;
    } else if (keyCode == DOWN) {
      sketchNum --;
    }
  }
}
