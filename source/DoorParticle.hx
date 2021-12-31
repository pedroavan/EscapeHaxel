package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;

class DoorParticle extends FlxParticle
{
	public function new()
	{
		super();
		loadGraphic(AssetPaths.door_debris__png, true, 8, 8);
		animation.add("none", [FlxG.random.int(0, 7)]);
		animation.play("none");
		exists = false;
	}
}
