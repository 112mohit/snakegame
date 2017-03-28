class Growth { 
  PVector location; 
  
  Growth(int locationX, int locationY) { 
    this.location = new PVector(locationX, locationY);
  }
  
  void renderGrowth() { 
    if (superModeTimer < 0) fill(255); 
    else fill(rainbowColor.x, rainbowColor.y, rainbowColor.z); 
    stroke(255); 
    rect(this.location.x, this.location.y, GrowthSize, GrowthSize);
  }
}