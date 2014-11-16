package proto;

/**
 * ...
 * @author Ciro Duran
 */
class RhythmAction
{
	public var time : Float;
	public var action : RhythmActionEnum;

	public function new(time : Float, action : RhythmActionEnum) 
	{
		this.action = action;
	}
	
}