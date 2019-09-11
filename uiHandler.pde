
class UIHandler {
  
  private EntityManager _entityManager;
  private Button _loadLargeBullet;
  private Button _loadMediumBullet;
  private Button _loadSmallBullet;
  private Button _quit;
  private Button _activeButton;
  
  public UIHandler(EntityManager em) {
    _entityManager = em;
    
    // Place our buttons
    _quit = new Button(new PVector(50, 50, 0), 40, color(0, 0, 255, 255));
    _loadSmallBullet = new Button(new PVector(50, 600, 0), 30, color(255, 0, 255, 255));
    _loadMediumBullet = new Button(new PVector(50, 660, 0), 40, color(0, 255, 255, 255));
    _loadLargeBullet = new Button(new PVector(50, 725, 0), 50, color(255, 255, 0, 255));
    
    // Start out cannon with a small shot
    _entityManager.EventListener(Event.loadSmall);
    _activeButton = _loadSmallBullet;
    _activeButton.Active();
  }
    
  public void HandleInput() {
    // Get Mouse position
    PVector mousePos = new PVector(mouseX, mouseY, 0);
    
    _entityManager.AimCannon(mousePos);
    
    if (mousePressed && (mouseButton == LEFT)) {
      
      // Check if any buttons were clicked and respond accordingly
      if (_loadLargeBullet.IsClicked(mousePos)) {
        _entityManager.EventListener(Event.loadLarge);
        _activeButton.NotActive();
        _activeButton = _loadLargeBullet;
        _activeButton.Active();
        
      } else if (_loadMediumBullet.IsClicked(mousePos)) {
        _entityManager.EventListener(Event.loadMedium);
        _activeButton.NotActive();
        _activeButton = _loadMediumBullet;
        _activeButton.Active();
        
      } else if (_loadSmallBullet.IsClicked(mousePos)) {
        _entityManager.EventListener(Event.loadSmall);
        _activeButton.NotActive();
        _activeButton = _loadSmallBullet;
        _activeButton.Active();
        
      } else if (_quit.IsClicked(mousePos)) {
        exit();
        _activeButton.NotActive();
        
      } else {
        _entityManager.EventListener(Event.shoot);
      }
      
    }
    
  }
  
  public void DrawUI() {
    _loadLargeBullet.DrawButton();
    _loadMediumBullet.DrawButton();
    _loadSmallBullet.DrawButton();
    _quit.DrawButton();
  }
  
};
