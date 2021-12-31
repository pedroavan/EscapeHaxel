package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxAxes;

class LevelSegment extends FlxBasic
{
	private var debrisSound:FlxSound;

	public var horizontalVelocity:Float = Registry.runSpeed;
	public var mainLayer:FlxTilemap;
	public var bgLayer:FlxTilemap;
	public var tileLength:Int;
	public var type:Int;
	public var position:Float;
	public var nextSegment:LevelSegment;
	public var spriteGroup:FlxGroup;
	public var debrisGroup:FlxGroup;
	public var obstacleGroup:FlxGroup;
	public var pickupGroup:FlxGroup;
	public var sprite:FlxSprite;

	public var activateDebris:Bool = false;
	public var debrisRange:Float;
	public var debrisMin:Float;
	public var debrisQuantity:Int;

	public function new(p:Float, t:Int)
	{
		super();
		debrisSound = new FlxSound();
		debrisSound.loadEmbedded(AssetPaths.debris__wav);

		nextSegment = null;
		position = p;
		type = t;
		tileLength = 512;
		mainLayer = new FlxTilemap();
		bgLayer = new FlxTilemap();
		spriteGroup = new FlxGroup();
		debrisGroup = new FlxGroup();
		obstacleGroup = new FlxGroup();
		pickupGroup = new FlxGroup();

		bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg1__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

		switch (type)
		{
			case 0:
				loadBg([0]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Intro1__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);

			case 1:
				loadBg([1, 2, 5, 6]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map1__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);

			case 2:
				loadBg([1, 2, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map2__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(0, mainLayer.width, 48, 8);
				createEnemy(0, mainLayer.width - 48, 80, 8);
				createEnemy(1, 416, 156, 5);
				createHealth(336, 64, 2);

			case 3:
				loadBg([1, 2, 3, 4, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map3__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(0, mainLayer.width, 48, 8);
				createEnemy(0, mainLayer.width - 48, 80, 8);
				createHealth(232, 192, 2);

			case 4:
				loadBg([2, 3, 4, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map4__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(1, 448, 156, 5);
				createHealth(456, 80, 2);

			case 5:
				loadBg([11]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map5__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(0, mainLayer.width, 48, 5);
				createEnemy(1, 448, 156, 5);
				createHealth(344, 64, 2);

			case 6:
				loadBg([1, 2, 3, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map6__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(0, mainLayer.width, 48, 8);
				createEnemy(0, mainLayer.width - 48, 80, 8);

			case 7:
				loadBg([1, 2, 3, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map7__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(0, mainLayer.width, 48, 5);

			case 8:
				loadBg([1, 2, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map8__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createEnemy(0, mainLayer.width, 48, 5);

			case 9:
				loadBg([5, 9, 12]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map9__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createDebris(128, 463, 3, 3);

			case 10:
				loadBg([10]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map10__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createDoor(48, 128, 2);
				createEnemy(1, 288, 156, 3);
				createEnemy(1, 432, 156, 5);

			case 11:
				loadBg([10]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map11__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createDoor(48, 128, 2);
				createEnemy(1, 144, 156, 8);
				createEnemy(1, 288, 156, 3);
				createEnemy(1, 432, 156, 5);
				createHealth(376, 112, 2);

			case 12:
				loadBg([1, 2, 5, 6]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map12__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createDoor(240, 112, 2);
				createEnemy(1, 432, 156, 5);
				createEnemy(0, mainLayer.width, 48, 10);

			case 13:
				loadBg([7, 8, 9, 12]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map13__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createDebris(128, 463, 3, 5);

			case 14:
				loadBg([2, 3, 4, 5, 9]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map14__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
				createPlatform(64, 160, 4);
				createPlatform(320, 144, 3);

			case 15:
				loadBg([1, 2, 3, 4, 12]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map15__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);

			case 16:
				loadBg([2, 3, 4, 5]);
				mainLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Map16__csv, AssetPaths.level1__png, 16, 16, null, 0, 1, 32);
		}

		mainLayer.setTileProperties(32, FlxObject.CEILING);
		mainLayer.setTileProperties(33, FlxObject.CEILING);
		mainLayer.setTileProperties(34, FlxObject.CEILING);
		mainLayer.setTileProperties(47, FlxObject.CEILING);
		mainLayer.setTileProperties(59, FlxObject.CEILING);
		mainLayer.setTileProperties(60, FlxObject.CEILING);
		mainLayer.setTileProperties(61, FlxObject.NONE);
		mainLayer.setTileProperties(62, FlxObject.NONE);
		mainLayer.x = position;
		mainLayer.y = 0.000000;

		bgLayer.x = position;
		bgLayer.y = 0.000000;
		FlxG.state.add(this);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mainLayer.x <= Registry.cameraTarget.x - tileLength - 240)
		{
			if (Registry.gameState == 3 || Registry.gameState == 4)
				Registry.segmentManager.insertSegment(FlxG.random.int(0, 16));
			else
				Registry.segmentManager.insertSegment(0);
			kill();
		}

		if (activateDebris)
		{
			if (mainLayer.x <= Registry.player.x)
			{
				FlxG.camera.shake(0.03, 0.7, null, true, FlxAxes.Y);
				debrisSound.play(true);
				for (i in 0...debrisQuantity)
				{
					sprite = new Debris(FlxG.random.float() * debrisRange + debrisMin + mainLayer.x, -32, 0);
					debrisGroup.add(sprite);
				}

				activateDebris = false;
			}
		}
	}

	public function loadBg(bg:Array<Int>)
	{
		var t:Int;
		t = FlxG.random.int(0, bg.length - 1);
		switch (bg[t])
		{
			case 0:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_BgIntro1__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 1:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg1__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 2:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg2__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 3:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg3__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 4:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg4__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 5:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg5__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 6:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg6__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 7:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg7__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 8:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg8__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 9:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg9__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 10:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg10__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 11:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg11__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);

			case 12:
				bgLayer.loadMapFromCSV(AssetPaths.mapCSV_Level1_Bg12__csv, AssetPaths.level1_bg__png, 16, 16, null, 0, 1, 32);
		}
	}

	public function createDoor(X:Float, Y:Float, rate:Int)
	{
		if (FlxG.random.float() * rate < 1)
		{
			sprite = new Door(position + X, Y, 0);
			obstacleGroup.add(sprite);
		}
	}

	public function createDebris(Xmin:Float, Xmax:Float, rate:Int, quantity:Int)
	{
		if (FlxG.random.float() * rate < 1)
		{
			activateDebris = true;
			debrisMin = Xmin;
			debrisQuantity = quantity;
			debrisRange = Xmax - Xmin;
		}
	}

	public function createEnemy(type:Int, X:Float, Y:Float, rate:Int)
	{
		if (FlxG.random.float() * rate < 1)
		{
			switch (type)
			{
				case 0:
					sprite = new Flyer(position + X, Y, 0);

				case 1:
					sprite = new Zombie(position + X, Y, 0);
			}
			spriteGroup.add(sprite);
		}
	}

	public function createHealth(X:Float, Y:Float, rate:Int)
	{
		if (FlxG.random.float() * rate < 1)
		{
			if (Registry.player.health < Registry.player.maxHealth)
			{
				sprite = new HealthKit(position + X, Y, 0);
				pickupGroup.add(sprite);
			}
		}
	}

	public function createPlatform(X:Float, Y:Float, rate:Int)
	{
		if (FlxG.random.float() * rate < 1)
		{
			sprite = new Platform(position + X, Y, 0, true);
		}
		else
		{
			sprite = new Platform(position + X, Y, 0, false);
		}
		obstacleGroup.add(sprite);
	}

	override public function kill()
	{
		var destroyF = function(member:FlxBasic)
		{
			member.destroy();
		}
		Registry.collideLayer.remove(mainLayer);
		Registry.spriteLayer.remove(spriteGroup);
		Registry.debrisLayer.remove(debrisGroup);
		Registry.obstacleLayer.remove(obstacleGroup);
		Registry.pickupLayer.remove(pickupGroup);

		FlxG.state.remove(this);
		super.kill();
		mainLayer.kill();
		mainLayer.destroy();

		bgLayer.kill();
		bgLayer.destroy();

		spriteGroup.kill();
		spriteGroup.forEach(destroyF);
		spriteGroup.destroy();

		debrisGroup.kill();
		debrisGroup.forEach(destroyF);
		debrisGroup.destroy();

		obstacleGroup.kill();
		obstacleGroup.forEach(destroyF);
		obstacleGroup.destroy();

		pickupGroup.kill();
		pickupGroup.forEach(destroyF);
		pickupGroup.destroy();

		destroy();
	}
}
