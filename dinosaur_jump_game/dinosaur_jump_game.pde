/**

Dinosaur Jump Game
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
int topOfDinosaur;
int normalTopOfDinosaur;
int dinosaurHeight = 167;
int dinosaurWidth = 245;
int dinosaurPosition = 60;

PImage dinoStill;
PImage dinoJump;
PImage dinoRun1;
PImage dinoRun2;
PImage dinoDead;

PImage mouse;

PImage cloud1;
PImage cloud2;
PImage cloud3;
PImage cloud4;



boolean jumping = false;

int numberOfTerrainBlocks = 3;
int speed = 7;
int numberOfTrees = 6;
int numberOfClouds = 4;

int minTreeWidth = 80;
int maxTreeWidth = 80;

int minTreeHeight = 120;
int maxTreeHeight = 120;

int minTreeSpacing = 700;
int maxTreeSpacing = 1200;

int animationCount;

float gravity = 0.8;
float jumpVelocity = -30;

boolean newGame = false;
int failMillis;
int seconds = 3;

int bestScore;
int score;

float jumpPercentage = .6;

Dinosaur dino;
Terrain[] terrain;
Tree[] trees;
Cloud[] clouds;

Minim minim;
AudioPlayer running;
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
int totalBlobs;
int totalYellow;
int totalRed;
float percentage;


void setup(){
   size(1920,1080);
   
   //fullScreen();
   background(255);  
   noStroke();
   
   dinoStill = loadImage("dino_still.png");
   dinoJump = loadImage("dino_jump.png");
   dinoRun1 = loadImage("dino_run1.png");
   dinoRun2 = loadImage("dino_run2.png");
   dinoDead = loadImage("dino_dead.png");
   
   mouse = loadImage("mouse1.png");
   
   cloud1 = loadImage("cloud1.png");
   cloud2 = loadImage("cloud2.png");
   cloud3 = loadImage("cloud3.png");
   cloud4 = loadImage("cloud4.png");
   
   minim = new Minim(this);
   running = minim.loadFile("running.wav");
   running.loop();
   
   jump = minim.loadFile("jump.wav");   
   dead = minim.loadFile("dead.wav");
   
   floorHeight = height -150;
   topOfDinosaur = floorHeight - dinosaurHeight;
   maxJumpHeight = floorHeight - 300;

   dino = new Dinosaur();

   terrain = new Terrain[numberOfTerrainBlocks];
   
   for (int i=0; i< numberOfTerrainBlocks; i++){
     float eachWidth = width/(numberOfTerrainBlocks-1);
     terrain[i] = new Terrain(i * eachWidth, int(random(8,15)));   
     println("i: " + i + " width: " + i*eachWidth);
   }
   
   trees = new Tree[numberOfTrees];
   trees[0] = new Tree(width, random(minTreeWidth,maxTreeWidth), random(minTreeHeight,maxTreeHeight), numberOfTrees-1 );   
  
   for (int i=1; i< numberOfTrees; i++){
     trees[i] = new Tree(random(trees[i-1].x + minTreeSpacing,trees[i-1].x + maxTreeSpacing), random(minTreeWidth,maxTreeWidth), random(minTreeHeight,maxTreeHeight), i-1);   
   }
   
   clouds = new Cloud[numberOfClouds];
   for (int i=0; i< numberOfClouds; i++){
     
     clouds[i] = new Cloud( int(random(0, width+300)), int(random(0, height-300)), int(random(100,200)), int(random(1,4)), int(random(1,3)));
   }
   
   // Initialise OSC connections/ports
   oscP5Receiver = new OscP5(this,6449);
   dest = new NetAddress("127.0.0.1",6448);
   

}

void draw(){
  
  if (newGame == false){
    background(255);
   /* fill(205,211,246);
    noStroke();
    rect(0,0, width, height - 60);
    fill(215,256,221);
    rect(0,height-60, width, 60);
    */
    if (jumping == true){
      dino.jump();
    }
    
   
    
    for (int i=0; i< numberOfTerrainBlocks; i++){
      terrain[i].move();
      terrain[i].display(i);
     }
     
    for (int i=0; i< numberOfClouds; i++){
      clouds[i].move();
      clouds[i].display();
     }
     
    for (int i=0; i< numberOfTrees; i++){
      trees[i].move();
      trees[i].collision();
      trees[i].display();
     }
     
     dino.display();
     
     textSize(45);
     fill(0);
     textAlign(LEFT);
     text("Current score: " + score, 40, 60);
     text("High Score: " + bestScore, 40, 130);
     
     textAlign(RIGHT);
     fill(255,240,0);
     stroke(0);
     rect(width-260,30, 50,60);
     fill(0);
     text(" = JUMP", width-40, 70);
     
  }
  
  else{    
    newGame();    
  }
  

  
}

void keyPressed(){
  if (!jumping && !newGame){
   if (key == 'j') {
     jumping = true;
     dino.yVel = jumpVelocity;
     jump.play();
     jump.rewind();
     running.pause();
     running = minim.loadFile("running.wav");
     
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
     trees[0].x = random(width,width+100);   
    
     for (int i=1; i< numberOfTrees; i++){
       trees[i].x = random(trees[i-1].x + minTreeSpacing,trees[i-1].x + maxTreeSpacing);   
     }
   }
   
   dino.display();
  
}

void oscEvent(OscMessage theOscMessage) {
  
  if (theOscMessage.checkAddrPattern("/direction") == true) {

   leftBlobs = theOscMessage.get(0).intValue();
    rightBlobs = theOscMessage.get(1).intValue();
    leftYellow = theOscMessage.get(2).intValue();
    leftRed = theOscMessage.get(3).intValue();
    rightYellow = theOscMessage.get(4).intValue();
    rightRed = theOscMessage.get(5).intValue();
    
    println(leftYellow);
    
    totalBlobs = rightBlobs + leftBlobs;
    totalYellow = rightYellow + leftYellow;
    totalRed = rightRed + leftRed;
    
    if (totalBlobs != 0){
      percentage = totalYellow / totalBlobs;
    }
    else{
      percentage = 0;
    }
    println(totalYellow);
  
    if (percentage > jumpPercentage) {
      if (!jumping && !newGame){
        jumping = true;
        dino.yVel = jumpVelocity;
        jump.play();
        jump.rewind();
        running.pause();
        running = minim.loadFile("running.wav"); 
      }  
    }   
  } 
}