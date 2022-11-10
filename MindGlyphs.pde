
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;

Serial serialPort;
String serialPortId = "COM6";

ArrayList<MindFlexDataSet> mindFlexData = new ArrayList<MindFlexDataSet>();  // This is the array list that stores each data point read from the MindFlex headset. It has a .get() method that returns an array of the data points

int cols = 15;  // How many cols across the page
int rows = 25;  // How many rows down the page

float circleSize = 5;  // This is the overall size of each glyph
float randomOffSet = 0;  // Does nothing now

// Calculated variables
int colSpacing;
int rowSpacing;
// Event updated variables
int gMeditationLevel;
int gAttentionLevel;

boolean activeHeadset = false;
boolean readyToReceive = false;
int previousCount = 0;

float feed = 1000;

// A0 = 841, 1188
// A1 = 594, 841
// A2 = 420, 594
// A3 = 297, 420
// A4 = 210, 297

PrintWriter gcodeFile;

void setup() {
  size(290, 420);  
  gcodeFile = createWriter("mind-glyphs.gcode");
  mindSet = new MindSet(this, "COM11");
  senderInit("G10 L2 P2 X-140 Y-550 Z5", true);
  //senderInit("", true);
  // FluidNC wallbot A2 offset "G10 L2 P1 X? Y? Z?" Note: This plots from bottom up ?!?!
  sender("G0 Z5");  // Lift pen
  sender("G55 X0 Y0 F1500");  // Go to home for G55 work offset (defined by L2)
  // TODO: Slow down data collection so we are keeping up with the plotter. Can we know when a plot event has completed?
  // Setup the page
  frameRate(1);
  background(255);
  noFill();
  stroke(150);
   
  
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
  if (frameCount % 1 == 0){
    println("Check every 10 secs");
    println("We have " + mindFlexData.size() + " mindflex data points");
    readyToReceive = true;
    //println("Previous count = " + previousCount + " number of items = " + mindFlexData.size() + "");
    while (previousCount != mindFlexData.size()){
      //println("Waiting for new mindFlex data...");
    }
    

  // Don't draw anything until we have some data
  if ((mindFlexData.size()>0) && (activeHeadset)){ 
    
    // Now loop over the array that we have and draw circles for each point
    while (currentIndex<mindFlexData.size()){
      int x = currentIndex % cols; // Work out what x would be for the current index
      int y = currentIndex / cols; // Work out what y would be for the current index
      //println("i="+i+" x="+x+" y="+y);
      
      drawGlyph(x*colSpacing+(colSpacing/2), y*rowSpacing + (rowSpacing/2), mindFlexData.get(currentIndex).rand());  // Draw a circle for the current x,y cooridinates
      plotGlyph(x*colSpacing+(colSpacing/2), y*rowSpacing + (rowSpacing/2), mindFlexData.get(currentIndex).rand());
      // Test plotting by faking the data for a mindflex headset
      //plotGlyph(x*colSpacing+(colSpacing/2), y*rowSpacing + (rowSpacing/2), mindFlexData.get(currentIndex).rand());
      currentIndex++;
    }
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

void keyPressed() {
  gcodeFile.flush(); // Writes the remaining data to the file
  gcodeFile.close(); // Finishes the file
  exit(); // Stops the program
}
