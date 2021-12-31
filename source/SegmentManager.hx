package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import openfl.display.Stage;

class SegmentManager extends FlxGroup
{
	public var newSegment:LevelSegment;

	private var lastSegment:LevelSegment;
	private var firstSegment:LevelSegment;

	public function new()
	{
		super();
		newSegment = new LevelSegment(-100, 0);
		add(newSegment);
		Registry.currentSegment = newSegment;
		Registry.backLayer.add(newSegment.bgLayer);
		Registry.collideLayer.add(newSegment.mainLayer);
		Registry.spriteLayer.add(newSegment.spriteGroup);
		Registry.debrisLayer.add(newSegment.debrisGroup);
		Registry.obstacleLayer.add(newSegment.obstacleGroup);
		Registry.pickupLayer.add(newSegment.pickupGroup);
		lastSegment = newSegment;
		firstSegment = newSegment;
	}

	public function insertSegment(type:Int)
	{
		trace("insertSegment", type);

		newSegment = new LevelSegment(Math.floor(lastSegment.mainLayer.x + lastSegment.tileLength), type);
		lastSegment.nextSegment = newSegment;
		add(newSegment);
		Registry.currentSegment = newSegment;
		Registry.backLayer.add(newSegment.bgLayer);
		Registry.collideLayer.add(newSegment.mainLayer);
		Registry.spriteLayer.add(newSegment.spriteGroup);
		Registry.debrisLayer.add(newSegment.debrisGroup);
		Registry.obstacleLayer.add(newSegment.obstacleGroup);
		Registry.pickupLayer.add(newSegment.pickupGroup);
		var boundX = lastSegment.mainLayer.x;
		lastSegment = newSegment;
		remove(firstSegment);

		firstSegment = firstSegment.nextSegment;
		FlxG.worldBounds.set(boundX, 0, newSegment.mainLayer.width * 2, newSegment.mainLayer.height * 2);
	}
}
