import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ProcessingGame extends PApplet {



// Run with Visual Studio Code:
// Ctrl + Shift + B
GameManager _gameManager;
boolean paused;
float timePaused;
float offset = 0;

public void setup() {    
  
  
  _gameManager = new GameManager();
  _gameManager.Setup();
}

public void draw() {
  _gameManager.Update(offset);
  offset = 0;
}

public void keyPressed() {
  _gameManager.HandleKeyPressed(); 
}

public void keyReleased() {
  _gameManager.HandleKeyReleased(); 
}

public void mouseClicked() {
    if (mouseButton == RIGHT) {
      paused = !paused;

      if (paused) {
        noLoop();
        timePaused = millis()/1000.0f;
      } else {
        loop();
        offset = millis()/1000.0f - timePaused;
      }
    }

  }

class BalloonBulletTier1 extends Bullet {
    
    public BalloonBulletTier1(PVector position) {
        super(position);
    }

};

class BalloonBulletTier2 extends Bullet {
    
    public BalloonBulletTier2(PVector position) {
        super(position);
    }
    
};

class BalloonBulletTier3 extends Bullet {
    
    public BalloonBulletTier3(PVector position) {
        super(position);
    }
    
};

class BalloonDrop {
    public PVector _position;
    public BalloonDropType _type;

    protected PVector _direction;
    protected int _speed;
    protected PShape _shape;
    protected int _color;
    protected int _radius;

    public BalloonDrop(PVector position) {
        _position = position;
        _direction = new PVector(0, 1, 0);
        _speed = 200;
        _radius = 10;
    }

    public void Update(float dt) {
        _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    }

    public void Draw() {
        fill(_color);
        rectMode(CENTER);
        _shape = createShape(RECT, _position.x, _position.y, _radius*2, _radius*2);
        shape(_shape); 
    }

};

class BackupDrop extends BalloonDrop {

    public BackupDrop(PVector position) {
        super(position);
        _color = color(0, 0, 255, 255);
        _type = BalloonDropType.backup;
    }

};

class UpgradeDrop extends BalloonDrop{

    public UpgradeDrop(PVector position) {
        super(position);
        _color = color(0, 255, 0, 255);
        _type = BalloonDropType.upgrade;
    }

};

class BalloonSpawner {
  
  public ArrayList<Balloon> _balloons;
  
  float fighterOdds = 0.4f;
  float carrierOdds = 0.7f;
  float screamerOdds = 0.9f;
  float armoredOdds = 1.0f;
  float difficulty = 0;
  
  
  BalloonSpawner() {
    _balloons = new ArrayList<Balloon>();
  }
  
  public Balloon AddBalloon(PVector shipPos) {

    // Difficulty based on time
    if (millis()/1000.0f < 10) {
      difficulty = 1;
    } else if (millis()/1000.0f < 20) {
      difficulty = 2.0f;
    } else {
      difficulty = 3.0f;
    }

    float randVal = random(1) + difficulty/30.0f;
    PVector pos = new PVector(random(50, 750), 0, 0);
    
    if (randVal < 0.4f) {
      return new FighterBalloon(pos, null, difficulty);
    } else if (randVal < 0.7f) {
      return new CarrierBalloon(pos, null, difficulty);
    } else if (randVal < 0.9f) {
      return new ScreamerBalloon(pos, shipPos, difficulty);
    } else {
      return new ArmoredBalloon(pos, null, difficulty);
    }  
    
  }
  
  
};

class Bullet {

  protected int _damageLeft;
  protected int _speed;
  protected PShape _shape;
  protected int _color;

  public float _radius;
  public int _damage;
  public PVector _position;

  private PVector _direction;

  public Bullet() {}

  public Bullet(PVector position) {
    _position = position;
    _direction = new PVector(0, -1, 0);
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
  }

  public void Draw() {}
  
  public void Shoot(PVector direction) {
    _direction = direction;
  }

  public void LosePower(int hp) {
    _damageLeft = _damageLeft - hp;
  }

  public boolean OutOfPower() {
    return _damageLeft < 1;
  }
  
};

class Button {
  
  public int _strokeWeight;
  public int _strokeVal;
  
  protected PVector _position;
  protected PShape _shape;
  protected int _radius;
  protected int _color;
  protected Event _event;
  protected char keyBind; 
  
  private int _activeOffset = 80;
  
  public Button(PVector position, int radius, int c) {
    _position = position;
    _radius = radius;
    _color = c;
    _strokeWeight = 1;
    _strokeVal = 0;
  }

  public void Draw() {      
    push();
    
    stroke(_strokeVal);
    strokeWeight(_strokeWeight);
    fill(_color);
    rectMode(CENTER);
    _shape = createShape(RECT, _position.x, _position.y, _radius*2, _radius*2);
    shape(_shape); 
    
    pop();
  }
  
  // Check if the user has clicked inside our button
  public boolean IsClicked(PVector pos) {
    PVector diff = PVector.sub(pos, _position);
    if (sqrt(diff.x*diff.x + diff.y*diff.y) < _radius) {
      return true;
    }
    return false;
  }
  
  public Event Clicked() {
    return _event;
  }
  
  public void NotActive() {
    _strokeWeight = 1;
    _strokeVal = 0;
    _color = color(red(_color)+_activeOffset, green(_color)+_activeOffset, blue(_color)+_activeOffset, alpha(_color));
  }
  
  public void Active() {
    _strokeWeight = 4;
    _strokeVal = 255;
    _color = color(red(_color)-_activeOffset, green(_color)-_activeOffset, blue(_color)-_activeOffset, alpha(_color));
  }
  
};


class BombButton extends Button {
 
  BombButton(PVector position, int radius, int c) {
    super(position, radius, c);
    _event = Event.bomb;
  }
  
};


class BackupButton extends Button {
 
  BackupButton(PVector position, int radius, int c) {
    super(position, radius, c);
    _event = Event.backup;
  }
  
};

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
    if (PApplet.parseInt(random(30)) == 0) {
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

public enum BalloonDropType {
  backup,
  upgrade
};

public enum BulletType {
  shipTier1,
  shipTier2,
  shipTier3,
  balloonTier1,
  balloonTier2,
  balloonTier3;

  public static BulletType[] vals = values();
  public BulletType Next() {
    return vals[ordinal() + 1];
  }
};

enum Event {
  shoot,
  forward,
  left,
  right,
  back,
  slowHorizontal,
  slowVertical,
  bomb,
  backup
};

// Shot cooldowns in milliseconds
// I want an enum so that values can be shared amongst classes and only changed in one place
enum CooldownTime {
  shotCooldown(50),
  backupCooldown(500),
  bombCooldown(2000);
  
  private final int _code;
  private CooldownTime (int code) {
    _code = code;
  }
  
  public int getCode() { return _code; }
};
  

class GameManager {
  
  private EntityManager _entityManager;
  private UIHandler _uiHandler;
  private GameRenderer _gameRenderer;
  private float _elapsedTime;

  private int _lives = 5;

  GameManager() {
    _entityManager = new EntityManager();
    _uiHandler = new UIHandler(this);
    _gameRenderer = new GameRenderer(_entityManager, _uiHandler);
  }
  
  public void Setup() {    
    _elapsedTime = millis();
  }
  
  public void Update(float offset) {
    float dt = calculateDt() - offset;
    println(dt);
    
    // Update our entities and handle our user input
    // Update UI first so that we can give correct information to our manager
    _uiHandler.HandleInput();

    _entityManager.Update(dt);
    _lives = _lives - _entityManager._hits;

    _gameRenderer.Render(_lives);

    if (_lives <= 0) {
      noLoop();
      _gameRenderer.Lose();
    }
  }
  
  public void EventListener(Event event) {
    switch (event) {
    case shoot: 
    case forward:
    case back:
    case left:
    case right:
    case slowVertical:
    case slowHorizontal:
      _entityManager.EventListener(event);
      break;
      
    case bomb:
    case backup:
      break;

    default:
      break;
    }
  }
  
  public void HandleKeyPressed() {
    _uiHandler.HandleKeyPressed();
  }
  
  public void HandleKeyReleased() {
    _uiHandler.HandleKeyReleased(); 
  }
  
  private float calculateDt() {
    float currTime = millis();
    float dt = (currTime - _elapsedTime) / 1000.0f;
    _elapsedTime = currTime;
    return dt;
  }
  
};

class GameRenderer {
  
  private ArrayList<Balloon> _balloons;
  private ArrayList<Bullet> _bullets;
  private Ship _ship;
  private ArrayList<Button> _buttons;
  private ArrayList<BalloonDrop> _balloonDrops;
  
  GameRenderer(EntityManager em, UIHandler ui) {
    _balloons = em._balloons;
    _bullets  = em._bullets;
    _ship     = em._ship;
    _balloonDrops = em._balloonDrops;
    _buttons  = ui._buttons;
  }
  
  public void Render(int lives) {
    
    background(100, 150, 255, 200);
    
    for (Balloon b : _balloons) { 
      b.Draw();
    }
    
    for (Bullet b : _bullets)   { 
      b.Draw();
    }
    
/*     for (Button b : _buttons) {
      b.Draw();      
    } */

    for (BalloonDrop b : _balloonDrops) {
      b.Draw();
    }

    _ship.Draw();  

    textSize(32);
    text(lives + " lives", 25, 750);  
  }

  public void Lose() {
    background(0, 0, 0, 255);
    textSize(60);
    textAlign(CENTER);
    text("You lose!", width/2, height/2);
  }
  
};

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

    _shape = createShape(ELLIPSE, _position.x - _radius/2.0f, _position.y, _radius, _radius);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x + _radius/2.0f, _position.y, _radius, _radius);
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

    _shape = createShape(ELLIPSE, _position.x - 3*_radius/4.0f, _position.y, _radius/2.0f, _radius/2.0f);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x - _radius/4.0f, _position.y - _radius/4.0f, _radius/2.0f, _radius/2.0f);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x + _radius/4.0f, _position.y - _radius/4.0f, _radius/2.0f, _radius/2.0f);
    shape(_shape);

    _shape = createShape(ELLIPSE, _position.x + 3*_radius/4.0f, _position.y, _radius/2.0f, _radius/2.0f);
    shape(_shape);
  }
  
};


