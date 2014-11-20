package;

import flixel.addons.ui.FlxUISpriteButton;
import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxTypedButton;
import flixel.util.FlxMath;
import openfl.filters.BitmapFilterQuality;
import openfl.filters.GlowFilter;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	//public var glow_filter : GlowFilter;
	public var start_normal : FlxSprite;
	//public var normal_filter : FlxSpriteFilter;
	public var start_tutorial : FlxSprite;
	//public var tutorial_filter : FlxSpriteFilter;
	public var start_credits : FlxSprite;
	//public var credits_filter : FlxSpriteFilter;
	//var filter_times : Int;
	public var controls : FlxSprite;
	
	public var screen_controls : ScreenControls;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.fixedTimestep = false;
		
		var bg : FlxSprite = new FlxSprite(0, 0, AssetPaths.splash_screen_temp__png);
		add(bg);
		
		var logo : FlxSprite = new FlxSprite(FlxG.width/2 - 562/2, -10, AssetPaths.logo__png);
		add(logo);
		
		start_normal = new FlxSprite(FlxG.width / 2 - 190 / 2, FlxG.height - 140, AssetPaths.menu2__png);
		add(start_normal);
		
		start_tutorial = new FlxSprite(FlxG.width / 2 - 190 / 2, FlxG.height - 90, AssetPaths.menu1__png);
		add(start_tutorial);
		
		start_credits = new FlxSprite(FlxG.width / 2 - 190 / 2, FlxG.height - 45, AssetPaths.menu3__png);
		add(start_credits);
		
		controls = new FlxSprite(0, -30, AssetPaths.controls__png);
		add(controls);
		
		screen_controls = new ScreenControls();
		add(screen_controls);
		
		//glow_filter = new GlowFilter(0xFF0000, 0.5, 4, 4, 0.2, BitmapFilterQuality.HIGH); //, 1, 50, 50, 1.5, 1);
		//normal_filter = new FlxSpriteFilter(start_normal, 50, 50);
		//tutorial_filter = new FlxSpriteFilter(start_tutorial, 50, 50);
		//credits_filter = new FlxSpriteFilter(start_credits, 50, 50);
		//filter_times = 0;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		var in_anyone : Bool = false;
		
		if (start_normal.overlapsPoint(FlxG.mouse.getScreenPosition(), true))
		{
			if (FlxG.mouse.justPressed)
			{
				Reg.game_type = GameType.NORMAL;
				FlxG.switchState(new PlayState());
			}
			/*if (filter_times < 40)
			{
				normal_filter.addFilter(glow_filter);
			}
			filter_times++;*/
			in_anyone = true;
		}
		else
		{
			//normal_filter.removeAllFilters();
		}
		
		if (start_tutorial.overlapsPoint(FlxG.mouse.getScreenPosition(), true))
		{
			if (FlxG.mouse.justPressed)
			{
				Reg.game_type = GameType.TUTORIAL;
				FlxG.switchState(new PlayState());
			}
			/*if (filter_times < 40)
			{
				tutorial_filter.addFilter(glow_filter);
			}
			filter_times++;*/
			in_anyone = true;
		}
		else
		{
			//tutorial_filter.removeAllFilters();
		}
		
		if (start_credits.overlapsPoint(FlxG.mouse.getScreenPosition(), true))
		{
			if (FlxG.mouse.justPressed)
			{
				FlxG.switchState(new CreditsState());
			}
			/*if (filter_times < 40)
			{
				credits_filter.addFilter(glow_filter);
			}
			filter_times++;*/
			in_anyone = true;
		}
		else
		{
			//credits_filter.removeAllFilters();
		}
		
		if (!in_anyone)
		{
			//filter_times = 0;
		}
	}	
	
	public function go_to_game()
	{
		FlxG.switchState(new PlayState());
	}
}