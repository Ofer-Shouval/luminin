Spirals spiral = new Spirals();

class Spirals {
  float xOff = 0,
    pxOff = 0,
    yOff = 0,
    pyOff = 0;
  float spiralCounter = 0;
  float interval = 0.05;
  float tightness = 0.5;
  float rotation = 0;
  float roughness = 0.5;
  float rotationSpeed = -0.1;
  float stats;
  //float spiralCount = 0;

  int bkg = 255;
  float opc = 255;
  float dOpc = 0.5;
  float strk = 0;
  float strkwt = 15;
  int res = 30;

  Spirals() {
    
  }
  void init(){
    roughness = 0.5;
  }
  void update() {
    stroke(strk);
    rotationSpeed = zTilt;
    
     constrain(roughness, 0.5,100);
     
     pg.fill(0,30);
    pg.beginDraw();
    
    pg.noStroke();
    pg.rect(0,0,width,height);
    pg.colorMode(RGB);  
    pg.stroke(255,0,0);
   
   // pg.stroke(map(zTilt,-1,1,0,255)+random(255/(bkg+1)), 255, 255);
    
  //  pg.fill(map(zTilt,-1,1,255,0)+random(255/(bkg+1)), 255, 255,map(downJolt,0,250,100,10));
    
    


    pg.translate(width / 2, height / 2);
    pg.rotate(rotation);

    while (xOff < width) {
      pxOff = xOff;
      pyOff = yOff;
      xOff =
        spiralCounter * (spiralCounter / tightness) * cos(spiralCounter) +
        (xOff / roughness) * noise(spiralCounter);
      yOff =
        spiralCounter * (spiralCounter / tightness) * sin(spiralCounter) +
        (yOff / roughness) * noise(spiralCounter);

      pg.strokeWeight(strkwt);
      
     // pg.stroke(map(zTilt,-1,1,0,255)+random(bkg), 255, 255);
      pg.line(xOff, yOff, pxOff, pyOff);
      spiralCounter += interval;
    }

    image(pg, 0, 0);
    pg.endDraw();

    res = (int)spiralCounter;
    xOff = 0;
    pxOff = 0;
    yOff = 0;
    pyOff = 0;
    spiralCounter = 0;

    noiseSeed((int)random(100));
    rotation += rotationSpeed;
    
    
    if (roughness < 4) {
      roughness += 0.2;
    }

    if (tightness < 2) {
      tightness +=0.01;
    } else if (tightness > 2) {
      tightness -=0.2;
    }

    if (opc < 255) {
      opc += dOpc;
    }
    
    if(bkg <200){
      bkg += 1;
    }

   // if (downJolt > 2) {
      roughness = constrain(map(downJolt, 0,1000,10,0.5),0.5, 10);
      strkwt = constrain(downJolt/20,15,50);
      bkg = 0;
   // }
    
  }
}




//function keyPressed() {
//  // if (key === 's') {
//  //   saveFrames('spiral', 'png', 5, 12);
//  // }
//  if (keyCode == "49") {
//    roughness = 0.7;
//    tightness = random(20, 100);
//  }
//  if (keyCode == "50") {
//    tightness = random(180, 200);
//    roughness = 3;
//  }

//   if (keyCode == "51") {
//    tightness = random(100);
//    roughness = 4;
//  }
//    if (keyCode == "52") {
//    roughness = 0.5;

//    tightness = random(1000, 2000);
//  }
//  if (keyCode == "53") {
//    roughness = 0.5;
//    tightness = random(1, 4);
//  }



//  if (keyCode == "32") {
//    opc = 0;
//  }
//  if (keyCode == 38) {
//    strk = 255;
//    bkg = 0;
//  }
//  if (keyCode == 40) {
//    strk = 0;
//    bkg = 255;
//  }

//  if (keyCode == 39) {
//    if (dOpc >= 0) {
//      dOpc -= 0.1;
//    }
//  }
//  if (keyCode == 37) {
//    dOpc += 0.1;
//  }

//  // print(opc);
//}
