package states;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.nape.FlxPhysState;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import nape.phys.BodyType;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxU;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class SolarSystem extends FlxPhysState
{

	private var shooter:Shooter;
	private var planets:Array<FlxPhysSprite>;
	private static inline var halfWidth:Int = Std.int(FlxG.width / 2);
	private static inline var halfHeight:Int = Std.int(FlxG.height / 2);
	private static inline var gravity:Int = Std.int(5e4);
	private var sun:FlxPhysSprite;
	
	override public function create():Void 
	{	
		super.create();
		FlxG.mouse.show();
		
		FlxPhysState.space.worldAngularDrag = 0;
		FlxPhysState.space.worldLinearDrag = 0;

		createWalls();
		
		createSolarSystem();
		
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
	
	private function createSolarSystem() 
	{
		planets = new Array<FlxPhysSprite>();
		
		var planet:FlxPhysSprite;
		
		
		
		planet = new FlxPhysSprite(halfWidth, halfHeight + 70, null);
		planet.setBodyMaterial(1, 0, 0, 10, 0);
		planet.createCircularBody(5);
		planets.push(planet);
		planet.body.applyImpulse(new Vec2(220 * planet.body.mass, 0));
		add(planet);
		
		planet = new FlxPhysSprite(halfWidth, halfHeight + 100, null);
		planet.setBodyMaterial(1, 0, 0, 10, 0);
		planet.createCircularBody(10);
		planets.push(planet);
		planet.body.applyImpulse(new Vec2(220 * planet.body.mass, 0));
		add(planet);
		
		planet = new FlxPhysSprite(halfWidth, halfHeight + 150, null);
		planet.setBodyMaterial(1, 0, 0, 10, 0);
		planet.createCircularBody(15);
		planets.push(planet);
		planet.body.applyImpulse(new Vec2(220 * planet.body.mass, 0));
		add(planet);
		
		planet = new FlxPhysSprite(halfWidth, halfHeight + 200, null);
		planet.setBodyMaterial(1, 0, 0, 10, 0);
		planet.createCircularBody(9);
		planets.push(planet);
		planet.body.applyImpulse(new Vec2(220 * planet.body.mass, 0));
		add(planet);
		
		sun = new FlxPhysSprite(halfWidth, halfHeight);
		sun.createCircularBody(20);
		sun.setBodyMaterial(0, 0, 0, 100);
		sun.body.type = BodyType.STATIC;
		add(sun);
	}
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.keys.justPressed("G"))
			disablePhysDebug(); // PhysState method to remove the debug graphics.
		if (FlxG.keys.justPressed("R"))
			FlxG.resetState();
			
		for (planet in planets)
		{
			var angle = FlxU.getAngle(new FlxPoint(planet.x, planet.y), new FlxPoint(halfWidth, halfHeight)) - 90;
			var distance = FlxU.getDistance(new FlxPoint(planet.x, planet.y), new FlxPoint(halfWidth, halfHeight));
			
			var impulse = gravity * planet.body.mass / (distance * distance);
			var force:Vec2 = new Vec2((planet.x - halfWidth) * -impulse, (planet.y - halfHeight) * -impulse);
			force.muleq(FlxG.elapsed);
			planet.body.applyImpulse(force);
			
		}
		
		if (FlxG.keys.justPressed("W"))
			planets[0].body.applyImpulse(new Vec2(0, -10));
			
		if (FlxG.keys.justPressed("A"))
			planets[0].body.applyImpulse(new Vec2(-10, 0));
			
		if (FlxG.keys.justPressed("S"))
			planets[0].body.applyImpulse(new Vec2(0, 10));
			
		if (FlxG.keys.justPressed("D"))
			planets[0].body.applyImpulse(new Vec2(10, 0));
			
		
		if (FlxG.keys.justPressed("LEFT"))
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
	}
	
	
	
}