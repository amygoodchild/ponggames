
class Paddle {
  
  float h;
  int side;
  int w;
  int d;
  
  Paddle(int side_){
    
    side = side_;
    h = height/2;
    w = 30;
    d = 200;
    
  }
  
  void move(boolean down){
   
    if (down){ 
        println(h);
        if (h > 90 - d/2){
        float moveAmount = map(percentage, 0.5, 1, 10,40);
        h+=moveAmount;
      }
    }
    else{
      if (h < height - 100){
      
        float moveAmount = map(percentage, 0.5, 1, 10,40);
        h-=moveAmount;
      }
    }
  }
  
  void display(){
    fill(255);
    rect(side, h, w, d);
    
    fill(255, 246, 0);
    rect(side, h, w, d/5);
    
    fill(255, 0, 0);
    rect(side, h+((d/5)*4), w, d/5);
  }
  
  
  
}
