package;

import flixel.FlxObject;
import flixel.group.FlxGroup;

class Registry
{
	public static var runSpeed:Int = 175;

	public static var backdropSpeed:Int = -50;

	public static var cameraTarget:FlxObject;

	public static var player:Player;
	public static var controller:Controller;
	public static var hudLayer:FlxGroup;
	public static var segmentManager:SegmentManager;
	public static var currentSegment:LevelSegment;
	public static var bulletManager:BulletManager;
	public static var collideLayer:FlxGroup;
	public static var backLayer:FlxGroup;
	public static var spriteLayer:FlxGroup;
	public static var obstacleLayer:FlxGroup;
	public static var bulletLayer:FlxGroup;
	public static var fxLayer:FlxGroup;
	public static var particleLayer:FlxGroup;
	public static var debrisLayer:FlxGroup;
	public static var pickupLayer:FlxGroup;

	// public static var scoreDist:int = 0;
	public static var scoreEnemies:Int = 0;
	public static var scorePickup:Int = 0;
	// public static var scoreDamage:int = 0;
	public static var scoreBullets:Int = 0;

	// public static var scoreFuel:int = 0;
	public static var gameState:Int = 0;

	public function Registry() {}
}
