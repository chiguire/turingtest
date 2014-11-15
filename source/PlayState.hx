package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import proto.Grid;
import proto.Character;
import proto.RhythmActionEnum;
import proto.RhythmManager;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var debug_text : FlxText;
	
	public static var key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["W"] => RhythmActionEnum.UP,
		["S"] => RhythmActionEnum.DOWN,
		["A"] => RhythmActionEnum.LEFT,
		["D"] => RhythmActionEnum.RIGHT,
		["Q"] => RhythmActionEnum.RAISE_ARMS,
	];
	
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
		
		var ballroom : FlxSprite = new FlxSprite(0, 0, AssetPaths.ballroom__png);
		add(ballroom);
		
		grid = new Grid(12, 16, 360, 240, 140, 135);
		add(grid);
		
		character_list = new List<Character>();
		var c = new Character(2, 4, grid, FlxColor.IVORY);
		add(c);
		character_list.push(c);
		
		player_character = c;
		c.is_player = 0;
		
		c = new Character(4, 3, grid, FlxColor.RED);
		add(c);
		character_list.push(c);
		
		rhythm_manager = new RhythmManager();
		add(rhythm_manager);
		
		debug_text = new FlxText(110, 0, 200, "Actions");
		add(debug_text);
		
		FlxG.sound.playMusic(AssetPaths.waltz__mp3, 1, true);
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
		
		for (k in key_mapping.keys())
		{
			if (FlxG.keys.anyJustPressed(k))
			{
				rhythm_manager.player_move(key_mapping.get(k));
				player_character.move(key_mapping.get(k));
			}
		}
		
		if (rhythm_manager.will_dancers_move())
		{
			for (c in character_list)
			{
				if (c == player_character)
				{
					continue;
				}
				
				//Move people in the decided action by the RhythmManager
				c.move(rhythm_manager.get_dancers_action());
			}
		}
		
		grid.resolve_swaps();
		
		if (rhythm_manager.first_bars < 4)
		{
			debug_text.text = 'First bars! Get ready! ${rhythm_manager.first_bars}/4';
		}
		else
		{
			debug_text.text = get_debug_text();
		}
	}	
	
	private function get_debug_text() : String
	{
		var result : String = "";
		
		var i : Int = 0;
		for (a in rhythm_manager.action_map)
		{
			result += (if (i == rhythm_manager.next_action_index) ">" else "-") + " " + Std.string(a.action) + "\n";
			i++;
		}
		return result;
	}
}