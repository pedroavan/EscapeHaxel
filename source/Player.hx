package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.postprocess.Shader;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
	private var bulletSound:FlxSound;
	private var emptySound:FlxSound;
	private var jetSound:FlxSound;
	private var damageSound:FlxSound;
	private var deathSound:FlxSound;
	private var healthSound:FlxSound;

	private var gravity:Float = 600;
	private var impulse:Float = -400;

	public var maxHealth:Int = 5;

	private var hurtCounter:Float = 0;
	private var hurtMax:Float = 4;
	private var hurtRecover:Float = 5;

	public var fuel:Float;
	public var maxFuel:Float = 32;

	private var fuelUse:Float = 40;
	private var fuelRechargeAir:Float = 20;
	private var fuelRechargeGround:Float = 60;

	private var jetSoundDelay:Float = 0;

	public var bullets:Float;
	public var maxBullets:Float = 16;

	private var bulletsCooldown:Float;
	private var maxBulletsCooldown:Float = 2;
	private var bulletsDelay:Float = 30;
	private var bulletsRecharge:Float = 20;

	public var velX:Float = -5 + Registry.runSpeed;

	private var velXWalking:Float = 20 + Registry.runSpeed;
	private var velXWalkingBack:Float = -20 + Registry.runSpeed;
	private var velXFlying:Float = 50 + Registry.runSpeed;
	private var velXFlyingBack:Float = -50 + Registry.runSpeed;

	private var jet:FlxEmitter;
	private var explosion:FlxEmitter;

	private var floating:Bool = false;
	private var falling:Bool = false;
	private var shooting:Bool = false;

	public var stopped:Bool = false;

	public function new()
	{
		super(0, 96);
		fuel = maxFuel;
		bullets = maxBullets;
		bulletsCooldown = maxBulletsCooldown;
		loadGraphic(AssetPaths.player__png, true, 32, 48, false);
		width = 16;
		height = 36;
		offset.x = 12;
		offset.y = 12;
		acceleration.y = gravity;
		maxVelocity.y = 300;
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7], 18);
		animation.add("float", [8, 9, 8, 10], 8);
		animation.add("stop", [11]);
		animation.add("falling", [5]);

		animation.add("gun_run", [16, 17, 18, 19, 20, 21, 22, 23], 18);
		animation.add("gun_float", [12, 13, 12, 14], 8);
		animation.add("gun_stop", [15]);
		animation.add("gun_falling", [21]);

		bulletSound = new FlxSound();
		bulletSound.loadEmbedded(AssetPaths.shoot__wav);

		emptySound = new FlxSound();
		emptySound.loadEmbedded(AssetPaths.empty__wav);

		jetSound = new FlxSound();
		jetSound.loadEmbedded(AssetPaths.jet__wav, true);

		damageSound = new FlxSound();
		damageSound.loadEmbedded(AssetPaths.damage__wav);

		deathSound = new FlxSound();
		deathSound.loadEmbedded(AssetPaths.death__wav);

		healthSound = new FlxSound();
		healthSound.loadEmbedded(AssetPaths.getHealth__wav);

		jet = new FlxEmitter(x - 3, y + 12, 40);

		jet.acceleration.set(0, 50);
		jet.launchMode = FlxEmitterMode.SQUARE;
		jet.velocity.set(-100 + Registry.runSpeed, 10, -5 + Registry.runSpeed, 25);

		for (i in 0...40)
		{
			var jetpar:JetParticle = new JetParticle();
			jet.add(jetpar);
		}

		jet.start(false, 0.02, 0);
		jet.emitting = false;

		explosion = new FlxEmitter(0, 0, 40);
		explosion.acceleration.set(0, 50);
		explosion.launchMode = FlxEmitterMode.SQUARE;
		explosion.velocity.set(-70 + Registry.runSpeed, 70, -70 + Registry.runSpeed, 70);

		for (j in 0...40)
		{
			var expar:JetParticle = new JetParticle();
			explosion.add(expar);
		}

		explosion.start(true, 3);
		explosion.emitting = false;

		health = maxHealth;

		Registry.fxLayer.add(jet);
		Registry.fxLayer.add(explosion);
		animation.play("run");
		velocity.x = velXWalking * 2;

		alive = false;
		exists = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		jet.x = x - 3;
		jet.y = y + 12;

		if (Registry.gameState == 2 && !alive)
		{
			explosion.exists = true;
			drag.x = 100;
			floating = true;

			if (fuel > 0)
			{
				if (!jet.emitting)
				{
					jet.emitting = true;
				}

				jetSound.play();

				fuel -= elapsed * fuelUse;
				if (fuel < 0)
					fuel = 0;
				acceleration.y = gravity / 2;
			}
			else
			{
				if (jet.emitting)
					jet.emitting = false;

				jetSound.stop();

				acceleration.y = gravity;
				animation.play("run");
			}
		}

		if (Registry.gameState == 3)
		{
			if (hurtCounter > 0)
				hurtCounter -= elapsed * hurtRecover;
			else
				FlxFlicker.stopFlickering(this);

			if (Registry.controller.jump)
			{
				if (fuel > 0)
				{
					floating = true;
					if (!jet.emitting)
						jet.emitting = true;

					jetSound.play();

					fuel -= elapsed * fuelUse;
					if (fuel < 0)
						fuel = 0;
					acceleration.y = impulse;
				}
				else
				{
					floating = false;
					if (jet.emitting)
						jet.emitting = false;
					acceleration.y = gravity;

					jetSound.stop();
					if (velocity.y > 12 && !isTouching(FlxObject.FLOOR))
					{
						falling = true;
					}
					else
					{
						falling = false;
					}
				}
			}
			else
			{
				if (jet.emitting)
					jet.emitting = false;

				jetSound.stop();
				acceleration.y = gravity;
				if (fuel < maxFuel && isTouching(FlxObject.FLOOR))
				{
					fuel += elapsed * fuelRechargeGround;
					floating = false;
					falling = false;
				}
				else
				{
					floating = false;

					if (fuel < maxFuel)
					{
						fuel += elapsed * fuelRechargeAir;
					}

					if (velocity.y > 12 && !isTouching(FlxObject.FLOOR))
					{
						falling = true;
					}
					else
					{
						falling = false;
					}
				}
			}

			if (Registry.controller.fire)
			{
				if (bullets > 0)
				{
					shooting = true;
					if (bulletsCooldown < 0)
					{
						Registry.bulletManager.fire(x + 14, y + 9);
						Registry.scoreBullets++;
						bulletSound.play(true);
						if (bullets > 1)
							bullets--;
						else
							bullets = 0;
						bulletsCooldown = maxBulletsCooldown;
					}
					else
					{
						bulletsCooldown -= elapsed * bulletsDelay;
					}
				}
				else
				{
					shooting = false;
					if (bulletsCooldown < 0)
					{
						bulletsCooldown = maxBulletsCooldown;
						emptySound.play(true);
					}
					else
					{
						bulletsCooldown -= elapsed * bulletsDelay;
					}
				}
			}
			else
			{
				shooting = false;
				if (bullets < maxBullets)
				{
					bullets += elapsed * bulletsRecharge;
				}
			}

			if (isTouching(FlxObject.WALL))
			{
				stopped = true;
			}
			else
			{
				stopped = false;
			}

			if (Registry.controller.left)
			{
				if (jet.emitting || velocity.y < -5)
					velocity.x = velXFlyingBack;
				else
					velocity.x = velXWalkingBack;
			}
			else
			{
				if (Registry.controller.right)
				{
					if (jet.emitting || velocity.y < -5)
					{
						velocity.x = velXFlying;
					}
					else
					{
						velocity.x = velXWalking;
					}
				}
				else
					velocity.x = velX;
			}

			if (y < 0)
				y = 0;

			if (x < Registry.cameraTarget.x - 270 || y > Registry.cameraTarget.y + 180)
				kill();
		}

		if (floating)
		{
			if (shooting)
			{
				animation.play("gun_float");
			}
			else
			{
				animation.play("float");
			}
		}
		else
		{
			if (falling)
			{
				if (shooting)
				{
					animation.play("gun_falling");
				}
				else
				{
					animation.play("falling");
				}
			}
			else
			{
				if (stopped)
				{
					if (shooting)
					{
						animation.play("gun_stop");
					}
					else
					{
						animation.play("stop");
					}
				}
				else
				{
					if (shooting)
					{
						animation.play("gun_run");
					}
					else
					{
						animation.play("run");
					}
				}
			}
		}
	}

	override public function hurt(Damage:Float)
	{
		if (alive)
		{
			if (hurtCounter <= 0)
			{
				super.hurt(Damage);
				hurtCounter = hurtMax;
				FlxFlicker.flicker(this, 0);
				if (Damage > 0)
					damageSound.play(true);
				else
					healthSound.play(true);
			}
		}
	}

	override public function kill()
	{
		explosion.x = x;
		explosion.y = y;
		explosion.start(true, 3);
		explosion.emitting = true;
		deathSound.play(true);
		jetSound.stop();
		super.kill();

		FlxG.camera.flash();
		FlxG.camera.shake(0.03, 0.7, null, true);
	}
}
