
class BalloonDrop {
    public PVector _position;
    protected PVector _direction;

    public BalloonDrop(PVector position) {
        _position = position;
    }

    public void Update(float dt) {}

    public void Draw() {}
};

class BackupDrop extends BalloonDrop {

    public BackupDrop(PVector position) {
        super(position);
    }

    public void Update(float dt) {
        
    }

};

class BombDrop extends BalloonDrop {

    public BombDrop(PVector position) {
        super(position);
    }

    public void Update(float dt) {
        
    }

};

class UpgradeDrop extends BalloonDrop{

    public UpgradeDrop(PVector position) {
        super(position);
    }

    public void Update(float dt) {
        
    }

};