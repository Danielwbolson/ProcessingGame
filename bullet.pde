
class Bullet {

  protected int _damageLeft;
  protected int _speed;
  protected PShape _shape;
  protected color _color;

  public float _radius;
  public int _damage;
  public PVector _position;

  private PVector _direction;

  public Bullet(PVector position) {
    _position = position;
    _direction = new PVector(0, -1, 0);
  }

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

class LargeBullet extends Bullet {

  public LargeBullet(PVector position) {
    super(position);
    _damage = 20;
    _damageLeft = _damage;
    _speed = 100;
    _radius = 40;
    _color = color(255, 255, 0, 255);
  }
  
};

class MediumBullet extends Bullet {

  public MediumBullet(PVector position) {
    super(position);
    _damage = 4;
    _damageLeft = _damage;
    _speed = 200;
    _radius = 15;
    _color = color(255, 165, 0, 255);
  }
  
};

class SmallBullet extends Bullet {

  public SmallBullet(PVector position) {
    super(position);
    _damage = 1;
    _damageLeft = _damage;
    _speed = 1000;
    _radius = 4;
    _color = color(0, 255, 255, 255);
  }
  
};
