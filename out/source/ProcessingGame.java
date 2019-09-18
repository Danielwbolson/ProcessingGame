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

  
GameManager _gameManager;

public void setup() {    
  
  
  _gameManager = new GameManager();
  _gameManager.Setup();
}

public void draw() {
  _gameManager.Update();
}

public void keyPressed() {
  _gameManager.HandleKeyPressed(); 
}

public void keyReleased() {
  _gameManager.HandleKeyReleased(); 
}

class Balloon {
  
  protected PShape _shape;
  protected int _color;
  protected int _maxHP;
  protected PVector _direction;
  protected float _speed;
  
  public float _radius;
  public PVector _position;
  public int _hp;

  public Balloon(PVector position) {
    _position = position;
    _direction = new PVector(0, 1, 0);
    
    _color = color(random(255), random(255), random(255), PApplet.parseInt(random(100, 200)));
  }
  
  public void Update(float dt) {}
  
  public void DrawBalloon() {
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

};

// Flies out and shoots roughly in direction of enemy
// Small fast shots
class FighterBalloon extends Balloon {
  
  FighterBalloon(PVector position) {
    super(position);
    _hp = 1;
    _maxHP = _hp;
    
    _radius = 15;
    _speed = 150;
    _color = 0xff4b5320;
  }
  
};

// Tankier Balloon which carries infinite-until-destroyed fighters
class CarrierBalloon extends Balloon {
  
  CarrierBalloon(PVector position) {
    super(position);
    _hp = 10;
    _maxHP = _hp;
        
    _radius = 40;
    _speed = 50;
    
    _color = 0xffd3d3d3;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }
};

// Big tanky balloon which shoots bit shots
class ArmoredBalloon extends Balloon {
  
  ArmoredBalloon(PVector position) {
    super(position);
    _hp = 25;
    _maxHP = _hp;
        
    _radius = 60;
    _speed = 25;
    
    _color = 0xff36454f;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }
  
};

// Races for player hoping for a collision
class ScreamerBalloon extends Balloon {
  
  ScreamerBalloon(PVector position) {
    super(position);
    _hp = 1;
    _maxHP = _hp;
        
    _radius = 10;
    _speed = 250;
    
    _color = 0xff000000;
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    _color = color(red(_color), green(_color), blue(_color), 255 * ((float)_hp / _maxHP));
  }
  
};

class BalloonSpawner {
  
  public ArrayList<Balloon> _balloons;
  
  float fighterOdds = 0.4f;
  float carrierOdds = 0.7f;
  float screamerOdds = 0.9f;
  float armoredOdds = 1.0f;
  
  
  BalloonSpawner() {
    _balloons = new ArrayList<Balloon>();
  }
  
