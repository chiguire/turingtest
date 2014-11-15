package proto;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import haxe.ds.IntMap;
import haxe.ds.Vector;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ciro Duran
 */
class RhythmManager extends FlxSprite
{	
	public var action_map : Array<RhythmAction>;

	public var current_timer : Float;
	public var max_timer : Float;
	
	public var previous_action : RhythmAction;
	public var next_action : RhythmAction;
	public var next_action_index : Int;
	
	public var first_bars : Int;
	public var first_bars_max : Int;
	
	public var bar_duration : Float = 2;
	public var would_you_kindly_move : Bool = false;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		reset_manager();
		
		makeGraphic(100, 100, FlxColor.TRANSPARENT, true);
	}
	
	override public function update():Void 
	{
		super.update();
		
		would_you_kindly_move = false;
		
		//current_timer = (current_timer + 1) % max_timer;
		current_timer += FlxG.elapsed;
		if (current_timer >= max_timer)
		{
			would_you_kindly_move = true;
			current_timer -= max_timer;
			
			if (first_bars <= first_bars_max)
			{
				first_bars++;
				
				if (first_bars == first_bars_max)
				{
					get_nearest_actions();
				}
			}
			else
			{
				//if (next_action.time == current_timer)
				//{
					previous_action = next_action;
					next_action_index = (next_action_index + 1) % action_map.length;
					next_action = action_map[next_action_index];
				//}
			}
		}
	}
	
	override public function draw() : Void
	{
		super.draw();
		
		var lineStyle1 : LineStyle = { color: FlxColor.WHITE, thickness: 1 };
		var lineStyle2 : LineStyle = { color: FlxColor.GRAY, thickness: 1 };
		var lineStyle3 : LineStyle = { color: FlxColor.RED, thickness: 1 };
		var fillStyle : FillStyle = { color: FlxColor.TRANSPARENT };
		
		var direction : FlxPoint = FlxAngle.rotatePoint(50, 0, 0, 0, (current_timer / max_timer) * 360);
		
		drawCircle(50, 50, 50, FlxColor.WHITE, lineStyle1, fillStyle);
		drawLine(50, 50, 100, 50, lineStyle2);
		drawLine(50, 50, 50 + direction.x, 50 + direction.y, lineStyle3);
	}
	
	public function reset_manager() : Void
	{
		current_timer = 0;
		max_timer = bar_duration;
		first_bars = 0;
		first_bars_max = 4;
		
		generate_new_dance();
	}
	
	public function generate_new_dance() : Void
	{
		action_map = new Array<RhythmAction>();
		
		current_timer = 0;
		max_timer = bar_duration;
		
		var action1 = new RhythmAction(Std.int(bar_duration * (0.0 / 4)), RhythmActionEnum.RIGHT);
		var action2 = new RhythmAction(Std.int(bar_duration * (1.0 / 4)), RhythmActionEnum.DOWN);
		var action3 = new RhythmAction(Std.int(bar_duration * (2.0 / 4)), RhythmActionEnum.LEFT);
		var action4 = new RhythmAction(Std.int(bar_duration * (3.0 / 4)), RhythmActionEnum.UP);
		
		action_map.push(action1);
		action_map.push(action2);
		action_map.push(action3);
		action_map.push(action4);
		
		previous_action = action4;
		next_action = action1;
		next_action_index = 0;
	}
	
	public function player_move(action:RhythmActionEnum) : Void
	{
		//Compare typed action against current_action
	}
	
	private function get_next_action() : RhythmAction
	{
		return next_action;
	}
	
	private function get_nearest_actions() : Null<RhythmAction>
	{
		var distance_previous = Math.abs(previous_action.time - current_timer);
		var distance_next = Math.abs(next_action.time - current_timer);
		
		//This would return null if both distances are too long
		if (distance_next <= distance_previous)
		{
			return next_action;
		}
		else
		{
			return previous_action;
		}
	}
	
	public function will_dancers_move() : Bool
	{
		return would_you_kindly_move;
	}
	
	public function get_dancers_action() : RhythmActionEnum
	{
		if (first_bars < first_bars_max)
		{
			return RhythmActionEnum.NONE;
		}
		
		return next_action.action;
	}
}