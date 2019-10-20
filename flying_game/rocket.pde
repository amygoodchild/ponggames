

class Rocket{
  
  float x;  
  float y;
  float w;
  float h;

  
  Rocket(){
    x = rocketPosition;
    w = rocketWidth;
    h = rocketHeight;
    y = height/2;
   
    
  }
  
  void move(int direction){
    if (y < 50){  
      
     y = 50;
    }
    
    else if (y>height -50){
      y = height -50;
    }
    
    else{
      if (direction == 0){
        y -= 10;
      }
      else{
        y+= 10;
      }
    }
    

      
     
  }
  
  void position(){
    float position = map(lerpPercentage, 0, 1, maxterrainheight, height - 200);
    y = position;
  }
  
 
  
  void display(){
     fill(0);
    // rect(x,y,w,h); 
    image(rocketimage, x,y);
     
    if(!newGame){
     
    }
    else{
     
      
    }
  }
  
  
}