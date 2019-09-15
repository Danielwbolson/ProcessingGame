
class UIHandler {

  private GameManager _gameManager;
  private ArrayList<Button> _buttons;
  private Button _activeButton;

  // Key Presses
  boolean wPressed;
  boolean aPressed;
  boolean sPressed;
  boolean dPressed;

  public UIHandler(GameManager gm) {
    _gameManager = gm;
    _buttons = new ArrayList<Button>();
    
    _buttons.add(new BackupButton(new PVector(30, 715, 0), 25, color(255, 0, 255, 255)));
    _buttons.add(new BombButton(new PVector(30, 770, 0), 25, color(0, 255, 255, 255)));
  }

  public void HandleInput() {
    PVector mousePos = new PVector(mouseX, mouseY, 0);

    if (mousePressed && (mouseButton == LEFT)) {
      
      boolean buttonClicked = false;
      
      for (Button b : _buttons) {
        if (b.IsClicked(mousePos)) {
          Event event = b.Clicked();
          _gameManager.EventListener(event);
          
          if (_activeButton != null) {
            _activeButton.NotActive();
          }
          _activeButton = b;
          _activeButton.Active();
          
          buttonClicked = true;
          break;
        }
      }
      
      if (!buttonClicked) {
        _gameManager.EventListener(Event.shoot);
      }      
    }
    
    KeyEvents();
          
  }

  private void KeyEvents() {
    if (wPressed) { _gameManager.EventListener(Event.forward); }
    if (aPressed) { _gameManager.EventListener(Event.left); }
    if (sPressed) { _gameManager.EventListener(Event.back); }
    if (dPressed) { _gameManager.EventListener(Event.right); }
    
    if (!wPressed && !sPressed) { _gameManager.EventListener(Event.slowVertical); }
    if (!aPressed && !dPressed) { _gameManager.EventListener(Event.slowHorizontal); }
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

};
