
class Terrain{
  
 float w;
 float h;
 float x;
 float y;
 int amountOfDust;
 Dust[] dust;
 
 Terrain(float x_, int amountOfDust_){
   w = width/(numberOfTerrainBlocks-1);
   h = height - floorHeight + 10;
   y = height - h;
   x = x_;
   amountOfDust = amountOfDust_;
   
   dust = new Dust[amountOfDust];
   
   for (int i=0; i< amountOfDust; i++){  
     dust[i] = new Dust(random(0, w), random(y+2,height));     
   }
   

 }
 
 void move(){
   x -= speed;
   
   if (x < 0-w){
     x = width;
   }

 }
 
 void display(int j){
   stroke(0);
  // if (j == 0){ stroke(255,0,0);}
  // if (j == 1){ stroke(0,255,0);}
 //  if (j == 2){ stroke(0,0,255); } 
   line(x, y, x+w+10, y); 
   
   
   for (int i=0; i< amountOfDust; i++){  
     ellipse(x+dust[i].x, dust[i].y, 1, 1);
       
   }

 }
 
 
  
  
  
}