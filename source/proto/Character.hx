package proto;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.*;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ciro Duran
 */
class Character extends FlxSprite
{
	public static var FREEZE_MAX_TIMER : Float = 1.06 * 3;
	public static var KILL_COOLDOWN_TIMER : Float = 7;
	
	public var grid_x : Int;
	public var grid_y : Int;
	public var last_action : RhythmActionEnum;
	public var current_action : RhythmActionEnum;
	private var grid : Grid;
	
	public var is_player : Int;
	public var is_female : Bool;
	public var is_moving : Bool;
	public var is_killing : Bool;
	public var is_killed : Bool;
	public var resolved_this_movement : Bool;
	public var swapping_character : Character;
	
	public var next_dance_timer : Float;
	public var cant_move_timer : Float;
	
	public var cant_kill_timer : Float;
	public var freeze_callback : Character -> Void;
	
	public function new(grid_x:Int, grid_y:Int, grid:Grid, is_female:Bool) 
	{
		super(0, 0);
		this.grid_x = grid_x;
		this.grid_y = grid_y;
		this.grid = grid;
		this.is_female = is_female;
		this.is_moving = false;
		cant_move_timer = 0;
		next_dance_timer = 0;
		cant_kill_timer = 0;
		swapping_character = null;
		resolved_this_movement = false;
		
		if (is_female)
		{
			loadGraphic(AssetPaths.female_dancer__png, true, 50, 70);
		}
		else
		{
			loadGraphic(AssetPaths.male_dancer__png, true, 50, 70);
		}
		
		animation.add("idle", [0], 60, true);
		animation.add("walk-up", [1, 2, 3, 4], 10, false);
		animation.add("walk-right", [5, 6, 7, 8], 10, false);
		animation.add("walk-left", [9, 10, 11, 12], 10, false);
		animation.add("walk-down", [13, 14, 15, 16], 10, false);
		animation.add("raise-hands", [17, 18, 19, 20, 21, 22, 23, 24], 20, false);
		animation.add("death", [25, 26, 27, 28, 29, 30, 31], 20, false);
		animation.add("attack-up", [32, 33, 34, 35, 36, 37, 38, 39], 20, false);
		animation.add("attack-right", [40, 41, 42, 43, 44, 45, 46, 47], 20, false);
		animation.add("attack-left", [48, 49, 50, 51, 52, 53, 54, 55], 20, false);
		animation.add("attack-down", [56, 57, 58, 59, 60, 61, 62, 63], 20, false);
		animation.play("idle");
		
		x = x_grid_to_screen(grid_x);
		y = y_grid_to_screen(grid_y);
		
		
	}
	
	override public function draw():Void 
	{
		super.draw();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (!can_move())
		{
			cant_move_timer -= FlxG.elapsed;
		}
		
		if (cant_kill_timer > 0)
		{
			cant_kill_timer -= FlxG.elapsed;
		}
		
		if (animation.name == "death" && animation.curAnim != null && animation.curAnim.curFrame == animation.curAnim.numFrames - 1)
		{
			end_death();
		}
		
		last_action = RhythmActionEnum.NONE;
	}
	
	public function try_move(action : RhythmActionEnum/*, is_killing : Bool*/, force : Bool = false) : Void
	{
		if (is_killed)
		{
			return;
		}
		
		if (!force && is_moving || action == RhythmActionEnum.NONE || !can_move())
		{
			if (current_action != RhythmActionEnum.NONE && action == current_action && is_player > 0)
			{
				if (cant_kill_timer > 0)
				{
					return;
				}
				
				is_killing = true;
				if (swapping_character != null && !swapping_character.is_killed)
				{
					swapping_character.is_killed = true;
					cant_kill_timer = KILL_COOLDOWN_TIMER;
					var curFrame : Int = animation.curAnim.curFrame;
					var curAnim : String = animation.name.split("-")[1];
					animation.play("attack-" + curAnim, false, curFrame);
					if (is_player == 1 && swapping_character.is_player != 2 || is_player == 2)
					{
						Reg.vampire_kills++;
					}
					FlxG.sound.play(AssetPaths.Stab__wav, 1);
				}
			}
			
			return;
		}
		
		last_action = action;
		is_moving = true;
		is_killing = false;
	}
	
