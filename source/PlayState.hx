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
import flixel.ui.FlxBar;
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
	//private var debug_text : FlxText;
	//private var debug_state: FlxText;
	
	public static var player1_key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["W"] => RhythmActionEnum.UP,
		["S"] => RhythmActionEnum.DOWN,
		["A"] => RhythmActionEnum.LEFT,
		["D"] => RhythmActionEnum.RIGHT,
		["Q"] => RhythmActionEnum.RAISE_ARMS,
	];
	//public static var player1_kill_button : Array<String> = ["E"];
	
	public static var player2_key_mapping : Map<Array<String>, RhythmActionEnum> = [
		["UP"] => RhythmActionEnum.UP,
		["DOWN"] => RhythmActionEnum.DOWN,
		["LEFT"] => RhythmActionEnum.LEFT,
		["RIGHT"] => RhythmActionEnum.RIGHT,
		["P"] => RhythmActionEnum.RAISE_ARMS,
	];
	//public static var player2_kill_button : Array<String> = ["E"];
	
	private var character_group : FlxTypedGroup<Character>;
	private var player1_character : Null<Character>;
	private var player2_character : Null<Character>;
	private var grid : Grid;
	private var rhythm_manager : RhythmManager;
	
	public var is_public_agitated : Bool;
	public var was_public_agitated : Bool;
	public var public_sound : FlxSound;
	//Chance of the A.I making a mistake
	public var error_probability : Int = 6;
	
	private var vampire_kills : Array<FlxSprite>;
	private var game_over : Bool;
	private var game_over_1 : FlxSprite;
	private var game_over_2 : FlxSprite;
	private var game_over_timer : Float;
	
	private var player1_bar : FlxBar;
	private var player2_bar : FlxBar;
	
	private var screen_controls : ScreenControls;
	
	//Interface
	
	private var hud : HUD;
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
		rhythm_manager.x = FlxG.width - 200;
		add(rhythm_manager);
		
		var vampire_kill_ui = new FlxSprite(0, 0, AssetPaths.UI_vampireavatar__png);
		add(vampire_kill_ui);
		
		vampire_kills = new Array<FlxSprite>();
		
		for (i in 0...5)
		{
			var kill = new FlxSprite(127 + 10 * i, 440, AssetPaths.UI_vampireavatarkillicon__png);
			add(kill);
			kill.visible = false;
			vampire_kills.push(kill);
		}
		
		if (Reg.game_type == GameType.NORMAL)
		{
			reset_game();
		}
		else if (Reg.game_type == GameType.TUTORIAL)
		{
			reset_tutorial();
		}
		
		var txt : FlxText = new FlxText(20, 7, 0, "Player 1");
		add(txt);
		
		txt = new FlxText(420, 7, 0, "Player2");
		add(txt);
		
		player1_bar = new FlxBar(20, 20, FlxBar.FILL_LEFT_TO_RIGHT, 200, 10, null, "", 0, 1, true);
		player2_bar = new FlxBar(420, 20, FlxBar.FILL_LEFT_TO_RIGHT, 200, 10, null, "", 0, 1, true);
		add(player1_bar);
		add(player2_bar);
		
		game_over = false;
		
		game_over_1 = new FlxSprite(FlxG.width / 2 - 360 / 2, FlxG.height / 2 - 240 / 2, AssetPaths.gameoverhunter__png);
		game_over_1.visible = false;
		add(game_over_1);
		
		game_over_2 = new FlxSprite(FlxG.width / 2 - 360 / 2, FlxG.height / 2 - 240 / 2, AssetPaths.gameovervampire__png);
		game_over_2.visible = false;
		add(game_over_2);
		
		FlxG.sound.playMusic(AssetPaths.waltz__mp3, 0.6, true);
		public_sound = FlxG.sound.play(AssetPaths.Walla_Bar__wav, 1, true);
		
		//Interface
		hud = new HUD( rhythm_manager );
		add(hud);
		
		screen_controls = new ScreenControls();
		add(screen_controls);
		
		FlxG.watch.add(player1_character, "can_move_freely", "p1freemove");
		FlxG.watch.add(player2_character, "can_move_freely", "p2freemove");
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
		
		for (i in 0...Reg.vampire_kills)
		{
			vampire_kills[i].visible = true;
		}
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
			return;
		}
		
		if (!player2_character.alive || !player1_character.alive || Reg.vampire_kills == 5)
		{
			rhythm_manager.active = false;
			character_group.active = false;
			
			if (!game_over)
			{
				if (!player2_character.alive)
				{
					game_over_1.visible = true;
					game_over_timer = 1.5;
					game_over = true;
				}
				else if (!player1_character.alive || Reg.vampire_kills == 5)
				{
					game_over_2.visible = true;
					game_over_timer = 1.5;
					game_over = true;
				}
			}
			else
			{
				if (game_over_timer >= 0)
				{
					game_over_timer -= FlxG.elapsed;
				}
			}
			
			if (FlxG.keys.justPressed.ANY && game_over_timer < 0)
			{
				FlxG.switchState(new PlayState());
			}
		}
		
		is_public_agitated = !player1_character.can_move() || !player2_character.can_move();
		player1_character.can_move_freely = is_public_agitated;
		player2_character.can_move_freely = is_public_agitated;
		if (is_public_agitated != was_public_agitated)
		{
			public_sound.stop();
			if (is_public_agitated)
			{
				public_sound = FlxG.sound.play(AssetPaths.Walla_UpClose__wav, 1, true);
			}
			else
			{
				public_sound = FlxG.sound.play(AssetPaths.Walla_Bar__wav, 1, true);
			}
		}
		was_public_agitated = is_public_agitated;
		
		for (c in character_group)
		{
			c.resolved_this_movement = false;
		}

		if (rhythm_manager.current_bars >= rhythm_manager.first_bars_max - 1)
		{
			if (player1_character.can_move())
			{
				for (k in player1_key_mapping.keys())
				{
					if (FlxG.keys.anyJustPressed(k))
					{
						if (!player1_character.is_moving && rhythm_manager.player_move(player1_key_mapping.get(k), 1))
						{
							// Player 1 has made too many mistakes
							freeze_mistake(player1_character);
						}
						else
						{
							player1_character.try_move(player1_key_mapping.get(k));
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
							freeze_mistake(player2_character);
						}
						else
						{
							player2_character.try_move(player2_key_mapping.get(k));
						}
					}
				}
			}
		}
		
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
			}
		}
		
		if (rhythm_manager.will_dancers_move())
		{
			for (c in character_group)
			{
				if (c == player1_character || c == player2_character)
				{
					continue;
				}
				
				if (FlxRandom.chanceRoll(error_probability))
				{
					c.next_dance_timer = rhythm_manager.max_timer - rhythm_manager.current_timer + FlxRandom.floatRanged( -0.2, 0.0);
				}
				else
				{
					c.next_dance_timer = rhythm_manager.max_timer - rhythm_manager.current_timer;
				}
			}
		}
		
		grid.resolve_movements();
		
		character_group.sort(function (Order:Int, Obj1:FlxBasic, Obj2:FlxBasic):Int
		{
			return FlxSort.byValues(Order, cast(Obj1, FlxSprite).y, cast(Obj2, FlxSprite).y);
		}, FlxSort.ASCENDING);
		
		player1_bar.currentValue = rhythm_manager.get_error_normalised(1);
		player2_bar.currentValue = rhythm_manager.get_error_normalised(2);
		
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
			c.freeze_callback = freeze_mistake;
			character_group.add(c);
			
			if (FlxRandom.chanceRoll(error_probability))
			{
				c.next_dance_timer = rhythm_manager.max_timer - rhythm_manager.current_timer + FlxRandom.floatRanged( -0.2, 0.0);
			}
			else
			{
				c.next_dance_timer = rhythm_manager.max_timer - rhythm_manager.current_timer;
			}
		}
		
		var player1_character : Character = character_group.getRandom();
		this.player1_character = player1_character;
		this.player1_character.is_player = 1;
		this.player1_character.freeze_callback = freeze_mistake;
		rhythm_manager.player1_character = player1_character;
		
		var player2_character : Character;
		do
		{
			player2_character = character_group.getRandom();
		} while (player2_character == player1_character);
		this.player2_character = player2_character;
		this.player2_character.is_player = 2;
		this.player2_character.freeze_callback = freeze_mistake;
		rhythm_manager.player2_character = player2_character;
		
		add(character_group);
		is_public_agitated = false;
		was_public_agitated = false;
		Reg.vampire_kills = 0;
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
		
		var c = new Character(Std.int(grid.grid_width / 2 - 4), Std.int(grid.grid_height / 2), grid, true);
		c.freeze_callback = freeze_mistake;
		character_group.add(c);
		
		var player1_character : Character = c;
		this.player1_character = player1_character;
		this.player1_character.is_player = 1;
		rhythm_manager.player1_character = player1_character;
		
		c = new Character(Std.int(grid.grid_width / 2 + 4), Std.int(grid.grid_height / 2), grid, true);
		c.freeze_callback = freeze_mistake;
		character_group.add(c);
		
		var player2_character : Character = c;
		this.player2_character = player2_character;
		this.player2_character.is_player = 2;
		rhythm_manager.player2_character = player2_character;
		
		is_public_agitated = false;
		was_public_agitated = false;
		add(character_group);
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
	
	private function freeze_mistake(character:Character)
	{
		var warning : ExpiringWarning = new ExpiringWarning(character.x + character.width / 2.0 - 25, character.y - 30, 180);
		add(warning);
	}
}