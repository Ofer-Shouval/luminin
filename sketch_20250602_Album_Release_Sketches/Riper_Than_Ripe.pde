//char[] phrase1 = {'R', 'I', 'P', 'E', 'R', 'T', 'H', 'A', 'N', 'R', 'I', 'P', 'E'};
char[] phrase1 = {'O', '.', 'W', 'A', 'K', 'E', 'R', 'I', 'P', 'E', 'R', 'T', 'H', 'A', 'N', 'R', 'I', 'P', 'E', '#', '&', 'Ψ', 'Л', 'O', '.', 'W', 'A', 'K', 'E', };
float speed = .2;

float interval1;
float interval2;
float interval3;
float interval4;
int counter1 = 0;
int counter2 = 0;
int counter3 = 0;
int counter4 = 0;
int randomSize = 0;


int txtSz = 300;


void RTR() {

  noStroke();
  background(0);



  float tiltColor = map(zTilt, -.8, .8, 0, 360);


  textMode(CENTER);
  riperThanRipeDraw(tiltColor);

  pushMatrix();
  //scale(-1, 1);
  image(pg, 0, 0);

  popMatrix();
}



void riperThanRipeDraw( float tiltColor) {
  int letter1 = counter1;
  int letter2 = (counter2+1)%phrase1.length;
  int letter3 = (counter3+2)%phrase1.length;
  int letter4 = (counter4+3)%phrase1.length;



  pg.beginDraw();

  pg.colorMode(HSB);
  pg.noStroke();

  float shift = gyroX*2;
  pg.fill(0.05*millis()%255, 255, 255);
  pg.rect(shift, 0.7*millis()%(height+300)-50, width/4+totalAcc/4, 100);

  pg.fill(0.1*millis()%255, 255, 255);
  pg.rect(width/4+shift, 0.45*millis()%(height+300)-50, width/4+totalAcc/4, 100);

  pg.fill(0.2*millis()%255, 255, 255);
  pg.rect(width/2+shift, 0.55*millis()%(height+300)-50, width/4+totalAcc/4, 100);

  pg.fill(0.3*millis()%255, 255, 255);
  pg.rect(width-width/4+shift, 0.8*millis()%(height+300)-50, width/4+totalAcc/4, 100);

  //pg.fill(0,5);
  //pg.rect(0,0,width,height);


  //}
  int upSwitch = 0;
  if (upJolt>100) {
    upSwitch = 100;
  }
  int downSwitch = 0;
  if (downJolt>50) {
    downSwitch = 100;
  }

  if (downSwitch!=0) {

    pg.textSize(txtSz);
    pg.fill(250-tiltColor/2+random(-20, 20), 255, 255, 255 );
    pg.rect(0, 0, width, height);
    pg.fill(150-tiltColor/2+random(-20, 20), 255, 255, 255 );
    pg.textAlign(CENTER, CENTER);

    pg.text(phrase1, letter1, letter1+1, txtSz/3, height/2 );
    pg.text(phrase1, letter2, letter2+1, width/4 + txtSz, height/2);
    pg.text(phrase1, letter3, letter3+1, 3*width/4 - txtSz, height/2);
    pg.text(phrase1, letter4, letter4+1, width-txtSz/3, height/2);
    pg.fill(0, 0, 0);
  }

  pg.endDraw();

  interval1 += speed+random(speed/2);
  counter1 = floor(interval1);


  interval2 += speed+random(speed/2);
  counter2 = floor(interval1);


  interval3 += speed+random(speed/2);
  counter3 = floor(interval1);


  interval4 += speed+random(speed/2);
  counter4 = floor(interval1);

  //counter5++;


  if (counter1>=phrase1.length) {
    counter1=0;
    interval1=0;
  }

  if (counter2 >= phrase1.length) {
    counter2=0;
    interval2=0;
  }

  if (counter3 >= phrase1.length) {
    counter3=0;
    interval3=0;
  }

  if (counter4>=phrase1.length) {
    counter4=0;
    interval4=0;
  }
}
