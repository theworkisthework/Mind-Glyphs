
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;

ArrayList<MindFlexDataSet> mindFlexData = new ArrayList<MindFlexDataSet>();  // This is the array list that stores each data point read from the MindFlex headset. It has a .get() method that returns an array of the data points

int cols = 25;  // How many cols across the page
int rows = 25;  // How many rows down the page

float circleSize = 10;  // This is the overall size of each glyph
float randomOffSet = 0;  // Does nothing now

// Calculated variables
int colSpacing;
int rowSpacing;
// Event updated variables
int gMeditationLevel;
int gAttentionLevel;


void setup() {
  // Connect to the headset on the specified com port
  mindSet = new MindSet(this, "COM11");
  
  // Setup the page
  frameRate(1);
  background(255);
  noFill();
  stroke(150);
  size(1280, 891);
  
  // Calculate the row and column spacing for the given screen size and number of rows and cols
  colSpacing = width/cols;
  rowSpacing = height/rows;
  println("col count:" + cols + " col spacing:" + colSpacing);
  println("row count:" + rows + " row spacing:" + rowSpacing); 
}


void draw() {
  clear();
  background(255);
  
  // Don't draw anything until we have some data
  if (mindFlexData.size()>0){ 
    
    // Now loop over the array that we have and draw circles for each point
    for (int i=0; i<mindFlexData.size(); i++){
      int x = i % cols; // Work out what x would be for the current index
      int y = i / cols; // Work out what y would be for the current index
      //println("i="+i+" x="+x+" y="+y);
      drawGlyph(x*colSpacing+(colSpacing/2), y*rowSpacing + (rowSpacing/2), mindFlexData.get(i).rand());  // Draw a circle for the current x,y cooridinates
    }
  }
  
  // Clear the data so the array starts again (There is a weird bug here - the array seems to be 31 items long but that only clears half of it?)
  //if (mindFlexData.size() > (cols * rows)) {
  //  println("Maxed out, clearing array");
  //  int size = mindFlexData.size();
  //  for(int i=0; i<size; i++){
  //    println(i);
  //    mindFlexData.remove(i);
  //  }
  //}
  
}


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
  curveVertex(rx + x, ry + y);
  curveVertex(rx + x, ry + y);
  for (int i=0; i<dataPoints; i++){
    rx = circleSize * sin(angle);
    ry = circleSize * cos(angle);
    curveVertex(rx + x + constrain(data.get(i)/1000, 0, circleSize), ry + y + constrain(data.get(i)/1000, 0, circleSize));
    angle = angle + angleStep;
  }

  // Close the circle (The above only gives us points around the centre for n points, but does not comple the circle so we have to do that here)
  rx = circleSize * sin(0);
  ry = circleSize * cos(0);
  curveVertex(rx + x, ry + y);
  curveVertex(rx + x, ry + y);
  endShape(CLOSE);
}


void exit() {
  // Close the com port when we exit
  println("Exiting");
  mindSet.quit();
  super.exit();
}


//public void poorSignalEvent(int sig) {
//  println("Signal level: " + sig);
//}

public void attentionEvent(int attentionLevel) {
  //println("Attention Level: " + attentionLevel);
  gAttentionLevel = attentionLevel;
}


public void meditationEvent(int meditationLevel) {
  //println("Meditation Level: " + meditationLevel);
  gMeditationLevel = meditationLevel;
}

// This is our data object that stores all the data we get from the headset
class MindFlexDataSet {
  int delta, theta, lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, midGamma, attLevel, medLevel;
  
  MindFlexDataSet(int d, int t, int la, int ha, int lb, int hb, int lg, int mg, int at, int med){
    this.delta = d;
    this.theta = t;
    this.lowAlpha = la;
    this.highAlpha = ha;
    this.lowBeta = lb;
    this.highBeta = hb;
    this.lowGamma = lg;
    this.midGamma = mg;
    this.attLevel = at;
    this.medLevel = med;
  }
  
  // Return the data as an array - we could order the data in this array randomly to get around the slant that glyphs seem to share.
  int[] get(){
    int[] data = {this.delta, this.theta, this.lowAlpha, this.highAlpha, this.lowBeta, this.highBeta, this.lowGamma, this.midGamma, this.attLevel, this.medLevel}; 
  return data;
  }

  // Return the same list as .get() but in a random order
  IntList rand(){
    IntList data = new IntList(this.delta, this.theta, this.lowAlpha, this.highAlpha, this.lowBeta, this.highBeta, this.lowGamma, this.midGamma, this.attLevel, this.medLevel);
    data.shuffle();
    return data;
  }
}

// This is triggered by the library whenever it gets some data from the headset
public void eegEvent(int delta, int theta, int low_alpha, 
int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  //println("Delta: " + delta);
  //println("Theta: " + theta);
  //println("Low Alpha: " + low_alpha);
  //println("High Alpha: " + high_alpha);
  //println("Low Beta: " + low_beta);
  //println("High Beta: " + high_beta);
  //println("Low Gamma: " + low_gamma);
  //println("Mid Gamma: " + mid_gamma);

  // When this event is triggered, we create a new data set using our class
  MindFlexDataSet mindFlexDataSet = new MindFlexDataSet(delta, theta, low_alpha, high_alpha, low_beta, high_beta, low_gamma, mid_gamma, gAttentionLevel, gMeditationLevel);
  
  // Then we store that object in the array
  mindFlexData.add(mindFlexDataSet); 
} 
