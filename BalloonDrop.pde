
class BalloonDrop {
    public PVector _position;
    public BalloonDropType _type;

    protected PVector _direction;
    protected int _speed;
    protected PShape _shape;
    protected color _color;
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