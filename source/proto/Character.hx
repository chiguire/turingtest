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
	public var grid_x : Int;
	public var grid_y : Int;
	public var last_action : RhythmActionEnum;
	private var grid : Grid;
	
	public var is_player : Int;
	public var is_female : Bool;
	private var is_moving : Bool;
	
	public function new(grid_x:Int, grid_y:Int, grid:Grid, is_female:Bool) 
	{
		super(0, 0);
		this.grid_x = grid_x;
		this.grid_y = grid_y;
		this.grid = grid;
		this.is_female = is_female;
		this.is_moving = false;
		
		if (is_female)
		{
			loadGraphic(AssetPaths.female_dancer__png, true, 50, 50);
		}
		else
		{
			loadGraphic(AssetPaths.male_dancer__png, true, 50, 50);
		}
		
		animation.add("idle", [0], 60, true);
		animation.add("walk-up", [1, 2, 3, 4], 10, false);
		animation.add("walk-right", [5, 6, 7, 8], 10, false);
		animation.add("walk-left", [9, 10, 11, 12], 10, false);
		animation.add("walk-down", [13, 14, 15, 16], 10, false);
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
	}
	
	public function move(action : RhythmActionEnum) : Void
	{
		if (is_moving)
		{
			return;
		}
		
		last_action = action;
		var gmr : GridMoveResult = grid.try_move(this, action);
		
		switch (gmr)
		{
			case GridMoveResult.MOVED(RhythmActionEnum.UP):
				animation.play("walk-up");
				is_moving = true;
				FlxTween.tween(this, { x: x_grid_to_screen(grid_x), y: y_grid_to_screen(grid_y)}, 0.3, {complete: end_movement});
			case GridMoveResult.MOVED(RhythmActionEnum.DOWN): 
				animation.play("walk-down");
				is_moving = true;
				FlxTween.tween(this, { x: x_grid_to_screen(grid_x), y: y_grid_to_screen(grid_y)}, 0.3, {complete: end_movement});
			case GridMoveResult.MOVED(RhythmActionEnum.LEFT):
				animation.play("walk-left");
				is_moving = true;
				FlxTween.tween(this, { x: x_grid_to_screen(grid_x), y: y_grid_to_screen(grid_y)}, 0.3, {complete: end_movement});
			case GridMoveResult.MOVED(RhythmActionEnum.RIGHT):
				animation.play("walk-right");
				is_moving = true;
				FlxTween.tween(this, { x: x_grid_to_screen(grid_x), y: y_grid_to_screen(grid_y)}, 0.3, {complete: end_movement});
			default:
		}
	}
	
	private function end_movement(tween:FlxTween) : Void
	{
		is_moving = false;
	}
	
	private function x_grid_to_screen(_x:Float) : Float
	{
		return grid.x + (_x + 0.5) * grid.cell_width - 50 / 2.0;
	}
	
	private function y_grid_to_screen(_y:Float) : Float
	{
		return grid.y + (_y + 0.5) * grid.cell_height - 50;
	}
}