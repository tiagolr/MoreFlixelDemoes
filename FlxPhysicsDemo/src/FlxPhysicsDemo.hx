package ;
import nme.Lib;
import org.flixel.FlxGame;
import states.Piramid;

/**
 * Demo for HaxeFlixel nape physics.
 * 
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 * @link https://github.com/ProG4mr
 */

class FlxPhysicsDemo extends FlxGame
{

	public function new() 
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 600;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		#if TRUE_ZOOM_OUT
		ratio *= 0.5;
		#end
		
		#if (flash || desktop || neko)
		super(Math.floor(stageWidth / ratio) , Math.floor(stageHeight / ratio), Piramid, ratio, 60, 60, true);
		#else
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), Piramid, ratio, 60, 30, true);
		#end

		forceDebugger = true;
		useSystemCursor = true;
		mouseEnabled = true;
		_mouse.visible = true;
	}

}