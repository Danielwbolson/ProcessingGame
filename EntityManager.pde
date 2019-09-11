
class EntityManager {

  private ArrayList<Balloon> _balloons;
  private ArrayList<Bullet> _bullets;
  private Cannon _cannon;
  private PVector _cannonPos;

  public EntityManager() {
    _balloons = new ArrayList<Balloon>();
    _bullets = new ArrayList<Bullet>();
    _cannonPos = new PVector (400, 700, 0);
    _cannon = new Cannon(_cannonPos, new PVector(0, -1, 0));
  }

  // Update all of our entities besides cannon as that is handled by the event listener
  public void Update(float dt) {

    // Spawn any new balloons this frame
    SpawnBalloons();

    for (Balloon b : _balloons) {
      b.Update(dt);
    }
    for (Bullet b : _bullets) {
      b.Update(dt);
    }

    // Check for out of bounds
    BoundsCheck();

    // Check for collisions
    HandleCollisions();

    // Kill off our entities that shouldn't exist
    DespawnEntities();
  }

  // Draw all of our entities
  public void DrawEntities() {
    for (Balloon b : _balloons) {
      b.DrawBalloon();
    }
    for (Bullet b : _bullets) {
      b.DrawBullet();
    }
    _cannon.DrawCannon();
  }

  // Aim our cannon as dictated by our UIHandler
  public void AimCannon(PVector position) {
    _cannon.Aim(position);
  }

  // Waits for user events in regard to the cannon and responds appropriately
  public void EventListener(Event event) {

    switch (event) {

    case shoot:
      // Attempt to shoot our cannon
      Bullet b = _bullets.get(_bullets.size()-1);
      _cannon.Shoot(b);

      {
        // Queue up another of our most recently used bullet
        switch(b._bulletType) {
        case small:
          _bullets.add(new SmallBullet(_cannonPos));
          break;

        case medium:
          _bullets.add(new MediumBullet(_cannonPos));
          break;

        case large:
          _bullets.add(new LargeBullet(_cannonPos));
          break;

        default:
          _bullets.add(new SmallBullet(_cannonPos));
          break;
        }
      }

      break;

    case loadSmall:
      // Dump our current bullet and load the wanted one
      if (_bullets.size() != 0) {
        _bullets.remove(_bullets.size()-1);
      }
      // Load up our new bullet
      _bullets.add(new SmallBullet(_cannonPos));
      break;

    case loadMedium:
      if (_bullets.size() != 0) {
        _bullets.remove(_bullets.size()-1);
      }
      _bullets.add(new MediumBullet(_cannonPos));
      break;

    case loadLarge:
      if (_bullets.size() != 0) {
        _bullets.remove(_bullets.size()-1);
      }
      _bullets.add(new LargeBullet(_cannonPos));
      break;

    default:
      break;
    }
  }

  // Check if our balloons or bullets have gone outside the window and if so delete them
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
  }

  // Handle collisions between balloons and bullets
  private void HandleCollisions() {
    for (int i = _balloons.size()-1; i >= 0; i--) {
      for (int j = _bullets.size()-1; j >= 0; j--) {
        if (Collision(_bullets.get(j), _balloons.get(i))) {
          _balloons.get(i).OnHit(_bullets.get(j)._damage);
          _bullets.get(j).LosePower();
        }
      }
    }
  }

  // Spawn balloons
  private void SpawnBalloons() {
    if (int(random(15)) == 0) {
      _balloons.add(new Balloon(new PVector(random(50, 750), 0, 0)));
    }
  }

  // Hits between a bullet and balloon
  private boolean Collision(Bullet bullet, Balloon balloon) {

    // Get Vector from bullet to balloon
    PVector balloonToBullet = PVector.sub(bullet._position, balloon._position);

    // Calculate total distance between balloon and bullet
    float dist = balloonToBullet.mag();

    // If our distance is less than the sum of our radius'
    return (dist < bullet._radius + balloon._radius);
  }

  // Despawn our necessary entities
  private void DespawnEntities() {
    for (int i = _balloons.size()-1; i >= 0; i--) {

      if (_balloons.get(i).Popped()) {
        print("i: " + i);
        _balloons.remove(i);
      }
    }
    for (int j = _bullets.size()-1; j >= 0; j--) {


      if (_bullets.get(j).OutOfPower()) {
        print("j: " + j);
        _bullets.remove(j);
      }
    }
  }
};
