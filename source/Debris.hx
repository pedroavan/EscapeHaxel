package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.system.FlxSound;

class Debris extends Obstacle
{
	public var debrisFallSound:FlxSound;

	private var gravity:Float = 230;
	private var type:Int;

	public function new(X:Float, Y:Float, velx:Float)
	{
		Y = Y - FlxG.random.float() * 128;
		super(X, Y, velx);
		type = FlxG.random.int(0, 2);
		var f = 0;
		switch (type)
		{
			case 0:
				loadGraphic(AssetPaths.debris_big__png, true, 24, 24, false);
				height = 24;
				width = 24;
				f = FlxG.random.int(0, 0);
				animation.add("none", [f]);

			case 1:
				loadGraphic(AssetPaths.debris_small__png, true, 16, 16, false);
				height = 16;
				width = 16;
				f = FlxG.random.int(0, 11);
				animation.add("none", [f]);

			case 2:
				loadGraphic(AssetPaths.debris_medium__png, true, 32, 16, false);
				height = 16;
				width = 32;
				f = FlxG.random.int(0, 3);
				animation.add("none", [f]);
		}

		debrisFallSound = new FlxSound();
		debrisFallSound.loadEmbedded(AssetPaths.debrisFall__wav);

		acceleration.y = gravity + FlxG.random.float() * 50;
		angularVelocity = FlxG.random.float() * 100 + 10;
		animation.play("none");
	}

	override public function update(elapsed:Float)
	{
		if (isTouching(FlxObject.FLOOR))
		{
			velocity.y = -150;
			kill();
		}
		super.update(elapsed);
	}

	public function shot()
	{
		velocity.x += (FlxG.random.float() * 10) + 10;
		angularVelocity = FlxG.random.float() * 150 + 30;
	}

	override public function kill()
	{
		if (solid)
			debrisFallSound.play();
		solid = false;
		FlxFlicker.flicker(this, 0);
	}
}