class UIHandler {

  private GameManager _gameManager;
  private ArrayList<Button> _buttons;
  private Button _activeButton;

  // Key Presses
  boolean pressedW;
  boolean pressedA;
  boolean pressedS;
  boolean pressedD;
  boolean pressed1;
  boolean pressed2;

  public UIHandler(GameManager gm) {
    _gameManager = gm;
    _buttons = new ArrayList<Button>();
    
    _buttons.add(new BackupButton(new PVector(30, 715, 0), 25, color(255, 0, 255, 255)));
    _buttons.add(new BombButton(new PVector(30, 770, 0), 25, color(0, 255, 255, 255)));
  }

  public void HandleInput() {
    PVector mousePos = new PVector(mouseX, mouseY, 0);

    if (mousePressed && (mouseButton == LEFT)) {
      
      boolean buttonClicked = false;
      
      for (Button b : _buttons) {
        if (b.IsClicked(mousePos)) {
          Event event = b.Clicked();
          _gameManager.EventListener(event);
          
          if (_activeButton != null) {
            _activeButton.NotActive();
          }
          _activeButton = b;
          _activeButton.Active();
          
          buttonClicked = true;
          break;
        }
      }
      
      if (!buttonClicked) {
        _gameManager.EventListener(Event.shoot);
      }      
    }
    
    KeyEvents();

  }

