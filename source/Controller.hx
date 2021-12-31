package;

import flixel.FlxBasic;
import flixel.FlxG;
import lime.ui.KeyCode;

class Controller extends FlxBasic
{
	public var up:Bool;
	public var down:Bool;
	public var left:Bool;
	public var right:Bool;
	public var jump:Bool;
	public var fire:Bool;
	public var start:Bool;

	public function new()
	{
		super();
		up = false;
		down = false;
		left = false;
		right = false;
		jump = false;
		fire = false;
		start = false;
	}

	override public function update(elapsed:Float)
	{
		up = FlxG.keys.pressed.UP;
		down = FlxG.keys.pressed.DOWN;
		left = FlxG.keys.pressed.LEFT;
		right = FlxG.keys.pressed.RIGHT;
		jump = FlxG.keys.pressed.SPACE;
		fire = FlxG.keys.pressed.X;
		start = FlxG.keys.pressed.ENTER;
		super.update(elapsed);
	}
}
