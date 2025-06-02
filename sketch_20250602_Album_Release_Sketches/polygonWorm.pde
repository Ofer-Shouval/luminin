PolygonWorm polyWorm = new PolygonWorm();


class PolygonWorm {
  int numSegments = 120;
  PVector[] xyLoc = new PVector[numSegments];
  int c;
  color col;
  float noiseCounter = 0;
  float speed = 0.005;

  PolygonWorm() {

    for (int i = 0; i<numSegments; i++) {

      this.xyLoc[i] = new PVector(0, 0);
      //println(xyLoc[i]);
    }
    
  }
 
  void update() {
    
    //this.xyLoc[numSegments-1].x = noise (noiseCounter)*(downJolt)+ map(gyroY, -30,30, 0,width);
    
    this.xyLoc[numSegments-1].x = map(noise(noiseCounter), 0, 1, 0, width*1.5);
    this.xyLoc[numSegments-1].y = map(noise(noiseCounter+50), 0, 1, 0, height*1.5);
    
    speed = map(downJolt, 0,2000, 0.005,0.5);

    if (mousePressed) {
      xyLoc[numSegments-1].x = mouseX;
      xyLoc[numSegments-1].y = mouseY;
    }


    //sets the location of the last element according to where the mouse is

 

    

    pg.beginDraw();
    pg.colorMode(RGB);
    pg.strokeWeight(3);   
    
    
    

    //if(downJolt>0){
       pg.fill(255,map(downJolt,0,100,50,10)) ;
   
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

      //pg.rect(xyLoc[i].x, xyLoc[i].y, 400*scalar, 400*scalar);
      
      polygon(xyLoc[i].x, xyLoc[i].y,80*scalar,round(map(downJolt,0,2000,3,10)));
    }
    
    this.xyLoc[numSegments-1].x = map(noise(noiseCounter+100), 0, 1, 0, width*1.5);
    this.xyLoc[numSegments-1].y = map(noise(noiseCounter+150), 0, 1, 0, height*1.5);
    
    for (int i = 0; i<numSegments-1; i++) {
      xyLoc[i].x = xyLoc[i+1].x;
      xyLoc[i].y = xyLoc[i+1].y;
      float scalar = map(i, 0, numSegments -1, 0, PI);
      scalar = sin(scalar);
      pg.stroke(255-scalar*255*abs(zTilt)+random(-20,20), random(downJolt),scalar*250*abs(zTilt)+random(-20,20));
      pg.fill(scalar*250*abs(zTilt)+random(-20,20), random(downJolt), 255-scalar*255*abs(zTilt)+random(-20,20));

      //pg.rect(xyLoc[i].x, xyLoc[i].y, 400*scalar, 400*scalar);
      
      polygon(xyLoc[i].x, xyLoc[i].y,200*scalar,round(map(downJolt,0,2000,3,10)));
    }

    pg.endDraw();
    image(pg, 0, 0);
    noiseCounter+=speed;
  }
}
