

// Run with Visual Studio Code:
// Ctrl + Shift + B
GameManager _gameManager;
boolean paused;
float timePaused;
float offset = 0;

void setup() {    
  size(800, 800);
  
  _gameManager = new GameManager();
  _gameManager.Setup();
}

void draw() {
  _gameManager.Update(offset);
  offset = 0;
}

void keyPressed() {
  _gameManager.HandleKeyPressed(); 
}

void keyReleased() {
  _gameManager.HandleKeyReleased(); 
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    paused = !paused;

    if (paused) {
      noLoop();
      timePaused = millis()/1000.0;
    } else {
      loop();
      offset = millis()/1000.0 - timePaused;
    }
  }
}