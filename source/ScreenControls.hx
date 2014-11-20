package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Ciro Duran
 */
class ScreenControls extends FlxSpriteGroup
{

	public var music : FlxSprite;
	public var sound : FlxSprite;
	public var fullscreen: FlxSprite;
	
	public var was_music_active : Bool;
	public var was_fullscreen_active : Bool;
	public var was_sound_active : Bool;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		music = new FlxSprite(FlxG.width - 90, FlxG.height - 30);
		music.loadGraphic(AssetPaths.music__png, true, 20, 20, true);
		music.animation.add("on", [0]);
		music.animation.add("off", [1]);
		add(music);
		
		sound = new FlxSprite(FlxG.width - 60, FlxG.height - 30);
		sound.loadGraphic(AssetPaths.sfx__png, true, 20, 20, true);
		sound.animation.add("on", [0]);
		sound.animation.add("off", [1]);
		add(sound);
		
		fullscreen = new FlxSprite(FlxG.width - 30, FlxG.height - 30);
		fullscreen.loadGraphic(AssetPaths.fullscreen__png, true, 20, 20, true);
		fullscreen.animation.add("on", [0]);
		fullscreen.animation.add("off", [1]);
		add(fullscreen);
		
		was_fullscreen_active = Reg.fullscreen_active;
		was_music_active = Reg.music_active;
		was_sound_active = Reg.sound_active;
	}
	
	
	public override function update() : Void
	{
		if (FlxG.mouse.justPressed)
		{
			if (music.overlapsPoint(FlxG.mouse.getScreenPosition(), true))
			{
				Reg.switch_music();
			}
			
			if (sound.overlapsPoint(FlxG.mouse.getScreenPosition(), true))
			{
				Reg.switch_sound();
			}
			
			if (fullscreen.overlapsPoint(FlxG.mouse.getScreenPosition(), true))
			{
				Reg.switch_fullscreen();
			}
		}
		
		if (was_music_active != Reg.music_active)
		{
			music.animation.play(Reg.music_active? "on": "off");
		}
		
		if (was_sound_active != Reg.sound_active)
		{
			sound.animation.play(Reg.sound_active? "on": "off");
		}
		
		if (was_fullscreen_active != Reg.fullscreen_active)
		{
			fullscreen.animation.play(!Reg.fullscreen_active? "on": "off");
		}
		
		was_fullscreen_active = Reg.fullscreen_active;
		was_music_active = Reg.music_active;
		was_sound_active = Reg.sound_active;
	}
}