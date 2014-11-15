package proto;

import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ciro Duran
 */
class RhythmManager extends FlxSprite
{
	/*
	public static var key_mapping : Map<Int, RhythmActionEnum> = {
		FlxKey.W => RhythmActionEnum.UP,
		FlxKey.S => RhythmActionEnum.DOWN,
		FlxKey.A => RhythmActionEnum.LEFT,
		FlxKey.D => RhythmActionEnum.RIGHT,
		FlxKey.Q => RhythmActionEnum.RAISE_ARMS,
	};
	*/
	
	public var action_map : Map<Int, RhythmAction>;

	public var current_timer : Int;
	public var max_timer : Int;
	
	private var current_action : Null<RhythmAction>;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		current_timer = 0;
		max_timer = 120;
		
		action_map = new Map<Int, RhythmAction>();
		
		makeGraphic(100, 100, FlxColor.TRANSPARENT, true);
	}
	
	override public function update():Void 
	{
		super.update();
		
		current_timer = (current_timer + 1) % max_timer;
		
		current_action = get_nearest_action();
		
		if (action_map.exists(current_timer))
		{
			var ra : RhythmAction = action_map.get(current_timer);
		}
	}
	
	override public function draw() : Void
	{
		super.draw();
		
		var lineStyle1 : LineStyle = { color: FlxColor.WHITE, thickness: 1 };
		var lineStyle2 : LineStyle = { color: FlxColor.GRAY, thickness: 1 };
		var lineStyle3 : LineStyle = { color: FlxColor.RED, thickness: 1 };
		var fillStyle : FillStyle = { color: FlxColor.TRANSPARENT };
		
		var direction : FlxPoint = FlxAngle.rotatePoint(50, 0, 0, 0, (cast(current_timer, Float) / max_timer) * 360);
		
		drawCircle(50, 50, 50, FlxColor.WHITE, lineStyle1, fillStyle);
		drawLine(50, 50, 100, 50, lineStyle2);
		drawLine(50, 50, 50 + direction.x, 50 + direction.y, lineStyle3);
	}
	
	public function player_move(action:RhythmActionEnum) : Void
	{
		//Compare typed action against current_action
	}
	
	private function get_nearest_action() : Null<RhythmAction>
	{
		return null;
	}
}