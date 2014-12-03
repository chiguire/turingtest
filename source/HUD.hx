package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxPool;
import flixel.util.FlxRandom;
import openfl.display.SpreadMethod;
import proto.RhythmAction;
import proto.RhythmManager;
import proto.RhythmActionEnum;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxGroup
{

	private var arrow_right:FlxSprite;
	private var arrow_left:FlxSprite;
	private var arrow_up:FlxSprite;
	private var arrow_down:FlxSprite;
	private var dance:FlxSprite;
	
	private var icon_origin : FlxPoint;
	private var icon_width : Int;
	private var icon_group : FlxTypedGroup<HUDIcon>;
	
	public var rhythm_manager:RhythmManager;
	public var look_ahead_actions : Int;
	public var look_ahead_time : Float;
	
	public var le_bar:HUDIcon;
	
	public function new(rm : RhythmManager)
	{	
		super();
		
		rhythm_manager = rm;
		
		icon_origin = new FlxPoint(510, 150);
		icon_width = 20 + 5;
		//look_ahead_actions = 4;
		
		
		var bg : FlxSprite = new FlxSprite(0, 0, AssetPaths.UI_arrowbg__png);
		add(bg);
		
		//create_top_icons();	
		
		icon_group = new FlxTypedGroup<HUDIcon>();
		add(icon_group);
		
		var action_list = rhythm_manager.get_pattern();
		look_ahead_actions = action_list.length;
		look_ahead_time = rhythm_manager.bar_duration * look_ahead_actions;
		
		for (i in 0...action_list.length)
		{
			var a = action_list[i];
			var iconspr : HUDIcon = new HUDIcon(icon_origin, icon_width, a.action, rhythm_manager.bar_duration * i + a.time, look_ahead_time);
			iconspr.current_time = rhythm_manager.current_timer;
			icon_group.add(iconspr);
		}
		
		var lasticon : HUDIcon = new HUDIcon(icon_origin, icon_width, action_list[0].action, rhythm_manager.bar_duration * action_list.length + action_list[0].time, look_ahead_time);
		lasticon.current_time = rhythm_manager.current_timer;
		lasticon.alpha = 0.5;
		icon_group.add(lasticon);
		
		le_bar = new HUDIcon(icon_origin, icon_width, RhythmActionEnum.BAR, 0, look_ahead_time);
		icon_group.add(le_bar);
		//FlxG.watch.add(le_bar, "y", "lebary");
	}
	
	public function create_top_icons() : Void {
		//Top of UI is x= 510 y=150
		// These are the icons on top of the interface
		arrow_right	= 	new FlxSprite(icon_origin.x + 0 * icon_width, icon_origin.y, AssetPaths.button5__png);
		arrow_left	= 	new FlxSprite(icon_origin.x + 1 * icon_width, icon_origin.y, AssetPaths.button4__png);
		arrow_up 	= 	new FlxSprite(icon_origin.x + 2 * icon_width, icon_origin.y, AssetPaths.button2__png);
		arrow_down 	= 	new FlxSprite(icon_origin.x + 3 * icon_width, icon_origin.y, AssetPaths.button3__png);
		dance 		= 	new FlxSprite(icon_origin.x + 4 * icon_width, icon_origin.y, AssetPaths.button1__png);
		
		arrow_right.alpha = 0.5;
		arrow_left.alpha = 0.5;
		arrow_up.alpha = 0.5;
		arrow_down.alpha = 0.5;
		dance.alpha = 0.5;
		
		add(arrow_right);
		add(arrow_left);
		add(arrow_up);
		add(arrow_down);
		add(dance);
	}
	
	public override function update() : Void
	{
		super.update();
		/*
		for (i in icon_group)
		{
			i.current_time = rhythm_manager.current_bars * rhythm_manager.max_timer + rhythm_manager.current_timer;
		}
		
		if (rhythm_manager.would_you_kindly_move)
		{
			var action : RhythmAction = rhythm_manager.get_look_ahead_actions(2);
			var in_time : Float = (rhythm_manager.current_bars+1) * rhythm_manager.max_timer + action.time;
			var iconspr : HUDIcon = new HUDIcon(icon_origin, icon_width, action.action, in_time, look_ahead_time);
			iconspr.y = icon_origin.y + (in_time - rhythm_manager.current_timer) * look_ahead_time;
			iconspr.current_time = rhythm_manager.current_bars * rhythm_manager.max_timer + rhythm_manager.current_timer;
			icon_group.add(iconspr);
		}
		*/
		var bars = (look_ahead_actions*2+rhythm_manager.current_bars-rhythm_manager.first_bars_max+1) % look_ahead_actions;
		le_bar.in_time = bars * rhythm_manager.bar_duration + rhythm_manager.current_timer;
	}
}