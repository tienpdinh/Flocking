Camera cam;
ArrayList<Boid> crowd;
int agents;
float dt;
float boxSize;

// array of pillars
Pillar[] pillars;

void setup() {
  size(600, 600, P3D);
  agents = 100;
  boxSize = 700;
  dt = 1;
  cam = new Camera();
  crowd = new ArrayList<Boid>();
  for (int i = 0; i < agents; i++) {
    PVector randomPos = new PVector(random(-500, -450), random(-500, -450), random(-500, -450));
    PVector randomVel = new PVector(10, 10, 10);
    crowd.add(new Boid(randomPos, randomVel));
  }
  
  // set up the obstacles
  pillars = new Pillar[3];
  pillars[0] = new Pillar(new PVector(0, 0), 100, 150);
  pillars[1] = new Pillar(new PVector(200, 200), 50, 125);
  pillars[2] = new Pillar(new PVector(-200, -100), 70, 170);
}

void keyPressed()
{
  cam.HandleKeyPressed();
}

void keyReleased()
{
  cam.HandleKeyReleased();
}

void draw() {
  background(200);
  lights();
  noFill();
  stroke(255);
  box(boxSize);
  for (int i = 0; i < crowd.size(); i++) {
    crowd.get(i).flock(crowd, dt);
    crowd.get(i).avoidObstacles(pillars, dt);
    crowd.get(i).boundingBox(boxSize, boxSize, boxSize);
  }
  for (int i = 0; i < crowd.size(); i++) {
    crowd.get(i).update(dt);
    crowd.get(i).render(3.0f);
  }
  
  // render the pillars
  for (Pillar p : pillars)
    p.render();
  cam.Update( 1.0/frameRate );
}
