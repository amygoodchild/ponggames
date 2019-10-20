
class Terrain{
  
 float w;
 float h;
 float x;
 float y;
 int side;

 
 Terrain(float x_, float h_, int side_){
   w = width/(numberOfTerrainBlocks-1)+15;
   h = h_;
   
   x = x_;
   side = side_;
   
   if (side == 0){
     y = 0;
   }
   else{
     y = height - h;
   }
  

 }
 
 void move(){
   x -= speed;
   
   if (x < 0-w){
     x = width;
     h = random(minterrainheight,maxterrainheight);
   }

 }
 
 void display(){
   noStroke();
   fill(40,20,0);
   if (side == 0){
     rect(x, 0, w, h);
   }
   else{
     rect(x, height-h, w, h); 
   }
 }
 
float interSectionAmount() {
 
  float top = max(rocket.y, y);
  float bottom = min(rocket.y + rocket.h, y + h);
  float left = max(rocket.x, x);
  float right = min(rocket.x + rocket.w, x + w);
  float si = max(0, right - left) * max(0, bottom - top);
 
  return si;
 }
 
 
 void collision(){
 
  
   if (interSectionAmount() > 30){
      newGame = true;
      dead.play();
      dead.rewind();
      flying.pause();
      flying = minim.loadFile("flying.mp3");
      failMillis = millis();
      if (bestScore< score){
        bestScore = score;
      }
     
   }
 }
 
 
  
  
  
}