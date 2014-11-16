package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSort;
import proto.Grid;
import proto.Character;
import proto.RhythmActionEnum;
import proto.RhythmManager;
import proto.Tuple;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var debug_text : FlxText;
	
	public static var player1_key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["W"] => RhythmActionEnum.UP,
		["S"] => RhythmActionEnum.DOWN,
		["A"] => RhythmActionEnum.LEFT,
		["D"] => RhythmActionEnum.RIGHT,
		["Q"] => RhythmActionEnum.RAISE_ARMS,
	];
	
	public static var player2_key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["I"] => RhythmActionEnum.UP,
		["K"] => RhythmActionEnum.DOWN,
		["J"] => RhythmActionEnum.LEFT,
		["L"] => RhythmActionEnum.RIGHT,
		["U"] => RhythmActionEnum.RAISE_ARMS,
	];
	
	private var character_group : FlxGroup;
	private var player1_character : Null<Character>;
	private var player2_character : Null<Character>;
	private var grid : Grid;
	private var rhythm_manager : RhythmManager;
	//Interface
	
	private var hud : HUD;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.fixedTimestep = false;
		
		var ballroom : FlxSprite = new FlxSprite(0, 0, AssetPaths.ballroom__png);
		add(ballroom);
		
		grid = new Grid(12, 16, 360, 240, 140, 135);
		add(grid);
		
		reset_game();
		
		rhythm_manager = new RhythmManager();
		add(rhythm_manager);
		
		debug_text = new FlxText(110, 0, 200, "Actions");
		add(debug_text);
		
		FlxG.sound.playMusic(AssetPaths.waltz__mp3, 1, true);
		
		//Interface
		hud = new HUD();
		//hud.set_bar( rhythm_manager.current_bars , rhythm_manager.bar_duration );
		add(hud); 
		
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
		
		for (k in player1_key_mapping.keys())
		{
			if (FlxG.keys.anyJustPressed(k))
			{
				if (rhythm_manager.player_move(player1_key_mapping.get(k), 2))
				{
					// Player 1 has made too many mistakes
					trace("Player 1: Too many mistakes");
				}
				player1_character.try_move(player1_key_mapping.get(k));
			}
		}
		
		
		for (k in player2_key_mapping.keys())
		{
			if (FlxG.keys.anyJustPressed(k))
			{
				if (rhythm_manager.player_move(player2_key_mapping.get(k), 2))
				{
					// Player 2 has made too many mistakes
					trace("Player 2: Too many mistakes");
				}
				player2_character.try_move(player2_key_mapping.get(k));
			}
		}
		
		if (rhythm_manager.will_dancers_move())
		{
			trace("Moving to the " + Std.string(rhythm_manager.get_dancers_action()));
			for (c in character_group)
			{
				if (c == player1_character || c == player2_character)
				{
					continue;
				}
				
				//Move people in the decided action by the RhythmManager
				cast(c, Character).try_move(rhythm_manager.get_dancers_action());
			}
		}
		//Testing stuff 
		if (rhythm_manager.will_dancers_move()) {
			hud.generate_icon();
		}
		grid.resolve_movements();
		
		if (rhythm_manager.current_bars < 4)
		{
			debug_text.text = 'First bars! Get ready! ${rhythm_manager.current_bars}/4';
		}
		else
		{
			debug_text.text = get_debug_text();
		}
		
		character_group.sort(function (Order:Int, Obj1:FlxBasic, Obj2:FlxBasic):Int
		{
			return FlxSort.byValues(Order, cast(Obj1, FlxSprite).y, cast(Obj2, FlxSprite).y);
		}, FlxSort.ASCENDING);
		
		//Interface
		hud.roll_all_icons();
		
	}	
	
	private function reset_game() : Void
	{
		if (character_group != null)
		{
			for (i in character_group)
			{
				character_group.remove(i);
			}
			remove(character_group);
		}
		
		character_group = new FlxGroup();
		grid.character_group = character_group;
		add(character_group);
		
		var positions = generate_grid_positions(35);
		
		for (p in positions)
		{
			var is_female = FlxRandom.chanceRoll(50);
			var c = new Character(p.element(1), p.element(2), grid, is_female);
			character_group.add(c);
		}
		
		var player1_character : Character = cast(character_group.getRandom(), Character);
		this.player1_character = player1_character;
		this.player1_character.is_player = 1;
		
		var player2_character : Character;
		do
		{
			player2_character = cast(character_group.getRandom(), Character);
		} while (player2_character == player1_character);
		this.player2_character = player2_character;
		this.player2_character.is_player = 2;
		
		add(character_group);
		
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
	
	private function generate_grid_positions(howMany:Int = 10) : Array<Tuple2<Int, Int>>
	{
		var arr: Array<Tuple2<Int, Int>> = new Array<Tuple2<Int, Int>>();
		for (i in 1...grid.grid_width-1)
		{
			for (j in 1...grid.grid_height-1)
			{
				arr.push(new Tuple2(i, j));
			}
		}
		
		FlxRandom.shuffleArray(arr, arr.length * 4);
		
		return arr.splice(0, howMany);
	}
	
}