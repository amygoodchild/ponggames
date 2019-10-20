
class Ball {

  PVector direction;
  PVector location;

  Ball() {

    direction = new PVector(speed, 1);
    location = new PVector(width/2, height/2);
  }

  void move() {
    location.add(direction);
  }

  void off() {
    
    
    
    if (location.x > width) {
      leftScore++;
      location = new PVector(width/2, height/2);
      if (currentRally > bestRally){
        bestRally = currentRally;
      }
      currentRally = 0;
        
      }
    if (location.x < 0) {
      rightScore++;
      location = new PVector(width/2, height/2);
      if (currentRally > bestRally){
        bestRally = currentRally;
      }
      currentRally = 0;
      
    }
    
    if (location.y < 90) {
      direction.y = direction.y * -1;
      beep1.play();
    } 
    
    if (location.y > height-30) {
      direction.y = direction.y * -1;
      beep1.play();
    }     
  }  

  void hitPaddle() {
    
   
    
    // hit the right
    if (location.x > width-edgeGap-rightPaddle.w && location.x < width-edgeGap-rightPaddle.w+10 && location.y > rightPaddle.h && location.y < rightPaddle.h+rightPaddle.d ) {
      direction.x = direction.x * -1;
      currentRally++;
       beep2.play();
    }

    // hit the left
    if (location.x > edgeGap+leftPaddle.w && location.x < edgeGap+leftPaddle.w+10 && location.y > leftPaddle.h && location.y < leftPaddle.h+leftPaddle.d ) {
      direction.x = direction.x * -1;
      currentRally++;
       beep2.play();
    }
  }


  void display() {
    fill(255);
    ellipse(location.x, location.y, 50, 50);
  }
}