
class EntityManager {

  private ArrayList<Balloon> _balloons;
  private ArrayList<Bullet> _bullets;
  private ArrayList<BalloonDrop> _balloonDrops;
  private Ship _ship;
  private BalloonSpawner _balloonSpawner;

  public int _hits = 0;

  public EntityManager() {
    _balloonSpawner = new BalloonSpawner();
    _balloons       = _balloonSpawner._balloons;

    _bullets        = new ArrayList<Bullet>();
    _balloonDrops   = new ArrayList<BalloonDrop>();
    PVector pos     = new PVector (400, 700, 0);
    _ship           = new Ship(pos);
  }

  // Update all of our entities besides cannon as that is handled by the event listener
  public void Update(float dt) {
    for (Balloon b : _balloons) {
      b.Update(dt);
    }
    for (Bullet b : _bullets)   { 
      b.Update(dt);
    }
    for (BalloonDrop b : _balloonDrops) {
      b.Update(dt);
    }
    _ship.Update(dt);

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
        Bullet b = _ship.LoadedBullet();
        _ship.Shoot(b);
        _bullets.add(b);
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
      
    case bomb:
    case backup:
      break;

    default:
      break;
    }
  }

  // Check if our balloons, bullets, or ship have gone outside the window
  private void BoundsCheck() {
    _hits = 0;
    
    for (int i = _balloons.size()-1; i >= 0; i--) {
      Balloon b = _balloons.get(i);
      if (b._position.y > height) {
        _balloons.remove(i);
        _hits = _hits + 1;
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
        Bullet bu = _bullets.get(j);
        Balloon ba = _balloons.get(i);
        if (Collision(bu._position, bu._radius, ba._position, ba._radius)) {
          _bullets.get(j).LosePower(_balloons.get(i)._hp);
          _balloons.get(i).OnHit(_bullets.get(j)._damage);
        }
      }
    }

    for (int i = _balloonDrops.size()-1; i >= 0; i--) {
      BalloonDrop b = _balloonDrops.get(i);

      if (Collision(_ship._position, _ship._width, b._position, b._radius)) {
        _ship.GetDrop(b._type);
        _balloonDrops.remove(i);
      }
      
    }
  }

  private void SpawnBalloons() {   
    if (int(random(30)) == 0) {
      _balloons.add(_balloonSpawner.AddBalloon(_ship._position));
    }
  }

  private boolean Collision(PVector pos1, float radius1, PVector pos2, float radius2) {

    // Get Vector from bullet to balloon
    PVector ptop = PVector.sub(pos1, pos2);

    // Calculate total distance between balloon and bullet
    float dist = ptop.mag();

    // If our distance is less than the sum of our radius'
    return (dist < radius1 + radius2);
  }

  private void DespawnEntities() {
    for (int i = _balloons.size()-1; i >= 0; i--) {
      if (_balloons.get(i).Popped()) {
        if (_balloons.get(i).DropOnPop()) {
          BalloonDrop b = _balloons.get(i).Drop();
          _balloonDrops.add(b);
        }
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
