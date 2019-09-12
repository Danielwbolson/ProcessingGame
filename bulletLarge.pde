
class LargeBullet extends Bullet {
  
  public LargeBullet(PVector position) {
    super(position);
    _damage = 20;
    _damageLeft = _damage;
    _speed = 100;
    _radius = 40;
    _color = color(255, 255, 0, 255);
    _bulletType = BulletType.large;
  }
  
};
