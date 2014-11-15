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

	
	private var move_right:FlxText;
	private var move_left:FlxText;
	private var move_up:FlxText;
	private var move_down:FlxText;
	private var dance:FlxText;
	private var icon_width:Int;
	
	private var arrow_up:FlxSprite;
	

	public function new()
	{	 
		icon_width = 60; 
		super();
		move_right	= 	new FlxText(FlxG.width - icon_width		, 20, 60, "Right", 15);
		move_left	= 	new FlxText(FlxG.width - 2*icon_width 	, 20, 60, "Left", 15);
		move_up 	= 	new FlxText(FlxG.width - 3*icon_width 	, 20, 60, "Up", 15);
		move_down 	= 	new FlxText(FlxG.width - 4*icon_width 	, 20, 60, "Down", 15);
		dance 		= 	new FlxText(FlxG.width - 5*icon_width 	, 20, 60, "Dance", 15);
		add(move_down);
		add(move_right);
		add(move_left);
		add(move_up);
		add(dance);
	}
	
}