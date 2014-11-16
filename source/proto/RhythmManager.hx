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
	
	public var current_bars : Int;
	public var first_bars_max : Int;

	
	public var bar_duration : Float = 1.06;
	public var would_you_kindly_move : Bool = false;
	
	public var did_player1_acted : Bool;
	public var did_player2_acted : Bool;
	
	public var player1_error_accumulation : Float;
	public var player2_error_accumulation : Float;
	public var player_error_threshold : Float;
	public var player_error_multiplier : Float = 0.2;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		reset_manager();
		
		makeGraphic(100, 300, FlxColor.TRANSPARENT, true);
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
			
			if (current_bars < first_bars_max)
			{
				current_bars++;
			}
			else
			{
				previous_action = next_action;
				next_action_index = (next_action_index + 1) % action_map.length;
				next_action = action_map[next_action_index];
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
		
		direction = FlxAngle.rotatePoint(40, 0, 0, 0, (player1_error_accumulation / player_error_threshold) * 360);
		drawCircle(50, 150, 40, FlxColor.WHITE, lineStyle1, fillStyle);
		drawLine(50, 150, 90, 150, lineStyle2);
		drawLine(50, 150, 50 + direction.x, 150 + direction.y, lineStyle3);
		
		direction = FlxAngle.rotatePoint(40, 0, 0, 0, (player2_error_accumulation / player_error_threshold) * 360);
		drawCircle(50, 240, 40, FlxColor.WHITE, lineStyle1, fillStyle);
		drawLine(50, 240, 90, 240, lineStyle2);
		drawLine(50, 240, 50 + direction.x, 240 + direction.y, lineStyle3);
	}
	
	public function reset_manager() : Void
	{
		current_timer = 0;
		max_timer = bar_duration;
		current_bars = 0;
		first_bars_max = 4;
		
		player1_error_accumulation = 0.0;
		player2_error_accumulation = 0.0;
		player_error_threshold = 1.0;
		
		generate_new_dance();
	}
	
	public function generate_new_dance() : Void
	{
		action_map = new Array<RhythmAction>();
		
		current_timer = 0;
		max_timer = bar_duration;
		
		var action1 = new RhythmAction(bar_duration * (0.0 / 8.0), RhythmActionEnum.RIGHT);
		var action2 = new RhythmAction(bar_duration * (1.0 / 8.0), RhythmActionEnum.DOWN);
		var action3 = new RhythmAction(bar_duration * (2.0 / 8.0), RhythmActionEnum.LEFT);
		var action4 = new RhythmAction(bar_duration * (3.0 / 8.0), RhythmActionEnum.UP);
		var action5 = new RhythmAction(bar_duration * (4.0 / 8.0), RhythmActionEnum.RIGHT);
		var action6 = new RhythmAction(bar_duration * (5.0 / 8.0), RhythmActionEnum.RAISE_ARMS);
		var action7 = new RhythmAction(bar_duration * (6.0 / 8.0), RhythmActionEnum.NONE);
		var action8 = new RhythmAction(bar_duration * (7.0 / 8.0), RhythmActionEnum.LEFT);
		
		action_map.push(action1);
		action_map.push(action2);
		action_map.push(action3);
		action_map.push(action4);
		action_map.push(action5);
		action_map.push(action6);
		action_map.push(action7);
		action_map.push(action8);
		
		previous_action = action8;
		next_action = action1;
		next_action_index = 0;
	}
	
	public function player_move(action:RhythmActionEnum, player_number : Int) : Bool
	{
		var nearest_action : Null<RhythmAction>= get_nearest_actions();
		
		if (nearest_action != null)
		{
			var error : Float = 0.0;
			
			if (action == nearest_action.action)
			{
				error = Math.abs(nearest_action.time - current_timer);
			}
			else
			{
				error = 0.6;
			}
			
			if (player_number == 1)
			{
				player1_error_accumulation += error * player_error_multiplier;
				
				if (player1_error_accumulation >= player_error_threshold)
				{
					player1_error_accumulation = 0;
					return true;
				}
			}
			else if (player_number == 2)
			{
				player2_error_accumulation += error * player_error_multiplier;
				
				if (player2_error_accumulation >= player_error_threshold)
				{
					player2_error_accumulation = 0;
					return true;
				}
			}
		}
		return false;
	}
	
	private function get_next_action() : RhythmAction
	{
		return next_action;
	}
	
	private function get_nearest_actions() : Null<RhythmAction>
	{
		var distance_previous = Math.abs(previous_action.time - current_timer);
		var distance_next = Math.abs(next_action.time - current_timer);
		var distance_action : Float;
		
		if (next_action_index == 0)
		{
			distance_action = (max_timer + next_action.time - previous_action.time);
		}
		else
		{
			distance_action = (next_action.time - previous_action.time);
		}
		
		//This would return null if both distances are too long
		if (distance_next <= distance_previous)
		{
			if (distance_next < distance_action / 3.0)
			{
				return next_action;
			}
			else
			{
				return null;
			}
		}
		else
		{
			if (distance_previous < distance_action / 3.0)
			{
				return previous_action;
			}
			else
			{
				return null;
			}
		}
	}
	
	public function will_dancers_move() : Bool
	{
		return would_you_kindly_move;
	}
	
	public function get_dancers_action() : RhythmActionEnum
	{
		if (current_bars < first_bars_max)
		{
			return RhythmActionEnum.NONE;
		}
		
		return next_action.action;
	}
}