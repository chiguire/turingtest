package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
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
import proto.ExpiringWarning;
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
	private var debug_state: FlxText;
	
	public static var player1_key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["W"] => RhythmActionEnum.UP,
		["S"] => RhythmActionEnum.DOWN,
		["A"] => RhythmActionEnum.LEFT,
		["D"] => RhythmActionEnum.RIGHT,
		["Q"] => RhythmActionEnum.RAISE_ARMS,
	];
	public static var player1_kill_button : Array<String> = ["E"];
	
	public static var player2_key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["I"] => RhythmActionEnum.UP,
		["K"] => RhythmActionEnum.DOWN,
		["J"] => RhythmActionEnum.LEFT,
		["L"] => RhythmActionEnum.RIGHT,
		["U"] => RhythmActionEnum.RAISE_ARMS,
	];
	public static var player2_kill_button : Array<String> = ["O"];
	
	private var character_group : FlxTypedGroup<Character>;
	private var player1_character : Null<Character>;
	private var player2_character : Null<Character>;
	private var grid : Grid;
	private var rhythm_manager : RhythmManager;
	public var vampire_kills : Int = 0;
	public var was_player1_frozen : Bool;
	public var was_player2_frozen : Bool;
	
	public var public_sound : FlxSound;
	//Interface
	
	//private var hud : HUD;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.log.redirectTraces = true;
		FlxG.fixedTimestep = false;
		var ballroom : FlxSprite = new FlxSprite(0, 0, AssetPaths.ballroom__png);
		add(ballroom);
		
		grid = new Grid(12, 16, 360, 240, 140-10, 135+14);
		add(grid);
		
		rhythm_manager = new RhythmManager();
		add(rhythm_manager);
		
		if (Reg.game_type == GameType.NORMAL)
		{
			reset_game();
		}
		else if (Reg.game_type == GameType.TUTORIAL)
		{
			reset_tutorial();
		}
		
		debug_text = new FlxText(110, 0, 200, "Actions");
		
		add(debug_text);
		
		FlxG.sound.playMusic(AssetPaths.waltz__mp3, 1, true);
		public_sound = FlxG.sound.play(AssetPaths.Walla_Bar__wav, 0.5, true);
		//Interface
		//hud = new d();
		//hud.set_bar( rhythm_manager.current_bars , rhythm_manager.bar_duration );
		//add(hud); 
		
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
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}
		
		if (!player2_character.alive || vampire_kills == 5)
		{
			rhythm_manager.active = false;
		}
		
		if ((!was_player1_frozen && !player1_character.can_move()) ||
		    (!was_player2_frozen && !player2_character.can_move()))
		{
			public_sound.stop();
			public_sound = FlxG.sound.play(AssetPaths.Walla_UpClose__wav, 0.5, true);
		}
		else if (player1_character.can_move() && player2_character.can_move() && !was_player1_frozen && !was_player2_frozen)
		{
			public_sound.stop();
			public_sound = FlxG.sound.play(AssetPaths.Walla_Bar__wav, 0.5, true);
		}
		was_player1_frozen = !player1_character.can_move();
		was_player2_frozen = !player2_character.can_move();
		
		if (player1_character.can_move())
		{
			for (k in player1_key_mapping.keys())
			{
				if (FlxG.keys.anyJustPressed(k))
				{
					if (rhythm_manager.player_move(player1_key_mapping.get(k), 1))
					{
						// Player 1 has made too many mistakes
						trace("Player 1: Too many mistakes");
						player1_character.freeze_mistake();
						
						var warning : ExpiringWarning = new ExpiringWarning(player1_character.x + player1_character.width / 2.0 - 25, player1_character.y - 30, 80);
						add(warning);
					}
					else
					{
						player1_character.try_move(player1_key_mapping.get(k), FlxG.keys.anyPressed(player1_kill_button) && Reg.game_type == GameType.NORMAL);
					}
				}
			}
		}
		
		if (player2_character.can_move())
		{
			for (k in player2_key_mapping.keys())
			{
				if (FlxG.keys.anyJustPressed(k))
				{
					if (rhythm_manager.player_move(player2_key_mapping.get(k), 2))
					{
						// Player 2 has made too many mistakes
						trace("Player 2: Too many mistakes");
						player2_character.freeze_mistake();
						
						var warning : ExpiringWarning = new ExpiringWarning(player1_character.x + player1_character.width / 2.0 - 25, player1_character.y - 30, 80);
						add(warning);
					}
					else
					{
						player2_character.try_move(player2_key_mapping.get(k), FlxG.keys.anyPressed(player2_kill_button) && Reg.game_type == GameType.NORMAL);
					}
				}
			}
		}
		
		//if (rhythm_manager.will_dancers_move())
		//{
			//trace("Moving to the " + Std.string(rhythm_manager.get_dancers_action()));
			for (c in character_group)
			{
				if (c == player1_character || c == player2_character)
				{
					continue;
				}
				
				c.next_dance_timer -= FlxG.elapsed;
				
				if (c.next_dance_timer <= 0.0)
				{
					//Move people in the decided action by the RhythmManager
					c.try_move(rhythm_manager.get_dancers_action(), false);
					
					c.next_dance_timer = rhythm_manager.max_timer + FlxRandom.floatRanged( -0.1, 0.1);
				}
			}
		//}
		//Testing stuff 
	
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
		//hud.roll_all_icons();

		
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
		
		character_group = new FlxTypedGroup<Character>();
		grid.character_group = character_group;
		add(character_group);
		
		var positions = generate_grid_positions(35);
		
		for (p in positions)
		{
			var is_female = FlxRandom.chanceRoll(50);
			var c = new Character(p.element(1), p.element(2), grid, is_female);
			character_group.add(c);
			c.next_dance_timer = rhythm_manager.max_timer + FlxRandom.floatRanged( -0.1, 0.1);
		}
		
		var player1_character : Character = character_group.getRandom();
		this.player1_character = player1_character;
		this.player1_character.is_player = 1;
		rhythm_manager.player1_character = player1_character;
		
		var player2_character : Character;
		do
		{
			player2_character = character_group.getRandom();
		} while (player2_character == player1_character);
		this.player2_character = player2_character;
		this.player2_character.is_player = 2;
		rhythm_manager.player2_character = player2_character;
		
		add(character_group);
		
		vampire_kills = 0;
	}
	
	private function reset_tutorial()
	{
		if (character_group != null)
		{
			for (i in character_group)
			{
				character_group.remove(i);
			}
			remove(character_group);
		}
		
		character_group = new FlxTypedGroup<Character>();
		grid.character_group = character_group;
		add(character_group);
		
		var c = new Character(Std.int(grid.grid_width/2 - 4), Std.int(grid.grid_height/2), grid, true);
		character_group.add(c);
		
		var player1_character : Character = c;
		this.player1_character = player1_character;
		this.player1_character.is_player = 1;
		rhythm_manager.player1_character = player1_character;
		
		c = new Character(Std.int(grid.grid_width/2 + 4), Std.int(grid.grid_height/2), grid, true);
		character_group.add(c);
		
		var player2_character : Character = c;
		this.player2_character = player2_character;
		this.player2_character.is_player = 2;
		rhythm_manager.player2_character = player2_character;
		
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