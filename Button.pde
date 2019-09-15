
class Button {
  
  public int _strokeWeight;
  public int _strokeVal;
  
  protected PVector _position;
  protected PShape _shape;
  protected int _radius;
  protected color _color;
  protected Event _event;
  protected char keyBind; 
  
  private int _activeOffset = 80;
  
  public Button(PVector position, int radius, color c) {
    _position = position;
    _radius = radius;
    _color = c;
    _strokeWeight = 1;
    _strokeVal = 0;
  }
  
  // Check if the user has clicked inside our button
  public boolean IsClicked(PVector pos) {
    PVector diff = PVector.sub(pos, _position);
    if (sqrt(diff.x*diff.x + diff.y*diff.y) < _radius) {
      return true;
    }
    return false;
  }
  
  public Event Clicked() {
    return _event;
  }
  
  public void NotActive() {
    _strokeWeight = 1;
    _strokeVal = 0;
    _color = color(red(_color)+_activeOffset, green(_color)+_activeOffset, blue(_color)+_activeOffset, alpha(_color));
  }
  
  public void Active() {
    _strokeWeight = 4;
    _strokeVal = 255;
    _color = color(red(_color)-_activeOffset, green(_color)-_activeOffset, blue(_color)-_activeOffset, alpha(_color));
  }
  
};


class BombButton extends Button {
 
  BombButton(PVector position, int radius, color c) {
    super(position, radius, c);
    _event = Event.bomb;
  }
  
};


class BackupButton extends Button {
 
  BackupButton(PVector position, int radius, color c) {
    super(position, radius, c);
    _event = Event.backup;
  }
  
};
