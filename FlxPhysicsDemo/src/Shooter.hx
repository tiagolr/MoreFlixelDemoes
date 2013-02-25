package ;
import org.flixel.nape.FlxPhysSprite;
import nape.callbacks.CbType;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxU;

/**
 * Fires small projectiles to where the user clicks.
 * 
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Shooter extends FlxGroup
{

	static public var CB_BULLET:CbType = new CbType();
	
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
			spr.kill();
			add(spr);
		}
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.mouse.justPressed()) 
		{
			var impulse = 4000;
			var spr:FlxPhysSprite = cast(recycle(FlxPhysSprite), FlxPhysSprite);
			spr.revive();
			spr.body.position.y = 30;
			spr.body.position.x = 30 + Std.random(640 - 30);
			var angle = FlxU.getAngle(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), 
									  new FlxPoint(spr.body.position.x, spr.body.position.y));
			angle += 90;
			spr.body.velocity.setxy(impulse * Math.cos(angle * 3.14 / 180),
									impulse * Math.sin(angle * 3.14 / 180));
		}
	}
}