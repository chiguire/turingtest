package proto;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.*;
import proto.Tuple;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ciro Duran
 */
class Grid extends FlxSprite
{
	public var grid_width : Int;
	public var grid_height : Int;
	public var sprite_width : Int;
	public var sprite_height : Int;
	public var cell_width (default, null): Float;
	public var cell_height (default, null): Float;
	public var character_group : FlxTypedGroup<Character>;

	public function new(grid_width : Int, grid_height : Int, sprite_width : Int, sprite_height : Int, x : Int = 0, y : Int = 0) 
	{
		super(x, y);
		this.grid_width = grid_width;
		this.grid_height = grid_height;
		this.sprite_width = sprite_width;
		this.sprite_height = sprite_height;
		this.cell_width = sprite_width / grid_width;
		this.cell_height = sprite_height / grid_height;
		makeGraphic(sprite_width, sprite_height, FlxColor.TRANSPARENT, true);
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		var lineStyle : LineStyle = { color: FlxColor.NAVY_BLUE, thickness: 1 };
		
		for (i in 0...grid_width + 1)
		{
			var x = (cast(i, Float) / grid_width) * sprite_width;
			drawLine(x, 0, x, FlxG.height, lineStyle);
		}
		
		for (j in 0...grid_height + 1)
		{
			var y = (cast(j, Float) / grid_height) * sprite_height;
			drawLine(0, y, FlxG.width, y, lineStyle);
		}
	}
	
	public function resolve_movements()
	{
		for (c in character_group)
		{
			if (c.last_action == RhythmActionEnum.NONE)
			{
				continue;
			}
			
			c.resolve_movement(try_move(c, c.last_action));
		}
	}
	
	public function try_move(c:Character, a:RhythmActionEnum) : GridMoveResult
	{
		var original_position : Tuple2<Int, Int> = new Tuple2(c.grid_x, c.grid_y);
		var is_moved : Bool = false;
		
		if (a == RhythmActionEnum.UP)
		{
			if (c.grid_y - 1 >= 0)
			{
				c.grid_y--;
				is_moved = true;
			}
			else
			{
				return GridMoveResult.TRIPPED(a);
			}
		}
		else if (a == RhythmActionEnum.DOWN)
		{
			if (c.grid_y + 1 < grid_height)
			{
				c.grid_y++;
				is_moved = true;
			}
			else
			{
				return GridMoveResult.TRIPPED(a);
			}
		}
		else if (a == RhythmActionEnum.LEFT)
		{
			if (c.grid_x - 1 >= 0)
			{
				c.grid_x--;
				is_moved = true;
			}
			else
			{
				return GridMoveResult.TRIPPED(a);
			}
		}
		else if (a == RhythmActionEnum.RIGHT)
		{
			if (c.grid_x + 1 < grid_width)
			{
				c.grid_x++;
				is_moved = true;
			}
			else
			{
				return GridMoveResult.TRIPPED(a);
			}
		}
		
		var someone : Character = get_someone_at(c.grid_x, c.grid_y, c);
				
		if (someone != null && someone.last_action != a)
		{
			return GridMoveResult.SWAPPED(a, original_position, someone, c.is_killing);
		}
		else if (is_moved)
		{
			return GridMoveResult.MOVED(a);
		}
		
		return GridMoveResult.ACTED(a);
	}
	
	private function get_someone_at(i:Int, j:Int, not_this_character:Character) : Null<Character>
	{
		for (c in character_group)
		{
			if (c != not_this_character && c.grid_x == i && c.grid_y == j)
			{
				return c;
			}
		}
		return null;
	}
}