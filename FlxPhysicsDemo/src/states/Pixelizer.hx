package states;
import flixel.addons.nape.FlxPhysSprite;
import flixel.addons.nape.FlxPhysState;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import flash.display.BitmapData;
import flixel.FlxG;
import openfl.Assets;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Pixelizer extends FlxPhysState 
{

	private var shooter:Shooter;
	
	override public function create():Void 
	{	
		super.create();
		FlxG.mouse.show();
		
		// Sets gravity.
		//FlxPhysState.space.gravity.setxy(0, 1500);

		createWalls( -2000, -2000, 1640, 480);
		createPixels();
		
		shooter = new Shooter();
		add(shooter);
											
	}
	
	private function createPixels() 
	{
		var image:BitmapData = Assets.getBitmapData("assets/logo.png");
		
		for (x in 0...30) 
		{
			for (y in 0...30)
			{
				var spr:FlxPhysSprite = new FlxPhysSprite(x * 4, y * 4);
				spr.makeGraphic(4, 4, 0xFFFFFFFF);
				spr.createRectangularBody();
				add(spr);
			}
		}
	}	
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.keys.justPressed("G"))
			disablePhysDebug(); // PhysState method to remove the debug graphics.
	}
	
}