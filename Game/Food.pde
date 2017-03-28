class Food { //Class for food
  PVector location; //Location of the food
 
  Food() { //Creates a new food
    this.location = new PVector((int)random(SCREEN_SIZE/GrowthSize)*GrowthSize, (int)random(SCREEN_SIZE/GrowthSize)*GrowthSize); //Sets food location to a random location
  }
  
  void renderFood() { //Renders the food
    fill(255, 0, 0); //Fills red
    stroke(255); //Borders with white
    image(img,this.location.x, this.location.y, GrowthSize, GrowthSize); //Draws the food
    
    if(!pauseState && this.location.x == Growth.get(0).location.x && this.location.y == Growth.get(0).location.y) { //If the head of the snake is on the food and the game is not paused
      food = new Food(); //Moves the food to different locations
      addGrowthNextUpdate = true; //Makes the snake longer
      score++; //Increments the score
    }
  }
}