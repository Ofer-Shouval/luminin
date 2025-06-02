

Worm worm = new Worm();
class Worm {
  int numSegments = 80;
  PVector[] xyLoc = new PVector[numSegments];
  int c;
  color col;
  float noiseCounter = 0;
  float speed = 0.002;

  Worm() {

    for (int i = 0; i<numSegments; i++) {

      this.xyLoc[i] = new PVector(0, 0);
      //println(xyLoc[i]);
    }
    
  }
 
  void update(float circSize) {
    
    //this.xyLoc[numSegments-1].x = noise (noiseCounter)*(downJolt)+ map(gyroY, -30,30, 0,width);
    
    this.xyLoc[numSegments-1].x = map(noise(noiseCounter), 0, 1, -width/2, 3*width/2);
    this.xyLoc[numSegments-1].y = map(noise(noiseCounter+50), 0, 1, -height/2, 3*height/2);
    
    speed = map(downJolt, 0,2000, 0.005,0.5);

    if (mousePressed) {
      xyLoc[numSegments-1].x = mouseX;
      xyLoc[numSegments-1].y = mouseY;
    }


    //sets the location of the last element according to where the mouse is

 

    

    pg.beginDraw();
    pg.colorMode(RGB);
    pg.strokeWeight(3);

    pg.fill(downJolt + random(50), 100, 0);
    pg.colorMode(RGB);//pg.noFill();
    
    
    

    //if(downJolt>0){
       pg.fill(noise(noiseCounter)*50, 150*noise(noiseCounter+5),150*noise(noiseCounter+10),map(downJolt,0,100,50,10)) ;
        
       // pg.fill(0,10);
        pg.rect(0,0,width,height);
   // }
  //  else{


  //  }
   

    for (int i = 0; i<numSegments-1; i++) {
      xyLoc[i].x = xyLoc[i+1].x;
      xyLoc[i].y = xyLoc[i+1].y;
      float scalar = map(i, 0, numSegments -1, 0, PI);
      scalar = sin(scalar);
      pg.stroke(255-scalar*255*abs(zTilt)+random(-20,20), random(downJolt),scalar*250*abs(zTilt)+random(-20,20));
      pg.fill(scalar*250*abs(zTilt)+random(-20,20), random(downJolt), 255-scalar*255*abs(zTilt)+random(-20,20));

      pg.ellipse(xyLoc[i].x, xyLoc[i].y, circSize*scalar, circSize*scalar);
    }


    pg.endDraw();
    image(pg, 0, 0);
    noiseCounter+=speed;
  }
}
