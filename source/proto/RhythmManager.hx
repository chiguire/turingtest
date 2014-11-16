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
//import proto.generate_random_action;
//import proto.update_state;

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
	public var non_movement_penalisation : Bool;
	public var player1_character : Character;
	public var player2_character : Character;
	
	public var player1_error_accumulation : Float;
	public var player2_error_accumulation : Float;
	public var player_error_threshold : Float;
	public var player_error_multiplier : Float = 0.2;
	
	public var character_group (default, set) : FlxTypedGroup<Character>;
	
	public var always_generate_random : Bool = false;
	public var state : Int = 1;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		reset_manager();
		
		makeGraphic(100, 300, FlxColor.TRANSPARENT, true);
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
		var distance_action : Float = Math.abs(max_timer - next_action.time + previous_action.time);
		
		would_you_kindly_move = false;
		
		current_timer += FlxG.elapsed;
		
		if (non_movement_penalisation &&
		    current_bars >= first_bars_max &&
		    previous_action.action != RhythmActionEnum.NONE &&
			current_timer >= previous_action.time + distance_action/3.0)
		{
			if (!did_player1_acted)
			{
				if (add_player_error(1, 0.6))
				{
					player1_character.freeze_mistake();
				}
			}
			if (!did_player2_acted)
			{
				if (add_player_error(2, 0.6))
				{
					player2_character.freeze_mistake();
				}
			}
			non_movement_penalisation = false;
		}
		if (current_timer >= max_timer)
		{
			would_you_kindly_move = true;
			current_timer -= max_timer;
			non_movement_penalisation = true;
			
			if (current_bars < first_bars_max)
			{
				current_bars++;
			}
			else
			{
				if (always_generate_random)
				{
					previous_action = next_action;
					
					//if (next_action_index == action_map.length - 1)
					//{
						//generate_new_dance();
					//}
					//else
					//{
						next_action_index = (next_action_index + 1) % action_map.length;
						next_action = action_map[next_action_index];
					//}
				}
				else
				{
					previous_action = next_action;
					next_action_index = (next_action_index + 1) % action_map.length;
					next_action = action_map[next_action_index];
				}
			}
		}
	}
	
	override public function draw() : Void
	{
		super.draw();
		
		var lineStyle1 : LineStyle = { color: FlxColor.WHITE, thickness: 1 };
		var lineStyle2 : LineStyle = { color: FlxColor.GRAY, thickness: 1 };
		var lineStyle3 : LineStyle = { color: FlxColor.RED, thickness: 1 };
		var lineStyle4 : LineStyle = { color: FlxColor.AQUAMARINE, thickness: 0.5 };
		var fillStyle : FillStyle = { color: FlxColor.TRANSPARENT };
		
		var direction : FlxPoint = FlxAngle.rotatePoint(50, 0, 0, 0, (current_timer / max_timer) * 360);
		var action_distance = Math.abs(max_timer - next_action.time + previous_action.time);
		action_distance /= 3.0;
		var direction2 : FlxPoint = FlxAngle.rotatePoint(50, 0, 0, 0, action_distance / max_timer * 360);
		var direction3 : FlxPoint = FlxAngle.rotatePoint(50, 0, 0, 0, -action_distance / max_timer * 360);
		
		drawCircle(50, 50, 50, FlxColor.WHITE, lineStyle1, fillStyle);
		drawLine(50, 50, 100, 50, lineStyle2);
		drawLine(50, 50, 50 + direction2.x, 50 + direction2.y, lineStyle4);
		drawLine(50, 50, 50 + direction3.x, 50 + direction3.y, lineStyle4);
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
		non_movement_penalisation = false;
		
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
		var rand_number = FlxRandom.intRanged( 1, 5 );
		var last_action : RhythmAction;
		var temp : RhythmAction;
		
		if (always_generate_random)
		{
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			action_map.push(new RhythmAction(0, Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5))));
			
			for ( i in  0...7 ){
				if ( action_map.length != 0 ) {
					last_action = action_map[action_map.length - 1];
					temp = new RhythmAction(bar_duration * ( i / 8.0), Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5)));
					action_map.push(temp);
				}
				else {
					generate_random_action (i);
				}
			}
			
			
			if (previous_action == null)
			{
				previous_action = action_map[7];
			}

			next_action = action_map[0];
			next_action_index = 0;
			
		}
		else
		{
			action_map.push(new RhythmAction(0, RhythmActionEnum.RIGHT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.DOWN));
			action_map.push(new RhythmAction(0, RhythmActionEnum.LEFT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.UP));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RIGHT));
			action_map.push(new RhythmAction(0, RhythmActionEnum.RAISE_ARMS));
			action_map.push(new RhythmAction(0, RhythmActionEnum.NONE));
			action_map.push(new RhythmAction(0, RhythmActionEnum.LEFT));
			
			previous_action = action_map[action_map.length-1];
			next_action = action_map[0];
			next_action_index = 0;
		}		
	}
	
	public function generate_random_action ( i : Int ) : Void {
		var temp : RhythmAction;
		temp = new RhythmAction(bar_duration * ( i / 8.0), Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5)));
		switch ( state ) {
			case 1:
				while ( temp.action == RhythmActionEnum.LEFT || temp.action == RhythmActionEnum.UP )
					temp = new RhythmAction(bar_duration * ( i / 8.0), Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5)));
			case 2:
				while ( temp.action == RhythmActionEnum.RIGHT || temp.action == RhythmActionEnum.UP )
					temp = new RhythmAction(bar_duration * ( i / 8.0), Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5)));
			case 3:
				while ( temp.action == RhythmActionEnum.RIGHT || temp.action == RhythmActionEnum.UP )
					temp = new RhythmAction(bar_duration * ( i / 8.0), Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5)));
			case 4:
				while ( temp.action == RhythmActionEnum.LEFT || temp.action == RhythmActionEnum.UP )
					temp = new RhythmAction(bar_duration * ( i / 8.0), Type.createEnumIndex(RhythmActionEnum, FlxRandom.intRanged(0, 5)));
		}
		action_map.push(temp);
		update_state(temp);
	}


	public function update_state( temp : RhythmAction ) : Void {
		
		if ( temp.action == RhythmActionEnum.RAISE_ARMS || temp.action == RhythmActionEnum.NONE ) {
			return;
		}
		if ( temp.action == RhythmActionEnum.UP ) {
			if ( state == 3 ) { state = 1; } 
			if ( state == 4 ) { state = 2; }
		}
		if ( temp.action == RhythmActionEnum.DOWN) {
			if ( state == 1 ) { state = 3; } 
			if ( state == 2 ) { state = 4; }
		}
		if ( temp.action == RhythmActionEnum.LEFT) {
			if ( state == 2 ) { state = 1; } 
			if ( state == 3 ) { state = 4; }
		}
		if ( temp.action == RhythmActionEnum.RIGHT) {
			if ( state == 1 ) { state = 2; } 
			if ( state == 4 ) { state = 3; }
		}
		
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
				did_player1_acted = true;
				
				if (add_player_error(1, error))
				{
					trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player1_error_accumulation)})');
					return true;
				}
				trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player1_error_accumulation)})');
			}
			else if (player_number == 2)
			{
				did_player2_acted = true;
				
				if (add_player_error(2, error))
				{
					trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player2_error_accumulation)})');
					return true;
				}
				trace('(Player: $player_number Action: ${action} Intended action: ${nearest_action.action} Error: ${floatToStringPrecision(error)} Accumulated: ${floatToStringPrecision(player2_error_accumulation)})');
			}
		}
		else
		{
			trace('(Player: $player_number Action: ${action} Intended action: null *No error* Accumulated: ${floatToStringPrecision(player1_error_accumulation)})');
		}
		
		return false;
	}
	
	private function add_player_error(player_number:Int, error:Float) : Bool
	{
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
		
		return false;
	}
	private function get_next_action() : RhythmAction
	{
		return next_action;
	}
	
	private function get_nearest_actions() : Null<RhythmAction>
	{
		var distance_previous = Math.abs(previous_action.time - current_timer);
		var distance_next = if (next_action_index == action_map.length - 1) Math.abs(max_timer + next_action.time - current_timer); else Math.abs(next_action.time - current_timer);
		var distance_action : Float = Math.abs(max_timer - next_action.time + previous_action.time);
		
		trace('Current time: ${floatToStringPrecision(current_timer)}, DistAction: ${floatToStringPrecision(distance_action)}, DistNext: ${floatToStringPrecision(distance_next)}, DistPrevious: ${floatToStringPrecision(distance_previous)}');
		
		//This would return null if both distances are too long
		if (distance_next <= distance_previous)
		{
			if (distance_next < distance_action/3.0)
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
			if (distance_previous < distance_action/3.0)
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
	
	public static function floatToStringPrecision(n:Float, prec:Int=4){
	  n = Math.round(n * Math.pow(10, prec));
	  var str = ''+n;
	  var len = str.length;
	  if(len <= prec){
		while(len < prec){
		  str = '0'+str;
		  len++;
		}
		return '0.'+str;
	  }
	  else{
		return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
	  }
	}
}