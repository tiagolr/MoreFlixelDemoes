package states;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.nape.FlxPhysState;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Material;
import org.flixel.FlxG;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Balls extends FlxPhysState
{

	private var shooter:Shooter;
	
	override public function create():Void 
	{	
		super.create();
		FlxG.mouse.show();
		
		// Sets gravity.
		FlxPhysState.space.gravity.setxy(0, 1500);
		//FlxPhysState.space.worldLinearDrag = 0;
		//FlxPhysState.space.worldAngularDrag = 0;

		createWalls( -2000, -2000, 1640, 480);
		createBalls();
		
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
		if (shooter.getFirstAlive() != null) 
		{
			shooter.getFirstAlive().kill();
		}
	}
	
	private function createBalls() 
	{
		var ball:FlxPhysSprite;
		var constraint:DistanceJoint;
		var constraint2:PivotJoint;
		var numBalls = 6;
		var radius = 25;
		
		for (i in 0...numBalls)
		{
			ball = new FlxPhysSprite();
			ball.makeGraphic(2, 2, 0x0);
			ball.createCircularBody(radius);				
			ball.setBodyMaterial(1, 0, 0, 10);
			ball.body.position.y = 350;
			ball.body.position.x = (FlxG.width / 2 - radius * (numBalls - i - 1)) + (radius + 3) * i; 
			add(ball);
			
			constraint = new DistanceJoint(FlxPhysState.space.world, ball.body, new Vec2(ball.body.position.x , 100), new Vec2(0, -radius), 0, 250);
			constraint.space = FlxPhysState.space;
			
			if (i != 0 && i != numBalls - 1) 
			{
				constraint2 = new PivotJoint(FlxPhysState.space.world, ball.body, new Vec2(ball.body.position.x , ball.body.position.y + radius), new Vec2(0, 0));
				constraint2.stiff = false;
				constraint2.maxForce = 250;
				constraint2.damping = 100;
				constraint2.space = FlxPhysState.space;
			}
			
			
			if (i == 0)
			{
				// Position first ball added.
				ball.body.position.x -= 200;
			}
			
		}
		
		
	}
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.keys.justPressed("G"))
			disablePhysDebug(); // PhysState method to remove the debug graphics.
		if (FlxG.keys.justPressed("R"))
			FlxG.resetState();
			
		if (FlxG.keys.justPressed("LEFT"))
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
	}
	
}