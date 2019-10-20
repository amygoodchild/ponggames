/**

Flying Game
Amy Goodchild 2018

**/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


int floorHeight;
int maxJumpHeight;
int topOfRocket;
int normalTopOfRocket;
int rocketHeight = 100;
int rocketWidth = 150;
int rocketPosition = 60;

PImage rocketimage;
PImage planetimage;

boolean jumping = false;

int numberOfTerrainBlocks = 15;
int speed = 5;
int numberOfPlanets = 6;
int numberOfClouds = 4;

int minPlanetWidth = 80;
int maxPlanetWidth = 80;

int minPlanetHeight = 120;
int maxPlanetHeight = 120;

int minPlanetSpacing = 700;
int maxPlanetSpacing = 1200;

int animationCount;

boolean newGame = false;
int failMillis;
int seconds = 3;

int bestScore;
int score;

float jumpPercentage = .6;

Rocket rocket;
Terrain[] terrainTop;
Terrain[] terrainBottom;
Planet[] planets;

Minim minim;
AudioPlayer flying;
AudioPlayer jump;
AudioPlayer dead;

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
float totalBlobs;
float totalYellow;
float totalRed;
float percentage;
float lerpPercentage;
float lerpamount = 0.5;

int maxterrainheight = 190;
int minterrainheight = 80;

void setup(){
   size(1920, 1080);
   
   //fullScreen();
   background(255);  
   noStroke();
   
   rocketimage = loadImage("rocket.png");
   planetimage = loadImage("planet.png");
   minim = new Minim(this);
   flying = minim.loadFile("flying.mp3");
   flying.loop();
   dead = minim.loadFile("dead.mp3"); 
   
  
  
   rocket = new Rocket();

   terrainTop = new Terrain[numberOfTerrainBlocks];
   terrainBottom = new Terrain[numberOfTerrainBlocks];
   
   for (int i=0; i< numberOfTerrainBlocks; i++){
     float eachWidth = width/(numberOfTerrainBlocks-2);
     terrainTop[i] = new Terrain(i * eachWidth, random(minterrainheight,maxterrainheight), 0);   
     terrainBottom[i] = new Terrain(i*eachWidth, random(minterrainheight,maxterrainheight), 1);
   }

   planets = new Planet[numberOfPlanets];
   planets[0] = new Planet(width, random(maxterrainheight, height-maxterrainheight-50), numberOfPlanets-1 );   
  
   for (int i=1; i< numberOfPlanets; i++){
     planets[i] = new Planet(random(planets[i-1].x + minPlanetSpacing,planets[i-1].x + maxPlanetSpacing), random(maxterrainheight, height-maxterrainheight-50), i-1);   
   }
   
   // Initialise OSC connections/ports
   oscP5Receiver = new OscP5(this,6449);
   dest = new NetAddress("127.0.0.1",6448);
   

}

void draw(){
  
  if (newGame == false){
    background(255);


    
    for (int i=0; i< numberOfTerrainBlocks; i++){
      terrainTop[i].move();
      terrainTop[i].collision();
      terrainTop[i].display();
      terrainBottom[i].move();
      terrainBottom[i].collision();
      terrainBottom[i].display();
     }
     

    for (int i=0; i< numberOfPlanets; i++){
      planets[i].move();
      planets[i].collision();
      planets[i].display();
     }
     
     
     
     rocket.display();
     
     
     fill(200,200,200,150);
     rect(width-430, 0, 430, 170);
     textSize(45);
     fill(0);
     textAlign(RIGHT);
     
     text("Current score: " + score, width-40, 60);
     text("High Score: " + bestScore, width-40, 130);
     
     

  }
  
  else{ 
    newGame();    
  }
  

  
}

void keyPressed(){
  if (!newGame){
   if (key == 'k') {
     rocket.move(0);
   }
   if (key =='m'){
     rocket.move(1);
   }
  }
    
}

void newGame(){
   fill(200);
   rect(width/2 - 200, height/2 - 100, 400, 200);
   fill(30);
   textSize(50);
   textAlign(CENTER);
   text("GAME OVER",width/2, height/2);
   textSize(40);
   text("Try again... " + seconds, width/2, height/2 + 50);
   
   if (millis() > failMillis + 1000){
     seconds = 2; 
   }
   
   if (millis() > failMillis + 2000){
     seconds = 1; 
   }   
   

   if (millis() > failMillis + 3000){
     seconds = 3;
     newGame = false;
     score = 0;
     planets[0].x = random(width,width+100);  
     rocket.y = height/2;
     flying.loop();
     for (int i=1; i< numberOfPlanets; i++){
       planets[i].x = random(planets[i-1].x + minPlanetSpacing,planets[i-1].x + maxPlanetSpacing);   
     }
   }
   
   rocket.display();
  
}

void oscEvent(OscMessage theOscMessage) {
 
  if (theOscMessage.checkAddrPattern("/direction") == true) {

    leftBlobs = theOscMessage.get(0).intValue();
    rightBlobs = theOscMessage.get(1).intValue();
    leftYellow = theOscMessage.get(2).intValue();
    leftRed = theOscMessage.get(3).intValue();
    rightYellow = theOscMessage.get(4).intValue();
    rightRed = theOscMessage.get(5).intValue();
    
    
    
    totalBlobs = rightBlobs + leftBlobs;
    totalYellow = rightYellow + leftYellow;
    totalRed = rightRed + leftRed;
    
    if (totalBlobs != 0){
      percentage = totalRed / totalBlobs;
      print("yellow: " + totalYellow);
      print(" total: " + totalBlobs);
      println(" percentage: " + percentage);
      lerpPercentage = lerp(percentage, lerpPercentage, lerpamount);
    }
    else{
      percentage = 0;
    }
    
    rocket.position();
    
  } 
}