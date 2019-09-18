
class Balloon {
  
  protected PShape _shape;
  protected color _color;
  protected int _maxHP;
  protected PVector _direction;
  protected float _speed;
  
  public float _radius;
  public PVector _position;
  public int _hp;

  public Balloon(PVector position) {
    _position = position;
    _direction = new PVector(0, 1, 0);
    
    _color = color(random(255), random(255), random(255), int(random(100, 200)));
  }
  
  public void Update(float dt) {}

  public void Draw() {      
    fill(_color);
    ellipseMode(CENTER);
    _shape = createShape(ELLIPSE, _position.x, _position.y, _radius*2, _radius*2);
    shape(_shape);
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

  public boolean DropOnPop() {
    if (int(random(10)) == 0) {
      return true;
    }
    return false;
  }

  public BalloonDrop Drop() {
    int dropIndex = int(random(2));
    if (dropIndex == 0) {
      return new UpgradeDrop(_position);
    } else {
      return new BackupDrop(_position);
    } 
  }

};

// Flies out and shoots roughly in direction of enemy
// Small fast shots
class FighterBalloon extends Balloon {
  
  FighterBalloon(PVector position) {
    super(position);
    _hp = 1;
    _maxHP = _hp;
    
    _radius = 15;
    _speed = 150;
    _color = #4b5320;
  }
  
};

// Tankier Balloon which carries infinite-until-destroyed fighters
class CarrierBalloon extends Balloon {
  
  CarrierBalloon(PVector position) {
    super(position);
    _hp = 10;
    _maxHP = _hp;
        
    _radius = 40;
    _speed = 50;
    
    _color = #d3d3d3;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }

  public void OnPop() {}
};

// Big tanky balloon which shoots bit shots
class ArmoredBalloon extends Balloon {
  
  ArmoredBalloon(PVector position) {
    super(position);
    _hp = 25;
    _maxHP = _hp;
        
    _radius = 60;
    _speed = 25;
    
    _color = #36454f;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }

  public void OnPop() {}
  
};

// Races for player hoping for a collision
class ScreamerBalloon extends Balloon {
  
  ScreamerBalloon(PVector position) {
    super(position);
    _hp = 1;
    _maxHP = _hp;
        
    _radius = 10;
    _speed = 250;
    
    _color = #000000;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }

  public void OnPop() {}
   
};
