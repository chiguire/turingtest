package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends flixel.group.FlxTypedGroup<FlxSprite>
{

    private var overlay:FlxSpriteGroup;
	public var healthDisplay:FlxText;

	public function create():Void 
	{
		healthDisplay = new FlxText(200, 200, 500);
		healthDisplay.size = 50;
		healthDisplay.text = "This is a test";
	}
	
    public function updateHealth():Void
    {
		healthDisplay.text = "I am updated";
    }
}