public void poorSignalEvent(int sig) {
  //println("Signal level: " + sig);
  if (sig < 100){
  activeHeadset = true;} else {
  activeHeadset = false;}
}

public void attentionEvent(int attentionLevel) {
  //println("Attention Level: " + attentionLevel);
  gAttentionLevel = attentionLevel;
}


public void meditationEvent(int meditationLevel) {
  //println("Meditation Level: " + meditationLevel);
  gMeditationLevel = meditationLevel;
}

// This is triggered by the library whenever it gets some data from the headset
public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  //println("Delta: " + delta);
  //println("Theta: " + theta);
  //println("Low Alpha: " + low_alpha);
  //println("High Alpha: " + high_alpha);
  //println("Low Beta: " + low_beta);
  //println("High Beta: " + high_beta);
  //println("Low Gamma: " + low_gamma);
  //println("Mid Gamma: " + mid_gamma);

  // Only add data when the headset is being worn (i.e. when the signal level is below a chosen threshold
  
  // When this event is triggered, we create a new data set using our class
  MindFlexDataSet mindFlexDataSet = new MindFlexDataSet(delta, theta, low_alpha, high_alpha, low_beta, high_beta, low_gamma, mid_gamma, gAttentionLevel, gMeditationLevel);
  
  // Then we store that object in the array
  if (activeHeadset){
    if (readyToReceive) {
    mindFlexData.add(mindFlexDataSet);
    readyToReceive = false;
    previousCount++;
  }
}
   
} 
