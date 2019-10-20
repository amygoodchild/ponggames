/**

Pong Game
This code receives info over OSC about how many paddles of each colour are being held up from each team, and uses them to control a game of pong. 
Amy Goodchild 2018

**/


// Pong Game Variables
Ball ball;
Paddle leftPaddle;
Paddle rightPaddle;

int leftScore;
int rightScore;
int currentRally;
int bestRally;

int speed = 5;
int edgeGap = 60;

// Osc libraries
import oscP5.*;
import netP5.*;

// Set up different OSC connections for the various communications
OscP5 oscP5Receiver;
NetAddress dest;

int leftRed;
int leftYellow;
int rightYellow;
int rightRed;
int leftBlobs;
int rightBlobs;
float percentage;

import processing.sound.*;
SoundFile beep1;
SoundFile beep2;


void setup(){
  size(1920, 1080);
  //fullScreen();
  
  background(0);  
  noStroke();
   
  leftPaddle = new Paddle(30);
  rightPaddle = new Paddle(width-60);
  ball = new Ball();
   
  // Initialise OSC connections/ports
  oscP5Receiver = new OscP5(this,6449);
  dest = new NetAddress("127.0.0.1",6448);
  
  beep1 = new SoundFile(this, "beep1.wav");
  beep2 = new SoundFile(this, "beep2.wav");
}

void draw(){
  background(0);
  ball.move();
  ball.off();
  ball.hitPaddle();
  ball.display();
  
  leftPaddle.display();
  rightPaddle.display();
  
  textSize(30);
  fill(100);
  noStroke();
  rect(0,0,width,80);
  
  fill(255);
  
 // rect(minx, miny, maxx, maxy);
  text("Score: " + leftScore, 30, 50);
  text("Score: " + rightScore, width-160, 50);
  
  textSize(20);
  
  text("Current Rally: " + currentRally, width/2-50, 40);
  text("Best Rally: " + bestRally, width/2-50, 60);
  
}

void keyPressed(){
  
   if (key == 's') {
     leftPaddle.move(true); 
   }
   if (key == 'x') {
     leftPaddle.move(false); 
   }   
   
   if (key == 'k') {
     rightPaddle.move(true); 
   }
   if (key == 'm') {
     rightPaddle.move(false); 
   }    
   
}

void oscEvent(OscMessage theOscMessage) {
  
  if (theOscMessage.checkAddrPattern("/direction") == true) {

      leftBlobs = theOscMessage.get(0).intValue();
      rightBlobs = theOscMessage.get(1).intValue();
      leftYellow = theOscMessage.get(2).intValue();
      leftRed = theOscMessage.get(3).intValue();
      rightYellow = theOscMessage.get(4).intValue();
      rightRed = theOscMessage.get(5).intValue();
      
     
      if (rightYellow > rightRed) {
       percentage = rightYellow / rightBlobs;
       leftPaddle.move(false); 
     }
     if (rightYellow < rightRed) {
       percentage = rightRed / rightBlobs;
       leftPaddle.move(true); 
     }   
     
    if (leftYellow > leftRed) {
       percentage = leftYellow / leftBlobs;
       rightPaddle.move(false); 
     }
     if (leftYellow < leftRed) {
       percentage = leftRed / leftBlobs;
       rightPaddle.move(true); 
     } 
     
      
  }
 
}
