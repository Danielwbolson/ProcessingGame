
class Button {
  
  private PVector _position;
  private PShape _shape;
  private int _radius;
  private color _color;
  private int _activeOffset;
  
  public Button(PVector position, int radius, color c) {
    _position = position;
    _radius = radius;
    _color = c;
  }
  
  public void DrawButton() {
    fill(_color);
     ellipseMode(CENTER);
    _shape = createShape(ELLIPSE, _position.x, _position.y, _radius*2, _radius*2);
    shape(_shape);
  }
  
  // Check if the user has clicked inside our button
  public boolean IsClicked(PVector pos) {
    PVector diff = PVector.sub(pos, _position);
    if (sqrt(diff.x*diff.x + diff.y*diff.y) < _radius) {
      return true;
    }
    return false;
  }
  
  public void NotActive() {
    _color = color(red(_color)+_activeOffset, green(_color)+_activeOffset, blue(_color)+_activeOffset, alpha(_color));
  }
  
  public void Active() {
    _color = color(red(_color)-_activeOffset, green(_color)-_activeOffset, blue(_color)-_activeOffset, alpha(_color));
  }
  
}
