package;

import flixel.effects.FlxFlicker;

class Enemy extends Obstacle
{
	private var hurtCounter:Float = 0;
	private var hurtMax:Float = 0.5;
	private var hurtRecover:Float = 8;

	public function new(X:Float, Y:Float, velx:Float)
	{
		super(X, Y, velx);
		dieSound.loadEmbedded(AssetPaths.enemyDie__wav);
		immovable = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (hurtCounter > 0)
			hurtCounter -= elapsed * hurtRecover;
		else
			FlxFlicker.stopFlickering(this);
	}

	override public function hurt(Damage:Float)
	{
		if (alive)
		{
			if (hurtCounter <= 0)
			{
				health -= Damage;
				if (health <= 0)
				{
					kill();
					Registry.scoreEnemies++;
				}
				else
				{
					hurtCounter = hurtMax;
					FlxFlicker.flicker(this, 0);
				}
			}
		}
	}
}
