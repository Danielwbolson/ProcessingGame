
class UIHandler {

  private EntityManager _entityManager;
  private Button _loadLargeBullet;
  private Button _loadMediumBullet;
  private Button _loadSmallBullet;
  private Button _quit;
  private Button _activeButton;

  // Key Presses
  boolean wPressed;
  boolean aPressed;
  boolean sPressed;
  boolean dPressed;

  public UIHandler(EntityManager em) {
    _entityManager = em;

    // Place our buttons
    _quit = new Button(new PVector(30, 30, 0), 20, color(255, 0, 0, 255));
    _loadSmallBullet = new Button(new PVector(30, 680, 0), 15, color(255, 0, 255, 255));
    _loadMediumBullet = new Button(new PVector(30, 720, 0), 20, color(0, 255, 255, 255));
    _loadLargeBullet = new Button(new PVector(30, 770, 0), 25, color(255, 255, 0, 255));

    _activeButton = _loadSmallBullet;
    _activeButton.Active();
  }

  public void HandleInput() {
    PVector mousePos = new PVector(mouseX, mouseY, 0);

    if (mousePressed && (mouseButton == LEFT)) {
      if (_loadLargeBullet.IsClicked(mousePos)) {
        //_entityManager.EventListener(Event.loadLarge);
        _activeButton.NotActive();
        _activeButton = _loadLargeBullet;
        _activeButton.Active();
      } else if (_loadMediumBullet.IsClicked(mousePos)) {
        //_entityManager.EventListener(Event.loadMedium);
        _activeButton.NotActive();
        _activeButton = _loadMediumBullet;
        _activeButton.Active();
      } else if (_loadSmallBullet.IsClicked(mousePos)) {
        //_entityManager.EventListener(Event.loadSmall);
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

    KeyEvents();
  }

  private void KeyEvents() {
    if (wPressed) { _entityManager.EventListener(Event.forward); }
    if (aPressed) { _entityManager.EventListener(Event.left); }
    if (sPressed) { _entityManager.EventListener(Event.back); }
    if (dPressed) { _entityManager.EventListener(Event.right); }
    
    if (!wPressed && !sPressed) { _entityManager.EventListener(Event.slowVertical); }
    if (!aPressed && !dPressed) { _entityManager.EventListener(Event.slowHorizontal); }
  }

  private void HandleKeyPressed() {
    if (key == 'w' || key == 'W') { wPressed = true; }
    if (key == 'a' || key == 'A') { aPressed = true; }
    if (key == 's' || key == 'S') { sPressed = true; }
    if (key == 'd' || key == 'D') { dPressed = true; }
  }

  private void HandleKeyReleased() {
    if (key == 'w' || key == 'W') { wPressed = false; }
    if (key == 's' || key == 'S') { sPressed = false; }
    if (key == 'a' || key == 'A') { aPressed = false; }
    if (key == 'd' || key == 'D') { dPressed = false; }
  }

  public void DrawUI() {
    _loadLargeBullet.DrawButton();
    _loadMediumBullet.DrawButton();
    _loadSmallBullet.DrawButton();
    _quit.DrawButton();
  }
};
