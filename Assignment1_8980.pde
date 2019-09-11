
// In game entities and tools
EntityManager _entityManager;
UIHandler _uiHandler;

// Track time between frames
float _elapsedTime;

void setup() {
  // Setup window
  size(800, 800);
  
  // Setup Game managers and tools
  _entityManager = new EntityManager();
  _uiHandler = new UIHandler(_entityManager);
  
  // Get our start time after initialization
  _elapsedTime = millis();
}


void draw() {
  // Calculate realtime frame speed
  float dt = calculateDt();
  
  // Update all of our entities
  update(dt);
  
  // Draw our entire scene
  drawScene();
}

void update(float dt) {
  // Update our entities and handle our user input
  // Update UI first so that we can give correct information to our manager
  _uiHandler.HandleInput();
  _entityManager.Update(dt);
}

void drawScene() {
  // Wipe clean our scene
  background(100, 150, 255, 200);
  
  // Draw all entities as well as our UI
  // Draw UI last so it goes over everything else
  _entityManager.DrawEntities();
  _uiHandler.DrawUI();
}

float calculateDt() {
  float currTime = millis();
  float dt = (currTime - _elapsedTime) / 1000.0;
  _elapsedTime = currTime;
  return dt;
}
