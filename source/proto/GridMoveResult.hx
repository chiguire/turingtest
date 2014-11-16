package proto;

/**
 * @author Ciro Duran
 */
import proto.Tuple;

enum GridMoveResult 
{
	NONE;
	ACTED(direction:RhythmActionEnum);
	MOVED(direction:RhythmActionEnum);
	SWAPPED(direction:RhythmActionEnum, original_position:Tuple2<Int, Int>, character:Character);
	TRIPPED(direction:RhythmActionEnum);
}