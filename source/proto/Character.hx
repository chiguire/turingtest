package proto;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
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
	
	public var cell_color : Int;
	public var is_player : Int;
	public var is_female : Bool;
	
	public function new(grid_x:Int, grid_y:Int, grid:Grid, color : Int = FlxColor.WHITE) 
	{
		super(0, 0);
		this.grid_x = grid_x;
		this.grid_y = grid_y;
		this.grid = grid;
		this.is_female = true;
		cell_color = color;
		
		loadGraphic(AssetPaths.female_dancer__png, true, 50, 50);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		animation.add("idle", [0], 60, true);
		animation.add("walk-up", [1, 2, 3, 4], 10, false);
		animation.add("walk-right", [5, 6, 7, 8], 10, false);
		animation.add("walk-left", [9, 10, 11, 12], 10, false);
		animation.add("walk-down", [13, 14, 15, 16], 10, false);
		animation.play("idle");
		
		x = grid.x + (grid_x+0.5) * grid.cell_width - 50/2.0;
		y = grid.y + (grid_y+0.5) * grid.cell_height - 50;
		
		
	}
	
	override public function draw():Void 
	{
		super.draw();
	}
	
	override public function update():Void
	{
		super.update();
		
		x = grid.x + (grid_x+0.5) * grid.cell_width - 50/2.0;
		y = grid.y + (grid_y+0.5) * grid.cell_height - 50;
	}
	
	public function move(action : RhythmActionEnum) : Void
	{
		last_action = action;
		var gmr : GridMoveResult = grid.try_move(this, action);
		
		switch (gmr)
		{
			case GridMoveResult.MOVED(RhythmActionEnum.UP):
				animation.play("walk-up");
				facing = FlxObject.UP;
			case GridMoveResult.MOVED(RhythmActionEnum.DOWN): 
				animation.play("walk-down");
				facing = FlxObject.DOWN;
			case GridMoveResult.MOVED(RhythmActionEnum.LEFT):
				animation.play("walk-left");
				facing = FlxObject.LEFT;
			case GridMoveResult.MOVED(RhythmActionEnum.RIGHT):
				animation.play("walk-right");
				facing = FlxObject.RIGHT;
			default:
		}
	}
	
}