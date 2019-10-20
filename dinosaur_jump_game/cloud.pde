

class Cloud{
  
  int x;
  int y;
  int w;
  int which;
  int h;
  int opa;
  int speed;
  
  Cloud(int x_, int y_, int opa_, int which_, int speed_){
    x = x_;
    y = y_;
    w = 120;
    h = 60;
    which = which_;
    opa = opa_; 
    speed = speed_;
  }
  
  
  void move(){
    x -= speed;  
    
    if (x< 0 - w - 10){
      x = int(random(width+10, width+ 100));
      y = int(random(20, floorHeight - 100));
      
    }
  }
  
  void display(){
   
   
    tint(255, opa);
   
    if (which == 1){
      image(cloud1, x, y);
      
    }
    if (which == 2){
      image(cloud2, x, y);
    }
    if (which == 3){
      image(cloud3, x, y);
    }
    if (which == 4){
      image(cloud4, x, y);
    }
    
    tint(255,255);
  }
}