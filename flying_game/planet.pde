

class Planet{
  
  float x, y, h, w;
  int comparisonPlanet;
  
  
  Planet(float x_, float y_,int comparisonPlanet_){
    x = x_;
    y = y_;
    w = 80;
    h = 80;

    comparisonPlanet = comparisonPlanet_;
  }
  
  void move(){
   x -= speed;
   
   if (x < 0 -w-20){
     
     x = random(planets[comparisonPlanet].x + minPlanetSpacing,planets[comparisonPlanet].x + maxPlanetSpacing);
     y = random(maxterrainheight, height-maxterrainheight-50);
     
     score++;
   }
  }
   
  void display(){
     
     fill(0);
     
     image(planetimage,x,y);
  
   
  
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