  private void KeyEvents() {
    if (pressedW) { _gameManager.EventListener(Event.forward); }
    if (pressedA) { _gameManager.EventListener(Event.left); }
    if (pressedS) { _gameManager.EventListener(Event.back); }
    if (pressedD) { _gameManager.EventListener(Event.right); }
    
    if (!pressedW && !pressedS) { _gameManager.EventListener(Event.slowVertical); }
    if (!pressedA && !pressedD) { _gameManager.EventListener(Event.slowHorizontal); }
    
    if (pressed1) { _gameManager.EventListener(Event.backup); }
    if (pressed2) { _gameManager.EventListener(Event.bomb); }

  }

  private void HandleKeyPressed() {
    if (key == 'w' || key == 'W') { pressedW = true; }
    if (key == 'a' || key == 'A') { pressedA = true; }
    if (key == 's' || key == 'S') { pressedS = true; }
    if (key == 'd' || key == 'D') { pressedD = true; }
    if (key == '1' || key == '!') { pressed1 = true; }
    if (key == '2' || key == '@') { pressed2 = true; }
  }

  private void HandleKeyReleased() {
    if (key == 'w' || key == 'W') { pressedW = false; }
    if (key == 's' || key == 'S') { pressedS = false; }
    if (key == 'a' || key == 'A') { pressedA = false; }
    if (key == 'd' || key == 'D') { pressedD = false; }
    if (key == '1' || key == '!') { pressed1 = false; }
    if (key == '2' || key == '@') { pressed2 = false; }
  }

};

