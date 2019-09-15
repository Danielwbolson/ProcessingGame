
class BalloonSpawner {
  
  public ArrayList<Balloon> _balloons;
  
  float fighterOdds = 0.4;
  float carrierOdds = 0.7;
  float screamerOdds = 0.9;
  float armoredOdds = 1.0;
  
  
  BalloonSpawner() {
    _balloons = new ArrayList<Balloon>();
  }
  
  public Balloon AddBalloon() {

    float randVal = random(1);
    PVector pos = new PVector(random(50, 750), 0, 0);
    
    if (randVal < 0.4) {
      return new FighterBalloon(pos);
    } else if (randVal < 0.7) {
      return new CarrierBalloon(pos);
    } else if (randVal < 0.9) {
      return new ScreamerBalloon(pos);
    } else {
      return new ArmoredBalloon(pos);
    }  
    
  }
  
  
};
