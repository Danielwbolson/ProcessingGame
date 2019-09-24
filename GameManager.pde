
class GameManager {
  
  private EntityManager _entityManager;
  private UIHandler _uiHandler;
  private GameRenderer _gameRenderer;
  private float _elapsedTime;

  private int _lives = 5;

  GameManager() {
    _entityManager = new EntityManager();
    _uiHandler = new UIHandler(this);
    _gameRenderer = new GameRenderer(_entityManager, _uiHandler);
  }
  
  public void Setup() {    
    _elapsedTime = millis();
  }
  
  public void Update(float offset) {
    float dt = calculateDt() - offset;
    println(dt);
    
    // Update our entities and handle our user input
    // Update UI first so that we can give correct information to our manager
    _uiHandler.HandleInput();

    _entityManager.Update(dt);
    _lives = _lives - _entityManager._hits;

    _gameRenderer.Render(_lives);

    if (_lives <= 0) {
      noLoop();
      _gameRenderer.Lose();
    }
  }
  
  public void EventListener(Event event) {
    switch (event) {
    case shoot: 
    case forward:
    case back:
    case left:
    case right:
    case slowVertical:
    case slowHorizontal:
      _entityManager.EventListener(event);
      break;
      
    case bomb:
    case backup:
      break;

    default:
      break;
    }
  }
  
  public void HandleKeyPressed() {
    _uiHandler.HandleKeyPressed();
  }
  
  public void HandleKeyReleased() {
    _uiHandler.HandleKeyReleased(); 
  }
  
  private float calculateDt() {
    float currTime = millis();
    float dt = (currTime - _elapsedTime) / 1000.0;
    _elapsedTime = currTime;
    return dt;
  }
  
};
