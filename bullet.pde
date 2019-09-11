
class Bullet {
  
  protected int _damage;
  protected int _speed;
  protected boolean _active;
  protected int _radius;
  protected PShape _shape;
  protected color _color;
  
  public BulletType _bulletType;
  public PVector _position;
  public PVector _direction;

  
  public Bullet(PVector position) {
    _position = position;
    _active = false;
  }
  
  public void DrawBullet() {
    if (_active) {
      fill(_color);
      ellipseMode(CENTER);
      _shape = createShape(ELLIPSE, _position.x, _position.y, _radius, _radius);
      shape(_shape);
    }
  }
  
  public void Update(float dt) {
    if (_active) {
      _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    }
  }
  
  
  
  
  public void Shoot(PVector direction) {
    _direction = direction;
    _active = true;
  }
  
  void OnHit() {
    
  }
  
  void OnOverShoot() {
    
  }
  
  boolean Hit(Balloon balloon) {
    return false;
  }
  
};
