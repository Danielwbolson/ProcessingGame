
class SmallBullet extends Bullet {
  
  public SmallBullet(PVector position) {
    super(position);
    _damage = 1;
    _damageLeft = _damage;
    _speed = 300;
    _radius = 4;
    _color = color(255, 0, 255, 255);
    _bulletType = BulletType.small;
  }
  
};
