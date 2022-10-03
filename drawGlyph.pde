public void drawGlyph(int x, int y, IntList data){
  // Plot our data points around a centre point (x,y)
  // Use a data array to move the points of the circle around
  // There will always be n points that make up the cirle that correspond to the number of data items we get back from mindflex
  int dataPoints = data.size(); // The number of points around the circle will be the same as the number of data items
  float angle = 0;  // Our start angle
  float angleStep = TWO_PI/dataPoints;  // The step angle (each segment is this many degrees)
  
  // Start drawing our shape
  beginShape();
  float rx = circleSize * sin(0);
  float ry = circleSize * cos(0);
  // Loop and add points - We affect the radius of the circle for each bit of data
  //vertex(rx + x, ry + y);
  vertex(rx + x, ry + y);
  for (int i=0; i<dataPoints; i++){
    rx = circleSize * sin(angle);
    ry = circleSize * cos(angle);
    vertex(rx + x + constrain(data.get(i)/1000, 0, circleSize), ry + y + constrain(data.get(i)/1000, 0, circleSize));
    angle = angle + angleStep;
  }

  // Close the circle (The above only gives us points around the centre for n points, but does not comple the circle so we have to do that here)
  rx = circleSize * sin(0);
  ry = circleSize * cos(0);
  vertex(rx + x, ry + y);
  //vertex(rx + x, ry + y);
  endShape(CLOSE);
}
