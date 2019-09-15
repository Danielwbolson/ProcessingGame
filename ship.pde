
class Ship {

  public PVector _position;
  public PVector _direction;
  public boolean _slowingDownVertical;
  public boolean _slowingDownHorizontal;
  public int _width = 20;
  public int _height = 40;
  public color _color;

  private PShape _shape;
  private float _speed = 300;
  private int _sbCooldownTime = CooldownTime.smallCooldown.getCode();
  private int _lastSmallShot;

  public Ship(PVector pos) {
    _position = pos;
    _direction = new PVector(0, 0, 0);
    _color = color(255);
  }

  public void Shoot(Bullet bullet) {
    bullet.Shoot(new PVector(0, -1, 0));
    _lastSmallShot = millis();
  }

  public void SlowDown() {    
    if (_slowingDownHorizontal) { _direction.x = _direction.x * 0.9f; }
    if (_slowingDownVertical) { _direction.y = _direction.y * 0.9f; }

    if (abs(_direction.x) < 0.1) {  _direction.x = 0; }
    if (abs(_direction.y) < 0.1) {  _direction.y = 0; }
  }

  private boolean CanShoot() {
    if (millis() - _lastSmallShot > _sbCooldownTime) {
      return true;
    }
    return false;
  }
};
