
class Balloon {
  
  private float _speed;
  private PShape _shape;
  private color _color;
  
  public float _radius;
  public PVector _position;
  public PVector _direction;
  public int _hp = 2;

  public Balloon(PVector position) {
    _position = position;
    _direction = new PVector(0, 1, 0);
    
    _radius = random(20, 80);
    _speed = sqrt(_radius*_radius + _radius*_radius) / 2.0;
    
    _color = color(random(255), random(255), random(255), int(random(100, 200)));
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
  }
  
  public void DrawBalloon() {
    fill(_color);
    ellipseMode(CENTER);
    _shape = createShape(ELLIPSE, _position.x, _position.y, _radius*2, _radius*2);
    shape(_shape);
  }
  
  public void OnHit(int damage) {
    _hp = _hp - damage;
  }
  
  public boolean Popped() {
	  return _hp < 1;
  }

};
