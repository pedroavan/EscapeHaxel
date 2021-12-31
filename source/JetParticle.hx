package;

import flixel.effects.particles.FlxParticle;

class JetParticle extends FlxParticle
{
	public function new()
	{
		super();
		loadGraphic(AssetPaths.jet__png, true, 8, 8);
		animation.add("fire", [0, 1, 2, 3, 4, 5], 20, false);
		animation.add("stop", [5]);
		animation.play("fire");
		exists = false;
	}

	override public function update(elapsed:Float)
	{
		if (exists && !animation.finished)
			animation.play("fire");

		super.update(elapsed);
	}

	override public function kill()
	{
		animation.play("stop");
		super.kill();
	}
}
