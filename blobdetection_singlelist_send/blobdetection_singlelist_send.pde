/*****
 
 This code takes a video feed, and looks for blobs of specified colours.
 It sends information about those blobs over OSC.
 
 Amy Goodchild 2018
 
*****/

// OSC libraries
import oscP5.*;
import netP5.*;

NetAddress dest;

OscP5 oscP5;
OscMessage msg;

import processing.video.*;

Capture video;

color trackColorRed;
color trackColorYellow;

int game = 0;


// These thresholds can be adjusted to suit the lighting conditions etc
float threshold = 40;
float distThreshold = 80;

// The camera feed is split into left and right, to create two teams. 
// These variables are created to store the number of yellow/red blobs in each side.
int leftRed;
int leftYellow;
int rightYellow;
int rightRed;
int leftBlobs;
int rightBlobs;

ArrayList<Blob> blobs = new ArrayList<Blob>();

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.awt.event.InputEvent;

Robot robot;
int delayTime = 2;

void setup() {
  //size(1920,1080);
  size(1200, 800);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  
  // Set the RGB values of the cards/paddles or whatever you're using here. 
  trackColorYellow = color(223,249,22);
  trackColorRed = color(211, 72, 46);
  
  //Let's get a Robot...
  try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
  
  // Set up OSC connection
  oscP5 = new OscP5(this,8000);
  dest = new NetAddress("127.0.0.1",6449);
 
 
}

void captureEvent(Capture video){
  video.read();
}

void draw() {
  background(0);
  video.loadPixels(); 
  scale(2);
  image(video, 0,0);
  scale(0.5); 
  stroke(255);
  strokeWeight(2);
  line(width/2, 0, width/2, height);
  
 
  blobs.clear();
  
  detectBlobs();
  countBlobs();

  sendOsc();
 
  scale(2);
  for (int i = 0; i < blobs.size(); i++) {
     blobs.get(i).showGrid();
  } 
  scale(0.5);
  

  textSize(16);
  fill(0);
  noStroke();
  //rect(0,480,640,130);
  
  fill(255);
  
  // rect(minx, miny, maxx, maxy);
  //text("left red: " + leftRed, 30, 510);
  //text("left yellow: " + leftYellow, 30, 530);
  // text("right red: " + rightRed, 30, 560);
  // text("right yellow: " + rightYellow, 30, 580);
}

void sendOsc(){
  msg = new OscMessage("/direction");
  msg.add(leftBlobs);
  msg.add(rightBlobs);  
  msg.add(leftYellow);  
  msg.add(leftRed);  
  msg.add(rightYellow);  
  msg.add(rightRed);  
  oscP5.send(msg, dest); 
}

void countBlobs(){ 
  leftRed = 0;
  leftYellow= 0;
  rightRed = 0;
  rightYellow =0;
  leftBlobs = 0;
  rightBlobs = 0;
  for (int i = 0; i < blobs.size(); i++) {
     if (blobs.get(i).whichSide == 0){
       leftBlobs++;
       if (blobs.get(i).whichColor == 0){ 
         leftRed++;    
       }
       if (blobs.get(i).whichColor == 1){ 
         leftYellow++;    
       }
     }
     
     if (blobs.get(i).whichSide == 1){
       rightBlobs++;
       if (blobs.get(i).whichColor == 0){ 
         rightRed++;    
       }
       if (blobs.get(i).whichColor == 1){ 
         rightYellow++;    
       }
     }
  } 
  
  
}

void detectBlobs(){  
  
  // Goes through each pixel, row by row.
  for (int x = 0; x< video.width; x++){
    for (int y = 0; y < video.height; y++){
      int loc = x + y * video.width;
      
      
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      
      float r2 = red(trackColorRed);
      float g2 = green(trackColorRed);
      float b2 = blue(trackColorRed);
      
      float r3 = red(trackColorYellow);
      float g3 = green(trackColorYellow);
      float b3 = blue(trackColorYellow);
      
      // Checks how close (in colour space) this pixel's colour is to the tracked colours.
      float d2 = distSq(r1, g1, b1, r2, g2, b2);
      float d3 = distSq(r1, g1, b1, r3, g3, b3);
      
      // If the pixel is close (in colour space) to a tracked colour
      if (d2 < threshold * threshold){
        
        // Then go through all the existing blobs and see if this pixels is close (in physical space)
        // to an existing blob. 
        boolean found = false;
        for (Blob b : blobs){
          if (b.isNear(x,y)){
            // If it's close to an existing blob, just add this pixel to the blob.
            b.add(x,y);
            found = true; 
            break;
          }
        }
        
        // If the pixel isn't close to an existing blob..
        if(!found){
          int theSide;
          // Figure out which side of the camera feed this pixel is on
          if (x<video.width/2){theSide = 0;} else {theSide = 1;}
          int theColor = 0;
          
          // Create a new blob with this pixel 
          Blob b = new Blob(x,y, theColor, theSide);
          blobs.add(b);
        }
      }
      
      // Same as above, but for the second tracked colour
      if (d3 < threshold * threshold){
        boolean found = false;
        for (Blob b : blobs){
          if (b.isNear(x,y)){
            b.add(x,y);
            found = true; 
            break;
          }
        }
        
        if(!found){
          int theSide;
          if (x<video.width/2){theSide = 0;} else {theSide = 1;}
          int theColor = 1;
          Blob b = new Blob(x,y, theColor, theSide);
          blobs.add(b);
        }
      }
      
      
           
    } 
  }
}


float distSq(float x1, float y1, float x2, float y2){
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
  
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2){
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1);
  return d;
  
}


// Use this for colour calibration when you are setting up.
// Hold up one of the coloured paddles to the camera feed and then click on it in the sketch
// This will print out the RGB values. You can then insert these into the code above. 
void mousePressed(){
   int loc = mouseX + mouseY * video.width;
     
   color clickColor = video.pixels[loc];
   
   print("red: " + red(clickColor));
   print(" green: " + green(clickColor));
   println(" blue: " + blue(clickColor));
   
   
}
