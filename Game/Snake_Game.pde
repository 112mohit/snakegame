/* Programme created by Mohit Sharma, Christian Sanchez, Danil Vorobjov

References- 
https://processing.org/reference/conditional.html
https://processing.org/reference/PVector.html
https://processing.org/reference/tint_.html
https://processing.org/reference/loop_.html
https://processing.org/reference/class.html
Videos by marco 
*/
//Variables for the game set up
PImage soil; //Image for background - image was set to the size of the screen
final int SCREEN_SIZE = 600; //Size of the screen
int score = 0; //Score of the player
int rainbowFreq = 10, rainbowTimer = rainbowFreq; //Rainbow timing
PVector rainbowColor = new PVector(255, 255, 255); //The color of the rainbow color - all colours selected
boolean pauseState = false; //If the game is paused or not
boolean showInstructionMenu = true; //If the instruction menu should be shown
int superModeTimer = 0, superModeMax = 15, chanceOfSuperMode = 10; //If superpower is on

//Variables for the food and growth
ArrayList<Growth> Growth = new ArrayList<Growth>(); //Creates an arraylist holding the growth
char currentDirection, lastDirection; //The current direction of the snake head
int GrowthSize = 20; //Size of the segment
int snakeMovementTimer = 0, snakeMovementDelay = 4; //The timers for the snake's movement
boolean addGrowthNextUpdate = false; //If a segment should be added at the next update
PImage img; // image named

//Variables pertaining to the food
Food food = new Food(); //Creates a new food
SuperPower SuperPower = null; //Creates the superfood

void setup() { //Main method
  size(600, 600); //Creates a screen
  textSize(20);
  textAlign(CENTER); //Aligns text to the center
  soil = loadImage("soil.jpg");
  
  Growth.add(new Growth(SCREEN_SIZE/2, SCREEN_SIZE/2)); //Adds the head of the snake
  img=loadImage("Apple.png"); // image of the food being loaded
}

void draw() { //Continual loop
 background(soil);
  if(!pauseState) rainbowTimer++; //Increments the rainbow color timer
  if(rainbowTimer >= rainbowFreq) { //If the time for color change
    rainbowColor = new PVector(random(255), random(255), random(255)); //Changes it to a random color for super food and snake
    rainbowTimer = 0; //Resets the rainbow timer
  }

  if(!pauseState) snakeMovementTimer++; //Increments the snake movement timer if not paused
  if(snakeMovementTimer == snakeMovementDelay) { //If the time for movement has come
    updateSnake(); //Update the snake
    snakeMovementTimer = 0; //Reset the timer
  }
  
  if(superModeTimer >= 0) superModeTimer--; //Decrements the super timer
  if(SuperPower == null && superModeTimer < 0 && !pauseState && !showInstructionMenu)
    if(random(1000) < chanceOfSuperMode) SuperPower = new SuperPower();
  
  
  for(int i = 0; i < Growth.size(); i++) //Checks each growth
    Growth.get(i).renderGrowth(); //Renders the growth
  food.renderFood(); //Renders the food
  if(SuperPower != null) SuperPower.renderFood(); //Renders superfood if it is not null
  
  fill(0); //Colors black
  text("Score: " + score, SCREEN_SIZE/2, GrowthSize*28); //Writes the score for the player at the bottom
  
  if(pauseState) { //If the game is paused
    fill(0, 0, 0, 100); //Fills a translucent black
    noStroke(); //Cancels the stroke
    rect(0, 0, SCREEN_SIZE, SCREEN_SIZE); //Cover the screen with a transluscent black so that player knows its been paused
    fill(255); //Colors white
    text("Game Paused", SCREEN_SIZE/2, SCREEN_SIZE/2);
    text("Press 'P' To Continue", SCREEN_SIZE/2, SCREEN_SIZE/2 + GrowthSize*6/5);
  } else if(showInstructionMenu) { //If the instruction menu is shown
    text("Use The Arrows To Move", SCREEN_SIZE/2, SCREEN_SIZE*3/4);
    text("Press 'P' To Pause", SCREEN_SIZE/2, SCREEN_SIZE*3/4 + GrowthSize*6/5);
  }
}

