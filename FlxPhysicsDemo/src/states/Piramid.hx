package states;
import flixel.text.FlxText;
import flixel.util.FlxRandom;
import FlxPhysicsDemo;
import flixel.addons.nape.FlxPhysSprite;
import flixel.addons.nape.FlxPhysState;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.GeomPoly;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.Assets;
import openfl.display.FPS;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Piramid extends FlxPhysState
{	
	private var shooter:Shooter;
	private static var levels;
	var bricks:Array<FlxPhysSprite>;
	var fps:FPS;
	
	override public function create():Void 
	{	
		super.create();
		FlxG.mouse.show();
		
		disablePhysDebug();
		
		add(new FlxSprite(0, 0, "assets/piramidbg.jpg"));

		if (Piramid.levels == 0)
			Piramid.levels = 10;
			
		shooter = new Shooter();
		add(shooter);	
			
		createWalls( -2000, -2000, 1640, 480);
		createBricks();
		
		
		
		var txt:FlxText = new FlxText(FlxG.width - 100, 30, 100, "Bricks: " + bricks.length);
		add(txt);
		
		
		add(txt);
		fps = new FPS(FlxG.width - 100, 5, 0xFFFFFF);
		FlxG.stage.addChild(fps);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		FlxG.stage.removeChild(fps);
	}
	

	
	private function createBricks() 
	{
		bricks = new Array<FlxPhysSprite>();
		var brick:FlxPhysSprite;
		
		var brickHeight:Int = Std.int(8 * 40 / Piramid.levels); // magic number!
		var brickWidth:Int = brickHeight * 2;
		
		
		
		for (i in 0...levels)
		{
			for (j in 0...(Piramid.levels - i)) 
			{
				brick = new FlxPhysSprite();
				brick.makeGraphic(brickWidth, brickHeight, 0x0);
				brick.createRectangularBody();
				brick.loadGraphic("assets/brick" + Std.string(FlxRandom.intRanged(1, 4)) + ".png");
				//brick.antialiasing = true;
				brick.scale.x = brickWidth / 80;
				brick.scale.y = brickHeight / 40;
				if (FlxRandom.chanceRoll()) brick.scale.x *= -1; // add some variety
				if (FlxRandom.chanceRoll()) brick.scale.y *= -1; // add some variety.
				brick.setBodyMaterial(.5, .5, .5, 2);
				brick.body.position.y = FlxG.height - brickHeight / 2 - brickHeight * i + 2;
				brick.body.position.x = (FlxG.width / 2 - brickWidth / 2 * (Piramid.levels - i - 1)) + brickWidth * j; 
				add(brick);
				bricks.push(brick);
				shooter.registerPhysSprite(brick);
			}
		}
	}
	
	
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.mouse.justPressed() && FlxPhysState.space.gravity.y == 0)
			FlxPhysState.space.gravity.setxy(0, 500);
		
		if (FlxG.keys.justPressed("G"))
			if (_physDbgSpr != null)
				disablePhysDebug(); // PhysState method to remove the debug graphics.
			else
				enablePhysDebug();
			
		if (FlxG.keys.justPressed("R"))
			FlxG.resetState();
			
		if (FlxG.keys.justPressed("LEFT"))
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
		if (FlxG.keys.justPressed("Q"))
		{
			Piramid.levels++;
			FlxG.resetState();
		}
		if (FlxG.keys.justPressed("W"))
		{
			Piramid.levels--;
			FlxG.resetState();
		}
	}
	
}