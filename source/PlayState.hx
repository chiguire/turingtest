package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import proto.Grid;
import proto.Character;
import proto.RhythmActionEnum;
import proto.RhythmManager;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var character_list : List<Character>;
	private var player_character : Null<Character>;
	private var grid : Grid;
	private var rhythm_manager : RhythmManager;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		grid = new Grid(8, 6);
		add(grid);
		
		character_list = new List<Character>();
		var c = new Character(2, 4, grid, FlxColor.IVORY);
		add(c);
		character_list.push(c);
		
		player_character = c;
		c.is_player = 0;
		
		c = new Character(4, 5, grid, FlxColor.RED);
		add(c);
		character_list.push(c);
		
		rhythm_manager = new RhythmManager();
		add(rhythm_manager);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.anyJustPressed(["UP", "W"]))
		{
			rhythm_manager.player_move(RhythmActionEnum.UP);
			player_character.move(RhythmActionEnum.UP);
		}
		else if (FlxG.keys.anyJustPressed(["DOWN", "S"]))
		{
			rhythm_manager.player_move(RhythmActionEnum.DOWN);
			player_character.move(RhythmActionEnum.DOWN);
		}
		else if (FlxG.keys.anyJustPressed(["LEFT", "A"]))
		{
			rhythm_manager.player_move(RhythmActionEnum.LEFT);
			player_character.move(RhythmActionEnum.LEFT);
		}
		else if (FlxG.keys.anyJustPressed(["RIGHT", "D"]))
		{
			rhythm_manager.player_move(RhythmActionEnum.RIGHT);
			player_character.move(RhythmActionEnum.RIGHT);
		}
		else if (FlxG.keys.anyJustPressed(["Q"]))
		{
			rhythm_manager.player_move(RhythmActionEnum.RAISE_ARMS);
			player_character.move(RhythmActionEnum.RAISE_ARMS);
		}
		
		for (c in character_list)
		{
			if (c == player_character)
			{
				continue;
			}
			
			//Move people in the decided action by the RhythmManager
		}
	}	
}