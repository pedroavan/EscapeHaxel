package;

import flixel.group.FlxGroup;
import flixel.system.FlxSound;

class BulletManager extends FlxGroup
{
	public var bulletWallSound:FlxSound;

	public function new()
	{
		super();

		for (i in 0...40)
		{
			add(new Bullet(-10, -10));
		}

		bulletWallSound = new FlxSound();
		bulletWallSound.loadEmbedded(AssetPaths.bulletWall__wav);
		bulletWallSound.volume = 0.5;
	}

	public function fire(bx:Float, by:Float)
	{
		if (getFirstAvailable != null)
		{
			(cast(getFirstAvailable(), Bullet)).fire(bx, by);
		}
	}
}
