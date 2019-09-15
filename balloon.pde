
class Balloon {
  
  private float _speed;
  private PShape _shape;
  private color _color;
  private int _maxHP;
  private PVector _direction;
  
  public float _radius;
  public PVector _position;
  public int _hp;

  public Balloon(PVector position) {
    _position = position;
    _direction = new PVector(0, 1, 0);
    
    _radius = random(20, 80);
    _speed = sqrt(_radius*_radius + _radius*_radius) / 2.0;
    
    _maxHP = (int)(_radius / 10);
    _hp = _maxHP;
    
    _color = color(random(255), random(255), random(255), int(random(100, 200)));
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

class FighterBalloon extends Balloon {
  
  FighterBalloon(PVector position) {
    super(position);
  }
  
};

class CarrierBalloon extends Balloon {
  
  CarrierBalloon(PVector position) {
    super(position);
  }
  
};

class ArmoredBalloon extends Balloon {
  
  ArmoredBalloon(PVector position) {
    super(position);
  }
  
};

class ScreamerBalloon extends Balloon {
  
  ScreamerBalloon(PVector position) {
    super(position);
  }
  
};
