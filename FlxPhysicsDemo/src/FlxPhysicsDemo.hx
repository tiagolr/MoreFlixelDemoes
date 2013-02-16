package ;
import nme.Lib;
import org.flixel.FlxGame;
import states.Balls;
import states.Explosions;
import states.Piramid;
import states.Pixelizer;
import states.SolarSystem;

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
		
		var ratioX:Float = stageWidth / 640;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		#if (flash || desktop || neko)
		super(Math.floor(stageWidth / ratio) , Math.floor(stageHeight / ratio), Explosions, ratio, 60, 60,true);
		#else
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), Explosions, ratio, 60, 30,true);
		#end

		forceDebugger = true;
		useSystemCursor = true;
		mouseEnabled = true;
		_mouse.visible = true;
	}

}