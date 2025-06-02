
GoldenCircles goldenCircles = new GoldenCircles();

int slow = 3;
int num = 40;

float[] xLoc = new float[num];
float[] yLoc =new float[num];

float[] cosWave=new float[num];
float[] sinWave=new float[num];

class GoldenCircles {

  GoldenCircles() {

    for (int i = 0; i<num; i++) {
      float amt = map(i, 0, num, 0, PI);
      cosWave[i] = abs(cos(amt));
      sinWave[i] = abs(sin(amt));
    }
  }

  void update() {
  


    if (speedCounter%slow == 0 ){
        strokeWeight(10);
    background(0);
      for (int i = 0; i < yLoc.length - 1; i++) {
        yLoc[i] = yLoc[i + 1];
        xLoc[i] = xLoc[i + 1];

        // fill(0);
        fill(10 * cosWave[i] + map(zTilt, -2, 1, 100, 260)-random(downJolt), 255, 100+downJolt/2);
        stroke(20 * cosWave[i] + map(zTilt, -1, 1, 0, 40), 255, 255);


        //stroke(random(200, 255) * sinWave[i], random(200, 255) * cosWave[i], 255 - random(200, 255) * sinWave[i]);
        // fill(0, 200 * sinWave[i], 255 - 150 * sinWave[i]);


        float diameter = sin(map(i, 0, yLoc.length, 0, PI)) * ((height/2)*(1+totalAcc/3));
        pushMatrix();
        translate(xLoc[i], yLoc[i]);
        //rotate(cosWave[i]*4);

        ellipse(0, 0, (diameter), (diameter));
        popMatrix();
      }
    }

    yLoc[yLoc.length - 1] = random(height);
    xLoc[xLoc.length - 1] = random(width)+gyroY*5;

    speedCounter++;
  }
}
