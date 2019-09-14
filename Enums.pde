
// Events from our ui handler to communicate with our entitymanager
enum Event {
  shoot,
  forward,
  left,
  right,
  back,
  slowHorizontal,
  slowVertical,
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
  
