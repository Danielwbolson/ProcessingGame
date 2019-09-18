
class GameRenderer {
  
  private ArrayList<Balloon> _balloons;
  private ArrayList<Bullet> _bullets;
  private Ship _ship;
  private ArrayList<Button> _buttons;
  private ArrayList<_balloonDrops> _balloonDrops;
  
  GameRenderer(EntityManager em, UIHandler ui) {
    _balloons = em._balloons;
    _bullets  = em._bullets;
    _ship     = em._ship;
    _balloonDrops = em._balloonDrops;
    _buttons  = ui._buttons;
  }
  
  public void Render() {
    
    background(100, 150, 255, 200);
    
    for (Balloon b : _balloons) { 
      b.Draw();
    }
    
    for (Bullet b : _bullets)   { 
      b.Draw();
    }
    
    for (Button b : _buttons) {
      b.Draw();      
    }

    for (BalloonDrop b : _balloonDrops) {
      b.Draw();
    }

    _ship.Draw();    
  }
  
};
