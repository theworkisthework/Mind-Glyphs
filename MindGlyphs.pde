
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;

Serial serialPort;
String serialPortId = "COM11";

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

boolean activeHeadset = false;
float feed = 2500;

void setup() {
  //restartMindSet();
  // See if we have the com port we expect
  //checkSerialPort();
  mindSet = new MindSet(this, "COM11");
  senderInit("G10 P0 L20 X0 Y0 Z0", true);
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

int currentIndex = 0;

void draw() {
  //clear();
  //background(255);
  //println(mindFlexData);
  // Every 10 seconds (10 frames @ 1 frame/sec) check to see if we have received any data from the mindset
  // If not try to re-initialize it
  //if (frameCount % 10 == 0){
  //  println("Check every 10 secs");
  //  //restartMindSet();
  //  // Can't re-init mindset because the port is busy?
  //  // Can't detect if the port is busy...
  //}
  
  // Don't draw anything until we have some data
  println(mindFlexData.size());
  println(activeHeadset);
  if ((mindFlexData.size()>0) && (activeHeadset)){ 
    
    // Now loop over the array that we have and draw circles for each point
    while (currentIndex<mindFlexData.size()){
      int x = currentIndex % cols; // Work out what x would be for the current index
      int y = currentIndex / cols; // Work out what y would be for the current index
      //println("i="+i+" x="+x+" y="+y);
      drawGlyph(x*colSpacing+(colSpacing/2), y*rowSpacing + (rowSpacing/2), mindFlexData.get(currentIndex).rand());  // Draw a circle for the current x,y cooridinates
      plotGlyph(x*colSpacing+(colSpacing/2), y*rowSpacing + (rowSpacing/2), mindFlexData.get(currentIndex).rand());
      currentIndex++;
    }
  } 
}

//public void restartMindSet() {
//  //checkSerialPort();
//  mindSet = new MindSet(this, serialPortId);
//}
void exit() {
  // Close the com port when we exit
  println("Exiting");
  mindSet.quit();
  super.exit();
}
