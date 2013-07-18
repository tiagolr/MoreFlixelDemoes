package states;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

/**
 * ...
 * @author TiagoLr (~~~ ProG4mr ~~~)
 */
class FlxPhysGroup extends FlxGroup
{

	public function new(MaxSize:Int = 0) 
	{
		super(MaxSize);
	}
	
	override public function add(Object:FlxBasic):FlxBasic
	{
		super.add(Object);
		return Object;
	}
	
}