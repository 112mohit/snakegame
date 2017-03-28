class SuperPower extends Food {
  void renderFood() {
    fill(rainbowColor.x, rainbowColor.y, rainbowColor.z); //Fills rainbow
    stroke(255); //Borders with white
    rect(this.location.x, this.location.y, GrowthSize, GrowthSize); //Draws the segment onto the screen
    
    if(!pauseState && this.location.x == Growth.get(0).location.x && this.location.y == Growth.get(0).location.y) { //If the head of the snake is on the food and the game is not paused
      superModeTimer = superModeMax * 30;
      SuperPower = null;
    }
  }
}