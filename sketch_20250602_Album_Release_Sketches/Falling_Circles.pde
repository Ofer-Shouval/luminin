
FallingCircles fallingCircles = new FallingCircles();

float rotate;
int dirSwitch=0;
int strobe = 0;
int counter = 0;
int freq = 2;
// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;


class FallingCircles {
  
  FallingCircles() {
   
      flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehicle>();

  for (int i = 0; i < 20; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(3, 8), random(0.1, 0.5)));
  }
  }

  void update() {
    rotate = map(gyroY, -100, 100, -1, 1);

    joltFactor = map((upJolt+downJolt), 0, 700, 0, 1);
    background(0);
    flowfield.update();
    pg.beginDraw();
    pg.colorMode(HSB);
   // pg.rectMode(CENTER);

    if (upJolt>340) {
      dirSwitch=1;
    }
    if (downJolt >340) {
      dirSwitch = 0;
    }

    counter++;
    if (strobe == 0 && counter >= freq)
    {
      strobe = 1;
      counter = 0;
    }
    if (strobe == 1 && counter >= freq) {
      strobe = 0;
      counter = 0;
    }
    pg.noFill();


    for (Vehicle v : vehicles) {
      v.follow(flowfield);
      v.run();
      PVector l = v.loc();
      float vel = map(v.velocity(), 3, 8, 50, 100);
      float r = v.radius();
      //colorMode(RGB);
      color col =color(255-((zTilt+.25)*500), 255-(vel-(zTilt*50)), (zTilt+.1)*500);
      pg.colorMode(HSB);
      //pg.noFill();
      pg.stroke(hue(col)+random(-5-(10*joltFactor), 5+(10*joltFactor))-l.y/(16-(10*joltFactor)), 255-((downJolt/1.5)-upJolt/1.5), 255);
      pg.strokeWeight(2+joltFactor*20);
      //pg.stroke(hue(col)+random(-5,5),255-downJolt,255);

      pg.ellipse(l.x, l.y, r*2, r*2);

      //pg.fill(255-vel,vel,255);
      //pg.rect(width-l.x,height-l.y,20,r);
      //pg.ellipse(l.x,l.y,r+downJolt/5,r+downJolt/5);
    }
    pg.fill(0, 15-(joltFactor*20)-abs(rotate*10));

    pg.strokeWeight(3+upJolt/3);

    pg.stroke(255-gyroY*2, 255-upJolt, 255);

   // pg.rect(width/2, height/2, width, height);
    //println(map(zTilt,-1,0,255,0));
    //pg.ellipse(100,height/2+gyroY,50,50);
    //pg.ellipse(width-100,height/2+gyroX,50,50);
    //pg.ellipse(width/2,height/2+zTilt*100,50,50);
    noFill();
    pg.stroke(downJolt, 255-(downJolt/3), 255, 255-downJolt/4);
    pg.strokeWeight(downJolt/2);

    pg.rect(0, 0, width, height);

    //pg.stroke(255,0+(200*strobe),255,255*joltFactor);
    //pg.strokeWeight(20);

    //pg.rect(width/2,height/2,width,height);
    //pg.ellipse(width/2,(height/2),downJolt,downJolt);
    pg.endDraw();

    image(pg, 0, 0);
  }
}

class Vehicle {

  // The usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;   // Maximum speed
  int colorVariation;

    Vehicle(PVector l, float ms, float mf) {
    position = l.get();
    r = random(5,40);
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    colorVariation = (int)random(0,100);
  }

  public void run() {
    update();
    borders();
  }


  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(position);
    // Scale it up by maxspeed
    desired.mult(maxspeed+(joltFactor*100 ));
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed+(upJolt+downJolt/30));
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
PVector loc(){
 return position;
}
int col(){
 return colorVariation; 
}
float radius(){
 return(r); 
}
float velocity(){
 
  return velocity.mag();
}

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) {position.y = -r; position.x = random(width);}
  }
}

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  float zoff = 0.0; // 3rd dimension of noise
  
  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  void init() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta),sin(theta));
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }

  void update() {
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        
       
        float theta = map(noise(xoff,yoff,zoff),0,1,HALF_PI-.3+joltFactor,HALF_PI+.3+joltFactor)+rotate+(PI*dirSwitch);
        // Make a vector from an angle
        field[i][j] = PVector.fromAngle(theta);
        yoff += 0.05+joltFactor;
      }
      xoff += 0.05+joltFactor;
    }
    // Animate by changing 3rd dimension of noise every frame
    zoff += 0.01+joltFactor;
  }

  // Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j],i*resolution,j*resolution,resolution-2);
      }
    }

  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to position to render vector
    translate(x,y);
    stroke(0,150);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].copy();
  }


}
