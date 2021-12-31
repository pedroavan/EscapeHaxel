package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Bullet extends FlxSprite
{
	private var speed:Int = 220 + Registry.runSpeed;

	public var damage:Int = 1;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(0, 0);
		loadGraphic(AssetPaths.bullet__png, true, 8, 8);
		width = 4;
		height = 2;
		offset.x = 3;
		offset.y = 2;
		animation.add("shot", [0]);
		animation.add("destroy", [1, 2, 3, 4, 5], 30, false);
		exists = false;
	}

	public function fire(bx:Float, by:Float)
	{
		animation.play("shot");
		x = bx;
		y = FlxG.random.float() * 4 - 2 + by;
		velocity.x = speed;
		exists = true;
		alive = true;
	}

	override public function update(elapsed:Float)
	{
		if (exists && !isOnScreen())
		{
			exists = false;
		}

		if (animation.finished && !alive)
		{
			exists = false;
		}

		if (isTouching(FlxObject.WALL))
		{
			kill();
		}

		super.update(elapsed);
	}

	override public function kill()
	{
		Registry.bulletManager.bulletWallSound.play(true);
		alive = false;
		animation.play("destroy");
	}
}
