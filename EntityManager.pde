
class EntityManager {

  private ArrayList<Balloon> _balloons;
  private ArrayList<Bullet> _bullets;
  private Ship _ship;
  private BalloonSpawner _balloonSpawner;

  public EntityManager() {
    _bullets    = new ArrayList<Bullet>();
    PVector pos = new PVector (400, 700, 0);
    _ship       = new Ship(pos);
    
    _balloonSpawner = new BalloonSpawner();
    _balloons = _balloonSpawner._balloons;
  }

  // Update all of our entities besides cannon as that is handled by the event listener
  public void Update(float dt) {
    for (Balloon b : _balloons) {
      b._position = PVector.add(b._position, PVector.mult(b._direction, b._speed * dt));
      
      color col = b._color;
      b._color = color(red(col), green(col), blue(col), 255 * ((float)b._hp / b._maxHP));
    }
    for (Bullet b : _bullets)   { 
      b._position = PVector.add(b._position, PVector.mult(b._direction, b._speed * dt));
    }
    
    _ship._position = PVector.add(_ship._position, PVector.mult(_ship._direction, _ship._speed * dt));
    if (_ship._slowingDownHorizontal || _ship._slowingDownVertical) {
      _ship.SlowDown();
    }

    BoundsCheck();
    HandleCollisions();
    DespawnEntities();
    SpawnBalloons();
  }
  
  // Waits for user events in regard to the cannon and responds appropriately
  public void EventListener(Event event) {
    switch (event) {
    case shoot: 
      if (_ship.CanShoot()) {
        Bullet b = new SmallBullet(_ship._position);
        _bullets.add(b);
        _ship.Shoot(b);
      }
      break;

    case forward:
      _ship._direction.y = -1;
      _ship._slowingDownVertical = false;
      break;

    case back:
      _ship._direction.y = 1;
      _ship._slowingDownVertical = false;
      break;

    case left:
      _ship._direction.x = -1;
      _ship._slowingDownHorizontal = false;
      break;

    case right:
      _ship._direction.x = 1;
      _ship._slowingDownHorizontal = false;
      break;

    case slowVertical:
      _ship._slowingDownVertical = true;
      break;

    case slowHorizontal:
      _ship._slowingDownHorizontal = true;      
      break;

    default:
      break;
    }
  }

  // Check if our balloons, bullets, or ship have gone outside the window
  private void BoundsCheck() {
    for (int i = _balloons.size()-1; i >= 0; i--) {
      Balloon b = _balloons.get(i);
      if (b._position.y > height) {
        _balloons.remove(i);
      }
    }
    for (int i = _bullets.size()-1; i >= 0; i--) {
      Bullet b = _bullets.get(i);

      if (b._position.x > width || b._position.x < 0) {
        _bullets.remove(i);
        continue;
      }
      if (b._position.y > height || b._position.y < 0) {
        _bullets.remove(i);
      }
    }
    
    if (_ship._position.x > width - _ship._width / 2.0f) {
      _ship._position.x = width - _ship._width / 2.0f;
    }
    if (_ship._position.x < _ship._width / 2.0f) {
      _ship._position.x = _ship._width / 2.0f;
    }
    if (_ship._position.y > height - _ship._height / 2.0f) {
      _ship._position.y = height - _ship._height / 2.0f;
    }
    if (_ship._position.y < _ship._height / 2.0f) {
      _ship._position.y = _ship._height / 2.0f;
    }
  }

  private void HandleCollisions() {
    for (int i = _balloons.size()-1; i >= 0; i--) {
      for (int j = _bullets.size()-1; j >= 0; j--) {
        if (Collision(_bullets.get(j), _balloons.get(i))) {
          _bullets.get(j).LosePower(_balloons.get(i)._hp);
          _balloons.get(i).OnHit(_bullets.get(j)._damage);
        }
      }
    }
  }

  private void SpawnBalloons() {
    if (int(random(30)) == 0) {
      _balloons.add(new Balloon(new PVector(random(50, 750), 0, 0)));
    }
    
    // _balloonSpawner
  }

  private boolean Collision(Bullet bullet, Balloon balloon) {

    // Get Vector from bullet to balloon
    PVector balloonToBullet = PVector.sub(bullet._position, balloon._position);

    // Calculate total distance between balloon and bullet
    float dist = balloonToBullet.mag();

    // If our distance is less than the sum of our radius'
    return (dist < bullet._radius + balloon._radius);
  }

  private void DespawnEntities() {
    for (int i = _balloons.size()-1; i >= 0; i--) {
      if (_balloons.get(i).Popped()) {
        _balloons.remove(i);
      }
    }
    for (int j = _bullets.size()-1; j >= 0; j--) {
      if (_bullets.get(j).OutOfPower()) {
        _bullets.remove(j);
      }
    }
  }
  
};
