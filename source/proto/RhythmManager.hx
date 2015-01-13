package proto;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import haxe.ds.IntMap;
import haxe.ds.Vector;
import haxe.macro.Expr.Var;
//import proto.generate_random_action;
//import proto.update_state;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ciro Duran
 */
class RhythmManager extends FlxSprite
{	
	public var MISTAKE_ERROR : Int = 1;
	public var NON_MOVEMENT_ERROR : Int = 1;
	public var MAX_ERROR_POINTS : Int = 10;
	
	public var action_map : Array<RhythmAction>;

	public var current_timer : Float;
	public var max_timer : Float;
	
	public var previous_action : RhythmAction;
	public var next_action : RhythmAction;
	public var next_action_index : Int;
	
	public var current_bars : Int;
	public var first_bars_max : Int;
	
	public var highlight_stage (default, null) : RhythmManagerStage;
	
	public var bar_duration : Float = 1.059;
	public var would_you_kindly_move : Bool = false;
	
	public var did_player1_acted : Bool;
	public var did_player2_acted : Bool;
	public var non_movement_penalisation : Bool;
	public var player1_character : Character;
	public var player2_character : Character;
	
	public var player1_error_accumulation : Float;
	public var player2_error_accumulation : Float;
	public var player_error_threshold : Float;
	
	public var character_group (default, set) : FlxTypedGroup<Character>;
	
	public var always_generate_random : Bool = false;
	public var state : Int = 1;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		reset_manager();
		
