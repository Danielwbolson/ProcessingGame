
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
  
