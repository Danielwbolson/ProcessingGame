
class MediumBullet extends Bullet {
  
  public MediumBullet(PVector position) {
    super(position);
    _damage = 4;
    _damageLeft = _damage;
    _speed = 200;
    _radius = 15;
    _color = color(0, 255, 255, 255);
    _bulletType = BulletType.medium;
  }
  
};
