class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  
  float maxDesired;
  float maxSteer;
  
  float visibility;
  
  public Boid() {
    pos = new PVector(0, 0, 0);
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    maxDesired = 20;
    maxSteer = 15;
    visibility = 500;
  }
  
  public Boid(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    acc = new PVector(0, 0, 0);
    maxDesired = 10;
    maxSteer = 2;
    visibility = 500;
  }
  
  public Boid(PVector pos, PVector vel, float desired, float steer) {
    this.pos = pos;
    this.vel = vel;
    acc = new PVector(0, 0, 0);
    maxDesired = desired;
    maxSteer = steer;
  }
  
  public void flock(ArrayList<Boid> allBoids, float dt) {
    PVector align = new PVector(0,0,0);
    PVector cohes = new PVector(0,0,0);
    PVector separ = new PVector(0,0,0);
    int total = 0;
    for (Boid b : allBoids) {
      float dist = dist(this.pos.x, this.pos.y, this.pos.z, b.pos.x, b.pos.y, b.pos.z);
      if (b != this && dist < 200) {
        // alignment force
        align.add(b.vel);
        // cohesion force
        cohes.add(b.pos);
        // separation force
        PVector tmp = PVector.sub(this.pos, b.pos);
        tmp.div(dist);
        separ.add(tmp);
        total++;
      }
    }
    if (total != 0) {
      align.div(total);
      align.setMag(maxDesired*2);
      align.sub(vel);
      align.limit(maxSteer);
      
      cohes.div(total);
      cohes.sub(pos);
      cohes.setMag(maxDesired*0.8);
      cohes.sub(vel);
      cohes.limit(maxSteer);
      
      separ.div(total);
      separ.setMag(maxDesired*0.8);
      separ.sub(vel);
      separ.limit(maxSteer);
    }
    acc.add(PVector.mult(align, dt));
    acc.add(PVector.mult(cohes, dt));
    acc.add(PVector.mult(separ, dt));
  }
  
  public void avoidObstacles(Pillar[] pillars, float dt) {
    for (Pillar p : pillars) {
      p.pos.y = this.pos.y;
      PVector toPillar = PVector.sub(p.pos, this.pos);
      float distance = toPillar.mag();
      if (distance < visibility) {
        float dotProd = PVector.dot(toPillar, this.vel);
        if (dotProd > 0) {
          // the projected vector
          dotProd /= this.vel.mag();
          PVector normVel = this.vel.normalize(null);
          normVel.mult(dotProd);
          PVector steer = PVector.sub(normVel, toPillar);
          if (steer.mag() < p.r) {
            steer.div(distance);
          
            // now we steer away
            acc.add(PVector.mult(steer, dt*10));
          }
        }
      }
    }
  }
  
  public void update(float dt) {
    vel.add(PVector.mult(acc, dt));
    pos.add(PVector.mult(vel, dt));
    acc.mult(0);
  }
  
  public void boundingBox(float boxWidth, float boxHeight, float boxDepth) {
    if (this.pos.x > boxWidth / 2)
      this.pos.x = -boxWidth / 2;
    if (this.pos.x < -boxWidth / 2)
      this.pos.x = boxWidth / 2;
    if (this.pos.y > boxHeight / 2)
      this.pos.y = -boxHeight / 2;
    if (this.pos.y < -boxHeight / 2)
      this.pos.y = boxHeight / 2;
    if (this.pos.z > boxDepth / 2)
      this.pos.z = -boxDepth / 2;
    if (this.pos.z < -boxDepth / 2)
      this.pos.z = boxDepth / 2;
  }
  
  public void render(float r) {
    noStroke();
    fill(189, 10, 50);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(r);
    popMatrix();
  }
}
