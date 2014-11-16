package proto;

import flixel.FlxSprite;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Ciro Duran
 */
class ExpiringWarning extends FlxSprite
{

	private var timer : Int = 0;
	private var base_x : Float;
	private var base_y : Float;
	
	public function new(X:Float=0, Y:Float=0, timer:Int) 
	{
		super(X, Y, AssetPaths.exclamation__png);
		this.timer = timer;
		base_x = X;
		base_y = Y;
	}
	
	public override function update() : Void
	{
		super.update();
		
		x = base_x + FlxRandom.intRanged( -2, 2);
		y = base_y + FlxRandom.intRanged( -2, 2);
		
		timer--;
		
		if (timer == 0)
		{
			destroy();
		}
	}
	

	
}