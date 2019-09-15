  
GameManager _gameManager;

void setup() {    
  size(800, 800);
  
  _gameManager = new GameManager();
  _gameManager.Setup();
}

void draw() {
  _gameManager.Update();
}

void keyPressed() {
  _gameManager.HandleKeyPressed(); 
}

void keyReleased() {
  _gameManager.HandleKeyReleased(); 
}
