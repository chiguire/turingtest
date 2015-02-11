package ;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import proto.RhythmActionEnum;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ciro Duran
 */
class HUDIcon extends FlxSprite
{
	public var y_height : Int = 260;
	public var beats_in_measure(default, null) : Int;
	public var in_beat(default, null) : Int;
	
	public function new(origin : FlxPoint, width : Float, action : RhythmActionEnum, beats_in_measure : Int, in_beat : Int)
	{
		super(origin.x, origin.y);
		
		this.beats_in_measure = beats_in_measure;
		this.in_beat = in_beat;
		this.y += (in_beat / beats_in_measure) * y_height;
		
		switch (action)
		{
			case RhythmActionEnum.DOWN:
				loadGraphic(AssetPaths.button3__png);
				x += 3 * width;
			case RhythmActionEnum.UP:
				loadGraphic(AssetPaths.button2__png);
				x += 2 * width;
			case RhythmActionEnum.LEFT:
				loadGraphic(AssetPaths.button4__png);
				x += 1 * width;
			case RhythmActionEnum.RIGHT:
				loadGraphic(AssetPaths.button5__png);
				x += 0 * width;
			case RhythmActionEnum.RAISE_ARMS:
				loadGraphic(AssetPaths.button1__png);
				x += 4 * width;
			case RhythmActionEnum.BAR:
				makeGraphic(Std.int(5 * width - 10), 10, FlxColor.TRANSPARENT, true);
				drawLine(0, 9, this.width, 9, { color: FlxColor.AQUAMARINE, thickness: 1.0 } );
			case RhythmActionEnum.NONE:
		}
		
		update();
	}
}