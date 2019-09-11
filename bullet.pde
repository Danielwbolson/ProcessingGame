
class Bullet {

  protected int _damageLeft;
  protected int _speed;
  protected boolean _active;
  protected PShape _shape;
  protected color _color;

  public float _radius;
  public int _damage;
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
      _shape = createShape(ELLIPSE, _position.x, _position.y, _radius*2, _radius*2);
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

  public void LosePower() {
    _damageLeft = _damageLeft - 1;
  }

  public boolean OutOfPower() {
    return _damageLeft < 1;
  }
};
