package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
using flixel.util.FlxSpriteUtil;

class HUD extends flixel.group.FlxTypedGroup<FlxSprite>
{

	
	private var arrow_right:FlxSprite;
	private var arrow_left:FlxSprite;
	private var arrow_up:FlxSprite;
	private var arrow_down:FlxSprite;
	
	private var test_arrow_right:FlxSprite;
	private var test_arrow_left:FlxSprite;
	private var test_arrow_up:FlxSprite;
	private var test_arrow_down:FlxSprite;


	private var dance:FlxSprite;
	private var icon_width:Int;
	private var icon_list:List<FlxSprite>;
	
	private var speed:Float;
	
	
	

	public function new() 
	{	
		super();
		speed = 0.6;
		icon_width = 63; 
		icon_list = new List();
		
		// These are the icons on top of the interface
		arrow_right	= 	new FlxSprite(FlxG.width - icon_width		, 20);
		arrow_left	= 	new FlxSprite(FlxG.width - 2 * icon_width 	, 20);
		arrow_up 	= 	new FlxSprite(FlxG.width - 3 * icon_width 	, 20);
		arrow_down 	= 	new FlxSprite(FlxG.width - 4 * icon_width 	, 20);
		dance 		= 	new FlxSprite(FlxG.width - 5 * icon_width 	, 20);
		
		arrow_right.loadGraphic(AssetPaths.arrow_test__png);
		arrow_left.loadGraphic(AssetPaths.arrow_test__png);
		arrow_up.loadGraphic(AssetPaths.arrow_test__png);
		arrow_down.loadGraphic(AssetPaths.arrow_test__png);
		dance.loadGraphic(AssetPaths.arrow_test__png);
		
		add(arrow_right);
		add(arrow_left);
		add(arrow_up);
		add(arrow_down);
		add(dance);
		

	}
	

	public function roll_icon( icon: FlxSprite ) : Void {
		
		icon.y -= speed;  
		
	}

	public function roll_all_icons() : Void {
		
		var iterator = icon_list.iterator();
		
		while ( iterator.hasNext() ) {
			
			roll_icon ( iterator.next() ) ;
		}
		
	}
	
	
	public function generate_icon( ) : Void {	// Generates one icon randomly out of the 5 potential icons
		
		var rand_number = FlxRandom.intRanged( 1, 5 );
		var temp : FlxSprite;
		switch ( rand_number ) {
			case 1:
				temp = new FlxSprite(FlxG.width - icon_width		, FlxG.height - 50);
				temp.loadGraphic(AssetPaths.arrow_test__png);
			case 2:
				temp = new FlxSprite(FlxG.width - 2 * icon_width 	, FlxG.height - 50);
				temp.loadGraphic(AssetPaths.arrow_test__png);
			case 3: 
				temp = new FlxSprite(FlxG.width - 3 * icon_width 	, FlxG.height - 50);
				temp.loadGraphic(AssetPaths.arrow_test__png);
			case 4: 
				temp = new FlxSprite(FlxG.width - 4 * icon_width 	, FlxG.height - 50);
				temp.loadGraphic(AssetPaths.arrow_test__png);
			case 5: 
				temp = new FlxSprite(FlxG.width - 5 * icon_width 	, FlxG.height - 50);
				temp.loadGraphic(AssetPaths.arrow_test__png);
			default:
				//Just add a default value...
				temp = new FlxSprite(FlxG.width - icon_width		, FlxG.height - 50);
				temp.loadGraphic(AssetPaths.arrow_test__png);
		}
		
		add(temp);
		icon_list.add(temp); 
	}
	
}