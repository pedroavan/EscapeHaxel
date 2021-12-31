package;

import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitter;

class Door extends Obstacle
{
	private var explode:FlxEmitter;

	public function new(X:Float, Y:Float, velx:Float)
	{
		super(X, Y, velx);
		health = 6;

		loadGraphic(AssetPaths.door__png, true, 16, 64, false);
		width = 16;
		height = 64;
		immovable = true;
		animation.add("destroyed", [1]);

		explode = new FlxEmitter(x, y, 12);

		explode.height = height;
		explode.width = width;
		explode.acceleration.set(0, 500);
		explode.velocity.set(-320, -50, 0, 50);

		for (i in 0...12)
		{
			var particle:DoorParticle = new DoorParticle();
			explode.add(particle);
		}

		Registry.particleLayer.add(explode);
	}

	override public function update(elapsed:Float)
	{
		explode.x = x;
		explode.y = y;
		super.update(elapsed);
	}

	override public function hurt(damage:Float)
	{
		if (alive)
		{
			super.hurt(damage);
			FlxFlicker.flicker(this, 0.3);
		}
	}

	override public function kill()
	{
		explode.start(true);
		animation.play("destroyed");
		super.kill();
	}

	override public function destroy()
	{
		Registry.particleLayer.remove(explode);
		explode.destroy();
		super.destroy();
	}
}
