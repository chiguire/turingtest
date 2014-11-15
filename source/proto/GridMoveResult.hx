package proto;

/**
 * @author Ciro Duran
 */

enum GridMoveResult 
{
	NONE;
	MOVED(direction:RhythmActionEnum);
	SWAPPED(direction:RhythmActionEnum);
	TRIPPED(direction:RhythmActionEnum);
}