package;

import flixel.FlxSprite;

class HealthKit extends FlxSprite
{
	private var levelVelocity:Float;

	public function new(X:Float, Y:Float, velx:Float)
	{
		super(X, Y);
		levelVelocity = velx;
		velocity.x = velx;
		loadGraphic(AssetPaths.healthkit__png, true, 16, 16);
		height = 16;
		width = 16;
		animation.add("rotate", [0, 1, 2, 3], 10, true);
		animation.play("rotate");
	}
}