  public Balloon AddBalloon() {

    float randVal = random(1);
    PVector pos = new PVector(random(50, 750), 0, 0);
    
    if (randVal < 0.4f) {
      return new FighterBalloon(pos);
    } else if (randVal < 0.7f) {
      return new CarrierBalloon(pos);
    } else if (randVal < 0.9f) {
      return new ScreamerBalloon(pos);
    } else {
      return new ArmoredBalloon(pos);
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

  public Bullet(PVector position) {
    _position = position;
    _direction = new PVector(0, -1, 0);
  }
  
  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
  }
  
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

class LargeBullet extends Bullet {

  public LargeBullet(PVector position) {
    super(position);
    _damage = 20;
    _damageLeft = _damage;
    _speed = 100;
    _radius = 40;
    _color = color(255, 255, 0, 255);
  }
  
};

class MediumBullet extends Bullet {

  public MediumBullet(PVector position) {
    super(position);
    _damage = 4;
    _damageLeft = _damage;
    _speed = 200;
    _radius = 15;
    _color = color(255, 165, 0, 255);
  }
  
};

class SmallBullet extends Bullet {

  public SmallBullet(PVector position) {
    super(position);
    _damage = 1;
    _damageLeft = _damage;
    _speed = 1000;
    _radius = 4;
    _color = color(0, 255, 255, 255);
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
  private Ship _ship;
  private BalloonSpawner _balloonSpawner;

  public EntityManager() {
    _bullets    = new ArrayList<Bullet>();
    PVector pos = new PVector (400, 700, 0);
    _ship       = new Ship(pos);
    
    _balloonSpawner = new BalloonSpawner();
    _balloons       = _balloonSpawner._balloons;
  }

  // Update all of our entities besides cannon as that is handled by the event listener
  public void Update(float dt) {
    for (Balloon b : _balloons) {
      b.Update(dt);
    }
    for (Bullet b : _bullets)   { 
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
      
    case bomb:
    case backup:
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
    if (PApplet.parseInt(random(random(15, 60))) == 0) {
      _balloons.add(_balloonSpawner.AddBalloon());
    }
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
  smallCooldown(50),
  mediumCooldown(500),
  largeCooldown(2000);
  
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

  GameManager() {
    _entityManager = new EntityManager();
    _uiHandler = new UIHandler(this);
    _gameRenderer = new GameRenderer(_entityManager, _uiHandler);
  }
  
  public void Setup() {    
    _elapsedTime = millis();
  }
  
  public void Update() {
    float dt = calculateDt();
    println(1.0f / dt);
    
    // Update our entities and handle our user input
    // Update UI first so that we can give correct information to our manager
    _uiHandler.HandleInput();
    _entityManager.Update(dt);
    _gameRenderer.Render();
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
  
  GameRenderer(EntityManager em, UIHandler ui) {
    _balloons = em._balloons;
    _bullets = em._bullets;
    _ship = em._ship;

    _buttons = ui._buttons;
  }
  
  public void Render() {
    
    background(100, 150, 255, 200);
    
    for (Balloon b : _balloons) { 
      fill(b._color);
      ellipseMode(CENTER);
      b._shape = createShape(ELLIPSE, b._position.x, b._position.y, b._radius*2, b._radius*2);
      shape(b._shape);
    }
    
    for (Bullet b : _bullets)   { 
      fill(b._color);
      ellipseMode(CENTER);
      b._shape = createShape(ELLIPSE, b._position.x, b._position.y, b._radius*2, b._radius*2);
      shape(b._shape);
    }
    
    for (Button b : _buttons) {
      
      push();
      
      stroke(b._strokeVal);
      strokeWeight(b._strokeWeight);
      fill(b._color);
      rectMode(CENTER);
      b._shape = createShape(RECT, b._position.x, b._position.y, b._radius*2, b._radius*2);
      shape(b._shape); 
      
      pop();
      
    }
    
    fill(_ship._color);
    rectMode(CENTER);
    _ship._shape = createShape(RECT, _ship._position.x, _ship._position.y, _ship._width, _ship._height);
    shape(_ship._shape);
    
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

  private PShape _shape;
  private float _speed = 300;
  private int _sbCooldownTime = CooldownTime.smallCooldown.getCode();
  private int _lastSmallShot;

  public Ship(PVector pos) {
    _position = pos;
    _direction = new PVector(0, 0, 0);
    _color = color(255);
  }

  public void Update(float dt) {
    _position = PVector.add(_position, PVector.mult(_direction, _speed * dt));
    
    if (_slowingDownHorizontal || _slowingDownVertical) {
      SlowDown();
    }
  }
  
  public void Shoot(Bullet bullet) {
    bullet.Shoot(new PVector(0, -1, 0));
    _lastSmallShot = millis();
  }

  public void SlowDown() {    
    if (_slowingDownHorizontal) { _direction.x = _direction.x * 0.9f; }
    if (_slowingDownVertical) { _direction.y = _direction.y * 0.9f; }

    if (abs(_direction.x) < 0.1f) {  _direction.x = 0; }
    if (abs(_direction.y) < 0.1f) {  _direction.y = 0; }
  }

  private boolean CanShoot() {
    if (millis() - _lastSmallShot > _sbCooldownTime) {
      return true;
    }
    return false;
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
