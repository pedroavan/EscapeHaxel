package;

class Zombie extends Enemy
{
	private var levelVelocity:Float;

	public function new(X:Float, Y:Float, velx:Float)
	{
		super(X, Y, velx);
		levelVelocity = velx;
		velocity.x = velx;
		loadGraphic(AssetPaths.zombie__png, true, 48, 48, false);
		animation.add("idle", [0, 1, 2, 3], 8);
		animation.add("die", [4, 5, 6, 7], 8, false);
		height = 36;
		width = 16;

		offset.y = 12;
		offset.x = 28;
		health = 3;

		animation.play("idle");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override public function kill()
	{
		animation.play("die");
		super.kill();
	}
}
