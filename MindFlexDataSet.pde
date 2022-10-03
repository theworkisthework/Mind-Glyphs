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
  IntList get(){
    IntList data = new IntList(this.delta, this.theta, this.lowAlpha, this.highAlpha, this.lowBeta, this.highBeta, this.lowGamma, this.midGamma, this.attLevel, this.medLevel); 
  return data;
  }

  // Return the same list as .get() but in a random order
  IntList rand(){
    IntList data = new IntList(this.delta, this.theta, this.lowAlpha, this.highAlpha, this.lowBeta, this.highBeta, this.lowGamma, this.midGamma, this.attLevel, this.medLevel);
    data.shuffle();
    return data;
  }
}
