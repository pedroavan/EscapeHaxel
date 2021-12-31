package;

class Flyer extends Enemy
{
	private var levelVelocity:Float;
	private var flyVelocity:Float = -50 + Registry.runSpeed;
	private var descendXVelocity:Float = -25;
	private var descendYVelocity:Float = 100;

	public function new(X:Float, Y:Float, velx:Float)
	{
		super(X, Y, velx);
		levelVelocity = velx;
		velocity.x = velx + flyVelocity;
		loadGraphic(AssetPaths.alien_flying__png, true, 48, 40, false);
		animation.add("fly", [0, 1, 2], 8);
		animation.add("die", [3, 4, 5, 6, 7], 16, false);
		height = 16;
		width = 30;

		offset.y = 16;
		offset.x = 10;
		health = 2;

		animation.play("fly");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override public function kill()
	{
		super.kill();
		animation.play("die");
	}
}