	public function resolve_movement(gmr : GridMoveResult) : Void
	{
		switch (gmr)
		{
			case GridMoveResult.MOVED(RhythmActionEnum.UP):
				animation.play("walk-up");
				current_action = RhythmActionEnum.UP;
				start_movement();
			case GridMoveResult.MOVED(RhythmActionEnum.DOWN): 
				animation.play("walk-down");
				current_action = RhythmActionEnum.DOWN;
				start_movement();
			case GridMoveResult.MOVED(RhythmActionEnum.LEFT):
				animation.play("walk-left");
				current_action = RhythmActionEnum.LEFT;
				start_movement();
			case GridMoveResult.MOVED(RhythmActionEnum.RIGHT):
				animation.play("walk-right");
				current_action = RhythmActionEnum.RIGHT;
				start_movement();
			case GridMoveResult.SWAPPED(direction, original_position, c, killed):
				animation.play(get_animation_name(direction, killed));
				start_movement();
				current_action = direction;
				c.is_killed = killed;
				swapping_character = c;
				c.swapping_character = this;
				if (killed)
				{
					if (is_player == 1 && c.is_player != 2 || is_player == 2)
					{
						Reg.vampire_kills++;
					}
					FlxG.sound.play(AssetPaths.Stab__wav, 1);
				}
				c.try_move(get_opposite(direction));
				c.animation.play(get_animation_name(get_opposite(direction), false));
				c.grid_x = original_position.element(1);
				c.grid_y = original_position.element(2);
				c.resolved_this_movement = true;
				c.start_movement();
			case GridMoveResult.ACTED(RhythmActionEnum.RAISE_ARMS):
				animation.play("raise-hands");
				current_action = RhythmActionEnum.NONE;
				start_movement(0.55);
			case GridMoveResult.ACTED(RhythmActionEnum.NONE):
				//no-op
				current_action = RhythmActionEnum.NONE;
			default:
				start_movement();
				current_action = RhythmActionEnum.NONE;
		}
	}
	
	public function freeze_mistake() : Void
	{
		cant_move_timer = FREEZE_MAX_TIMER;
		if (freeze_callback != null)
		{
			freeze_callback(this);
		}
	}
	
	public function can_move() : Bool
	{
		return cant_move_timer <= 0.0;
	}
	
	private function start_movement(time:Float = 0.3) : Void
	{
		FlxTween.tween(this, { x: x_grid_to_screen(grid_x), y: y_grid_to_screen(grid_y)}, time, {type: FlxTween.ONESHOT, complete: end_movement});
	}
	
	private function end_movement(tween:FlxTween) : Void
	{
		animation.play("idle");
		is_moving = false;
		swapping_character = null;
		is_killing = false;
		current_action = RhythmActionEnum.NONE;
		
		if (alive && is_killed)
		{
			start_death();
		}
	}
	
	private function start_death() : Void
	{
		//FlxTween.tween(this, { }, 0.55, { type: FlxTween.ONESHOT, complete: end_death} );
		animation.play("death", true);
		
		if (is_player == 2)
		{
			FlxG.sound.play(AssetPaths.SupernaturalDangerSound__wav, 1);
		}
		else if (is_female)
		{
			FlxG.sound.play(AssetPaths.Scream_Female__wav, 1);
		}
		else
		{
			FlxG.sound.play(AssetPaths.Scream_Male__wav, 1);
		}
	}
	
	private function end_death() : Void
	{
		kill();
	}
	
	private function x_grid_to_screen(_x:Float) : Float
	{
		return grid.x + (_x + 0.5) * grid.cell_width - 50 / 2.0;
	}
	
	private function y_grid_to_screen(_y:Float) : Float
	{
		return grid.y + (_y + 0.5) * grid.cell_height - 70;
	}
	
	private function get_opposite(rae:RhythmActionEnum) : RhythmActionEnum
	{
		switch (rae)
		{
			case RhythmActionEnum.UP: return RhythmActionEnum.DOWN;
			case RhythmActionEnum.DOWN: return RhythmActionEnum.UP;
			case RhythmActionEnum.LEFT: return RhythmActionEnum.RIGHT;
			case RhythmActionEnum.RIGHT: return RhythmActionEnum.LEFT;
			default: return rae;
		}
		return RhythmActionEnum.NONE;
	}
	
	private function get_animation_name(rae:RhythmActionEnum, killing:Bool) : String
	{
		if (killing)
		{
			switch (rae)
			{
				case RhythmActionEnum.UP: return "attack-up";
				case RhythmActionEnum.DOWN: return "attack-down";
				case RhythmActionEnum.LEFT: return "attack-left";
				case RhythmActionEnum.RIGHT: return "attack-right";
				case RhythmActionEnum.RAISE_ARMS: return "raise-hands";
				default: return "";
			}
		}
		else
		{
			switch (rae)
			{
				case RhythmActionEnum.UP: return "walk-up";
				case RhythmActionEnum.DOWN: return "walk-down";
				case RhythmActionEnum.LEFT: return "walk-left";
				case RhythmActionEnum.RIGHT: return "walk-right";
				case RhythmActionEnum.RAISE_ARMS: return "raise-hands";
				default: return "";
			}
		}
	}
}