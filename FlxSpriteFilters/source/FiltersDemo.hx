package ;
import flash.Lib;
import flixel.FlxGame;
import states.PlayState;

/**
 * @author 
 */

class FiltersDemo extends FlxGame
{

	public function new() 
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 640;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		#if (flash || desktop || neko)
		super(Math.floor(stageWidth / ratio) , Math.floor(stageHeight / ratio), PlayState, ratio, 60, 60);
		#else
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), PlayState, ratio, 60, 30);
		#end
		
		//forceDebugger = true;
		//useSystemCursor = true;
		//mouseEnabled = true;
		//_mouse.visible = true;
	}
	
}