package states;
import addons.nape.FlxPhysSprite;
import addons.nape.FlxPhysState;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

#if dev
#end

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
		/*createWalls();
        for (i in 0...50) 
		{
			var startX = 50 + Std.random(FlxG.width - 50);
			var startY = 50 + Std.random(FlxG.height - 50);
			add ( new FlxPhysSprite(startX, startY ));
		}*/
	}
	
	private function onBulletColides(clbk:InteractionCallback) 
	{
		if (shooter.getFirstAlive() != null)
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
	}
	
}