		makeGraphic(200, 100, FlxColor.TRANSPARENT, true);
	}
	
	public function reset_manager() : Void
	{
		current_timer = 0;
		max_timer = bar_duration;
		current_bars = 0;
		//first_bars_max = 4;
		non_movement_penalisation = false;
		
		player1_error_accumulation = 0.0;
		player2_error_accumulation = 0.0;
		player_error_threshold = 1.0;
		
		generate_new_dance();
		first_bars_max = action_map.length;
	}
	
	public function set_character_group(g:FlxTypedGroup<Character>)
	{
		for (c in g)
		{
			c.next_dance_timer = bar_duration + FlxRandom.floatRanged( -bar_duration * 0.1, bar_duration * 0.1 );
		}
		return character_group = g;
	}
	
	override public function update():Void 
	{
		super.update();
		would_you_kindly_move = false;
		
		current_timer += FlxG.elapsed;
		
		var old_highlight_stage = highlight_stage;
		
		if (current_timer >=  max_timer / 2.0 && current_timer < max_timer )
		{
			highlight_stage = RhythmManagerStage.HIGHLIGHT_NEXT;
		}
		else if ( current_timer < max_timer / 2.0)
		{
			highlight_stage = RhythmManagerStage.HIGHLIGHT_PREVIOUS;
		}
		else
		{
			highlight_stage = RhythmManagerStage.HIGHLIGHT_NONE;
		}
		
		
		
		
		//This is if he didn't move when he should have
		if (non_movement_penalisation &&
		    current_bars >= first_bars_max &&
		    previous_action.action != RhythmActionEnum.NONE &&
			(highlight_stage == RhythmManagerStage.HIGHLIGHT_NONE && old_highlight_stage == RhythmManagerStage.HIGHLIGHT_PREVIOUS))
		{
			//Add error to the player who didn't act. 
			if (!did_player1_acted && !player1_character.can_move_freely)
			{
				if (add_player_error(1, NON_MOVEMENT_ERROR))
				{
					player1_character.freeze_mistake();
				}
			}
			if (!did_player2_acted && !player2_character.can_move_freely)
			{
				if (add_player_error(2, NON_MOVEMENT_ERROR))
				{
					player2_character.freeze_mistake();
				}
			}
			non_movement_penalisation = false;
			did_player1_acted = false;
			did_player2_acted = false;
		}
		
		
		if (current_timer >= max_timer)
		{
			would_you_kindly_move = true;
			current_timer -= max_timer;
			non_movement_penalisation = true;
			current_bars++;
			//This is after the first time where we show the dance
			if (current_bars >= first_bars_max)
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
	
	}
	
	
	public function generate_new_dance() : Void
	{
		action_map = new Array<RhythmAction>();
		current_timer = 0;
		max_timer = bar_duration;
		var rand_number = FlxRandom.intRanged( 1, 5 );
		var last_action : RhythmAction;
		var temp : RhythmAction;
		var temp :Int;
		temp = FlxRandom.intRanged(1, 3);
			
		if ( temp == 1 ) {
			//action_map.push(new RhythmAction(0, RhythmActionEnum.RIGHT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.DOWN));
			action_map.push(new RhythmAction(0, RhythmActionEnum.UP));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RIGHT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.LEFT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RAISE_ARMS));
			
			previous_action = action_map[action_map.length-1];
			next_action = action_map[0];
			next_action_index = 0;
		}
		
		if ( temp == 2 ) {
			action_map.push(new RhythmAction(0, RhythmActionEnum.RIGHT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.DOWN));
			action_map.push(new RhythmAction(0, RhythmActionEnum.LEFT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RAISE_ARMS));
			action_map.push(new RhythmAction(0, RhythmActionEnum.UP));
			
			previous_action = action_map[action_map.length-1];
			next_action = action_map[0];
			next_action_index = 0;
		}
		if ( temp == 3 ) {
			action_map.push(new RhythmAction(0, RhythmActionEnum.RIGHT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RAISE_ARMS));
			action_map.push(new RhythmAction(0, RhythmActionEnum.LEFT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RAISE_ARMS));
			
			previous_action = action_map[action_map.length-1];
			next_action = action_map[0];
			next_action_index = 0;
		}
	}
	
	public function get_pattern() : Array<RhythmAction>
	{
		return action_map;
	}
	
	//returns whether a player moved???
	public function player_move(action:RhythmActionEnum, player_number : Int) : Bool
	{
		var nearest_action : Null<RhythmAction>= get_right_action();
		
		if (nearest_action != null)
		{
			var error : Int = 0;
			
			if (action == nearest_action.action)
			{
				error = 0;
			}
			else
			{
				error = MISTAKE_ERROR;
			}
			
			if (player_number == 1 && !player1_character.can_move_freely)
			{
				did_player1_acted = true;
				
				if (add_player_error(1, error))
				{
					//trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player1_error_accumulation)})');
					return true;
				}
				//trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player1_error_accumulation)})');
			}
			else if (player_number == 2 && !player2_character.can_move_freely)
			{
				did_player2_acted = true;
				
				if (add_player_error(2, error))
				{
					//trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player2_error_accumulation)})');
					return true;
				}
				//trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player2_error_accumulation)})');
			}
		}
		
		return false;
	}
	
	private function add_player_error(player_number:Int, error:Int) : Bool
	{
		if (player_number == 1)
		{
			player1_error_accumulation += error/(MAX_ERROR_POINTS*1.0);
			
			if (player1_error_accumulation >= player_error_threshold)
			{
				player1_error_accumulation = 0;
				return true;
			}
		}
		else if (player_number == 2)
		{
			player2_error_accumulation += error/(MAX_ERROR_POINTS*1.0);
				
			if (player2_error_accumulation >= player_error_threshold)
			{
				player2_error_accumulation = 0;
				return true;
			}
		}
		
		return false;
	}
	private function get_next_action() : RhythmAction
	{
		return next_action;
	}
	
	private function get_right_action(can_be_null:Bool = true) : Null<RhythmAction>
	{
		var distance_previous = if (next_action_index == 0) Math.abs(max_timer  - current_timer); else Math.abs(current_timer);
		var distance_next = if (next_action_index == 0) Math.abs(max_timer - current_timer); else Math.abs( current_timer);
		var distance_action : Float = Math.abs(max_timer);
		
		//trace('Current time: ${floatToStringPrecision(current_timer)}, DistAction: ${floatToStringPrecision(distance_action)}, DistNext: ${floatToStringPrecision(distance_next)}, DistPrevious: ${floatToStringPrecision(distance_previous)}');
		
		//This would return null if both distances are too long
		if (distance_next <= distance_previous)
		{
			if (!can_be_null || distance_next < distance_action/3.0)
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
			if (!can_be_null || distance_previous < distance_action/3.0)
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
		if (current_bars >= first_bars_max-1)
		{
			return get_right_action(false).action;
		}
		else
		{
			return RhythmActionEnum.NONE;
		}
	}
	
	public function get_error_normalised(player_number:Int)
	{
		if (player_number == 1)
		{
			return player1_error_accumulation / player_error_threshold;
		}
		else
		{
			return player2_error_accumulation / player_error_threshold;
		}
	}
}