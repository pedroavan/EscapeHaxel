package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var distCounter:Float;

	public var startCounter:Float;

	public var playerStart:Float;

	public var counterText:FlxText;

	public var debugText:FlxText;

	public var titleText:FlxText;
	public var titleText2:FlxText;

	public var startCounterText:FlxText;

	public var keysText:FlxText;

	public var endGameText:FlxText;

	public var player:Player;
	public var healthBar:FlxSprite;
	public var fuelBar:FlxSprite;
	public var bulletBar:FlxSprite;
	public var hudFrame:FlxSprite;
	public var hudBack:FlxSprite;

	public var keysSprite:FlxSprite;

	public var titleScreen:FlxGroup;
	public var counterScreen:FlxGroup;
	public var endGameScreen:FlxGroup;

	public var hudOffset:FlxPoint;
	public var counterOffset:FlxPoint;

	public var backdropA:FlxSprite;
	public var backdropB:FlxSprite;

	private var bulletHitSound:FlxSound;

	public var cameraTarget:FlxObject;

	override public function create()
	{
		super.create();

		Registry.collideLayer = new FlxGroup();
		Registry.backLayer = new FlxGroup();
		Registry.spriteLayer = new FlxGroup();
		Registry.obstacleLayer = new FlxGroup();
		Registry.fxLayer = new FlxGroup();
		Registry.particleLayer = new FlxGroup();
		Registry.debrisLayer = new FlxGroup();
		Registry.pickupLayer = new FlxGroup();

		Registry.hudLayer = new FlxGroup();
		Registry.controller = new Controller();

		backdropA = new FlxSprite(0, 0);
		backdropA.loadGraphic(AssetPaths.bg1__png, false);
		backdropB = new FlxSprite(FlxG.width, 0);
		backdropB.loadGraphic(AssetPaths.bg1__png, false);

		backdropA.velocity.x = Registry.backdropSpeed;
		backdropB.velocity.x = Registry.backdropSpeed;

		titleScreen = new FlxGroup();
		counterScreen = new FlxGroup();
		endGameScreen = new FlxGroup();

		Registry.bulletManager = new BulletManager();

		Registry.segmentManager = new SegmentManager();

		FlxG.state.bgColor = new FlxColor(0xff442233);

		player = new Player();
		Registry.player = player;

		distCounter = 0;

		playerStart = 0;

		bulletHitSound = new FlxSound();

		bulletHitSound.loadEmbedded(AssetPaths.bulletWall__wav);

		hudOffset = new FlxPoint(8, 192);
		counterOffset = new FlxPoint(8, 8);

		hudFrame = new FlxSprite(hudOffset.x, hudOffset.y);
		hudFrame.loadGraphic(AssetPaths.hudframe__png, false, 136, 48);
		hudFrame.scrollFactor.x = hudFrame.scrollFactor.y = 0;

		hudBack = new FlxSprite(hudOffset.x, hudOffset.y);
		hudBack.loadGraphic(AssetPaths.hudback__png, false, 128, 48);
		hudBack.scrollFactor.x = hudBack.scrollFactor.y = 0;

		healthBar = new FlxSprite(32 + hudOffset.x, 6 + hudOffset.y);
		healthBar.makeGraphic(1, 5, 0xffaa0022);
		healthBar.scrollFactor.x = healthBar.scrollFactor.y = 0;
		healthBar.origin.x = healthBar.origin.y = 0;

		fuelBar = new FlxSprite(32 + hudOffset.x, 22 + hudOffset.y);
		fuelBar.makeGraphic(1, 4, 0xffffcc44);
		fuelBar.scrollFactor.x = fuelBar.scrollFactor.y = 0;
		fuelBar.origin.x = fuelBar.origin.y = 0;

		bulletBar = new FlxSprite(32 + hudOffset.x, 38 + hudOffset.y);
		bulletBar.makeGraphic(1, 4, 0xff44ccff);
		bulletBar.scrollFactor.x = bulletBar.scrollFactor.y = 0;
		bulletBar.origin.x = bulletBar.origin.y = 0;

		counterText = new FlxText(counterOffset.x, counterOffset.y, 128, FlxMath.roundDecimal(distCounter, 2) + " m");
		counterText.borderStyle = FlxTextBorderStyle.SHADOW;
		counterText.scrollFactor.x = counterText.scrollFactor.y = 0;

		debugText = new FlxText(counterOffset.x, counterOffset.y + 16, 128, " - ");
		debugText.borderStyle = FlxTextBorderStyle.SHADOW;
		debugText.scrollFactor.x = debugText.scrollFactor.y = 0;

		titleText = new FlxText(0, 100, 480, "BREAKSCAPE");
		titleText.borderStyle = FlxTextBorderStyle.SHADOW;
		titleText.scrollFactor.x = titleText.scrollFactor.y = 0;
		titleText.alignment = "center";
		titleText.scale.x = 3;
		titleText.scale.y = 3;

		titleText2 = new FlxText(0, 200, 480, "Press ENTER to start");
		titleText2.borderStyle = FlxTextBorderStyle.SHADOW;
		titleText2.scrollFactor.x = titleText2.scrollFactor.y = 0;
		titleText2.alignment = "center";

		keysSprite = new FlxSprite(300, 120);
		keysSprite.loadGraphic(AssetPaths.keys__png, false);
		keysSprite.scrollFactor.x = keysSprite.scrollFactor.y = 0;

		keysText = new FlxText(180, 120, 480, "JETPACK \n\nSHOOT \n\nRUN SLOWER \n\nRUN FASTER");
		keysText.borderStyle = FlxTextBorderStyle.SHADOW;
		titleText2.borderStyle = FlxTextBorderStyle.SHADOW;
		keysText.scrollFactor.x = keysText.scrollFactor.y = 0;

		startCounterText = new FlxText(0, 64, 480, "");
		startCounterText.borderStyle = FlxTextBorderStyle.SHADOW;
		startCounterText.scale.x *= 2;
		startCounterText.scale.y *= 2;
		startCounterText.scrollFactor.x = startCounterText.scrollFactor.y = 0;
		startCounterText.alignment = "center";

		endGameText = new FlxText(160, 160, 480, "");
		endGameText.borderStyle = FlxTextBorderStyle.SHADOW;
		endGameText.scrollFactor.x = endGameText.scrollFactor.y = 0;

		Registry.segmentManager.insertSegment(0);
		add(backdropA);
		add(backdropB);
		add(Registry.backLayer);
		add(Registry.collideLayer);
		add(Registry.obstacleLayer);
		add(Registry.debrisLayer);
		add(Registry.particleLayer);
		add(Registry.spriteLayer);
		add(Registry.pickupLayer);
		add(Registry.fxLayer);
		add(player);
		add(Registry.bulletManager);

		Registry.hudLayer.add(hudBack);
		Registry.hudLayer.add(healthBar);
		Registry.hudLayer.add(fuelBar);
		Registry.hudLayer.add(bulletBar);
		Registry.hudLayer.add(hudFrame);
		Registry.hudLayer.add(counterText);
		// Registry.hudLayer.add(debugText);

		add(Registry.hudLayer);
		add(Registry.controller);

		titleScreen.add(titleText);
		titleScreen.add(titleText2);

		counterScreen.add(startCounterText);
		counterScreen.add(keysSprite);
		counterScreen.add(keysText);

		endGameScreen.add(endGameText);

		add(titleScreen);
		add(counterScreen);
		add(endGameScreen);

		Registry.hudLayer.visible = false;
		titleScreen.visible = true;
		counterScreen.visible = false;
		endGameScreen.visible = false;

		FlxG.sound.playMusic(AssetPaths.level1_intro__ogg, 1, true);

		cameraTarget = new FlxObject(FlxG.width / 2, FlxG.height / 2, 0, 0);
		FlxG.camera.follow(cameraTarget, FlxCameraFollowStyle.LOCKON);
		cameraTarget.velocity.x = Registry.runSpeed;
		Registry.cameraTarget = cameraTarget;

		add(cameraTarget);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Registry.gameState == 0)
		{
			if (FlxG.keys.justReleased.ENTER)
			{
				Registry.gameState = 1;
				startCounter = 3.0;
				titleScreen.visible = false;
				counterScreen.visible = true;
			}
			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(AssetPaths.level1_intro__ogg, 1, true);
			}
		}

		if (Registry.gameState == 1)
		{
			startCounterText.text = "GET READY!\n " + FlxMath.roundDecimal(startCounter, 1);

			if (startCounter <= 0.1)
			{
				Registry.gameState = 2;
				playerStart = cameraTarget.x - 260;

				FlxG.camera.shake(0.03, 0.7, null, true, FlxAxes.Y);
				player.exists = true;
				player.x = playerStart;
				player.y = 96;
				player.velocity.x = Registry.runSpeed + 240;
				player.velocity.y = -120;
				fuelBar.scale.x = 0;
				Registry.hudLayer.visible = true;
				counterScreen.visible = false;
				player.allowCollisions = FlxObject.FLOOR;

				FlxG.sound.playMusic(AssetPaths.level1__ogg, 1, true);
			}
			else
			{
				startCounter -= FlxG.elapsed;
			}

			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(AssetPaths.level1__ogg, 1, true);
			}
		}

		if (Registry.gameState == 2)
		{
			distCounter += (Registry.runSpeed + Registry.player.velocity.x) / 1500;
			counterText.text = FlxMath.roundDecimal(distCounter, 2) + " m";
			FlxG.collide(player, Registry.collideLayer);
			if (player.isTouching(FlxObject.FLOOR))
			{
				player.allowCollisions = FlxObject.ANY;
				Registry.gameState = 3;
				player.velocity.x = player.velX;
				player.drag.x = 0;
				player.alive = true;
			}

			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(AssetPaths.level1_intro__ogg, 1, true);
			}
		}

		if (Registry.gameState == 3)
		{
			if (!player.stopped)
				distCounter += (Registry.runSpeed + player.velocity.x) / 1500;
			healthBar.scale.x = Math.floor(Registry.player.health * 16);
			fuelBar.scale.x = Math.floor(Registry.player.fuel * 3);
			bulletBar.scale.x = Math.floor(Registry.player.bullets * 6);
			counterText.text = FlxMath.roundDecimal(distCounter, 2) + " m";

			FlxG.collide(player, Registry.collideLayer);
			FlxG.collide(player, Registry.obstacleLayer);
			FlxG.collide(Registry.debrisLayer, Registry.collideLayer);
			FlxG.collide(Registry.bulletManager, Registry.collideLayer);
			FlxG.collide(Registry.bulletManager, Registry.obstacleLayer, shotObstacle);
			FlxG.collide(Registry.bulletManager, Registry.spriteLayer, shotObstacle);
			FlxG.overlap(player, Registry.spriteLayer, playerHurt);
			FlxG.overlap(player, Registry.debrisLayer, playerHurt);
			FlxG.overlap(player, Registry.pickupLayer, playerHeal);

			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(AssetPaths.level1__ogg, 1, true);
			}
		}

		if (player.alive == false && player.exists == false && Registry.gameState != 0 && Registry.gameState != 1 && Registry.gameState != 5)
		{
			Registry.gameState = 4;
			FlxG.sound.music.stop();

			Registry.hudLayer.visible = false;
			endGameText.text = "You escaped for " + FlxMath.roundDecimal(distCounter, 2) + " meters, \nyou fired " + Registry.scoreBullets
				+ " bullets, \nyou killed " + Registry.scoreEnemies + " monsters and \nyou collected " + Registry.scorePickup
				+ " medikits \nbefore meeting a terrible fate.";
			endGameScreen.visible = true;
		}

		if (Registry.gameState == 4)
		{
			if (FlxG.keys.justReleased.ENTER)
			{
				endGameScreen.visible = false;
				Registry.scoreBullets = 0;
				Registry.scoreEnemies = 0;
				Registry.scorePickup = 0;
				Registry.gameState = 5;
				distCounter = 0;
				counterText.text = FlxMath.roundDecimal(distCounter, 2) + " m";
				player.fuel = player.maxFuel;
				player.bullets = player.maxBullets;
				player.health = player.maxHealth;
				player.velocity.y = 0;
			}
		}

		if (Registry.gameState == 5)
		{
			if (Registry.currentSegment.type == 0 && Registry.currentSegment.mainLayer.x <= Registry.cameraTarget.x - 120)
			{
				FlxG.timeScale = 1;
				Registry.gameState = 0;
				titleScreen.visible = true;
				if (FlxG.sound.music == null)
				{
					FlxG.sound.playMusic(AssetPaths.level1_intro__ogg, 1, true);
				}
			}
			else
				FlxG.timeScale = 5;
		}

		debugText.text = "X: " + FlxMath.roundDecimal(player.x, 2) + ", Y:" + FlxMath.roundDecimal(player.y, 2);

		if (backdropA.x < -FlxG.width)
			backdropA.x = FlxG.width;

		if (backdropB.x < -FlxG.width)
			backdropB.x = FlxG.width;
	}

	public function shotObstacle(b:Bullet, o:Obstacle)
	{
		if (o.isOnScreen())
		{
			b.kill();
			bulletHitSound.play(true);
			o.hurt(b.damage);
		}
	}

	public function playerHurt(p:Player, o:Obstacle)
	{
		p.hurt(1);
	}

	public function playerHeal(p:Player, h:HealthKit)
	{
		if (Registry.player.health < Registry.player.maxHealth)
		{
			Registry.scorePickup++;
			h.kill();
			p.hurt(-1);
		}
	}
}
