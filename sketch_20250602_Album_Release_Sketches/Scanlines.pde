
float y = -60;
float ySpeed = 9 + downJolt/100;
void scanLines() {
  background(0);
  pg.beginDraw();
  pg.colorMode(HSB);
  //pg.background(0);
  pg.noStroke();
  pg.fill(0, 50);
  pg.rect(0, 0, width, height);
  pg.strokeWeight(5+totalAcc*5);
  pg.stroke((255-(zTilt-0.2)*100)-random(totalAcc*50), 255-random(totalAcc*50), 255);

  pg.translate(0, y);
  for (int i = -height*5; i<height*5; i+=120) {
    pg.line(0, i, width/2, i+zTilt*600);
    pg.line(width, i, width/2, i+zTilt*600);
  }
  pg.endDraw();


  image(pg, 0, 0);

  y+=ySpeed;
  if (y>height) {
    y=-height;
  }
}
