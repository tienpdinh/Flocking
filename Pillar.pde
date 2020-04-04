class Pillar {
  PVector pos;
  float r;
  int res;
  PVector[][] coords;
  float col;
  
  public Pillar(PVector pos, float r, float col) {
    this.pos = new PVector(pos.x, 0, pos.y);
    this.r = r;
    res = 20;
    coords = new PVector[res+1][res+1];
    calcCoords();
    this.col = col;
  }
  
  public void calcCoords() {
    for (int i = 0; i <= res; i++) {
      float y = map(i, 0, res, -boxSize/2, boxSize/2);
      for (int j = 0; j <= res; j++) {
        float theta = map(j, 0, res, 0, 2*PI);
        float x = r * cos(theta) + pos.x;
        float z = r * sin(theta) + pos.z;
        coords[i][j] = new PVector(x, y, z);
      }
    }
  }
  
  public void render() {
    noStroke();
    fill(col);
    for (int i = 0; i < res; i++) {
      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j <= res; j++) {
        PVector v1 = coords[i][j];
        PVector v2 = coords[i+1][j];
        vertex(v1.x, v1.y, v1.z);
        vertex(v2.x, v2.y, v2.z);
      }
      endShape();
    }
  }
}
