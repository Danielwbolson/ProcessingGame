
class UIHandler {

  private GameManager _gameManager;
  private ArrayList<Button> _buttons;
  private Button _activeButton;

  // Key Presses
  boolean pressedW;
  boolean pressedA;
  boolean pressedS;
  boolean pressedD;
  boolean pressed1;
  boolean pressed2;

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
    if (pressedW) { _gameManager.EventListener(Event.forward); }
    if (pressedA) { _gameManager.EventListener(Event.left); }
    if (pressedS) { _gameManager.EventListener(Event.back); }
    if (pressedD) { _gameManager.EventListener(Event.right); }
    
    if (!pressedW && !pressedS) { _gameManager.EventListener(Event.slowVertical); }
    if (!pressedA && !pressedD) { _gameManager.EventListener(Event.slowHorizontal); }
    
    if (pressed1) { _gameManager.EventListener(Event.backup); }
    if (pressed2) { _gameManager.EventListener(Event.bomb); }
  }

  private void HandleKeyPressed() {
    if (key == 'w' || key == 'W') { pressedW = true; }
    if (key == 'a' || key == 'A') { pressedA = true; }
    if (key == 's' || key == 'S') { pressedS = true; }
    if (key == 'd' || key == 'D') { pressedD = true; }
    if (key == '1' || key == '!') { pressed1 = true; }
    if (key == '2' || key == '@') { pressed2 = true; }
  }

  private void HandleKeyReleased() {
    if (key == 'w' || key == 'W') { pressedW = false; }
    if (key == 's' || key == 'S') { pressedS = false; }
    if (key == 'a' || key == 'A') { pressedA = false; }
    if (key == 'd' || key == 'D') { pressedD = false; }
    if (key == '1' || key == '!') { pressed1 = false; }
    if (key == '2' || key == '@') { pressed2 = false; }
  }

};
