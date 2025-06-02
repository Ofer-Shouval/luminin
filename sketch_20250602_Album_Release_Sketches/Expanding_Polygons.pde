
ExpandingPolygons expandingPolygons = new ExpandingPolygons();

class ExpandingPolygons {
  float radius = 0;
  float growth = 5;
  int numPolys = 4;
  ExpandingPolygons() {
    
  }
  float rotations = 0;
  void update(){
    
    numPolys = round(map(downJolt, 0,1000,4,8));
    pg.beginDraw();
    pg.colorMode(HSB);
    //pg.noFill();
    pg.push();
    pg.translate(width/2, height/2);
    pg.rotate(rotations);
    pg.strokeWeight(15);
    pg.stroke((map(zTilt, -0.8,1,0, 255)+random(map(downJolt,0,1000,10,80)))%255,downJolt,255);
    pg.fill(0,10);
    
    
    for(int i = width; i>=0; i-=width/numPolys){
      
 
      
          polygon(0,0,radius+i,round(map(downJolt,0,2000,3,15)));

    }
    
    pg.pop();
    pg.endDraw();
    image(pg, 0, 0);
    
    radius+=growth;
    
    if (radius>= width/numPolys){
      radius = 0;
    }
    
    rotations+=0.01;
  }
}
