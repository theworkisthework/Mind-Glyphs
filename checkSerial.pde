public void checkSerialPort(){
  // Connect to the headset on the specified com port
  // Wait until the specified com port is available
  // Then create the mindflex object.
  // How do we then check we are still connected or handle disconnects?
  boolean havePort = false;
  println("!");
  while(!havePort){
    for (String port: Serial.list()){
      if (port.equals(serialPortId)){
        println("Matched port");
        havePort = true;
      }
    }    
  }
}
