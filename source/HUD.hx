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
import proto.RhythmManagerStage;
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
	public var icon_list : Array<HUDIcon>;
	
	public var rhythm_manager:RhythmManager;
	
	public var le_bar:HUDIcon;
	public var bar_duration : Int;
	
	public function new(rm : RhythmManager)
	{	
		super();
		
		rhythm_manager = rm;
		
		icon_origin = new FlxPoint(510, 150);
		icon_width = 20 + 5;
		
		var bg : FlxSprite = new FlxSprite(0, 0, AssetPaths.UI_arrowbg__png);
		add(bg);
		
		icon_group = new FlxTypedGroup<HUDIcon>();
		add(icon_group);
		
		var action_list = rhythm_manager.get_pattern();
		bar_duration = action_list.length;
		
		icon_list = new Array<HUDIcon>();
		for (i in 0...bar_duration)
		{
			var a = action_list[i];
			var iconspr : HUDIcon = new HUDIcon(icon_origin, icon_width, a.action, action_list.length, i);
			icon_group.add(iconspr);
			icon_list.push(iconspr);
		}
		
		le_bar = new HUDIcon(icon_origin, icon_width, RhythmActionEnum.BAR, action_list.length, 0);
		icon_group.add(le_bar);
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
		var current_beat_in_bar = 0;
		
		//if (rhythm_manager.beats_elapsed - rhythm_manager.beats_before_starting_to_dance >= 0)
		{
			current_beat_in_bar = (rhythm_manager.beats_elapsed - rhythm_manager.beats_before_starting_to_dance + 1) % bar_duration;
		}
		//else
		{
			
		}
		le_bar.y = le_bar.origin.y + (current_beat_in_bar * rhythm_manager.beat_duration + rhythm_manager.current_timer) / (bar_duration * rhythm_manager.beat_duration) * le_bar.y_height;
		
		for (i in 0...bar_duration)
		{
			var icon = icon_list[i];
			icon.alpha = 0.5;
		}
		
		var previous_icon = icon_list[current_beat_in_bar];
		var next_icon = icon_list[ ( current_beat_in_bar + 1 ) % bar_duration];
		
		//Highlight action in front of bar
		if (rhythm_manager.highlight_stage == RhythmManagerStage.HIGHLIGHT_NEXT)
		{
			next_icon.alpha = 1.0;
		}
		//Highlight action behind bar
		else if (rhythm_manager.highlight_stage == RhythmManagerStage.HIGHLIGHT_PREVIOUS)
		{
			previous_icon.alpha = 1.0;
		}
	}
}