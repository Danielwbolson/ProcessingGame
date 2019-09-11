
class MediumBullet extends Bullet {
  
  public MediumBullet(PVector position) {
    super(position);
    _damage = 2;
    _speed = 200;
    _radius = 30;
    _color = color(0, 255, 255, 255);
    _bulletType = BulletType.medium;
  }
  
};
