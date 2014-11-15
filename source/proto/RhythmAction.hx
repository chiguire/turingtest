package proto;

/**
 * ...
 * @author Ciro Duran
 */
class RhythmAction
{
	public var time : Int;
	public var action : RhythmActionEnum;

	public function new(time : Int, action : RhythmActionEnum) 
	{
		this.action = action;
	}
	
}