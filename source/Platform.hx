package;

class Platform extends Obstacle
{
	private var willFall:Bool;
	private var fallSpeed:Int = 140;

	public function new(X:Float, Y:Float, velx:Float, w:Bool)
	{
		super(X, Y, velx);
		loadGraphic(AssetPaths.platform__png);
		height = 16;
		width = 96;
		willFall = w;
		immovable = true;
		solid = true;

		allowCollisions = UP;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (isTouching(UP) && willFall)
		{
			fall();
		}
	}

	public function fall()
	{
		acceleration.y = fallSpeed;
	}
}
