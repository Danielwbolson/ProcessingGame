
class Ship {
  
  public PVector _position;
  public PVector _direction;
  
  private PShape _shape;
  private int _width = 10;
  private int _height = 20;
  
  private BulletType _lastBullet;
  
  private int _sbCooldownTime = CooldownTime.smallCooldown.getCode();
  private int _mbCooldownTime = CooldownTime.mediumCooldown.getCode();
  private int _lbCooldownTime = CooldownTime.largeCooldown.getCode();
  private int _lastSmallShot;
  private int _lastMediumShot;
  private int _lastLargeShot;
  
  public Ship(PVector pos, PVector dir) {
    _position = pos;
    _direction = dir;
    rectMode(CENTER);
    _shape = createShape(RECT, _position.x, _position.y, _width, _height);
  }
  
  public void DrawShip() {
    fill(255);
    shape(_shape);
  }
  
  public void Aim(PVector dir) {
    _direction = (PVector.sub(dir, _position)).normalize();
  }
  
  public void Shoot(Bullet bullet) {
    if (CanShoot(bullet._bulletType)) {
      bullet.Shoot(_direction);
      
      _lastBullet = bullet._bulletType;
      Cooldown(_lastBullet);
    }
  }
  
  private boolean CanShoot(BulletType bt) {
    switch(bt) {
      
      case small:
        if (millis() - _lastSmallShot > _sbCooldownTime) {
          return true;
        }
        return false;
        
      case medium:
        if (millis() - _lastMediumShot > _mbCooldownTime) {
          return true;
        }
        return false;
        
      case large:
        if (millis() - _lastLargeShot > _lbCooldownTime) {
            return true;
        }
        return false;
        
      default:
        return true;
        
    }
  }
  
  private void Cooldown(BulletType bt) {
    switch(bt) {
      
      case small:
        _lastSmallShot = millis();
        break;
        
      case medium:
        _lastMediumShot = millis();
        break;
        
      case large:
        _lastLargeShot = millis();
        break;
        
     default:
       break;
    }
  }
  
};
