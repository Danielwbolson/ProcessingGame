
class Balloon {
  
  private float _smallRadius;
  private float _bigRadius;
  private float _speed;
  private PShape _shape;
  private color _color;
  
  public PVector _position;
  public PVector _direction;
  public int _hp = 5;

  public Balloon(PVector position) {
    _position = position;
    _direction = new PVector(0, 1, 0);
    
    _smallRadius = random(20, 80);
    _bigRadius = 1.8 * _smallRadius;
    _speed = sqrt(_smallRadius*_smallRadius + _bigRadius*_bigRadius) / 2.0;
    
    _color = color(random(255), random(255), random(255), int(random(100, 200)));
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
  }
  
  public void DrawBalloon() {
    fill(_color);
    ellipseMode(CENTER);
    _shape = createShape(ELLIPSE, _position.x, _position.y, _smallRadius, _bigRadius);
    shape(_shape);
  }
  
  public bool OnHit(int damage) {
    _hp = _hp - damage;
  }
  
  public bool Popped() {
	  return _hp < 1;
  }

};