// Code below is so that the snake moves up, down, left and right.
void keyPressed() { //Called when a key is pressed
  switch(keyCode) { //Checks the key pressed
    case UP: if(Growth.size() == 1 || lastDirection != 'S' && !pauseState) currentDirection = 'W'; break; //Changes direction to up
    case DOWN: if(Growth.size() == 1 || lastDirection != 'W' && !pauseState) currentDirection = 'S'; break; //Changes direction to down
    case LEFT: if(Growth.size() == 1 || lastDirection != 'D' && !pauseState) currentDirection = 'A'; break; //Changes direction to left
    case RIGHT: if(Growth.size() == 1 || lastDirection != 'A' && !pauseState) currentDirection = 'D'; break; //Changes direction to right
    case 'P': case 'p': pauseState = !pauseState; break; //Toggles the pause
  }
  showInstructionMenu = false; //Take off the instruction menu
}

//Code below makes the snake keep moving the direction is it going
void updateSnake() { //Updates the snake's position
  if(addGrowthNextUpdate) //If must add a new segment
    Growth.add(new Growth((int)Growth.get(Growth.size() - 1).location.x, (int)Growth.get(Growth.size() - 1).location.y)); //Adds a segment at the tail
  for(int i = Growth.size() - 1; i > 0; i--) { //Checks each segments besides the head
    if(!addGrowthNextUpdate) Growth.get(i).location = new PVector(Growth.get(i - 1).location.x, Growth.get(i - 1).location.y); //Sets the location to the block ahead
    addGrowthNextUpdate = false; //Removes the need to add a new segment
  }
  
  switch(currentDirection) { //Checks the current direction and keeps the movement of the snake so it doesnt stop
    case 'W': Growth.get(0).location.y -= GrowthSize; break; //Moves the snake head up
    case 'S': Growth.get(0).location.y += GrowthSize; break; //Moves the snake head down
    case 'A': Growth.get(0).location.x -= GrowthSize; break; //Moves the snake head left
    case 'D': Growth.get(0).location.x += GrowthSize; break; //Moves the snake head right
  }
  lastDirection = currentDirection; //Sets the last direction used as the current direction
  
  for(int i = 2; i < Growth.size(); i++) //Checks each segment besides the head
    if(superModeTimer < 0 && Growth.get(i).location.x == Growth.get(0).location.x && Growth.get(i).location.y == Growth.get(0).location.y) //If a segment hits the head
      startNewGame(); //Starts a new game
      
      //If the snake has the superpower on then it cn go through the screen on the otherside in the X axis. 
    if(Growth.get(0).location.x >= SCREEN_SIZE || Growth.get(0).location.x < 0)
      if(superModeTimer >= 0) Growth.get(0).location.x = (Growth.get(0).location.x >= SCREEN_SIZE) ? 0 : SCREEN_SIZE - GrowthSize;
      else startNewGame();
       //If the snake has the superpower on then it cn go through the screen on the otherside in the y axis.  
    if(Growth.get(0).location.y >= SCREEN_SIZE || Growth.get(0).location.y < 0)
      if(superModeTimer >= 0) Growth.get(0).location.y = (Growth.get(0).location.y >= SCREEN_SIZE) ? 0 : SCREEN_SIZE - GrowthSize;
      else startNewGame();
}

void startNewGame() { //Starts a new game
  SuperPower = null; //Nullifies the super food
  score = 0; //Resets the score
  Growth.clear(); //Clears all segments
  Growth.add(new Growth(SCREEN_SIZE/2, SCREEN_SIZE/2)); //Adds the head of the snake
  snakeMovementTimer = 0; //Reset the timer
  currentDirection = 'Q'; //Nullifys the current direction
  keyCode = '+'; //Nullifys the keyCode
  food = new Food(); //Resets the food
  showInstructionMenu = true; //Show the instruction menu
}