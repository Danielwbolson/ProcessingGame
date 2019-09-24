
class Ship {

  public PVector _position;
  public PVector _direction;
  public boolean _slowingDownVertical;
  public boolean _slowingDownHorizontal;
  public int _width = 20;
  public int _height = 40;
  public color _color;
  public BulletType _currBulletType;

  private PShape _shape;
  private float _speed = 500;
  private int _shotCooldownTime = CooldownTime.shotCooldown.getCode();
  private int _backupCooldownTime = CooldownTime.backupCooldown.getCode();
  private int _bombCooldownTime = CooldownTime.bombCooldown.getCode();
  private int _lastShot;

  public Ship(PVector pos) {
    _position = pos;
    _direction = new PVector(0, 0, 0);
    _color = color(255);
    _currBulletType = BulletType.shipTier1;
  }

  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    
    if (_slowingDownHorizontal || _slowingDownVertical) {
      SlowDown();
    }
  }
  
  public void Draw() {
    fill(_color);
    rectMode(CENTER);
    _shape = createShape(RECT, _position.x, _position.y, _width, _height);
    shape(_shape);
  }

  public void Shoot(Bullet bullet) {
    bullet.Shoot(new PVector(0, -1, 0));
    _lastShot = millis();
  }

  public Bullet LoadedBullet() {

    switch(_currBulletType) {

      case shipTier1:
        return new ShipBulletTier1(_position);

      case shipTier2:
        return new ShipBulletTier2(_position);

      case shipTier3:
        return new ShipBulletTier3(_position);

      default:
        return new Bullet(_position);
    }
  }

  public void SlowDown() {    
    if (_slowingDownHorizontal) { _direction.x = _direction.x * 0.8f; }
    if (_slowingDownVertical) { _direction.y = _direction.y * 0.8f; }

    if (abs(_direction.x) < 0.1) {  _direction.x = 0; }
    if (abs(_direction.y) < 0.1) {  _direction.y = 0; }
  }

  public void GetDrop(BalloonDropType b) {
    switch (b) {
      case backup:
        break;
      case upgrade:
        if (_currBulletType != BulletType.shipTier3) {
          _currBulletType = _currBulletType.Next();
        }
    }
  }


  private boolean CanShoot() {
    if (millis() - _lastShot > _shotCooldownTime) {
      return true;
    }
    return false;
  }
};
