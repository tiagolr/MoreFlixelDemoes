package states;
import FlxPhysicsDemo;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.nape.FlxPhysState;
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
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Piramid extends FlxPhysState
{	
	private var shooter:Shooter;
	
	override public function create():Void 
	{	
		super.create();
		FlxG.mouse.show();
		
		// Sets gravity.
		FlxPhysState.space.gravity.setxy(0, 500);

		createWalls( -2000, -2000, 1640, 480);
		createBricks();
		
		shooter = new Shooter();
		add(shooter);
		
		FlxPhysState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
													 InteractionType.COLLISION, 
													 Shooter.CB_BULLET,
													 CbType.ANY_BODY,
													 onBulletColides));
											
	}
	
	public function onBulletColides(clbk:InteractionCallback) 
	{
		shooter.getFirstAlive().kill();
	}
	
	private function createBricks() 
	{
		var brick:FlxPhysSprite;
		var brickHeight = 30;
		var brickWidth = 60;
		var levels = 8;
		for (i in 0...levels)
		{
			for (j in 0...(levels - i)) 
			{
				brick = new FlxPhysSprite();
				brick.makeGraphic(brickWidth, brickHeight, 0x0);
				brick.createRectangularBody();
				brick.setBodyMaterial(.5, .5, .5, 2);
				brick.body.position.y = FlxG.height - brickHeight / 2 - brickHeight * i - 10;
				brick.body.position.x = (FlxG.width / 2 - brickWidth / 2 * (levels - i - 1)) + brickWidth * j; 
				add(brick);
			}
		}
	}
	
	
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.keys.justPressed("G"))
			disablePhysDebug(); // PhysState method to remove the debug graphics.
			
		if (FlxG.keys.justPressed("LEFT"))
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
	}
	
}