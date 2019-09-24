
class ShipBulletTier1 extends Bullet {

  public ShipBulletTier1(PVector position) {
    super(position);
    _damage = 1;
    _damageLeft = _damage;
    _speed = 1000;
    _radius = 4;
    _color = color(0, 255, 255, 255);
  }

  public void Draw() {
    fill(_color);
    ellipseMode(CENTER);
    _shape = createShape(ELLIPSE, _position.x, _position.y, _radius*2, _radius*2);
    shape(_shape);
  }
  
};

class ShipBulletTier2 extends Bullet {

  public ShipBulletTier2(PVector position) {
    super(position);
    _damage = 2;
    _damageLeft = _damage;
    _speed = 1000;
    _radius = 8;
    _color = color(255, 165, 0, 255);
  }

  public void Draw() {
    fill(_color);
    ellipseMode(CENTER);

    _shape = createShape(ELLIPSE, _position.x - _radius/2.0, _position.y, _radius, _radius);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x + _radius/2.0, _position.y, _radius, _radius);
    shape(_shape);
  }
  
};

class ShipBulletTier3 extends Bullet {

  public ShipBulletTier3(PVector position) {
    super(position);
    _damage = 4;
    _damageLeft = _damage;
    _speed = 1000;
    _radius = 16;
    _color = color(255, 255, 0, 255);
  }

  public void Draw() {
    fill(_color);
    ellipseMode(CENTER);

    _shape = createShape(ELLIPSE, _position.x - 3*_radius/4.0, _position.y, _radius/2.0, _radius/2.0);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x - _radius/4.0, _position.y - _radius/4.0, _radius/2.0, _radius/2.0);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x + _radius/4.0, _position.y - _radius/4.0, _radius/2.0, _radius/2.0);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x + 3*_radius/4.0, _position.y, _radius/2.0, _radius/2.0);
    shape(_shape);
  }
  
};

