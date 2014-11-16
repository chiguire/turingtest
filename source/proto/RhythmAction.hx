package proto;

/**
 * ...
 * @author Ciro Duran
 */
class RhythmAction
{
	public var time : Float; //Difference with max_timer
	public var action : RhythmActionEnum;

	public function new(time : Float, action : RhythmActionEnum) 
	{
		this.action = action;
		this.time = time;
	}
	
}