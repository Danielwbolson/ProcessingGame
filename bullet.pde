
class Bullet {

  protected int _damageLeft;
  protected int _speed;
  protected PShape _shape;
  protected color _color;

  public float _radius;
  public int _damage;
  public PVector _position;

  private PVector _direction;

  public Bullet() {}

  public Bullet(PVector position) {
    _position = position;
    _direction = new PVector(0, -1, 0);
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
  }

  public void Draw() {}
  
  public void Shoot(PVector direction) {
    _direction = direction;
  }

  public void LosePower(int hp) {
    _damageLeft = _damageLeft - hp;
  }

  public boolean OutOfPower() {
    return _damageLeft < 1;
  }
  
};
