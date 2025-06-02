Cloud cloud = new Cloud();

PImage clouds;
class Cloud {

  Cloud() {
    noiseDetail(5, 0.4);
    //colorMode(HSB);
    clouds = createImage(width, height, RGB);
    
    clouds.loadPixels();
    //clouds
  }


  void update() {
    float z = millis() * 0.0001 + totalAcc/2;

    float dx = millis() * 0.0001;

    //if(downJolt>100) {
    //    dx = dx+downJolt/3;
    //  }

    for (int x = 0; x<clouds.width; x++) {
      for (int y = 0; y<clouds.height; y++) {
        float  n = noise(x * 0.02*(1+totalAcc/3), dx+ y * 0.02*(1+totalAcc/3), z)-.2;
        //println(n);

        color c = color(map(zTilt, -1, 1, 0, -80)+240+100*n - random(20+downJolt), 255, 255);
        clouds.pixels[x + clouds.width*y] = c;
      }
    }
    clouds.updatePixels();
    image(clouds, 0, 0, width, height);
  }
}