class Balloon {
  
  protected PShape _shape;
  protected int _color;
  protected int _maxHP;
  protected PVector _direction;
  protected PVector _destination;
  protected float _speed;
  protected float _aggression;
  
  public float _radius;
  public PVector _position;
  public int _hp;

  public Balloon(PVector position, PVector destination, float aggression) {
    _position = position;
    _aggression = aggression;

    if (destination != null) {
      _destination = destination;
      _direction = PVector.sub(_destination, _position).normalize();
    } else {
      _direction = new PVector(0, 1, 0);
    }
    
    _color = color(random(255), random(255), random(255), PApplet.parseInt(random(100, 200)));
  }
  
  public void Update(float dt) {}

  public void Draw() {      
    fill(_color);
    ellipseMode(CENTER);
    _shape = createShape(ELLIPSE, _position.x, _position.y, _radius*2, _radius*2);
    shape(_shape);
  }
  
  public void OnHit(int damage) {
    _hp = _hp - damage;
  }
  
  public boolean Popped() {
	  return _hp < 1;
  }

  public boolean DropOnPop() {
    if (PApplet.parseInt(random(10)) == 0) {
      return true;
    }
    return false;
  }

  public BalloonDrop Drop() {
    int dropIndex = PApplet.parseInt(random(2));
    if (dropIndex == 0) {
      return new UpgradeDrop(_position);
    } else {
      return new BackupDrop(_position);
    } 
  }

};

// Flies out and shoots roughly in direction of enemy
// Small fast shots
class FighterBalloon extends Balloon {
  
  FighterBalloon(PVector position, PVector destination, float aggression) {
    super(position, destination, aggression);
    _hp = 2;
    _maxHP = _hp;
    
    _radius = 15;
    _speed = 150;
    _color = 0xff4b5320;
  }

    public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt * _aggression));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }
  
};

// Tankier Balloon which carries infinite-until-destroyed fighters
class CarrierBalloon extends Balloon {
  
  CarrierBalloon(PVector position, PVector destination, float aggression) {
    super(position, destination, aggression);
    _hp = 20;
    _maxHP = _hp;
        
    _radius = 40;
    _speed = 40;
    
    _color = 0xffd3d3d3;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt * _aggression));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }

};

// Big tanky balloon which shoots bit shots
class ArmoredBalloon extends Balloon {
  
  ArmoredBalloon(PVector position, PVector destination, float aggression) {
    super(position, destination, aggression);
    _hp = 50;
    _maxHP = _hp;
        
    _radius = 60;
    _speed = 10;
    
    _color = 0xff36454f;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt * _aggression));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }
  
};

// Races for player hoping for a collision
class ScreamerBalloon extends Balloon {
  
  ScreamerBalloon(PVector position, PVector destination, float aggression) {
    super(position, destination, aggression);
    _hp = 1;
    _maxHP = _hp;
        
    _radius = 10;
    _speed = 250;
    
    _color = 0xff000000;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt * _aggression));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }
   
};

class Ship {

  public PVector _position;
  public PVector _direction;
  public boolean _slowingDownVertical;
  public boolean _slowingDownHorizontal;
  public int _width = 20;
  public int _height = 40;
  public int _color;
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

    if (abs(_direction.x) < 0.1f) {  _direction.x = 0; }
    if (abs(_direction.y) < 0.1f) {  _direction.y = 0; }
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
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcessingGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
