ArrayList<PVector> points;
ArrayList<PVector> hull;
boolean showAngles = false;
PVector h1;
PVector h2;
PVector h3;

void setup() {
  size(600, 600);
  points = new ArrayList();
  hull = new ArrayList();
  h1 = new PVector();
  h2 = new PVector();
  h3 = new PVector();
  addPoints();
  smooth();

  // sort the points "lexically", i.e.
  // by x from left to right and
  // by y if they have the same x
  // see the LexicalComparison class
  // for the implementation of the sort.
  Collections.sort(points, new LexicalComparison());

  // add the first two points to the hull
  hull.add(points.get(0));
  hull.add(points.get(1));
}

// calculate some random points for which we'll find the hull
void addPoints() {
  int pointsToAdd = int(random(10, 50));
  for (int i = 0; i < pointsToAdd; i++) {
    points.add(new PVector(random(50, width - 50), random(50, height - 50)));
  }
}

void drawPoints() {
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    ellipse(p.x, p.y, 5, 5);
  }
}

void drawSortLabels() {
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    pushMatrix();
    translate(p.x + 2, p.y + 2);
    scale(0.8);
    fill(125);
    text(i, 0, 0);
    popMatrix();
  }
}


// use the cross product to determin if we have a right turn
boolean isRightTurn(PVector a, PVector b, PVector c) {
  return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) >= 0;
}

void drawHull() {
  stroke(255, 0, 0);
  for (int i = 1; i < hull.size(); i++) {
    PVector p1 = hull.get(i);
    PVector p2 = hull.get(i-1);
    line(p1.x, p1.y, p2.x, p2.y);
  }
}

void draw() {
  background(255);
  fill(125);
  text(points.size() + " points", 5, 15);
  text("Hit [spacebar] to iterate through the points", 5, 35);

  drawSortLabels();

  fill(0);
  drawHull();

  noStroke();
  drawPoints();

  // draw the current three points under consideration
  stroke(0);
  ellipse(h1.x, h1.y, 5, 5);
  line(h1.x, h1.y, h2.x, h2.y);
  ellipse(h2.x, h2.y, 5, 5);
  line(h3.x, h3.y, h2.x, h2.y);
  ellipse(h3.x, h3.y, 5, 5);
}

int currentPoint = 2;


int direction = 1;

PVector copyOf(PVector p){
  return new PVector(p.x, p.y);
}

void addPoint() {

  // add the next point
  hull.add(points.get(currentPoint));

  // look at the turn direction in the last three points
  // (we have to work with copies of the points because Java)
  h1 = copyOf(hull.get(hull.size() - 3));
  h2 = copyOf(hull.get(hull.size() - 2));
  h3 = copyOf(hull.get(hull.size() - 1));

  // while there are more than two points in the hull
  // and the last three points do not make a right turn
  while (!isRightTurn (h1, h2, h3) && hull.size() > 2) {
    // remove the middle of the last three points
    hull.remove(hull.size() - 2);
    
    // refresh our copies because Java
    if (hull.size() >= 3) {
      h1 = copyOf(hull.get(hull.size() - 3));
    }
    h2 = copyOf(hull.get(hull.size() - 2));
    h3 = copyOf(hull.get(hull.size() - 1));
  } 

  println("currentPoint: " + currentPoint + " numPoints: " + points.size() + " hullSize: " + hull.size() + " direction " + direction);
  
  // going through left-to-right calculates the top hull
  // when we get to the end, we reverse direction
  // and go back again right-to-left to calculate the bottom hull
  if (currentPoint == points.size() -1 || currentPoint == 0) {
    direction = direction * -1;
  }

  currentPoint+= direction;
}


void keyPressed() {
  addPoint();
}

