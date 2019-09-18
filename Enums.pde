
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
  
