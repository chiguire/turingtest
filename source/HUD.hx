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

	
	public var move_right:FlxText;
	public var move_left:FlxText;
	public var move_up:FlxText;
	public var move_down:FlxText;
	
	public var arrow_up:FlxSprite;

	public function new()
	{	 
		super();
		//move_right = new FlxText(25, 25, 30, "Right", 15);
		//move_left= new FlxText(25, 25, 30, "Left", 15);
		//move_up = new FlxText(25, 25, 30, "Up", 15);
		move_down = new FlxText(FlxG.width - 110 , 10, 120);
		move_down.text = "Down";
		move_down.size = 30; 
		add(move_down);
		//add(move_right);
		//add(move_left);
		//add(move_up);
		
	}
	
}