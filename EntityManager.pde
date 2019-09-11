
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
    if (int(random(15)) == 0) {
      _balloons.add(new Balloon(new PVector(random(50, 750), 0, 0)));
    }
    
    for (Balloon b : _balloons) {
      b.Update(dt);
    }
    for (Bullet b : _bullets) {
      b.Update(dt);
    }
    
    // Check for out of bounds
    BoundsCheck();
    
    // Check for collisions
    
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
    for (int i = _balloons.size()-1; i > 0; i--) {
      Balloon b = _balloons.get(i);
      if (b._position.y > height) {
        _balloons.remove(i);
      }
    }
    for (int i = _bullets.size()-1; i > 0; i--) {
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
  
};
