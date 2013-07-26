package ;
import flash.display.Sprite;
import flixel.addons.nape.FlxPhysSprite;
import flixel.addons.nape.FlxPhysState;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxAngle;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * Fires small projectiles to where the user clicks.
 * 
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Shooter extends FlxGroup
{

	static public var CB_BULLET:CbType = new CbType();
	var mouseJoint:DistanceJoint;
	
	public function new() 
	{
		super(10);
		for (i in 0...maxSize)
		{
			var spr = new FlxPhysSprite();
			spr.makeGraphic(2, 2, 0x0);
			spr.createCircularBody(8);
			spr.body.allowRotation = false;
			spr.setBodyMaterial(0, .2, .4, 11);
			spr.body.cbTypes.add(CB_BULLET);
			spr.body.isBullet = true;
			spr.body.setShapeFilters(new InteractionFilter(256, ~256));
			spr.kill();
			add(spr);
		}
		
		FlxPhysState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
													 InteractionType.COLLISION, 
													 Shooter.CB_BULLET,
													 CbType.ANY_BODY,
													 onBulletColides));
	
	}
	
	public function onBulletColides(clbk:InteractionCallback) 
	{
		var spr = getFirstAlive();
		if (spr != null)
			spr.kill();
	}
	
	public function registerPhysSprite(spr:FlxPhysSprite)
	{
		MouseEventManager.addSprite(spr, onMouseDown);
	}
	
	function onMouseDown(spr:FlxSprite) 
	{
		var body:Body = cast(spr, FlxPhysSprite).body;
		
		mouseJoint = new DistanceJoint(FlxPhysState.space.world, body, new Vec2(FlxG.mouse.x, FlxG.mouse.y),
								body.worldPointToLocal(new Vec2(FlxG.mouse.x, FlxG.mouse.y)), 0, 0);
		
		//constrain.active = false; <- default is true
		//constrain.stiff = false;  <- default is true
		//constrain.damping = 1;
		//constrain.frequency = 20;
		
		// Then update every step:
		// constrain.anchor1 = new Vec2(FlxG.mouse.x, FlxG.mouse.y);
		
		FlxG.mouse.reset();
	}
		
	
	override public function update():Void 
	{
		super.update();
		
		if (mouseJoint != null) 
		{
			mouseJoint.anchor1 = new Vec2(FlxG.mouse.x, FlxG.mouse.y);
			
			if (FlxG.mouse.justReleased())
			{
				mouseJoint.space = null;
			}
		}
		
		if (FlxG.mouse.justPressed()) 
		{
			var impulse = 4000;
			var spr:FlxPhysSprite = cast(recycle(FlxPhysSprite), FlxPhysSprite);
			spr.revive();
			spr.body.position.y = 30;
			spr.body.position.x = 30 + Std.random(640 - 30);
			var angle = FlxAngle.getAngle(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), 
									  new FlxPoint(spr.body.position.x, spr.body.position.y));
			angle += 90;
			spr.body.velocity.setxy(impulse * Math.cos(angle * 3.14 / 180),
									impulse * Math.sin(angle * 3.14 / 180));
		}
	}
}