

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  int whichColor;
  int whichSide;
  
  
  Blob (float x, float y, int whichColor_, int whichSide_){
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    whichColor = whichColor_;
    whichSide = whichSide_;
  }
  
  
  boolean isNear(float px, float py){
    float cx = (minx + maxx)/2;
    float cy = (miny + maxy)/2;
    
    float d = distSq(cx, cy, px, py);
    
    if (d < distThreshold * distThreshold){
      return true;
    }
    else{
      return false;
    }
    
  }
  
  void show(int theColor){
    if(theColor == 0){
      fill(255,50,100); //red
    }
    if (theColor == 1){
      fill(255,250,100); // yellow     
    }

  
    //fill(255);
    //noStroke();
    stroke(255,255,255);
    strokeWeight(3);
    //rectMode(CORNERS);
    //ellipse(minx+((maxx-minx)/2), miny+((maxy-miny)/2), maxx-minx, maxy-miny);
    //rect(minx, miny, maxx, maxy);
    rect (minx, miny, 30,40); 
  }
  
  void showGrid(){
    if(whichColor == 0){
      fill(255,50,100); //red

    }
    if (whichColor == 1){
      fill(255,250,100); // yellow     
    }

  
    //fill(255);
    //noStroke();
    stroke(255,255,255);
    strokeWeight(3);
    //rectMode(CORNERS);
    //ellipse(minx+((maxx-minx)/2), miny+((maxy-miny)/2), maxx-minx, maxy-miny);
    //rect(minx, miny, maxx, maxy);
    rect (minx, miny, 10,20); 
  }
  
  
  void add (float x, float y){
      minx = min(minx, x);
      miny = min(miny, y);
      maxx = max(maxx, x);
      maxy = max(maxy, y); 
  }
  
  float size(){
    return (maxx-minx)*(maxy-miny);
  }
}