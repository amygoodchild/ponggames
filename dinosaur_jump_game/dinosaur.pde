

class Dinosaur{
  
  float x;  
  float y;
  float w;
  float h;
  float yVel;

  int direction;
  
  Dinosaur(){
    x = dinosaurPosition;
    w = dinosaurWidth;
    h = dinosaurHeight;
    y = topOfDinosaur;
    direction = 0;
    yVel = 0;
    
  }
  
  void jump(){
    yVel += gravity;
    y += yVel;
    
      if (y > topOfDinosaur){
        y = topOfDinosaur;
        yVel = 0;
        jumping = false;
        running.loop();
      }
    
    
  }
  
 
  
  void display(){
    // fill(0);
    // rect(x,y,w,h); 
     
    if(!newGame){
      if (jumping){
         image(dinoJump, x, y);
       }
       else{
         if (animationCount<10){
           image(dinoRun1, x, y);
           animationCount++;
         }
         else{
           image(dinoRun2, x, y);
           animationCount++;
         }
         if (animationCount>20){
           animationCount = 0;
         }
       } 
    }
    else{
      image(dinoDead, x, y);
      
    }
  }
  
  
}