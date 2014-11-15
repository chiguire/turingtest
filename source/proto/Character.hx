package proto;

import flixel.FlxG;
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
	
	public function new(grid_x:Int, grid_y:Int, grid:Grid, color : Int = FlxColor.WHITE) 
	{
		super(0, 0);
		this.grid_x = grid_x;
		this.grid_y = grid_y;
		this.grid = grid;
		cell_color = color;
		makeGraphic(cast(grid.cell_width, Int), cast(grid.cell_height, Int), FlxColor.TRANSPARENT, true);
		x = grid_x * grid.cell_width;
		y = grid_y * grid.cell_height;
		
		
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		var lineStyle : LineStyle = { color: FlxColor.WHITE, thickness: if (is_player == 1) 1 else 0 };
		var fillStyle : FillStyle = { color: this.color, alpha: 0.9 };
		
		drawCircle(grid.cell_width * 0.5, grid.cell_height * 0.5, grid.cell_width * 0.5, cell_color, lineStyle, fillStyle);
	}
	
	override public function update():Void
	{
		super.update();
		
		x = grid_x * grid.cell_width;
		y = grid_y * grid.cell_height;
	}
	
	public function move(action : RhythmActionEnum) : Void
	{
		last_action = action;
		grid.try_move(this, action);
	}
	
}