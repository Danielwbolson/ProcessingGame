
class GameRenderer {
  
  private ArrayList<Balloon> _balloons;
  private ArrayList<Bullet> _bullets;
  private Ship _ship;
  private ArrayList<Button> _buttons;
  
  GameRenderer(EntityManager em, UIHandler ui) {
    _balloons = em._balloons;
    _bullets = em._bullets;
    _ship = em._ship;

    _buttons = ui._buttons;
  }
  
  public void Render() {
    
    background(100, 150, 255, 200);
    
    for (Balloon b : _balloons) { 
      fill(b._color);
      ellipseMode(CENTER);
      b._shape = createShape(ELLIPSE, b._position.x, b._position.y, b._radius*2, b._radius*2);
      shape(b._shape);
    }
    
    for (Bullet b : _bullets)   { 
      fill(b._color);
      ellipseMode(CENTER);
      b._shape = createShape(ELLIPSE, b._position.x, b._position.y, b._radius*2, b._radius*2);
      shape(b._shape);
    }
    
    for (Button b : _buttons) {
      
      push();
      
      stroke(b._strokeVal);
      strokeWeight(b._strokeWeight);
      fill(b._color);
      rectMode(CENTER);
      b._shape = createShape(RECT, b._position.x, b._position.y, b._radius*2, b._radius*2);
      shape(b._shape); 
      
      pop();
      
    }
    
    fill(_ship._color);
    rectMode(CENTER);
    _ship._shape = createShape(RECT, _ship._position.x, _ship._position.y, _ship._width, _ship._height);
    shape(_ship._shape);
    
  }
  
};
