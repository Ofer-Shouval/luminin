



IntenseWaves intenseWaves = new IntenseWaves();

class IntenseWaves{
  int spacing =10;
int w;
float theta = 0.0;
float amplitude = 15.0;
float period;
  float dx, radius;
  float[] yValues; 
  float[] yValues2; 
  float[] xValues; 
  IntenseWaves(){
    
   
  period=12;
  w = width+16;
  theta = 0.0;
  dx =(TWO_PI/period);
  yValues = new float[w/spacing];     
  xValues = new float[w/spacing];
  yValues2 = new float[w/spacing];
  
  }
  
  void update(){
    
  radius = 15+gyroY;
  period = 5+upJolt;
  amplitude = 50+downJolt/10;

  //radius = mouseX/5;
  //amplitude = mouseY/5;

  calcWave();


  pg.beginDraw();
  pg.colorMode(HSB);
  
  pg.background(0);
  pg.rectMode(CENTER);
  renderWave();
  pg.fill(0,10);
  pg.noStroke();
  pg.rect(0,0,width, height);
  
  pg.rectMode(CORNER); 
  pg.endDraw();


  image(pg, 0, 0);
    
  }
  
  void calcWave() {
  theta +=0.1 + map(gyroY, -50, 50, -0.4, 0.4);

  float x = theta;
  for (int i = 0; i <yValues.length; i++) {

    float angle = TWO_PI / yValues.length;
    yValues[i] = ((radius * sin(angle*i)) + (sin(x)*amplitude));
    yValues2[i] = ((radius * cos(angle*i)) - (sin(x)*amplitude));
    xValues[i] = i*width/spacing;

    x += dx;
  }
}


void renderWave() {
  
  for (int i = 0; i<yValues.length; i++) {
   // pg.colorMode(HSB);
    pg.strokeWeight(1);
    
    pg.rectMode(CENTER);   
    
    pg.fill(xValues[i]/10+255*abs(zTilt), 255-((joltFactor/10)*random(1)), 255, upJolt);
    
    //if(downJolt<400){
    //  pg.fill(xValues[i]/10+255*abs(zTilt), 255-((joltFactor/10)*random(1)), 200*map(zTilt,0,-0.5,1,0));
    //};
   
    pg.strokeWeight(map(downJolt,0,1000,1,10));
    //top wave
    pg.stroke(40 + xValues[i]/6, 255*random(1), 255);
    pg.rect( width - xValues[i]-5, random(1)*((upJolt+downJolt)/5), 50 + width/xValues.length, yValues2[i]*5);
    //bottom wave
    pg.stroke(230-(xValues[i]/6), 255*random(1), 255);
    pg.rect( width-xValues[i]-5, height-(random(1)*((upJolt+downJolt)/5)),50 + width/xValues.length, yValues[i]*5);  
    //middle wave
    pg.stroke(xValues[i]/2+(255*abs(zTilt)), 255-((joltFactor/2)*random(1)), 255);
    pg.rect(width - (xValues[i]-5) , height/2+(random(1)*(upJolt+downJolt/5)), abs(gyroY) + width/xValues.length, yValues[i]*4); 
  }
}
  
  
}
