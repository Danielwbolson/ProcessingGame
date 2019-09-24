
class BalloonSpawner {
  
  public ArrayList<Balloon> _balloons;
  
  float fighterOdds = 0.4;
  float carrierOdds = 0.7;
  float screamerOdds = 0.9;
  float armoredOdds = 1.0;
  float difficulty = 0;
  
  
  BalloonSpawner() {
    _balloons = new ArrayList<Balloon>();
  }
  
  public Balloon AddBalloon(PVector shipPos) {

    // Difficulty based on time
    if (millis()/1000.0 < 10) {
      difficulty = 1;
    } else if (millis()/1000.0 < 20) {
      difficulty = 2.0;
    } else {
      difficulty = 3.0;
    }

    float randVal = random(1) + difficulty/30.0;
    PVector pos = new PVector(random(50, 750), 0, 0);
    
    if (randVal < 0.4) {
      return new FighterBalloon(pos, null, difficulty);
    } else if (randVal < 0.7) {
      return new CarrierBalloon(pos, null, difficulty);
    } else if (randVal < 0.9) {
      return new ScreamerBalloon(pos, shipPos, difficulty);
    } else {
      return new ArmoredBalloon(pos, null, difficulty);
    }  
    
  }
  
  
};
