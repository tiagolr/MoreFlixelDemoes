package ;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxGame;
import org.flixel.nape.FlxPhysState;
import states.Balls;
import states.Explosions;
import states.Piramid;
import states.Pixelizer;
import states.SolarSystem;
import FlxPhysicsDemo;

/**
 * Demo for HaxeFlixel nape physics.
 * 
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 * @link https://github.com/ProG4mr
 */

class FlxPhysicsDemo extends FlxGame
{
	private static var currentState:Int = 0;
	
	public function new() 
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 640;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		#if (flash || desktop || neko)
		super(Math.floor(stageWidth / ratio) , Math.floor(stageHeight / ratio), Piramid, ratio, 60, 60);
		#else
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), Piramid, ratio, 60, 30);
		#end
	}
	
	public static function nextState()
	{
		currentState++;
		currentState %= 4;
		switchState();
	}
	
	public static function prevState()
	{
		currentState--;
		currentState < 0 ? currentState = 3 : null;
		switchState();
	}
	
	private static function switchState()
	{
		trace("current state " + currentState);
		switch (currentState)
		{
			case 0:	FlxG.switchState(new Piramid());
			case 1: FlxG.switchState(new Balls());
			case 2: FlxG.switchState(new SolarSystem());
			case 3: FlxG.switchState(new Explosions());
		}
	}

}