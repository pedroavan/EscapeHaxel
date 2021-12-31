package;

import flixel.FlxSprite;
import flixel.system.FlxSound;

class Obstacle extends FlxSprite
{
	public var dieSound:FlxSound;

	public function new(X:Float, Y:Float, velx:Float)
	{
		super(X, Y);
		dieSound = new FlxSound();
		dieSound.loadEmbedded(AssetPaths.obstacleDie__wav);
		velocity.x = velx;
	}

	override public function kill()
	{
		if (alive)
			dieSound.play(true);
		alive = false;
		solid = false;
	}
}
