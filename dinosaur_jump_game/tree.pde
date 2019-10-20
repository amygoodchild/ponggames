

class Tree{
  
  float x, y, h, w;
  int comparisonTree;
  
  
  Tree(float x_, float w_, float h_, int comparisonTree_){
    x = x_;
    y = floorHeight - h_+3;
    w = w_;
    h = h_;
    comparisonTree = comparisonTree_;
    
  
  }
  
  void move(){
   x -= speed;
   
   if (x < 0 -w-20){
     
     x = random(trees[comparisonTree].x + minTreeSpacing,trees[comparisonTree].x + maxTreeSpacing);
     w = random(minTreeWidth,maxTreeWidth);
     h = random(minTreeHeight,maxTreeHeight);
     y = floorHeight - h+3;
     
     score++;
   }
  }
   
  void display(){
     
  
     image(mouse, x, y);
  
   
  
 }
 
 void collision(){
 
  
   
    if (dino.x + dino.w -15 > x && dino.x + dino.w < x + w - 15 && dino.y + dino.h > y + 15){
      newGame = true;
      dead.play();
      dead.rewind();
      running.pause();
      running = minim.loadFile("running.wav");
      failMillis = millis();
      if (bestScore< score){
        bestScore = score;
      }
      
    }
    
    if (dino.x > x + 15 && dino.x < x + w -15 && dino.y + dino.h > y + 15){
      newGame = true;
      dead.play();
      dead.rewind();
      running.pause();
     running = minim.loadFile("running.wav");
      failMillis = millis();
      if (bestScore< score){
        bestScore = score;
      }
    }
    
 }
  
  
}