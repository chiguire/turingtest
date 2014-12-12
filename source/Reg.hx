package;

import flixel.util.FlxSave;
import flixel.FlxG;
import proto.Character;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	public static var game_type:GameType;
	public static var vampire_kills : Int = 0;
	
	public static function switch_music() : Void
	{
		music_active = !music_active;
		FlxG.sound.music.volume = music_active? 0.6: 0.0;
	}
	
	public static function switch_sound() : Void
	{
		sound_active = !sound_active;
		FlxG.sound.volume = sound_active? 1.0: 0.0;
	}
	
	#if (web || desktop)
	public static function switch_fullscreen() : Void
	{
		fullscreen_active = !fullscreen_active;
		FlxG.fullscreen = fullscreen_active;
	}
	#end
	
	public static var music_active : Bool = true;
	public static var sound_active : Bool = true;
	
	#if (web || desktop)
	public static var fullscreen_active : Bool = false;
	#end
}