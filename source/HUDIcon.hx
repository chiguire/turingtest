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
	public var in_time : Float;
	public var current_time : Float;
	public var look_ahead_time : Float;
	public var point_zero : FlxPoint;
	public var y_height : Int = 260;
	
	public function new(origin : FlxPoint, width : Float, action : RhythmActionEnum, in_time : Float, look_ahead_time : Float)
	{
		super(origin.x, origin.y);
		
		point_zero = origin;
		this.current_time = 0;
		this.in_time = in_time;
		this.look_ahead_time = look_ahead_time;
		
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
	
	override public function update():Void 
	{
		super.update();
		
		y = point_zero.y + (in_time - current_time) / look_ahead_time * y_height;
	}
	
	public function end_tween(tween:FlxTween) : Void
	{
		destroy();
	}
}