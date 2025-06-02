
SpinningCircles spinningCircles = new SpinningCircles();

class SpinningCircles {
float lerpedGyroY;

  int spacing = 20;
  int w;
  float theta = 0.0;
  float amplitude = 15.0;
  float period;
  float dx, radius;
  float[] yValues;
  float[] xValues;

  SpinningCircles() {
    
    
    period = random(3.0, 8.0);
    w = width+16;
    theta = 0.0;
    dx =(TWO_PI/period);
    yValues = new float[w/spacing];
    xValues = new float[w/spacing];
  }
  void update() {
    pg.background(0);
    lerpedGyroY = lerp(lerpedGyroY, gyroY, 0.1);
    float joltFactor = upJolt+downJolt;
    //print(gyroY);
    //print("  ");
    //println(lerpedGyroY);
    background(0);
    radius = map(zTilt, -1, 1, -150, 150);
    amplitude = 50+lerpedGyroY;

    calcWave();


    pg.beginDraw();
    pg.ellipseMode(CENTER);
    renderWave();
    //pg.stroke(map(upJolt,0,350,255,100),255,255,map(joltFactor,0,700,0,150));
    pg.noStroke();
    pg.fill(map(downJolt, 0, 350, 20, 0)+lerpedGyroY, 255-upJolt, map(joltFactor, 0, 350, 0, 255), map(joltFactor, 0, 700, 0, 150));

    pg.strokeWeight(upJolt/5);
    pg.rect(0, 0, width, height);
    pg.endDraw();


    image(pg, 0, 0);
  }

  void calcWave() {
    theta +=0.15 + map(zTilt, -.9, .9, -0.3, 0.3);



    float x = theta;
    for (int i = 0; i <yValues.length; i++) {

      float angle = TWO_PI - (TWO_PI / yValues.length);
      yValues[i] = ((radius * sin(angle*i)) + (sin(x)*amplitude));
      xValues[i] = ((radius * cos(angle*i)) + (cos(x)*amplitude));

      x += dx;
    }
  }

  void renderWave() {


    for (int i = 0; i<yValues.length; i++) {
      pg.colorMode(HSB);


      pg.strokeWeight(2);
      pg.fill(map(i, 0, yValues.length, 255, 200)-zTilt*100- (abs(gyroY)/2), 255 - abs(gyroY), 255);
      pg.stroke(map(i, 0, yValues.length, 0, 75)-zTilt*20, 255 -downJolt, 255);
      pg.ellipse( xValues[i] + width/4+ gyroY, height/2 + yValues [i], (100-downJolt)/2+30, (100-downJolt)/2+30);

      //pg.ellipse(80 + xValues[i], height/2 + yValues [i], 50-downJolt,50-downJolt);

      //pg.fill(map(i, 0, yValues.length, 0,75)-gyroY/5,255- totalAcc,255);
      //pg.stroke(map(i, 0, yValues.length, 100,175)+gyroY/5,255- totalAcc,255);
      pg.fill(map(i, 0, yValues.length, 0, 55)+map(zTilt, -1, 1, -85, 30)+ (abs(gyroY)/2), 255, 255);
      pg.stroke(map(i, 0, yValues.length, 75, 150)-zTilt*20, 255 -downJolt, 255);
      pg.ellipse( - xValues[i]+ 3*width/4 +gyroY, height/2 - yValues [i], (100-downJolt)/2+30, (100-downJolt)/2+30);
    }
  }
}
////variables for sketch


//void setup()
//{
//  period = random(3.0,8.0);
//     w = width+16;
//     theta = 0.0;
//     dx =(TWO_PI/period);
//     yValues = new float[w/spacing];
//     xValues = new float[w/spacing];


//}

//void draw()
//{



//



//}
